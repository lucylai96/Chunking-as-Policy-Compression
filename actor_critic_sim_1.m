function simdata = actor_critic_sim_1(agent, data)

if ~isfield(agent, 'beta')
    agent.beta = agent.beta0;
end

simdata.ID = data.ID;
cond = {{'Ns4,baseline'}, {'Ns4,train', 'Ns4,perform', 'Ns4,test'},...
    {'Ns6,baseline'}, {'Ns6,train', 'Ns6,perform', 'Ns6,test'}};

for setId = 1:length(cond)
    clear d_prev;
    idx = [];
    expCond = cond{setId};
    for c = 1:length(expCond)
        idx = [idx find(strcmp(data.cond, expCond{c}))'];
    end
    condition = data.cond(idx);
    state = data.s(idx);
    corrchoice = data.corrchoice(idx);
    setsize = length(unique(state));    % number of distinct stimuli
    nA = setsize + 1;                   % number of distinct actions
    theta = zeros(setsize, nA);         % policy parameters
    V = zeros(setsize,1)+0.01;          % state values
    Q = zeros(setsize,nA);              % state-action values
    beta = agent.beta;
    p = zeros(1,nA);                    % marginal action probabilities
    p(1:nA-1) = 1/(nA-1)-0.01; p(nA) = 0.01*(nA-1);
    ecost = 0;
    
    if setsize==4
        chunk = [2 1];
    elseif setsize==6
        chunk = [5 4];
    end
    
    inChunk = 0; % indicates whether it is in a chunk
    chunkStep = 0;
    for t = 1:length(state)
        s = state(t);
        
        if inChunk == 0
            d = beta * theta(s,:) + log(p);
            logpolicy = d - logsumexp(d);
            policy = exp(logpolicy);    % softmax policy
            a = fastrandsample(policy); % action
            
            if a == setsize+1
                inChunk = 1;
                a = chunk(1);
            end
            
        else % still in a chunk
            a = chunk(2);
            inChunk = 0;
        end
        
        if a == corrchoice(t)
            acc = 1;                % accuracy
        else
            acc = 0;
        end
        r = acc;
        
        if a==chunk(1); cost = logpolicy(a) - log(p(a)+p(setsize+1)); end   % policy complexity cost
        if a~=chunk(1); cost = logpolicy(a) - log(p(a)); end
        
        if agent.m > 1; rpe = beta*r - cost - V(s); end                     % reward prediction error
        if agent.m == 1; rpe = r - V(s); end
 
        logpolicy = zeros(1,setsize+1);
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
        policy = exp(logpolicy);    % softmax policy

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
        
         if a~=chunk(1)
            g = rpe*beta*(1 - policy(a));                                   % policy gradient
            theta(s,a) = theta(s,a) + agent.lrate_theta*g;                  % policy parameter update
        if a==chunk(1)
            g_c = rpe*beta*(1 - policy(setsize+1));
            g_a = rpe*beta*(1 - policy(a) - policy(setsize+1));
            theta(s,setsize+1) = theta(s,setsize+1) + agent.lrate_theta*g_c;
            theta(s,a) = theta(s,a) + agent.lrate_theta*g_a;
        end
        
        simdata.s(idx(t)) = s;
        simdata.a(idx(t)) = a;
        simdata.r(idx(t)) = acc;
        simdata.acc(idx(t)) = acc;
        %simdata.expreward(idx(t)) = policy(corchoice(t));
        simdata.beta(idx(t)) = beta;
        simdata.cost(idx(t)) = cost;
        simdata.cond(idx(t)) = condition(t);
        %simdata.theta(idx(t),:) = theta;
        
    end
    simdata.p(setId) = {p};
end

end
        
        
        