function analyze_manip()

prettyplot;
nSubj = length(data);
threshold = 0.4;   % lowest accuracy in each block
condition = {'random', 'structured_normal', 'structured_load', 'structured_incentive'};
Xlabel =     {'Random', 'Structured Baseline', 'Structured Load', 'Structured Incentive'};
bmap = [190 190 190
        0 0 0
        70 130 180
        60 179 113]/255;

%% Average Accuracy

acc = nan(nSubj, length(condition));
for s = 1:nSubj
    for c = 1:length(condition)
        accData = data(s).s == data(s).a;
        acc(s,c) = nanmean(accData(strcmp(data(s).cond, condition{c})));
    end
end

idx = ones(nSubj, 1);
for c = 1:length(condition)
    idx = idx & acc(:,c)>threshold;
end
acc = acc(idx,:);
sem = nanstd(acc,1) / sqrt(nSubj);

figure; hold on;
X = 1:length(condition);
b = bar(X, mean(acc,1), 0.7, 'FaceColor', 'flat');
for i = 1:length(condition)
    b.CData(i,:) = bmap(i,:);
end
errorbar(X, mean(acc,1), sem, sem, 'k','linestyle','none', 'lineWidth', 1.8);
ylim([0 1]);
set(gca, 'XTick',X, 'XTickLabel', Xlabel);
xlabel('Block'); ylabel('Average accuracy');
%exportgraphics(gcf,[pwd '/figures_load_incentive/avgAcc.png']);

data = data(idx);
nSubj = length(data);


%% Average Reward

reward = nan(nSubj, length(condition));
for s = 1:nSubj
    for c = 1:length(condition)
        reward(s,c) = sum(data(s).r(strcmp(data(s).cond, condition{c})));
    end
    reward(s,:) = reward(s,:) ./ [120 120 120 120];
end
sem = nanstd(reward,1) / sqrt(nSubj);

figure; hold on;
X = 1:length(condition);
b = bar(X, mean(reward,1), 0.7, 'FaceColor', 'flat');
for i = 1:length(condition)
    b.CData(i,:) = bmap(i,:);
end
ylim([0 2]);
errorbar(X, mean(reward,1), sem, sem, 'k','linestyle','none', 'lineWidth', 1.2);
set(gca, 'XTick',X, 'XTickLabel', Xlabel);
xlabel('Block'); ylabel('Average reward');

%% Average RT

rt = nan(nSubj, length(condition));
for s = 1:nSubj
    for c = 1:length(condition)
        rtData = data(s).rt;
        rt(s,c) = nanmean(rtData(strcmp(data(s).cond, condition(c))));
    end
end
sem = nanstd(rt,1) / sqrt(nSubj);

figure; hold on;
X = 1:length(condition);
b = bar(X, nanmean(rt,1), 0.7, 'FaceColor', 'flat');
for i = 1:length(condition)
    b.CData(i,:) = bmap(i,:);
end
errorbar(X, nanmean(rt,1), sem, sem, 'k','linestyle','none', 'lineWidth', 1.2);
set(gca, 'XTick',X, 'XTickLabel', Xlabel);
xlabel('Block'); ylabel('Average RT (ms)');


%% Intrachunk RT

rtChunk = zeros(nSubj, length(condition));
for s = 1:nSubj
    for c = 1:length(condition)
        idx = strcmp(data(s).cond, condition{c});
        rt = data(s).rt(idx);
        if strcmp(condition{c}, 'random')
            rtChunk(s,c) = nanmean(rt(data(s).s(idx)==data(s).a(idx)));
        elseif contains(condition{c}, 'structured')
            state = data(s).s(idx);
            action = data(s).a(idx);
            chunk = data(s).chunk.(condition{c});
            rtChunk(s,c) = nanmean(rt(state==chunk(2) & action==chunk(2)));
        end
    end
end
sem = nanstd(rtChunk,1) / sqrt(nSubj);

figure; hold on;
X = 1:length(condition);
b = bar(X, nanmean(rtChunk,1), 0.7, 'FaceColor', 'flat');
for i = 1:length(condition)
    b.CData(i,:) = bmap(i,:);
end
errorbar(X, nanmean(rtChunk,1), sem, sem, 'k','linestyle','none', 'lineWidth', 1.2);
set(gca, 'XTick',X, 'XTickLabel', Xlabel);
xlabel('Block'); ylabel('Intrachunk RT (ms)');


