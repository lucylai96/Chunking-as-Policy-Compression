function simdata = sim_from_empirical(modelIdx, data, results)

prettyplot
if nargin < 3; load actionChunk_data.mat; end

results = results(modelIdx);
for s = 1:length(data)
    agent.m = results.K;
    
    if agent.m == 2 % no cost model
        agent.C = [];
        agent.lrate_p = 0;
        agent.beta0 = 1;
        agent.lrate_beta = 0;
        agent.lrate_e = 0.1;
    elseif agent.m == 3
        agent.C = [];
        agent.lrate_p = 0;
        agent.lrate_beta = 0;
        agent.lrate_e = 0.1;
    elseif agent.m == 4
        agent.C = [];
        agent.lrate_beta = 0;
        agent.lrate_e = 0.1;
    elseif agent.m == 5
        agent.lrate_p = 0;
        agent.lrate_e = 0.1;
    elseif agent.m == 6
        agent.lrate_e = 0.1;
        
    end
    
    for k = 1:length(results.param)
        agent.(results.param(k).name) = results.x(s,k);
    end
    
    simdata(s) = actor_critic_sim_refined(agent, data(s));
    %simdata(s) = actor_critic_sim_1(agent, data(s));
end

end
        