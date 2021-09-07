function analyze_surveydata

subj = {'A1969Q0R4Y0E3J','A222R4PNCF08OF','A2QX3YJXAAHHVV','A5TWD5QD99GZY','AI5RMOS8R652G'};


folder = 'survey_data/';
A = readtable(strcat(folder, 'pilot'));
A = table2cell(A);
end
%{'A3774HPOUKYTX7';'A3LL096CAY5WHB';'A39VZ93N96XB6O';'A19CB2C4GY4C60';'AAF1SJ9FCBF75'}