%% Inchunk RT VS extrachunk RT--compared within structured blocks

conds = {'structured_normal', 'structured_load', 'structured_incentive'};
avgRT = zeros(2, length(conds), nSubj);
avgAll = zeros(length(conds), nSubj);
sem = zeros(2, length(conds));
for s = 1:nSubj
    for c = 1:length(conds)
        idx = strcmp(data(s).cond, conds{c});
        rt = data(s).rt(idx);
        state = data(s).s(idx);
        action = data(s).a(idx);
        chunk = data(s).chunk.(conds{c});
        idx = state==chunk(2) & action==chunk(2);
        avgRT(1,c,s) = nanmean(rt(idx));
        avgRT(2,c,s) = nanmean(rt(state~=chunk(2) & state==action));
        avgAll(c,s) = nanmean(rt);
    end
end

for i = 1:3
    avgRT(2,i,:) = squeeze(avgRT(2,i,:)) ./ avgAll(i,:)';
    avgRT(1,i,:) = squeeze(avgRT(1,i,:)) ./ avgAll(i,:)';
    sem(2,i) = nanstd(squeeze(avgRT(2,i,:))) / sqrt(nSubj);
    sem(1,i) = nanstd(squeeze(avgRT(1,i,:))) / sqrt(nSubj);
end

figure;
b = bar(nanmean(avgRT,3), 'FaceColor', 'flat');
hold on;
for i = 1:3
    b(i).CData(1,:) = bmap(i+1,:);
    b(i).CData(2,:) = bmap(i+1,:);
end
box off; ylim([0 1.2]);
ylabel('Normalized RT (ms)'); box off;
set(gca, 'XTick',1:2, 'XTickLabel', {'Other states', 'IntraChunk state'});
legend('Baseline', 'Load manipulation', 'Incentive manipulation', 'location', 'northeast');
legend('boxoff');
errorbar_pos = errorbarPosition(b, sem);
errorbar(errorbar_pos', nanmean(avgRT,3), sem, sem, 'k','linestyle','none', 'lineWidth', 1.2);

figure; hold on;
tmp = nanmean(avgRT,3); 
h = bar(tmp(2,:), 0.7, 'FaceColor', 'flat');
set(gca, 'XTick',1:3, 'XTickLabel', {'Baseline', 'Load', 'Incentive'});
for i = 1:length(conds)
    h.CData(i,:) = bmap(i+1,:);
end
errorbar(1:3, tmp(2,:), sem(2,:), sem(2,:), 'k','linestyle','none', 'lineWidth', 1.2);
ylim([0 1.05]);
xlabel('Block'); ylabel('Normalized ICRT');




%% Policy-complexity in different blocks

recode = 1;   
maxReward = [120 120 120 120];
[reward, complexity] = calculateRPC(data, condition, recode, maxReward);
sem = nanstd(complexity,1)/sqrt(nSubj);

figure; hold on;
X = 1:length(condition);
b = bar(X, mean(complexity,1), 0.7, 'FaceColor', 'flat');
for i = 1:length(condition)
    b.CData(i,:) = bmap(i,:);
end
errorbar(X, mean(complexity,1), sem, sem, 'k','linestyle','none', 'lineWidth', 1.2);
set(gca, 'XTick',X, 'XTickLabel', Xlabel);
xlabel('Block'); ylabel('Average Policy Complexity');


%% Reward-complexity curve
plot_RPCcurve(reward, complexity, [1 2], {'Random', 'Structured,Normal'}, 'load_incentive_manip');
plot_RPCcurve(reward, complexity, [1 2 3 4], {'Random', 'Baseline', 'Load manipulation', 'Incentive manipulation'}, 'load_incentive_manip');


%% Statistical tests 
% on average accuracy
[h,p] = ttest2(acc(:,1), acc(:,2), 'tail', 'left')
[h,p] = ttest2(acc(:,3), acc(:,2), 'tail', 'left')
[h,p] = ttest2(acc(:,3), acc(:,4), 'tail', 'left')

% on policy complexity
[h,p] = ttest2(complexity(:,1), complexity(:,2), 'tail', 'right')
[h,p] = ttest2(complexity(:,2), complexity(:,3), 'tail', 'right')
[h,p] = ttest2(complexity(:,3), complexity(:,4), 'tail', 'left')
[h,p] = ttest2(complexity(:,2), complexity(:,4), 'tail', 'left')
end