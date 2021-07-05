function [lik,latents] = likelihood_fun_chunk(x,data)
%{
fixed model free parameters (4):
    agent.beta:         fitted value of beta
    agent.lrate_theta:  actor learning rate
    agent.lrate_V:      critic learning rate
    agent.lrate_p:      learning rate for marginal action policyability

adaptive model free parameters (6):
    agent.C:            capacity
    agent.lrate_theta:  actor learning rate
    agent.lrate_V:      critic learning rate
    agent.lrate_p:      learning rate for marginal action policyability
    agent.lrate_beta:   learning rate for beta
    agent.beta0:        initial beta value

reduced adaptive model free parameters (5);
    agent.C:            capacity
    agent.lrate_theta:  actor learning rate
    agent.lrate_V:      critic learning rate
    agent.lrate_beta:   learning rate for beta
    agent.beta0:        initial beta value
%}

chunkNs4 = [2 1];
chunkNs6 = [5 4];

if length(x)==2             % no cost model            
    agent.m = 1;
    agent.C = [];
    agent.lrate_theta = x(1);
    agent.lrate_V = x(2);
    agent.lrate_p = 0;
    agent.beta0 = 1;
    agent.lrate_beta = 0;
    agent.lrate_e = 0.1;


elseif length(x)==3         % reduced fixed model
    agent.m = 3;
    agent.C = [];
    agent.beta0 = x(1);
    agent.lrate_theta = x(2);
    agent.lrate_V = x(3);
    agent.lrate_beta = 0;
    agent.lrate_p = 0;
    agent.lrate_e = 0.1;

   
elseif length(x)==4        % fixed model; makes sense for chunk learning   
    agent.m = 4;
    agent.C = [];
    agent.beta0 = x(1);
    agent.lrate_theta = x(2);
    agent.lrate_V = x(3);
    agent.lrate_p = x(4);
    agent.lrate_beta = 0;
    agent.lrate_e = 0.1;
  
    
elseif length(x)==5          % reduced adaptive model
    agent.m = 5;
    agent.C = x(1);
    agent.beta0 = x(2);
    agent.lrate_theta = x(3);
    agent.lrate_V = x(4);
    agent.lrate_beta = x(5);
    agent.lrate_p = 0;
    agent.lrate_e = 0.1;
    
elseif length(x)==6         % adaptive model; makes sense for chunk learning
    agent.m = 6;
    agent.C = x(1);
    agent.beta0 = x(2);
    agent.lrate_theta = x(3);
    agent.lrate_V = x(4);
    agent.lrate_beta = x(5);
    agent.lrate_p = x(6);
    agent.lrate_e = 0.1;
end

%%
%C = {{'Ns4,train', 'Ns4,perform', 'Ns4,test'},...
     %{'Ns6,train', 'Ns6,perform', 'Ns6,test'}};
C = {{'Ns6,train', 'Ns6,perform', 'Ns6,test'}};
lik = 0;
likelihood = [];

for setId = 1:length(C)
    ix = [];
    expCond = C{setId};
    for c = 1:length(expCond)
        ix = [ix find(strcmp(data.cond, expCond{c}))'];
    end
    reward = data.r(ix);
    action = data.a(ix);
    state = data.s(ix);
    acc = data.acc(ix); 
    setsize = length(unique(state));    % number of distinct states
    nA = setsize+1;                     % number of distinct actions
    theta = zeros(setsize,nA);          % policy parameters
    V = zeros(setsize,1);               % state values
    Q = zeros(setsize,nA);              % state-action values
    p = zeros(1,nA); p(1:nA-1) = 1/(nA-1)-0.01; p(nA) = 0.01*(nA-1);     % marginal action probabilities
    beta = agent.beta0;
    ecost = 0;

    if setsize==4
        chunk = chunkNs4;
    elseif setsize==6
        chunk = chunkNs6;
    end
          
    if nargout > 1                      % if you want to collect the latents
        ii = find(ix);
    end
    
    for t = 1:length(state)
        s = state(t); a = action(t); r = reward(t);
        if isnan(a)
            continue;
        end

        d = beta * theta(s,:) + log(p);
        logpolicy = zeros(1,setsize+1);

        %--------------------------------------------------
        
        for i = 1:setsize+1
            if i==chunk(1)
                d_chunk = zeros(2,1); d_chunk(1) = d(chunk(1)); d_chunk(2) = d(setsize+1);
                logpolicy(i) = logsumexp(d_chunk) -logsumexp(d); 
            elseif t>1 && data.a(t-1)==chunk(1) && i==chunk(2)
                if ~exist('d_prev','var'); d_prev = beta * theta(data.s(t-1)) + log(p); end
                d_chunk=zeros(2,1); d_chunk(1)=d_prev(chunk(1)); d_chunk(2)=d_prev(setsize+1);
                logpolicy(i) = log(exp(d(i)-logsumexp(d)) + exp(d_chunk(2)-logsumexp(d_chunk)));
            else
                logpolicy(i) = d(i)-logsumexp(d);
            end
        end    
        
        %--------------------------------------------------
        
        policy = exp(logpolicy); % softmax policy
        if ~isnan(logpolicy(1,a)) && logpolicy(1,a)~=Inf && logpolicy(1,a)~=-Inf
            lik = lik + logpolicy(1,a);
        end
        likelihood(end+1) = logpolicy(1,a);
        cost = logpolicy(a) - log(p(a));       % policy complexity cost
        
        if agent.m > 1                         % if it's a cost model
            rpe = beta*r - cost - V(s);        % reward prediction error
        else
            rpe = r - V(s);                    % reward prediction error w/o cost
        end
        

        V(s) = V(s) + agent.lrate_V*rpe;               % state value update
        Q(s,a) = Q(s,a) + agent.lrate_V*(beta*r-cost-Q(s,a));    % state-action value update
        ecost = ecost + agent.lrate_e*(cost-ecost);    % policy cost update
        
        if agent.lrate_beta > 0
            beta = beta + agent.lrate_beta*2*(agent.C-ecost); % squared deviation is independent of beta (beta not in policy)
            beta = max(min(beta,50),0);
        end
        
        if agent.lrate_p > 0
            if a==chunk(1)
                p(1:setsize) = p(1:setsize) + agent.lrate_p*(policy(1:setsize)-p(1:setsize));
            else
                p = p + agent.lrate_p*(policy - p); 
            end
            p = p./sum(p);  % marginal update
        end
        
        %--------------------------------------
        % haven't implement associative learning yet
        if a~=chunk(1)
            g = rpe*beta*(1 - policy(a));                                   % policy gradient
            theta(s,a) = theta(s,a) + agent.lrate_theta*g;                  % policy parameter update
        elseif a==chunk(1)
            g_c = rpe*beta*(1 - policy(setsize+1));
            g_a = rpe*beta*(1 - policy(a) - policy(setsize+1));
            theta(s,setsize+1) = theta(s,setsize+1) + agent.lrate_theta*g_c;
            theta(s,a) = theta(s,a) + agent.lrate_theta*g_a;
        end
        %----------------------------------------
        
        if nargout > 1                                          % if you want to collect the latents
            latents.rpe(ii(t)) = rpe;
        end
        
        d_prev = d;
        
    end % trials in block end
end % experimental condition end

end
        