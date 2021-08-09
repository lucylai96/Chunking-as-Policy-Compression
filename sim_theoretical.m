function simdata = sim_theoretical()

nSubj = 10;
%beta = [repmat([1], [1 9]) repmat([2], [1 9]) repmat([3], [1 9]) repmat([4], [1 9]) repmat([5], [1 9])];
beta = linspace(1, 10, 10);
load('actionChunk_data.mat');

for s = 1:nSubj
    % construct the agent 
    agent.m = 4;
    agent.C = [];
    agent.lrate_beta = 0;
    agent.lrate_e = 0.1;
    agent.lrate_theta = 0.15; 
    agent.lrate_V = 0.15;
    agent.lrate_p = 0.02;
    agent.beta = beta(s);
    
    % simulate the task
    task.s = data(s).s;
    task.cond = data(s).cond;
      
    % simulate agent performing the task
    simdata(s) = actor_critic_sim_incentive(agent, task);
    %simdata(s) = actor_critic_sim_0(agent, task);
end

end
    