function simdata = actor_critic_sim_incentive(agent, data, setsize, incentives)

if ~isfield(agent, 'beta')
    agent.beta = agent.beta0;
end

if setsize==4
    cond = {'Ns4,baseline','Ns4,train','Ns4,perform','Ns4,test'};
    chunk = [2 1];
elseif setsize==6
    cond = {'Ns6,baseline','Ns6,train','Ns6,perform','Ns6,test'}; 
    chunk = [5 4];
end

nA = setsize + 1; 
theta = zeros(setsize, nA);
V = zeros(setsize,1)+0.01;
Q = zeros(setsize,nA)+0.01;
beta = agent.beta;
p = ones(1,nA)/nA;

ecost = 0;
inChunk = 0;
chunkStep = 0;

for setId = 1:length(cond)
    idx = find(strcmp(data.cond, cond{setId}));
    condition = data.cond(idx);
    state = data.s(idx);
    nA = setsize + 1; 
    reward = incentives{setId};
    if setId==2
        theta = zeros(setsize, nA);               
        V = zeros(setsize,1)+0.01;             
        Q = zeros(setsize,nA)+0.01;                    
        beta = agent.beta;
        p = ones(1,nA)/nA;
        
        ecost = 0;
        inChunk = 0;
        chunkStep = 0;
    end
    
    for t = 1:length(state)
        s = state(t);
        
        if inChunk == 0
            d = beta * theta(s,:) + log(p);
            logpolicy = d-logsumexp(d);
            policy = exp(logpolicy);
            a = fastrandsample(policy); 
            
            r = reward(s,a);
            if a==nA; inChunk=1; chunkStep=1; end
        else
            a = nA;
            chunkStep = chunkStep+1;
            r = reward(s, chunk(chunkStep));
        end
        
        cost = logpolicy(a) - log(p(a));
        if inChunk==1 && chunkStep>1; cost=0; end
        if inChunk==1; acc = s==chunk(chunkStep); a_ground = chunk(chunkStep); end
        if inChunk==0; acc = s==a; a_ground = a; end
        
        if agent.m > 1                       
            rpe = beta*r - cost - V(s);       
        else
            rpe = r - V(s);                   
        end
        ecost = ecost + agent.lrate_e*(cost-ecost);    % policy cost update
        
        if agent.lrate_beta > 0
            beta = beta + agent.lrate_beta*2*(agent.C-ecost); 
            beta = max(min(beta,50),0);
        end
                    
        g = agent.beta*(1 - policy(a));                        % policy gradient
        theta(s,a) = theta(s,a) + (agent.lrate_theta)*rpe*g;   % policy parameter update
        V(s) = V(s) + agent.lrate_V*rpe;
        
        simdata.s(idx(t)) = s;
        simdata.r(idx(t)) = r;
        simdata.a(idx(t)) = a_ground;
        simdata.beta(idx(t)) = beta;
        simdata.ecost(idx(t)) = ecost;
        simdata.cost(idx(t)) = cost;
        simdata.acc(idx(t)) = acc;
        simdata.cond(idx(t)) = condition(t);
        simdata.theta{idx(t)} = theta;
        simdata.inChunk(idx(t)) = inChunk;
        simdata.chunkStep(idx(t)) = chunkStep;
        simdata.policy{idx(t)} = policy;
    
        if chunkStep==length(chunk); inChunk=0; chunkStep=0; end
    end
end
end
        
        
        