function simdata = sim_incentive_manipulation()
addpath([pwd '/matlab_data/']);
load('actionChunk_data.mat');
load('fixed_adaptive_chunk.mat');
modelIdx = 1;
nSubj = length(data);
setsize = 4;
conditions = {'Ns4,baseline', 'Ns4,train', 'Ns4,perform', 'Ns4,test'};

%%  Set incentive structure
for i = 1:4
    incentives{i} = [eye(4), transpose([0 1 0 0])];
end
manipulation = [eye(4), transpose([0 1 0 0])];
manipulation(1,1) = 5;
incentives{3} = manipulation;


%%  Simulate
results = results(modelIdx);
for subj = 1:nSubj
    agent.m = results.K;
    agent.C = [];
    agent.lrate_beta = 0;
    agent.lrate_e = 0.1;
    for k = 1:length(results.param)
        agent.(results.param(k).name) = results.x(subj,k);
    end
    
    % stores the task environment
    idx = [];
    for cond = 1:length(conditions)
        idx = [idx find(strcmp(data(subj).cond, conditions(cond)))'];
    end
    
    task.s = data(subj).s(idx);
    task.cond = data(subj).cond(idx);
    
    % sim data using the fitted model parameter and task env
    simdata(subj) = actor_critic_sim_incentive(agent, task, setsize, incentives);
end
