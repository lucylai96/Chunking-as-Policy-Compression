function data = analyze_rawdata()
%%
% analyze raw data and store into structure

clear all;

mode = 'subject';
folder = 'experiment/data/';
        
% control is before experiment
subj1 = {'AFM65NU0UXIGP', 'AT6OT5K5Z4V0J', 'A248QG4DPULP46', 'A26NGLGGFTATVN', ...
        'A2GJYB46FWIB5Q', 'A16G6PPH1INQL8', 'A1M1E62KXCDNL0', 'A38IPIPA3T3G4',...
        'A1160COTUR26JZ', 'A1FNNL4YJGBU8U', 'A1W7I6FN183I8F', 'AGTKSA15G1LBN',...
        'AJQ71YIGY01HZ', 'A30VAYXB85107X', 'A4SC8G0149GEG', 'AQMLJYUQCSG22',...
        'A1HKYY6XI2OHO1', 'A1DZMZTXWOM9MR', 'A23BWWRR7J5XLS', 'A2A07J1P6YEW6Z',...
        'A2S64AUN7JI7ZS', 'A2V1T6RKD06I2X', 'A2ZDEERVRN5AMC', 'A3BUWQ5C39GRQC',...
        'A3EG4C9T4F5DUR', 'A3KMNX2P2QP9JU', 'A3RR85PK3AV9TU', 'A8UJNIY9R8S7W',...
        'AJQ71YIGY01HZ', 'AW0K78T4I2T72'};
    
% control is after experiment
subj2 = {'A2YC6PEMIRSOAA', 'A16G6PPH1INQL8', 'A2BK45LZGGWPLX', 'A13WTEQ06V3B6D',...
         'A28AXX4NCWPH1F', 'A2NT3OQZUUZPEO', 'A3TBG0S2IEBVHU', 'A3UUH3632AI3ZX',...
         'A3VEF4M5FIN7KH', 'A6MWJK1YEY5L2', 'A8KX1HFH8NE2Q', 'AJQ71YIGY01HZ',...
         'AOOLS8280CL0Z', 'AR8O1107OAW4V', 'A12HWPFXQPITHD', 'A28U7B76HLCS1U',...
         'AJQ71YIGY01HZ'};

subj = [subj1, subj2];
         
cutoff = 0.6;
startOfExp = 4;  %change
data.cutoff = cutoff;
pcorr = zeros(length(subj),1);

for s = 1:length(subj)
    % 1.rt  2.url  3.trial_type  4.trial_index  5.time_elapsed  % 6.internal_node_id
    % 7.view_history  8.stimulus  9.key_pressed  10.state  11.test_part
    % 12.correct_response  13.correct  14.bonus  15.responses
    
    A = readtable(strcat(folder, subj{s}));
    A = table2cell(A);
    %A(strcmp(A(:,11), 'practice'),:) = [];
    
    corr = sum(strcmp(A(startOfExp:end, 13), 'true'));
    incorr = sum(strcmp(A(startOfExp:end,13), 'false'));
    pcorr(s) = corr/(corr+incorr);
end

hold on;
histogram(pcorr, 20, 'FaceColor', '#0072BD');
xlabel('% Accuracy'); ylabel('# of Subjects'); 
%xlim([0.7 1]); 
box off; set(gcf,'Position',[200 200 800 300]);
subj = subj(pcorr>cutoff); % filter by percent correct >cutoff%

%% Construct data structure

for s = 1:length(subj)
    A = readtable(strcat(folder, subj{s}));
    A = table2cell(A);
    corr = sum(strcmp(A(startOfExp:end, 13), 'true'));
    incorr = sum(strcmp(A(startOfExp:end,13), 'false'));
    data(s).performance = corr/(corr+incorr);
    
    A(:,13) = strrep(A(:,13), 'true', '1');
    A(:,13) = strrep(A(:,13), 'false', '0');
   
    condition = unique(A(:,11));
    condition(strcmp(condition, '')) = [];
    expTrialIdx = ismember(A(:,11), condition);
    A(strcmp(A, 'null'),9) = {'-1'};
    data(s).ID = subj{s};
    
    data(s).cond = A(expTrialIdx, 11);
    data(s).idx = A(expTrialIdx, 4);
    data(s).s = cell2mat(A(expTrialIdx, 10));
    data(s).a = str2num(cell2mat(A(expTrialIdx, 9))) - 48;
    data(s).a(data(s).a==-49) = NaN;
    data(s).corrchoice = cell2mat(A(expTrialIdx,12)) - 48;
    data(s).acc = str2num(cell2mat(A(expTrialIdx, 13)));
    data(s).r = str2num(cell2mat(A(expTrialIdx, 13)));
    data(s).rt = zeros(600, 1);
    idx = find(expTrialIdx);
    for i=1:sum(expTrialIdx)
        data(s).rt(i) = str2double(A{idx(i),1});
    end
    data(s).N = 750;
    
end

save('actionChunk_data.mat', 'data');

end