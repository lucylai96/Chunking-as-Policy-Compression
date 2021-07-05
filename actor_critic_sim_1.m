function simdata = actor_critic_sim_1(agent, data)

% tune prior 
% assume length 2 chunk

if ~isfield(agent, 'beta')
    agent.beta = agent.beta0;
end


simdata = data;
cond = unique(data(1).cond);

for c = 1:length(cond)
    idx = find(strcmp(data.cond, cond(c));
    state = data.s(idx);
    corrchoice = data.corrchoice(idx);
    setsize = length(unique(state));    % number of distinct stimuli
    nA = setsize + 1;                   % number of distinct actions
    theta = zeros(setsize, nA);         % policy parameters
    V = zeros(setsize,1);               % state values
    Q = zeros(setsize,nA);              % state-action values
    beta = agent.beta;
    p = zeros(1,nA);                    % marginal action probabilities
    p(1:nA-1) = 1/(nA-1)-0.01; p(nA) = 0.01*(nA-1);                
    ecost = 0;
    
    if setsize==4
        chunk = [2 1];
        actionset = {1, 2, 3, 4, [2 1]};
    elseif setsize==6
        chunk = [5 4];
        actionset = {1, 2, 3, 4, 5, 6, [5 4]};
    end
    
    inChunk = 0;
    chunkStep = 0;
    for t = 1:length(state)
        s = state(t);
        
        if inChunk == 0
            d = beta * theta(s,:) + log(p);
            logpolicy = d - logsumexp(d);
            policy = exp(logpolicy);    % softmax policy
            a = fastrandsample(policy); % action
            
            if a == setsize+1
                inChunk = 1; chunkStep = 1;
                a = chunk(1);
            end
        else
            chunkStep = chunkStep + 1;
            a = chunk(chunkStep+1);
        end    
                
        acc = a == corrchoice(t);
        if chunkStep==1 || inChunk==0
            cost = logpolicy(a) - log(p(a));               % policy complexity cost
        else
            cost = 0;
        end
        
        if agent.m > 1
            rpe = beta*r - cost - V(s);                % reward prediction error
        else
            rpe = r - V(s);                            % reward prediction error
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
        
        if inChunk==1 && chunkStep==1
            g_c = rpe*beta*(1 - policy(setsize+1));
            theta(s, setsize+1) = theta(s, setsize+1) + agent.lrate_theta*g_c;
        end
        g = rpe*beta*(1 - policy(a));                         
        theta(s,a) = theta(s,a) + agent.lrate_theta*g;
        
        simdata.s(idx(t)) = s;
        simdata.a(idx(t)) = a;
        simdata.r(idx(t)) = acc;
        simdata.acc(idx(t)) = acc;
        simdata.beta(idx(t)) = beta;
        simdata.cost(idx(t)) = cost;
        %simdata.theta(idx(t),:) = theta;
        
        if inChunk==1 && chunkStep==length(chunk)
            inChunk=0; chunkStep=0;
        end
    end
    simdata.p(c,:) = p;
end

    
        
        
        
        
        
        