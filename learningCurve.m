function learningCurve(data)
bmap = [
             16 78 139
             165 42 42
             141 182 205    
             255 140 105] /255;  
    
if nargin<1; load('actionChunk_data.mat'); end

stateConds = {'Ns4,baseline', 'Ns4,train', 'Ns6,baseline', 'Ns6,train'};
nSubj = length(data);
nPresent = sum(data(1).s(strcmp(data(1).cond, stateConds{1}))==1);

accuracy = nan(length(stateConds), nSubj, nPresent);
for s = 1:nSubj
    for condIdx = 1:length(stateConds)
        states = data(s).s(strcmp(data(s).cond, stateConds{condIdx}));
        acc = data(s).acc(strcmp(data(s).cond, stateConds{condIdx}));
        acc_by_nPres = nan(length(unique(states)), nPresent);
        for i = 1:length(unique(states))
            acc_by_nPres(i,:) = acc(states==i);
        end
        accuracy(condIdx,s,:) = nanmean(acc_by_nPres, 1);
    end
end

avgAccuracy = squeeze(nanmean(accuracy, 2));
%avgAccuracy = movmean(avgAccuracy,2);
figure; hold on;
colororder(bmap);
X = 1:nPresent;
for i = 1:length(stateConds)
    plot(X, avgAccuracy(i,:), 'LineWidth', 3.5);
end
legend({'Ns=4 Random Train', 'Ns=4 Structured Train', 'Ns=6 Random Train',...
        'Ns=6 Structured Train'}, 'Location', 'southeast');
legend('boxoff');
xlabel('Number of Iteration'); ylabel('Average Accuracy');
title('Learning Curve');
end