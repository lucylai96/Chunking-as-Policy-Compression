function simdata = actor_critic_sim_0(agent, data, incentives)

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
    corrchoice = state;
    setsize = length(unique(state));
    nA = setsize + 1;                 
    theta = zeros(setsize, nA);               
    V = zeros(setsize,1)+0.01;             
    Q = zeros(setsize,nA)+0.01;                    
    beta = agent.beta;
 
    if setsize==4
        p=[0.25 0.125 0.25 0.25 0.125]; 
        chunk = [2 1];
        if ~exist('incentives', 'var')
            reward = [eye(4), transpose([0 1 0 0])];
        else
            reward = incentives.Ns4;
        end
    end
    if setsize==6
        p=[1/6 1/6 1/6 1/6 1/12 1/6 1/12]; 
        chunk = [5 4];
        if ~exist('incentives', 'var')
            reward = [eye(6), transpose([0 0 0 0 1 0])];
        else
            reward = incentives.Ns6;
        end
    end

    ecost = 0;
    inChunk = 0;
    chunkStep = 0;
    a_actual = 0;
    policy_prev = 0;
    
    for t = 1:length(state)
        if inChunk == 0
            s = state(t);
            d = beta * theta(s,:) + log(p);
            logpolicy = d-logsumexp(d);
            policy = exp(logpolicy);    % softmax policy
            a = fastrandsample(policy); % action
            if a==nA; inChunk=1; chunkStep=1; end
        else
            chunkStep = chunkStep+1;
            a = nA;
        end
        
        if inChunk == 0; a_actual = a; end
        if inChunk == 1; a_actual = chunk(chunkStep); end
        
        r = reward(s, a_actual);
        cost = logpolicy(a) - log(p(a));
        %cost = abs(logpolicy(a) - log(p(a)));
        if inChunk==1 && chunkStep>1; cost=0; end

        ecost = ecost + agent.lrate_e*(cost-ecost);    % policy cost update
        
        if agent.lrate_beta > 0
            beta = beta + agent.lrate_beta*2*(agent.C-ecost); 
            beta = max(min(beta,50),0);
        end
                    
        
        rpe = beta*r - cost - V(s);       
        g = rpe*beta*(1 - policy(a));
        theta(s,a) = theta(s,a) + agent.lrate_theta*g;
        Q(s,a) = Q(s,a) + agent.lrate_V*(beta*r-cost-Q(s,a));
        V(s) = V(s) + agent.lrate_V*rpe;
        p = p + agent.lrate_p*(policy - p); p = p./sum(p);
        
        simdata.s(idx(t)) = s;
        simdata.a(idx(t)) = a_actual;
        simdata.r(idx(t)) = r;
        simdata.acc(idx(t)) = r;
        simdata.beta(idx(t)) = beta;
        simdata.cost(idx(t)) = cost;
        simdata.cond(idx(t)) = condition(t);
        simdata.theta{idx(t)} = theta;
        simdata.inChunk(idx(t)) = inChunk;
        simdata.chunkStep(idx(t)) = chunkStep;
        simdata.policy{idx(t)} = policy;
        if chunkStep==length(chunk); inChunk=0; chunkStep=0; end
        
    end
    simdata.p(setId) = {p};
end
end
        
        
        