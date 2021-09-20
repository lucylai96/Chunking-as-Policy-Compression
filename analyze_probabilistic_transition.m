function analyze_probabilistic_transition()

prettyplot;
nSubj = length(data);
threshold = 0.4;   % lowest accuracy in each block
struc_conds = {'structured_normal', 'structured_load', 'structured_incentive'};
Xlabel =      {'Structured Baseline', 'Structured Load', 'Structured Incentive'};
bmap = [190 190 190
        0 0 0
        70 130 180
        60 179 113]/255;
    
%% Compare ICRT & IC_accuracy

ICRT = nan(nSubj, length(struc_conds), 2);  % ICRT(:,:,1) frequent transition; ICRT(:,:,2) rare transition
IC_acc = nan(nSubj, length(struc_conds), 2);
action_slips = nan(nSubj, length(struc_conds));
for subj = 1:nSubj
    for c = 1:length(struc_conds)
        chunk = data(subj).chunk.(struc_conds{c});
        s = data(subj).s(strcmp(data(subj).cond, struc_conds{c}));
        a = data(subj).a(strcmp(data(subj).cond, struc_conds{c}));
        rt = data(subj).rt(strcmp(data(subj).cond, struc_conds{c}));
        
        CIS_idx = find(s == chunk(1));
        IC_idx = CIS_idx + 1;
        ICS = unique(s(IC_idx));   % find the 2 possible states following the CIS
        ICS_frequency = [sum(s(IC_idx)==ICS(1)) sum(s(IC_idx)==ICS(2))]; 
        
        ICS_freq = ICS(ICS_frequency == max(ICS_frequency)); % the intrachunk state in the more frequent transition
        ICS_rare = ICS(ICS_frequency == min(ICS_frequency)); % the "intrachunk" state in the rare transition
        IC_idx_freq = intersect(IC_idx, find(s==ICS_freq & s==a));
        IC_idx_rare = intersect(IC_idx, find(s==ICS_rare & s==a));
        
        ICRT(subj,c,1) = nanmean(rt(IC_idx_freq));
        ICRT(subj,c,2) = nanmean(rt(IC_idx_rare));
        IC_acc(subj,c,1) = mean(s(IC_idx_freq) == a(IC_idx_freq));
        IC_acc(subj,c,2) = mean(s(IC_idx_rare) == a(IC_idx_rare));
        
        numSlips = sum(a(IC_idx_rare)==ICS_freq);
        action_slips(subj,c) = numSlips;
    end
end
        
%% Plot ICRT & IC_accuracy
% the ICRT
sem_ICRT = squeeze(nanstd(ICRT, 1) / sqrt(nSubj));     % size(sem_ICRT) = (3,2)
mean_ICRT = squeeze(nanmean(ICRT, 1));
figure; 
hold on;
X = 1:length(struc_conds);
b = bar(X, mean_ICRT, 0.7, 'FaceColor', 'flat');
errorbar_pos = errorbarPosition(b, sem_ICRT);
errorbar(errorbar_pos', mean_ICRT, sem_ICRT, sem_ICRT, 'k','linestyle','none', 'lineWidth', 1.5);
set(gca, 'XTick',X, 'XTickLabel', Xlabel);
legend({'Frequent transition', 'Rare transition'});
legend('boxoff');
xlabel('Block'); ylabel('Response Time (ms)');
        
% the IC_accuracy
sem_IC_acc = squeeze(std(IC_acc, 1) / sqrt(nSubj));   
mean_IC_acc = squeeze(mean(IC_acc, 1));
figure; 
hold on;
X = 1:length(struc_conds);
b = bar(X, mean_IC_acc, 0.7, 'FaceColor', 'flat');
errorbar_pos = errorbarPosition(b, sem_IC_acc);
errorbar(errorbar_pos', mean_IC_acc, sem_IC_acc, sem_IC_acc, 'k','linestyle','none', 'lineWidth', 1.5);
set(gca, 'XTick',X, 'XTickLabel', Xlabel);
legend({'Frequent transition', 'Rare transition'});
legend('boxoff')
xlabel('Block'); ylabel('Average Accuracy');

% action slips
bar(squeeze(sum(action_slips,1)))


    