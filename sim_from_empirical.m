function simdata = sim_from_empirical(modelIdx, data, results)
addpath('/Users/ann/Desktop/CCN_Lab/BehavioralExperiment/Ns6_FinalVersion/matlab_data');
prettyplot
if nargin < 3; load model_fitting_all.mat; end
if nargin < 2; load actionChunk_data.mat; end
if nargin == 0; modelIdx = 4; end

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
    %{
    elseif agent.m == 5
        agent.lrate_beta = 0;
        agent.lrate_p = 0;
        agent.lrate_e = 0.1;   % MOMENTUM MODEL
     %}
    elseif agent.m == 6
        agent.lrate_e = 0.1;
        
    end
    
    for k = 1:length(results.param)
        agent.(results.param(k).name) = results.x(s,k);
    end
    
    simdata(s) = actor_critic_sim(agent, data(s));
end

end
        