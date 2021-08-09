function simdata = actor_critic_sim_momentum(agent, data)

if ~isfield(agent, 'beta')
    agent.beta = agent.beta0;
end

%simdata = data;
cond = {{'Ns4,baseline'}, {'Ns4,train', 'Ns4,perform', 'Ns4,test'},...
        {'Ns6,baseline'}, {'Ns6,train', 'Ns6,perform', 'Ns6,test'}};

for setId = 1:length(cond)
    idx = [];
    expCond = cond{setId};
    for c = 1:length(expCond)
        idx = [idx find(strcmp(data.cond, expCond{c}))'];
    end
    condition = data.cond(idx);
    state = data.s(idx);
    setsize = length(unique(state));
    nA = setsize;                
    theta = zeros(setsize, nA);             % policy parameters
    V = zeros(setsize,1)+0.1;               % state values
    Q = zeros(setsize,nA);                  % state-action values
    beta = agent.beta;
    p = ones(1,nA)/nA;                      % marginal action probabilities
    ecost = 0;
    a_prev = 0;
    rho = ones(nA, nA) / nA;
    epsilon = agent.epsilon;
    
    for t = 1:length(state)
        s = state(t);
        if a_prev==0
            d = beta * theta(s,:) + log(p);
        else
            d = beta * ((theta(s,:)+epsilon*rho(a_prev,:))/(1+epsilon)) + log(p);
        end
        logpolicy = d-logsumexp(d);
        policy = exp(logpolicy);    % softmax policy
        a = fastrandsample(policy); % action
        
        r = s==a;
        
        cost = logpolicy(a) - log(p(a));       % policy complexity cost
        if agent.m > 1                         % if it's a cost model
            rpe = beta*r - cost - V(s);        % reward prediction error
        else
            rpe = r - V(s);                    % reward prediction error w/o cost
        end
        
        if t>= 2
            rho(a_prev,a) = rho(a_prev,a) + agent.lrate_rho;
            rho(a_prev,:) = rho(a_prev,:)./sum(rho(a_prev,:));
        end

        V(s) = V(s) + agent.lrate_V*rpe;               % state value update
        Q(s,a) = Q(s,a) + agent.lrate_V*(beta*r-cost-Q(s,a));    % state-action value update
        ecost = ecost + agent.lrate_e*(cost-ecost);    % policy cost update
        
        if agent.lrate_beta > 0
            beta = beta + agent.lrate_beta*2*(agent.C-ecost); % squared deviation is independent of beta (beta not in policy)
            beta = max(min(beta,50),0);
        end
        
        p = p + agent.lrate_p*(policy - p); p = p./sum(p);              % marginal update
        g = rpe*beta*(1 - policy(a));                                   % policy gradient
        theta(s,a) = theta(s,a) + agent.lrate_theta*g;                  % policy parameter update
        %{
        if t>= 2 && a_prev~=0
            rho(a_prev,a) = rho(a_prev,a) + agent.lrate_rho*g*epsilon;
            rho(a_prev,:) = rho(a_prev,:)/sum(rho(a_prev,:));
        end
        %}
        
        simdata.s(idx(t)) = s;
        simdata.a(idx(t)) = a;
        simdata.r(idx(t)) = r;
        simdata.beta(idx(t)) = beta;
        simdata.cost(idx(t)) = cost;
        simdata.cond(idx(t)) = condition(t);
        simdata.theta{idx(t)} = theta;
        simdata.rho{idx(t)} = rho;
        simdata.acc(idx(t)) = s==a;
        
        a_prev = a;
        
    end
    simdata.p(setId) = {p};
end
              
end
        
        
        