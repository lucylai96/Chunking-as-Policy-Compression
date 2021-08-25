function policy_complexity_analysis_load_incentive()

prettyplot;
load('load_incentive_data.mat');   
nSubj = length(data);
condition = {'random train', 'structured train', 'structured test, normal',...
             'structured test, load', 'structured test, incentive', 'random test'};

recode = 1;     % whether to calculate recoded policy complexity
[reward, complexity] = calculateRPC(data, condition, 'incentive', recode);        

threshold = 0.4;
idx = ones(nSubj, 1);
for c = 1:length(condition)
    idx = idx & reward(:,c)>threshold;
end
reward = reward(idx,:); complexity = complexity(idx,:);

%% Average policy complexity for different blocks
sem = nanstd(complexity,1)/sqrt(nSubj);

figure; hold on;
X = 1:length(condition);
bar(X, mean(complexity,1));
errorbar(X, mean(complexity,1), sem, sem, 'k','linestyle','none', 'lineWidth', 1.2);
set(gca, 'XTick',X, 'XTickLabel', condition);
xlabel('Block'); ylabel('Average accuracy');
exportgraphics(gcf,[pwd '/figures_load_incentive/avgComplexity.png']);


%% Reward-complexity curve
plot_RPCcurve(reward, complexity, [1 2], {'Random Train', 'Structured Train'});
plot_RPCcurve(reward, complexity, [3 6], {'Structured Test', 'Random Test'});
plot_RPCcurve(reward, complexity, [3 4 5], {'Regular', 'Load manipulation', 'Incentive manipulation'}, 'load_incentive_manip');

end