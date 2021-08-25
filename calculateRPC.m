function [reward, complexity] = calculateRPC(data, condition, recode, maxReward)
nSubj = length(data);
if recode
    complexity = recoded_policy_complexity(data, condition);
end

reward = nan(nSubj, length(condition));
for s = 1:nSubj
    for c = 1:length(condition)
        idx = strcmp(data(s).cond, condition(c));
        state = data(s).s(idx);
        action = data(s).a(idx);
        reward(s,c) = sum(data(s).r(idx));
        nS = length(unique(state));
        if ~recode; complexity(s,c) = mutual_information(state,action,0.05, repmat(1/nS,1,nS)); end
    end
end
reward = reward ./ maxReward;

end