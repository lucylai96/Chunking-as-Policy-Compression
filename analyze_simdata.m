function analyze_simdata()

load('actionChunk_data.mat');
load('fixed_adaptive_chunk');
modelIdx = 1;
simdata = sim_from_empirical(modelIdx, data, results);

%% learning curve
learningCurve(simdata);

%% model-independent analysis
exploratoryAnalysis(simdata, 'avgAcc');
exploratoryAnalysis(simdata, 'reward-complexity');

%% how policy changes throughout Train, Perform, Test 
nSubj = length(data);
chunkInit = [2 5];
theta = cell(2, 3, nSubj); 
policy = cell(2, 50, nSubj);  %setsizeCond x iterations x subjects
conditions = {'Ns4,train', 'Ns4,perform', 'Ns4,test';...
              'Ns6,train', 'Ns6,perform', 'Ns6,test'};
d = cell(2, 50, nSubj);
for subj = 1:nSubj
    for i = 1:2
        stateIdx = [];
        for j = 1:3
            idx = find(strcmp(simdata(subj).cond, conditions{i,j}));
            theta{i,j, subj} = simdata(subj).theta{max(idx)};
            stateIdx = [stateIdx idx];
        end
        stateIdx = intersect(stateIdx, find(simdata(subj).s==chunkInit(i)));
        d = simdata(subj).d(stateIdx);
        for k = 1:length(d)
            logpolicy = simdata(subj).d{stateIdx(k)} - logsumexp(simdata(subj).d{stateIdx(k)});
            policy{i,k,subj} = exp(logpolicy);
        end
    end
end

policy4 = nan(50, 2, nSubj);
policy6 = nan(50, 2, nSubj);
for subj = 1:nSubj
    for iter = 1:50
        poli = policy{1,iter,subj};
        policy4(iter,1,subj)= poli(2);   
        policy4(iter,2,subj)= poli(5);
        
        poli = policy{2,iter,subj};
        policy6(iter,1,subj)= poli(5);   
        policy6(iter,2,subj)= poli(7);
    end
end
        


