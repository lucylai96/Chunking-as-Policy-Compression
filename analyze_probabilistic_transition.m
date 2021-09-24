function analyze_probabilistic_transition(data)

%{
    Plot the ICRT and IC_accuracy for different manipulation blocks.

    USAGE: analyze_probabilistic_transition()

    Called by: plot_all_figures()
%}

prettyplot;
if nargin==0; load('data_probabilistic.mat'); end
nSubj = length(data);
threshold = 0.4;   % lowest accuracy in each block
struc_conds = {'structured_normal', 'structured_load', 'structured_incentive'};
Xlabel =      {'Baseline', 'Load', 'Incentive'};
bmap = [190 190 190
    0 0 0
    70 130 180
    60 179 113]/255;

%% Compare ICRT & IC_accuracy for the correctly responded ICS

ICRT = nan(nSubj, length(struc_conds), 2);  % ICRT(:,:,1) frequent transition; ICRT(:,:,2) rare transition
ICRT_hit = nan(nSubj, length(struc_conds), 2);  % ICRT(:,:,1) frequent transition; ICRT(:,:,2) rare transition
IC_acc = nan(nSubj, length(struc_conds), 2);
action_slips = nan(nSubj, length(struc_conds));
for subj = 1:nSubj
    for c = 1:length(struc_conds) % each condition
        chunk = data(subj).chunk.(struc_conds{c});
        s = data(subj).s(strcmp(data(subj).cond, struc_conds{c}));
        a = data(subj).a(strcmp(data(subj).cond, struc_conds{c}));
        rt = data(subj).rt(strcmp(data(subj).cond, struc_conds{c}));
        rt(rt > mean(rt)+3*std(rt) | rt < mean(rt)-3*std(rt))
        rt(rt > mean(rt)+3*std(rt) | rt < mean(rt)-3*std(rt)) = NaN;
        
        
        CIS_idx = find(s == chunk(1));
        IC_idx = CIS_idx + 1;
        ICS = unique(s(IC_idx));   % find the 2 possible states following the CIS
        ICS_frequency = [sum(s(IC_idx)==ICS(1)) sum(s(IC_idx)==ICS(2))];
        
        ICS_freq = ICS(ICS_frequency == max(ICS_frequency)); % the intrachunk state in the more frequent transition
        ICS_rare = ICS(ICS_frequency == min(ICS_frequency)); % the "intrachunk" state in the rare transition
        IC_idx_freq = intersect(IC_idx, find(s==ICS_freq));  % all trials with freq regardless of correct or not
        IC_idx_rare = intersect(IC_idx, find(s==ICS_rare));
        IC_idx_freq_hit = intersect(IC_idx, find(s==ICS_freq & s==a)); % only take the ones that are correct/hit
        IC_idx_rare_hit = intersect(IC_idx, find(s==ICS_rare & s==a));
        
        ICRT(subj,c,1) = nanmean(rt(IC_idx_freq));
        ICRT(subj,c,2) = nanmean(rt(IC_idx_rare));
        ICRT_hit(subj,c,1) = nanmean(rt(IC_idx_freq_hit));
        ICRT_hit(subj,c,2) = nanmean(rt(IC_idx_rare_hit));
        IC_acc(subj,c,1) = nanmean(s(IC_idx_freq) == a(IC_idx_freq));
        IC_acc(subj,c,2) = nanmean(s(IC_idx_rare) == a(IC_idx_rare));
        
        numSlips = sum(a(IC_idx_rare)==ICS_freq);
        action_slips(subj,c) = numSlips;
    end
end

