function timeOnTaskEffect()

load('actionChunk_data.mat');
conditions = {{'Ns4,train', 'Ns4,perform', 'Ns4,test'},...
              {'Ns6,train', 'Ns6,perform', 'Ns6,test'}};
nSubj = length(data);
iter = nan(1,length(conditions{1}));
cumIter = [0 cumsum(iter)];
for c = 1:length(conditions{1})
    cond = conditions{1};
    iter(c) = sum(data(1).s(strcmp(data(1).cond, cond{c}))==1);
end
runningAvgRT = nan(length(conditions), sum(iter));
runningSemRT = nan(length(conditions), sum(iter));
setsizes = [4 6];

for c = 1:length(conditions)
    conds = conditions{c};
    setsize = setsizes(c);
    for condIdx = 1:length(conditions{1})
        avgRT = nan(nSubj, setsize, iter(condIdx));
        for subj = 1:nSubj
            for s = 1:setsize 
                avgRT(subj, s, :) = data(subj).rt(strcmp(data(subj).cond, conds(condIdx)) & data(subj).s==s);
            end
        end
        avgRT = squeeze(nanmean(avgRT, 2));
        runningAvgRT(c, cumIter(condIdx)+1:cumIter(condIdx+1)) = nanmean(avgRT, 1);
        runningSemRT(c, cumIter(condIdx)+1:cumIter(condIdx+1)) = nanstd(avgRT, 1) / sqrt(nSubj);
    end
end

%%
plot(runningAvgRT(:,21:50)', 'LineWidth', 3);