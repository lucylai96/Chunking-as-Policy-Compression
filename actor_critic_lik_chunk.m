function [lik,latents] = actor_critic_lik_chunk(x,data)
%{
Simpler version of the chunking framework
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

   
elseif length(x)==4        % fixed model   
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
    
elseif length(x)==6         % adaptive model
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
C = {{'Ns4,baseline'}, {'Ns4,train', 'Ns4,perform', 'Ns4,test'},...
     {'Ns6,baseline'}, {'Ns6,train', 'Ns6,perform', 'Ns6,test'}};
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
    setsize = length(unique(state));    % number of distinct states
    nA = setsize+1;                     % number of distinct actions
    theta = zeros(setsize,nA);          % policy parameters
    V = zeros(setsize,1)+0.01;               % state values
    Q = zeros(setsize,nA)+0.01;              % state-action values
    if setsize==4; p=[0.25 0.125 0.25 0.25 0.125]; end
    if setsize==6; p=[1/6 1/6 1/6 1/6 1/12 1/6 1/12]; end
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
        
        for i = 1:setsize
            if i==chunk(1)
                d_chunk = zeros(2,1); d_chunk(1) = d(chunk(1)); d_chunk(2) = d(setsize+1);
                logpolicy(i) = logsumexp(d_chunk) -logsumexp(d); 
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
            p = p + agent.lrate_p*(policy - p); p = p./sum(p);  % marginal update
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
        