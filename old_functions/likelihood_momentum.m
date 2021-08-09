function [lik,latents] = likelihood_momentum(x,data)

if length(x)==3         % reduced fixed model
    agent.m = 3;
    agent.C = [];
    agent.beta0 = x(1);
    agent.lrate_theta = x(2);
    agent.lrate_V = x(3);
    agent.lrate_beta = 0;
    agent.lrate_p = 0;
    agent.lrate_e = 0.1;

   
elseif length(x)==5        % fixed model; makes sense for chunk learning   
    agent.m = 5;
    agent.C = [];
    agent.beta0 = x(1);
    agent.lrate_theta = x(2);
    agent.lrate_V = x(3);
    agent.lrate_rho = x(4);
    agent.epsilon = x(5);
    agent.lrate_p = 0;
    agent.lrate_beta = 0;
    agent.lrate_e = 0.1;
  
    
end

%%
C = {{'Ns4,baseline'}, {'Ns4,train', 'Ns4,perform', 'Ns4,test'},...
     {'Ns6,baseline'}, {'Ns6,train', 'Ns6,perform', 'Ns6,test'}};
lik = 0;

for setId = 1:length(C)
    ix = [];
    expCond = C{setId};
    for c = 1:length(expCond)
        ix = [ix find(strcmp(data.cond, expCond{c}))'];
    end
  
    reward = data.r(ix);
    action = data.a(ix);
    state = data.s(ix);
    setsize = length(unique(state));
    nA = setsize;                                      % number of possible actions
    theta = zeros(setsize,nA);                         % policy parameters
    V = zeros(setsize,1)+0.2;                          % state values
    Q = zeros(setsize,nA);                             % state-action values
    p = ones(1,nA)/nA;                                 % marginal action probabilities
    beta = agent.beta0;
    epsilon = agent.epsilon;
    ecost = 0;
    rho = ones(nA, nA) / nA;
          
    if nargout > 1                      % if you want to collect the latents
        ii = find(ix);
    end
    
    a_prev = 0;
    for t = 1:length(state)
        s = state(t); a = action(t); r = reward(t);
        if isnan(a)
            continue;
        end
        
        if a_prev==0
            d = beta * theta(s,:) + log(p);
        else
            d = beta * ((theta(s,:)+epsilon*rho(a_prev,:))/(1+epsilon)) + log(p);
            %d = beta * ((1-epsilon)*theta(s,:)+epsilon*rho(a_prev,:)) + log(p);
        end
        logpolicy = d - logsumexp(d);
        policy = exp(logpolicy);
        lik = lik + logpolicy(a);
        cost = logpolicy(a) - log(p(a));
       
        if agent.m>1                        
            rpe = beta*r - cost - V(s);       
        else
            rpe = r - V(s);                  
        end
        
        % update action transition probability
        if t>= 2 && a_prev~=0
            rho(a_prev,a) = rho(a_prev,a) + agent.lrate_rho;
            rho(a_prev,:) = rho(a_prev,:)./sum(rho(a_prev,:));
        end
        
        V(s) = V(s) + agent.lrate_V*rpe;              
        Q(s,a) = Q(s,a) + agent.lrate_V*(beta*r-cost-Q(s,a));   
        ecost = ecost + agent.lrate_e*(cost-ecost);   
        
        if agent.lrate_beta > 0
            beta = beta + agent.lrate_beta*2*(agent.C-ecost); % squared deviation is independent of beta (beta not in policy)
            beta = max(min(beta,50),0);
        end
        p = p + agent.lrate_p*(exp(d-logsumexp(d)) - p); p = p./sum(p);             
        policy = exp(d-logsumexp(d));
        g = rpe*beta*(1 - policy(a));       
        
        % uodate theta and rho
        theta(s,a) = theta(s,a) + agent.lrate_theta*g;
        %{
        if t>= 2 && a_prev~=0
            rho(a_prev,a) = rho(a_prev,a) + agent.lrate_rho*g*epsilon;
            rho(a_prev,:) = rho(a_prev,:)/sum(rho(a_prev,:));
        end
        %}
        
        if nargout > 1                                          % if you want to collect the latents
            latents.rpe(ii(t)) = rpe;
        end
        
        a_prev = a;
    end % trials in block end
end % experimental condition end

end
        