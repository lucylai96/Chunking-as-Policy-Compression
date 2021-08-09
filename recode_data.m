function recoded_data = recode_data(data, option)

% convert raw states into "sequential pairs" state representation
if nargin<1
    load('actionChunk_data.mat');
    nSubj = length(data);
    conds = {'Ns4,baseline', 'Ns4,train', 'Ns4,perform', 'Ns4,test', ...
             'Ns6,baseline', 'Ns6,train', 'Ns6,perform', 'Ns6,test'};
    recoded_data.cutoff = data.cutoff;

    for subj = 1:nSubj
        all_s = []; all_a = []; all_conds = []; all_rewards = [];
        for c = 1:length(conds)
            idx = strcmp(data(subj).cond, conds{c});
            s = data(subj).s(idx);
            a = data(subj).a(idx);
            r = data(subj).r(idx);
            state = nan(length(s)-1, 1);
            action = nan(length(a)-1, 1);
            reward = nan(length(r)-1, 1);
            nS = length(unique(s)); 
            uA = unique(a); uA(isnan(uA)) = [];
            nA = length(uA);
            for step = 1:length(s)-1
                state(step) = (s(step)-1)*nS + s(step+1);
                action(step) = (a(step)-1)*nA + a(step+1);
                reward(step) = r(step) * r(step+1);
            end

            state(isnan(action))=[]; reward(isnan(action))=[]; action(isnan(action))=[];
            all_s = [all_s; state]; all_a = [all_a; action];
            all_conds = [all_conds; repmat(conds(c),length(state),1)]; 
            all_rewards = [all_rewards; reward];

        end
        recoded_data(subj).s = all_s;
        recoded_data(subj).a = all_a;
        recoded_data(subj).cond = all_conds;
        recoded_data(subj).r = all_rewards;
        recoded_data(subj).N = length(all_s);
    end
    save('recoded_data.mat', 'recoded_data');

% revert sequential pair representation to raw representation
elseif ~isempty(data) && strcmp(option, 'revert')
    for subj = 1:length(data)
        s = data(subj).s; a = data(subj).a; 
        state = nan(length(data(subj).s)+1, 1);
        if contains(data(subj).cond(1),'4'); nS=4; end
        if contains(data(subj).cond(1),'6'); nS=6; end
        state(1) = mod(s(1), nS) + 1;
        state(2) = s(1) - (state(1)-1)*nS;
        action(1) = mod(a(1), nS) + 1;
        action(2) = a(1) - (action(1)-1)*nS;
        
        for i = 2:length(data(subj).s)
            if contains(data(subj).cond(i),'4'); nS=4; end
            if contains(data(subj).cond(i),'6'); nS=6; end
            state(i+1) = s(i) - (state(i)-1)*nS;
            action(i+1) = a(i) - (action(i)-1)*nS;
        end
        
        recoded_data(subj).s = state;
        recoded_data(subj).a = action;
    end
end    
    