function simdata = sim_rc_tradeoff()
rng(0);
% simlation for load and incentive

load('data_manip_2.mat');

C = rand(1,length(data));

for s = 1:length(data)
    agent.lrate_V = 0.2;
    agent.lrate_theta = 0.2;
    agent.lrate_beta = 0.1;
    agent.beta = 1;
    agent.lrate_p = 0;
    agent.lrate_e = 0.2;
    agent.m = 2;
    
    % baseline condition in Random block
    agent.C = C(s);
    cond = {'random'};
    incentives.Ns4 = [eye(4), transpose([0 1 0 0])];
    simdata.random(s) = actor_critic_sim(agent, data(s), incentives, cond);
    
    % baseline condition in Structured block
    agent.C = C(s);
    cond = {'structured_normal'};
    incentives.Ns4 = [eye(4), transpose([0 1 0 0])];
    simdata.baseline(s) = actor_critic_sim(agent, data(s), incentives, cond);
    
    % load manipulation in Structured block
    agent.C = C(s)-0.3;
    cond = {'structured_load'};
    incentives.Ns4 = [eye(4), transpose([0 1 0 0])];
    simdata.load(s) = actor_critic_sim(agent, data(s), incentives, cond);
    
    % incentive manipulation in Structured block
    agent.C = C(s);
    cond = {'structured_incentive'};
    reward = [eye(4), transpose([0 1 0 0])]; reward(1,1) = 5;
    incentives.Ns4 = reward;
    simdata.incentive(s) = actor_critic_sim(agent, data(s), incentives, cond);
end

%% Analyze simulated data

recode = 0;
[random.r, random.pc]   = calculateRPC(simdata.random, {'random'}, recode, [120]);
[baseline.r, baseline.pc]   = calculateRPC(simdata.baseline, {'structured_normal'}, recode, [120]);
[cogload.r, cogload.pc]     = calculateRPC(simdata.load, {'structured_load'}, recode, [120]);
[incentive.r, incentive.pc] = calculateRPC(simdata.incentive, {'structured_incentive'}, recode, [120]);

reward = zeros(1,3); sem_reward = zeros(1,3);
complexity = zeros(1,3); sem_complexity = zeros(1,3);
for i = 1:3
    reward(1) = mean(baseline.r); sem_reward(1) = std(baseline.r)/sqrt(length(data));
    reward(2) = mean(cogload.r); sem_reward(2) = std(cogload.r)/sqrt(length(data));
    reward(3) = mean(incentive.r); sem_reward(3) = std(incentive.r)/sqrt(length(data));
    
    complexity(1) = mean(baseline.pc); sem_complexity(1) = std(baseline.pc)/sqrt(length(data));
    complexity(2) = mean(cogload.pc); sem_complexity(2) = std(cogload.pc)/sqrt(length(data));
    complexity(3) = mean(incentive.pc); sem_complexity(3) = std(incentive.pc)/sqrt(length(data));
end

%% Plotting

% Reward-Complexity Tradeoff
bmap = [0 0 0
        70 130 180
        60 179 113]/255;

figure; hold on;
scatter(baseline.pc, baseline.r, 120, 'filled', 'MarkerFaceColor', bmap(1,:));
scatter(cogload.pc, cogload.r, 120, 'filled', 'MarkerFaceColor',bmap(2,:));
scatter(incentive.pc, incentive.r, 120, 'filled', 'MarkerFaceColor',bmap(3,:));
legend({'Baseline', 'Load manipulation', 'Incentive manipulation'}, 'location', 'southeast', 'Fontsize', 18);
legend('boxoff');
xlabel('Policy Complexity'); ylabel('Average Reward');

% Average Reward
figure; hold on;
b = bar(1:3, reward, 0.7);
b.FaceColor = 'flat';
for i = 1:length(reward)
    b.CData(i,:) = bmap(i,:);
end
errorbar(1:3, reward, sem_reward, sem_reward, 'k','linestyle','none', 'lineWidth', 1.2);
set(gca, 'XTick', 1:3, 'XTickLabel', {'Baseline', 'Load', 'Incentive'});
ylabel('Average reward');

% Average Policy Complexity
figure; hold on;
b = bar(1:3, complexity, 0.7);
b.FaceColor = 'flat';
for i = 1:length(complexity)
    b.CData(i,:) = bmap(i,:);
end
errorbar(1:3, complexity, sem_complexity, sem_complexity, 'k','linestyle','none', 'lineWidth', 1.2);
set(gca, 'XTick', 1:3, 'XTickLabel', {'Baseline', 'Load', 'Incentive'});
ylabel('Policy complexity');
    