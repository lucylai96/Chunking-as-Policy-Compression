function analysis_manip(data)

prettyplot;
if nargin<1; load('data_manip_3.mat'); end
nSubj = length(data);
threshold = 0.4;   % lowest accuracy in each block
condition = {'random', 'structured_normal', 'structured_load', 'structured_incentive'};
Xlabel =     {'Random', 'Baseline', 'Load', 'Incentive'};
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
subplot 231; hold on;
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

subplot 232; hold on;
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

subplot 233; hold on;
X = 1:length(condition);
b = bar(X, mean(rt,1), 0.7, 'FaceColor', 'flat');
for i = 1:length(condition)
    b.CData(i,:) = bmap(i,:);
end
errorbar(X, mean(rt,1), sem, sem, 'k','linestyle','none', 'lineWidth', 1.2);
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

subplot 234; hold on;
X = 1:length(condition);
b = bar(X, nanmean(rtChunk,1), 0.7, 'FaceColor', 'flat');
for i = 1:length(condition)
    b.CData(i,:) = bmap(i,:);
end
errorbar(X, nanmean(rtChunk,1), sem, sem, 'k','linestyle','none', 'lineWidth', 1.2);
set(gca, 'XTick',X, 'XTickLabel', Xlabel);
xlabel('Block'); ylabel('Intrachunk RT (ms)');

%% Ann's version

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
        idx = state==chunk(2) & action==chunk(2);  % identify (correct) intrachunk states
        avgRT(1,c,s) = nanmean(rt(state~=chunk(2) & state==action));  % nonchunk RTs
        avgRT(2,c,s) = nanmean(rt(idx));           % avg intrachunk RTs
    end
end

for i = 1:3  % nonchunk RTs / non-chunk RTs
    avgRT(2,i,:) = squeeze(avgRT(2,i,:)) ./ squeeze(avgRT(1,i,:)); % ICRTs  / nonchunk RTs (<1 means more chunking)
    avgRT(1,i,:) = squeeze(avgRT(1,i,:)) ./ squeeze(avgRT(1,i,:)); % nonchunk RTs / nonchunk RTs
    sem(1,i) = nanstd(squeeze(avgRT(1,i,:))) / sqrt(nSubj);
    sem(2,i) = nanstd(squeeze(avgRT(2,i,:))) / sqrt(nSubj);
end

