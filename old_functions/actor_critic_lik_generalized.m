function [lik,latents] = actor_critic_lik_generalized(x,data)

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
    nA = setsize^2;                     % number of distinct actions
    theta = zeros(setsize,nA);          % policy parameters
    V = zeros(setsize,1)+0.01;               % state values
    beta = agent.beta0;
    ecost = 0;
    p = zeros(1,nA)+0.01;

    if setsize==4
        featureSet = [1 12 13 14 2 21 23 24 3 31 32 34 4 41 42 43];
    elseif setsize==6
        featureSet = [1 12 13 14 15 16 2 21 23 24 25 26 ...
                      3 31 32 34 35 36 4 41 42 43 45 46 ...
                      5 51 52 53 54 56 6 61 62 63 64 65]; 
    end
    
    for i = 1:nA
        if mod(i,setsize)==1; p(i) = (1-0.01*(setsize^2-setsize))/setsize; end
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
        prob = zeros(setsize, setsize);
        for i = 1:setsize
            d_pos = zeros(setsize,1);
            for j = 1:setsize
                d_pos(j) = d(setsize*(i-1)+j);
            end
            prob(i,:) = d_pos - logsumexp(d_pos);
        end
        logposterior = sum(prob, 2);
        posterior = exp(logposterior);

        if ~isnan(logposterior(a)) && logposterior(a)~=Inf && logposterior(a)~=-Inf
            lik = lik + logposterior(a);
        end
        cost = logposterior(a) - log(p(a));       % policy complexity cost
        ecost = ecost + agent.lrate_e*(cost-ecost);    % policy cost update
        
        if agent.lrate_beta > 0
            beta = beta + agent.lrate_beta*2*(agent.C-ecost); % squared deviation is independent of beta (beta not in policy)
            beta = max(min(beta,50),0);
        end
       
        rpe = beta*r - cost - V(s);        % reward prediction error

        logpolicy = d - logsumexp(d);
        policy = exp(logpolicy);               % softmax policy
        p = p + agent.lrate_p*(policy - p); p = p./sum(p);  % marginal update
        V(s) = V(s) + agent.lrate_V*rpe; 

        for i = 1:setsize
            idx = setsize*(s-1)+i;         
            g = rpe*beta*(1 - posterior(a));                                 
            theta(s,idx) = theta(s,idx) + agent.lrate_theta*g*prob(s,i);                  
        end   
        
        if nargout > 1                                          % if you want to collect the latents
            latents.rpe(ii(t)) = rpe;
        end
        
    end % trials in block end
end % experimental condition end

end
        