%% Plot ICRT & IC_accuracy
% the ICRT (all)
sem_ICRT = squeeze(nanstd(ICRT, 1) / sqrt(nSubj));     % size(sem_ICRT) = (3,2)
mean_ICRT = squeeze(nanmean(ICRT, 1));
figure; hold on; subplot 221; hold on;
X = 1:length(struc_conds);
b = bar(X, mean_ICRT, 0.7, 'FaceColor', 'flat');
errorbar_pos = errorbarPosition(b, sem_ICRT);
errorbar(errorbar_pos', mean_ICRT, sem_ICRT, sem_ICRT, 'k','linestyle','none', 'lineWidth', 1.5);
set(gca, 'XTick',X, 'XTickLabel', Xlabel);
legend({'Frequent transition', 'Rare transition'});
legend('boxoff');
xlabel('Block'); ylabel('Response Time (ms)'); title('All Trials')
ylim([600 800])

% the ICRT (correct)
sem_ICRT = squeeze(nanstd(ICRT_hit, 1) / sqrt(nSubj));     % size(sem_ICRT) = (3,2)
mean_ICRT = squeeze(nanmean(ICRT_hit, 1));
subplot 222; hold on;
X = 1:length(struc_conds);
b = bar(X, mean_ICRT, 0.7, 'FaceColor', 'flat');
errorbar_pos = errorbarPosition(b, sem_ICRT);
errorbar(errorbar_pos', mean_ICRT, sem_ICRT, sem_ICRT, 'k','linestyle','none', 'lineWidth', 1.5);
set(gca, 'XTick',X, 'XTickLabel', Xlabel);
legend({'Frequent transition', 'Rare transition'});
legend('boxoff');
xlabel('Block'); ylabel('Response Time(ms)'); title('Correct Trials Only')
ylim([600 800])

% the IC_accuracy
sem_IC_acc = squeeze(nanstd(IC_acc, 1) / sqrt(nSubj));
mean_IC_acc = squeeze(nanmean(IC_acc, 1));
subplot 223;
hold on;
X = 1:length(struc_conds);
b = bar(X, mean_IC_acc, 0.7, 'FaceColor', 'flat');
errorbar_pos = errorbarPosition(b, sem_IC_acc);
errorbar(errorbar_pos', mean_IC_acc, sem_IC_acc, sem_IC_acc, 'k','linestyle','none', 'lineWidth', 1.5);
set(gca, 'XTick',X, 'XTickLabel', Xlabel);
legend({'Frequent transition', 'Rare transition'});
legend('boxoff')
xlabel('Block'); ylabel('Average Accuracy');
ylim([0.6 1])

% action slips
subplot 224; hold on;
bar(squeeze(nanmean(action_slips,1))); % when the freq transition is chosen during the rare state
errorbar(X, squeeze(nanmean(action_slips,1)), squeeze(nanstd(action_slips,1)./sqrt(nSubj)), squeeze(nanstd(action_slips,1)./sqrt(nSubj)), 'k','linestyle','none', 'lineWidth', 1.5);
set(gca, 'XTick',X, 'XTickLabel', Xlabel);
xlabel('Block'); ylabel('% Action Slips (a=freq when s=rare)');


%% policy complexity
condition = {'random','structured_normal', 'structured_load', 'structured_incentive'};
maxReward = [140 140 140 140];
recode = 1;     % whether to calculate recoded policy complexity
[reward, complexity] = calculateRPC(data, condition, recode, maxReward);


threshold = 0.4;
idx = ones(nSubj, 1);
for c = 1:length(condition)
    idx = idx & reward(:,c)>threshold;
end
reward = reward(idx,:); complexity = complexity(idx,:);

sem = nanstd(complexity,1)/sqrt(nSubj);

% policy complexity in diff blocks
figure; hold on;
X = 1:length(condition);
b = bar(X, mean(complexity,1), 0.7, 'FaceColor', 'flat');
for i = 1:length(condition)
    b.CData(i,:) = bmap(i,:);
end
errorbar(X, mean(complexity,1), sem, sem, 'k','linestyle','none', 'lineWidth', 1.2);
set(gca, 'XTick',X, 'XTickLabel', Xlabel);
xlabel('Block'); ylabel('Average Policy Complexity');

% policy complexity lower  w ICRT? 

end

