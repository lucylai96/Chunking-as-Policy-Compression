function compareChunking()
%{
To determine if higher cognitive load induces more chunk use
%}

load('actionChunk_data.mat');
nSubj = length(data);
condition = {'Ns4,baseline', 'Ns4,train','Ns6,baseline', 'Ns6,train', };
chunkRT = zeros(nSubj, length(condition));
chunkInit = [2,5];
for s = 1:nSubj
    for c = 1:length(condition)
        idx = strcmp(data(s).cond, condition(c));
        state = data(s).s(idx);
        action = data(s).a(idx);
        rt = data(s).rt(idx);
        if contains(condition(c),'4')
            condIdx = 1;
        elseif contains(condition(c), '6')
            condIdx = 2;
        end
        pos = find(state==chunkInit(condIdx))+1; pos(pos>length(state))=[];
        chunkRT(s,c) = nanmean(rt(intersect(find(state == action), pos)));
    end
end

diffRT(:,1) = chunkRT(:,2)-chunkRT(:,1); diffRT(:,2) = chunkRT(:,4)-chunkRT(:,3);

%% Student's t-test
%%
[h, p] = ttest(diffRT(:,1), diffRT(:,2), 'Tail', 'left')