function data = analyze_rawdata()
%%
% analyze raw data and store into structure

clear all;

mode = 'subject';
folder = 'experiment/data/';
        
subj = {'A2G43KS55YGYQE', 'A3RKG5PZN97RD5', 'AOS2PVHT2HYTL', 'A27VFM67RPD2L5',...
        'A11CY37O9P73HW', 'A1BIJGB7XA0GME','A2EAJ7834XI2IT', 'A3FNC8ELMK8YJA',...
        'A1P3HHEXWNLJMP', 'A1ROEDVMTO9Y3X'...
        'A3UJSDFJ9LBQ6Z', 'A1FVXS8IM5QYO8', 'AK1Q45RF8A87Z', 'A110KENBXU7SUJ',...
        'A27SMEOPKV84VI', 'A3N4L5F7CEY0B2', 'A8C3WNWRBWUXO', 'A27W025UEXS1G0',...
        'A6E3QAJIQOFBQ', 'AZ8JL3QNIPY4U', 'A1V2H0UF94ATWY', 'A37QSTGGV90MFH',...
        'A34YDGVZKRJ0LZ', 'ARLGZWN6W91WD', 'A230VUDYOCRZ4N', 'A2FL477TMKC91L',...
        'A2NA6X1SON3KFH', 'A32JEH06T23HDF', 'A25PFSORDO3SWQ', 'A272X64FOZFYLB',...
        'A32QWM7BWCSPTS'};

cutoff = 0.6;
startOfExp = 64;  %change
data.cutoff = cutoff;
pcorr = zeros(length(subj),1);

for s = 1:length(subj)
    % 1.rt  2.url  3.trial_type  4.trial_index  5.time_elapsed  % 6.internal_node_id
    % 7.view_history  8.stimulus  9.key_pressed  10.state  11.test_part
    % 12.correct_response  13.correct  14.bonus  15.responses
    
    A = readtable(strcat(folder, subj{s}));
    A = table2cell(A);
    A(strcmp(A(:,11), 'practice'),:) = [];
    
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
    A(strcmp(A(:,11), 'practice'),:) = [];
   
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
    data(s).N = 150;
    
end

save('actionChunk_data.mat', 'data');

end