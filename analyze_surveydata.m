function data = analyze_surveydata(data)
%{ 
    Called by: analyze_rawdata to match survey results to subject specific data
    Next step processing is done by analyze_psycho.m 
%}

folder = 'survey_data/';
A = readtable(strcat(folder, 'pilot2'));
subj = table2cell(A(2:end,148))'; % get mturkIDs
A = table2array(A(2:end,27:146)); % only the data
if ~isempty(isnan(A))
    [r,c] = find(isnan(A));
    r = unique(r);
    A(r,:) = [];
    subj(r) = [];
    disp(strcat('# of subjects who didn''t do survey:',numel(r)))
end

%% % question table of contents
% SCZ: 1-43, higher - SCZ
% OCI-R: 44-61, higher = OCD
% PHQ-9: 62-70, higher = depression
% SHAPs: 71-84, higher = low pleasure
% TEPS: 85-102, higher = more positive
% AMI: 103-120, higher = more apathy

%% amend the reverse coding
% SCZ: 26,27,28,30,31,34,37,39
% SHAPS: 2,4,5,7,9 (72,74,75,77,79 in array)

recode_idx = [26,27,28,30,31,34,37,39];
A(:,recode_idx) = ~A(:,recode_idx);

recode_idx = [72,74,75,77,79];
A(:,recode_idx) = ~A(:,recode_idx);

%% match survey to subject, save into data file
for s = 1:length(subj)
    for i = 1:length(data) % find the survey data for each subject
        if isequal(data(i).ID,subj{s})
      
            % SCZ: 1-43
            idx = 1:43;
            survey.scz = sum(A(s,idx));
            
            % OCI-R: 44-61
            idx = 44:61;
            survey.oci = sum(A(s,idx));
            
            % PHQ-9: 62-70
            idx = 62:70;
            survey.phq = sum(A(s,idx));
            
            % SHAPs: 71-84
            idx = 71:84;
            survey.shaps = sum(A(s,idx));
            
            % TEPS: 85-102
            idx = 85:102;
            survey.teps = sum(A(s,idx));
            
            % AMI: 103-120
            idx = 103:120;
            survey.ami = sum(A(s,idx));
            
            data(i).survey = survey;
        end
    end
end

%% scoring
% SCZ : 0-27, add scores, yes = 1, no = 0 high scores mean SCZ
% OCI-R: 0-72, add scores, high scores >21 is OCD
% PHQ-9: 0-27 high scores mean depression
% SHAPs: 0-14, 1-2 is 1 and 3-4 is 0, high scores represent low pleasure,
% >3 is abnormal (already reverse coded, higher rating indicates
% more anhedonia)
% TEPS: 25-120, add together, more positive
% AMI: 0-72, add scores (already reverse coded, higher rating indicated
% more apathy)

% % SCZ: 1-43
% idx = 1:43;
% survey.scz = sum(A(s,idx),2);
% 
% % OCI-R: 44-61
% idx = 44:61;
% survey.oci = sum(A(s,idx),2);
% 
% % PHQ-9: 62-70
% idx = 62:70;
% survey.phq = sum(A(s,idx),2);
% 
% % SHAPs: 71-84
% idx = 71:84;
% survey.shaps = sum(A(s,idx),2);
% 
% % TEPS: 85-102
% idx = 85:102;
% survey.teps = sum(A(s,idx),2);
% 
% % AMI: 103-120
% idx = 103:120;
% survey.ami = sum(A(s,idx),2);
% save('survey_data.mat','survey')

end
