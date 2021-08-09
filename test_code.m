load('actionChunk_data.mat')
nSubj = length(data);
conditions = {'Ns4,train', 'Ns4,perform', 'Ns6,train', 'Ns6,perform'};
for subj = 1:nSubj
    for cond = 1:length(conditions)
        idx = strcmp(data(subj).cond, conditions{cond});
        nS = sum(idx);
        setsize = length(unique(data(subj).s(idx)));
        data(subj).s(idx) = repmat(1:setsize, 1, nS/setsize);
    end
end
   

simdata = sim_from_empirical(4, data);
