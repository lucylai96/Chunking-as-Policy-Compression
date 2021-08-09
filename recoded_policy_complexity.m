function complexity = recoded_policy_complexity(data, conds)
if nargin<1; load('actionChunk_data.mat'); end
nSubj = length(data);
if nargin==1
    conds = {'Ns4,baseline', 'Ns4,train', 'Ns4,perform', 'Ns4,test', ...
            'Ns6,baseline', 'Ns6,train', 'Ns6,perform', 'Ns6,test'};
end
complexity = nan(nSubj, length(conds));

for subj = 1:nSubj
    for c = 1:length(conds)
        idx = strcmp(data(subj).cond, conds{c});
        s = data(subj).s(idx);
        a = data(subj).a(idx);
        state = nan(length(s)-1, 1);
        action = nan(length(a)-1, 1);
        nS = length(unique(s)); nA = length(unique(a));
        pS = zeros(nS^2, 1);
        
        for step = 1:length(s)-1
            state(step) = (s(step)-1)*nS + s(step+1);
            pS(state(step)) = pS(state(step)) + 1;
            action(step) = (a(step)-1)*nA + a(step+1);
        end
        state(isnan(action))=[]; action(isnan(action))=[];
        pS = pS/sum(pS,'all');
        %complexity(subj, c) = mutual_information(state,action,1/nA,pS');
        complexity(subj, c) = mutual_information(state,action);
    end
    
end

end
        
            
            
    