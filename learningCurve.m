function learningCurve(data)

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
bmap = plmColors(4, 'pastel1');
figure; hold on;
X = 1:nPresent;
for i = 1:length(stateConds)
    plot(X, avgAccuracy(i,:), 'LineWidth', 3.5);
end
legend(stateConds, 'Location', 'southeast');
legend('boxoff');
xlabel('Number of Iteration'); ylabel('Average Accuracy');
end