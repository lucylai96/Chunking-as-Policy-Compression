function simdata = actor_critic_sim(nS, agent)    

if nS==4; chunk = [2 1]; actions = {1,2,3,4,[2 1]}; end
if nS==6; chunk = [5 4]; actions = {1,2,3,4,5,6,[5 4]}; end
blockstruct.chunk  = chunk;
blockstruct.length = 35 * nS;
blockstruct.chunk_freq = 1 / nS;
state = sim_block(nS, blockstruct);   % generate state sequence

nA = nS + 1;                  
theta = zeros(nS,nA);              
V = zeros(nS,1);   
p = horzcat(repmat([1/nS-0.01], [1 nS]), [0.01*nS]);

lastColumn = zeros(nS,1); lastColumn(nS) = 1;
R = horzcat(eye(nS), lastColumn);            
withinChunkUpdate = 0;
%%
clear simdata;

rt = 0;
inChunk = 0; % indicates whether it is in a chunk
chunkStep = 0;

for t = 1:length(state)
    s = state(t);  % sample start location
    
    % policy
    if inChunk == 0  % not in a chunk, sample action and get reward
        d = agent.beta * theta(s,:) + log(p);
        logpolicy = d - logsumexp(d);
        policy = exp(logpolicy);    % softmax
        a = fastrandsample(policy);   % sample action
        
        % reward
        r = R(s,a);
        rt = rt+1; % reaction time
        
    else % still in chunk
        a = simdata.action(t-1);
        % reward
        option = cell2mat(actions(a));
        r = R(s,option(chunkStep));
        rt = rt+ 0.2; % reaction time
        s = option(1);
    end
    
    if a > nS && inChunk == 0 % if you just start a chunk
        inChunk = 1; % turn the chunk on and off
        chunkStep = 1;
        option = cell2mat(actions(a));
        rt = rt+0.2;
    end
    
    cost = logpolicy(a) - log(p(a));    % policy complexity cost
    
    if inChunk == 1
        if chunkStep > 1 % if action is tere
            cost = 0; % no cost if executing chunk
        end
        chunkStep = chunkStep + 1;
        option = cell2mat(actions(a));
        if chunkStep > length(option)
            inChunk = 0;  % turn chunk off when action sequence is over
            chunkStep = 0;
        end
        
    end
    
    if (withinChunkUpdate==1) || (withinChunkUpdate==0 && chunkStep <= 1)
        % learning updates
        rpe = agent.beta*r - cost - V(s);                      % reward prediction error
        g = agent.beta*rpe*(1 - policy(a));                        % policy gradient
        theta(s,a) = theta(s,a) + (agent.lrate_theta)*rpe*g;   % policy parameter update
        V(s) = V(s) + agent.lrate_V*rpe;
    end
    p = p + agent.lrate_p*(policy - p); p = p./nansum(p);        % marginal update
    simdata.action(t) = a;
    simdata.reward(t) = r;
    simdata.state(t) = s;
    simdata.cost(t) = cost;
    
end

simdata.rt = rt/length(state);
simdata.V = V;
simdata.theta = theta;
simdata.pa = p;

for i = 1:nS
    d = agent.beta * theta(i,:) + log(p);
    logpolicy = d - logsumexp(d,2);
    policy = exp(logpolicy);    % softmax
    simdata.pas(i,:) = policy;
end

simdata.chooseC1 = sum(simdata.state == chunk(1) & simdata.action==nS+1)/sum(simdata.state == chunk(1));
simdata.chooseA3 = sum(simdata.state == chunk(1) & simdata.action==chunk(1))/sum(simdata.state == chunk(1));
simdata.KL = nansum(simdata.pas.*log(simdata.pas./simdata.pa),2);


chunkStep = 0;
if agent.test == 1
    state = state(randperm(length(state))); % shuffle states
    
    rt = 0;
    inChunk = 0;
    for t=1:length(state)
        s = state(t);  % sample start location
        
        % policy
        if inChunk == 0  % not in a chunk, sample action and get reward
            d = agent.beta * theta(s,:) + log(p);
            logpolicy = d - logsumexp(d);
            policy = exp(logpolicy);    % softmax
            a = fastrandsample(policy);   % sample action
            
            % reward
            r = R(s,a);
            rt = rt+1; % reaction time
            
        else % still in chunk
            a = simdata.test.action(t-1);
            % reward
            option = cell2mat(actions(a));
            r = R(s,option(chunkStep));
            rt = rt+ 0.2; % reaction time
            s = option(1);
        end
        
        if a > 3 && inChunk == 0 % if you just start a chunk
            inChunk = 1; % turn the chunk on and off
            chunkStep = 1;
            option = cell2mat(actions(a));
            rt = rt + 0.2;
        end
        
        cost = logpolicy(a) - log(p(a));    % policy complexity cost
        
        if inChunk == 1
            if chunkStep > 1 % if action is tere
                cost = 0; % no cost if executing chunk
            end
            chunkStep = chunkStep + 1;
            option = cell2mat(actions(a));
            if chunkStep > length(option)
                inChunk = 0;  % turn chunk off when action sequence is over
                chunkStep = 0;
            end
        end
        
        if (withinChunkUpdate==1) || (withinChunkUpdate==0 && chunkStep <= 1)
            % learning updates
            rpe = agent.beta*r - cost - V(s);                      % reward prediction error
            g = agent.beta*(1 - policy(a));                        % policy gradient
            theta(s,a) = theta(s,a) + (agent.lrate_theta)*rpe*g;   % policy parameter update
            V(s) = V(s) + agent.lrate_V*rpe;
        end
        p = p + agent.lrate_p*(policy - p); p = p./nansum(p);        % marginal update
        simdata.test.action(t) = a;
        simdata.test.reward(t) = r;
        simdata.test.state(t) = s;
        simdata.test.cost(t) = cost;
        
    end % state

    simdata.test.slips = sum(simdata.test.state == chunk(1) & simdata.test.action==6)/sum(simdata.test.state == chunk(1));
    simdata.test.chooseA3 = sum(simdata.test.state == chunk(1) & simdata.test.action==chunk(1))/sum(simdata.test.state == chunk(1));
    
    simdata.test.rt = rt/length(state);
end % agent test



    