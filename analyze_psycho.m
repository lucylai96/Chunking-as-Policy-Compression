function analyze_psycho(reward, complexity, data, survey)
% dimensional trait and psychopathology analysis
% called by "analysis_manip"

% INPUT: data - behavioral data
%        survey - survey data
if nargin<4; load('survey_data.mat'); end
if nargin<3; load('data_manip_3.mat'); end

% question table of contents
% SCZ: 1-43, higher - SCZ
% OCI-R: 44-61, higher = OCD
% PHQ-9: 62-70, higher = depression
% SHAPs: 71-84, higher = low pleasure
% TEPS: 85-102, higher = more pleasure
% AMI: 103-120, higher = more apathy
survey.teps = max(survey.teps)-survey.teps;

exc = 11;
data(exc) = []; reward(exc,:) = []; complexity(exc,:) = [];
%% complexity (each block condition) vs survey score
survey_name = {'SCZ','OCI-R','PHQ-9','SHAPS','TEPS','AMI'};
figure; hold on;
fn = fieldnames(survey);
for i = 1:length(fieldnames(survey))
    if(isnumeric(survey.(fn{i})))
        subplot(1,length(fn),i); hold on;
        plot(complexity(:,1:2),survey.(fn{i}),'.','MarkerSize',30); lsline;
        for c = 1:2
            [r(i,c),p(i,c)] = corr(complexity(:,c),survey.(fn{i}), 'Type', 'Pearson');
        end
        xlabel('Policy Complexity')
        ylabel('Score')
        title(survey_name{i})
    end
end

set(gcf, 'Position',  [0, 100, 1700, 250])
%% complexity (all block conditions) vs survey score

figure; hold on;
fn = fieldnames(survey);
for i = 1:length(fieldnames(survey))
    if(isnumeric(survey.(fn{i})))
        subplot(1,length(fn),i); hold on;
        plot(complexity(:),repmat(survey.(fn{i}),size(complexity,2),1),'k.','MarkerSize',30); lsline;
        [R(i),P(i)] = corr(complexity(:),repmat(survey.(fn{i}),size(complexity,2),1), 'Type', 'Pearson');
        xlabel('Policy Complexity')
        ylabel('Score')
        title(survey_name{i})
    end
end

set(gcf, 'Position',  [0, 300, 1700, 250])

%% reward (each block condition) vs survey score
survey_name = {'SCZ','OCI-R','PHQ-9','SHAPS','TEPS','AMI'};
figure; hold on;
fn = fieldnames(survey);
for i = 1:length(fieldnames(survey))
    if(isnumeric(survey.(fn{i})))
        subplot(1,length(fn),i); hold on;
        plot(reward(:,1:2),survey.(fn{i}),'.','MarkerSize',30); lsline;
        for c = 1:2
            [r(i,c),p(i,c)] = corr(reward(:,c),survey.(fn{i}), 'Type', 'Pearson');
        end
        xlabel('Reward')
        ylabel('Score')
        title(survey_name{i})
    end
end

set(gcf, 'Position',  [0, 500, 1700, 250])

%% reward (all block conditions) vs survey score

figure; hold on;
fn = fieldnames(survey);
for i = 1:length(fieldnames(survey))
    if(isnumeric(survey.(fn{i})))
        subplot(1,length(fn),i); hold on;
        plot(reward(:),repmat(survey.(fn{i}),size(reward,2),1),'k.','MarkerSize',30); lsline;
        [R(i),P(i)] = corr(reward(:),repmat(survey.(fn{i}),size(reward,2),1), 'Type', 'Pearson');
        xlabel('Reward')
        ylabel('Score')
        title(survey_name{i})
    end
end

set(gcf, 'Position',  [0, 700, 1700, 250])
%% can scores predict manipulations?

% prediction is that people who are reward insensitive (high on SHAPS, low
% on TEPS) will respond to reward incentives (increase reward), no change in
% complexity (correlate score to change in complexity--> higher/lower score
% means reward insensitive, they won't change complexity in reward incentive task \Delta_Complexity{I}

% people who are low capacity (e.g,SCZ), reward incentives won't change
% complexity (correlate score to change in complexity--> higher score,
% less change in complexity in reward incentive task \Delta_Complexity{I})

% scores vs change in policy complexity on load task / reward task
load_manip = [complexity(:,3)-complexity(:,2) reward(:,3)-reward(:,2)];
incentive_manip = [complexity(:,4)-complexity(:,2) reward(:,4)-reward(:,2)];

figure; hold on;
fn = fieldnames(survey);
for i = 1:length(fieldnames(survey))
    if(isnumeric(survey.(fn{i})))
        subplot(1,length(fn),i); hold on;
        h(1) = plot(survey.(fn{i}),load_manip(:,1),'.','MarkerSize',30); lsline;
        [rr(i,1),pp(i,2)] = corr(load_manip(:,1),survey.(fn{i}), 'Type', 'Pearson');
        
        h(2) = plot(survey.(fn{i}),incentive_manip(:,1),'.','MarkerSize',30); lsline;
        [rr(i,2),pp(i,2)] = corr(incentive_manip(:,1),survey.(fn{i}), 'Type', 'Pearson');
        ylabel('\Delta Complexity')
        xlabel('Score')
        title(survey_name{i})
    end
end
legend(h, {'\Delta Complexity_{L}','\Delta Complexity_{I}'})

set(gcf, 'Position',  [0, 100, 1700, 250])

figure; hold on;
fn = fieldnames(survey);
for i = 1:length(fieldnames(survey))
    if(isnumeric(survey.(fn{i})))
        subplot(1,length(fn),i); hold on;
        h(1) = plot(survey.(fn{i}),load_manip(:,2),'.','MarkerSize',30); lsline;
        [rrr(i,1),ppp(i,2)] = corr(load_manip(:,2),survey.(fn{i}), 'Type', 'Pearson');
        
        h(2) = plot(survey.(fn{i}),incentive_manip(:,2),'.','MarkerSize',30); lsline;
        [rrr(i,2),ppp(i,2)] = corr(incentive_manip(:,2),survey.(fn{i}), 'Type', 'Pearson');
        ylabel('\Delta Reward')
        xlabel('Score')
        title(survey_name{i})
    end
end
legend(h, {'\Delta Reward_{L}','\Delta Reward_{I}'})
% scores vs reduction in ICRT

set(gcf, 'Position',  [0, 100, 1700, 250])

%% change in reward vs change in complexity
figure; hold on; subplot 121; hold on;
h(1) = plot(load_manip(:,1),load_manip(:,2),'.','MarkerSize',30);lsline;
h(2) = plot(incentive_manip(:,1),incentive_manip(:,2),'.','MarkerSize',30); lsline;
xlabel('\Delta Complexity')
ylabel('\Delta Reward')
legend(h,{'Load manipulation','Incentive Manipulation'})


%% correlate survey score to anhedonia and apathy
subplot 122; hold on;
h(1) = plot(survey.ami,survey.shaps,'.','MarkerSize',30); lsline;
h(2) = plot(survey.ami,survey.teps,'.','MarkerSize',30);  lsline;
xlabel('Apathy')
ylabel('Anhedonia')
legend(h,{'SHAPS v AMI','TEPS v AMI'})

set(gcf, 'Position',  [0, 100, 1000, 400])
end