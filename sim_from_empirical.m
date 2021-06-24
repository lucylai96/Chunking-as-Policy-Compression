function [simdata, simresults] = sim_from_empirical(model, data, results)

prettyplot
if nargin < 2; load actionChunk_data.mat; end
if nargin < 3; load model_fits0.mat; end

results = results(model);
for s = 1:length(data)
    agent.m = model;
    
    if agent.m == 1 % no cost model
        agent.C = [];
        agent.lrate_p = 0;
        agent.beta0 = 1;
        agent.lrate_beta = 0;
        agent.lrate_e = 0.1;
    elseif agent.m = 3
        agent.lrate_p = 0;
        agent.lrate_beta = 0;
        agent.lrate_e = 0.1;
    end
    
    for k = 1:length(results.param)
        agent.(results.param(k).name) = results.x(s,k);
    end
    
    simdata(s) = actor_critic_sim(agent, data(s));
end

simresults = analyze_sim(simdata);
        