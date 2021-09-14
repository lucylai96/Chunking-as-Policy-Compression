function analyze_surveydata

folder = 'survey_data/';
A = readtable(strcat(folder, 'pilot'));
subj = table2cell(A(2:end,148))'; % get mturkIDs
A = table2array(A(2:end,27:146)); % only the data
if ~isempty(isnan(A))
    [r,c] = find(isnan(A));
    r = unique(r);
    A(r,:) = []; 
    disp('subjects who didn`t do survey:')
    length(r)
end
% question table of contents
% SCZ: 1-43
% OCI-R: 44-61
% PHQ-9: 62-70
% SHAPs: 71-84
% TEPS: 85-102
% AMI: 103-120

%% amend the reverse coding
% SCZ: 26,27,28,30,31,34,37,39
% SHAPS: 2,4,5,7,9 (72,74,75,77,79 in array)

recode_idx = [26,27,28,30,31,34,37,39];
A(:,recode_idx) = ~A(:,recode_idx);

recode_idx = [72,74,75,77,79];
A(:,recode_idx) = ~A(:,recode_idx);

%% scoring
% SCZ : 0-27, add scores, yes = 1, no = 0 high scores mean SCZ
% OCI-R: 0-72, add scores, high scores >21 is OCD
% PHQ-9: 0-27 high scores mean depression
% SHAPs: 0-14, 1-2 is 1 and 3-4 is 0, high scores represent low pleasure,
% >3 is abnormal (already reverse coded, higher rating indicates
% more anhedonia)
% TEPS: 25-120.add together
% AMI: 0-72, add scores (already reverse coded, higher rating indicated
% more apathy)

% SCZ: 1-43
idx = 1:43;
survey.scz = sum(A(:,idx),2);

% OCI-R: 44-61
idx = 44:61;
survey.oci = sum(A(:,idx),2);

% PHQ-9: 62-70
idx = 62:70;
survey.phq = sum(A(:,idx),2);

% SHAPs: 71-84
idx = 71:84;
survey.shaps = sum(A(:,idx),2);

% TEPS: 85-102
idx = 85:102;
survey.teps = sum(A(:,idx),2);

% AMI: 103-120
idx = 103:120;
survey.ami = sum(A(:,idx),2);

save('survey_data.mat','survey')

end