subplot 235; hold on;
% b = bar(nanmean(avgRT,3), 'FaceColor', 'flat');
% for i = 1:3
%     b(i).CData(1,:) = bmap(i+1,:);
%     b(i).CData(2,:) = bmap(i+1,:);
% end
% box off; ylim([0 1.2]);
% ylabel('Normalized RT (ms)'); box off;
% set(gca, 'XTick',1:2, 'XTickLabel', {'Other states', 'IntraChunk state'});
% legend('Baseline', 'Load manipulation', 'Incentive manipulation', 'location', 'northeast');
% legend('boxoff');
% errorbar_pos = errorbarPosition(b, sem);
% errorbar(errorbar_pos', nanmean(avgRT,3), sem, sem, 'k','linestyle','none', 'lineWidth', 1.2);

tmp = nanmean(avgRT,3); 
h = bar(tmp(2,:), 0.7, 'FaceColor', 'flat');
set(gca, 'XTick',1:3, 'XTickLabel', {'Baseline', 'Load', 'Incentive'});
for i = 1:length(conds)
    h.CData(i,:) = bmap(i+1,:);
end
errorbar(1:3, tmp(2,:), sem(2,:), sem(2,:), 'k','linestyle','none', 'lineWidth', 1.2);
%ylim([0 1.05]);
xlabel('Block'); ylabel('Normalized ICRT');


%% Inchunk RT VS exochunk RT--compared within structured blocks

% conds = {'structured_normal', 'structured_load', 'structured_incentive'};
% avgRT = zeros(2, length(conds), nSubj);
% sem = zeros(2, length(conds));
% for s = 1:nSubj
%     for c = 1:length(conds)
%         idx = strcmp(data(s).cond, conds{c});
%         rt = data(s).rt(idx);
%         state = data(s).s(idx);
%         action = data(s).a(idx);
%         chunk = data(s).chunk.(conds{c});
%         idx = state==chunk(2) & action==chunk(2);                     % identify (correct) intrachunk states
%         avgRT(1,c,s) = nanmean(rt(idx));                              % avg intrachunk RT
%         avgRT(2,c,s) = nanmean(rt(state~=chunk(2) & state==action));  % identify non-chunk correct answers
%     end
% end
% 
% % need to do within subject not across subject
% % before: avgRT(2,i,:) / nanmean(avgRT(1,c,:),3);
% % after: nanmean(avgRT(2,i,:) / avgRT(1,c,:)),3);
% for c = 1:length(conds)
%     avgRT1(2,c,:) =  avgRT(2,c,:) / nanmean(avgRT(1,c,:),3);
%     avgRT1(1,c,:) = avgRT(1,c,:) / nanmean(avgRT(1,c,:),3);
%     sem(2,c) = nanstd(squeeze(avgRT1(2,c,:))) / sqrt(nSubj);
%     sem(1,c) = nanstd(squeeze(avgRT1(1,c,:))) / sqrt(nSubj);
% end
% 
% subplot 235; hold on;
% b = bar(nanmean(avgRT1,3), 'FaceColor', 'flat');
% hold on;
% for i = 1:3
%     b(i).CData(1,:) = bmap(i+1,:);
%     b(i).CData(2,:) = bmap(i+1,:);
% end
% box off; ylim([0 1.2]);
% ylabel('Normalized RT (ms)');
% set(gca, 'XTick',1:2, 'XTickLabel', {'Other states', 'IntraChunk state'});
% legend('Baseline', 'Load manipulation', 'Incentive manipulation');
% errorbar_pos = errorbarPosition(b, sem);
% errorbar(errorbar_pos', nanmean(avgRT1,3), sem, sem, 'k','linestyle','none', 'lineWidth', 1.2);
% 
% subplot 236; hold on;
% 
% % ICRTs divided by avg RTs per subject, <1 means ICRTs shorter than RTs
% for c = 1:length(conds)
%     avgRT2(c) = nanmean(avgRT(1,c,:)./avgRT(2,c,:),3);
%     sem2(c) = nanstd(squeeze(avgRT(1,c,:)./avgRT(2,c,:))) / sqrt(nSubj);
% end
% 
% h = bar(avgRT2, 0.7, 'FaceColor', 'flat');
% set(gca, 'XTick',1:3, 'XTickLabel', {'Baseline', 'Load', 'Incentive'});
% for i = 1:length(conds)
%     h.CData(i,:) = bmap(i+1,:);
% end
% errorbar(1:3, avgRT2', sem2, sem2, 'k','linestyle','none', 'lineWidth', 1.2);
% 
% ylim([0 1.05]);
% xlabel('Block'); ylabel('Normalized ICRT');


%% Policy-complexity in different blocks

recode = 1;
maxReward = [120 120 120 120];
[reward, complexity] = calculateRPC(data, condition, recode, maxReward);
sem = nanstd(complexity,1)/sqrt(nSubj);

subplot 236; hold on;
X = 1:length(condition);
b = bar(X, mean(complexity,1), 0.7, 'FaceColor', 'flat');
for i = 1:length(condition)
    b.CData(i,:) = bmap(i,:);
end
errorbar(X, mean(complexity,1), sem, sem, 'k','linestyle','none', 'lineWidth', 1.2);
set(gca, 'XTick',X, 'XTickLabel', Xlabel);
xlabel('Block'); ylabel('Average Policy Complexity');


set(gcf, 'Position',  [0, 0, 1800, 1000])

%% Reward-complexity curve
plot_RPCcurve(reward, complexity, [1 2], {'Random', 'Structured,Normal'}, 'load_incentive_manip');
plot_RPCcurve(reward, complexity, [2 3 4], {'Baseline', 'Load manipulation', 'Incentive manipulation'}, 'load_incentive_manip');


%% Test whether policy capacity changed from 0 in reward and whether complexity changed from 
plot_RPCcurve(reward, complexity, [2 4], {'Baseline', 'Incentive manipulation'}, 'load_incentive_manip');
plot(complexity(:,[2,4])', reward(:,[2 4])','--','Color',[0.75 0.75 0.75])
[h,p,ci,stats] = ttest(complexity(:,4)-complexity(:,2),0) % test the hypothesis that the difference in complexity come from a distribution with mean 0
% h = 0 means it is centered around 0

%Scaled JZS Bayes Factor = 3.150472
%Scaled-Information Bayes Factor = 2.382151

figure; hold on;
b = bar([1 2], mean(complexity(:,[2,3]),1), 0.7, 'FaceColor', 'flat'); % load and baseline only, connect two
errorbar([1 2], mean(complexity(:,[2,3]),1), sem(2:3), sem(2:3), 'k','linestyle','none', 'lineWidth', 1.2);
b.CData(1,:) = bmap(2,:); b.CData(2,:) = bmap(3,:);
plot(repmat([1;2],1,length(complexity(:,[2,3])')), complexity(:,[2,3])','--','Color',[0.75 0.75 0.75])
ylabel('Policy Complexity'); 
set(gca, 'XTick',[1 2], 'XTickLabel', {Xlabel{2} Xlabel{3}});
xlabel('Block')
for i = 2:3
    scatter(repmat(i-1,1,length(complexity(:,i'))),complexity(:,i)',100,bmap(i,:),'filled','MarkerEdgeColor',[1 1 1],'LineWidth',1.5,'MarkerFaceAlpha',0.75','jitter','on','jitterAmount',0.05); hold on;
end

[h,p,ci,stats] = ttest(complexity(:,3)-complexity(:,2),0) % test the hypothesis that the difference in complexity come from a distribution with mean 0
% h = 1 means its different than 0!

%% Statistical tests
% on average accuracy
[h,p] = ttest2(acc(:,1), acc(:,2), 'tail', 'left');
[h,p] = ttest2(acc(:,3), acc(:,2), 'tail', 'left');
[h,p] = ttest2(acc(:,3), acc(:,4), 'tail', 'left');

% on policy complexity
[h,p] = ttest2(complexity(:,1), complexity(:,2), 'tail', 'right');
[h,p] = ttest2(complexity(:,2), complexity(:,3), 'tail', 'right') %  p=0.11
[h,p] = ttest2(complexity(:,3), complexity(:,4), 'tail', 'left');
[h,p] = ttest2(complexity(:,2), complexity(:,4), 'tail', 'left');
end