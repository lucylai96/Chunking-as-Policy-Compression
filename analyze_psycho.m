function analyze_psycho(reward, complexity, data)
% dimensional trait and psychopathology analysis
% INPUT: data - behavioral data

% question table of contents
% SCZ: 1-43, higher - SCZ
% OCI-R: 44-61, higher = OCD
% PHQ-9: 62-70, higher = depression
% SHAPs: 71-84, higher = low pleasure
% TEPS: 85-102, higher = more pleasure
% AMI: 103-120, higher = more apathy

maxTEPS = 102;
for i = 1:length(data)
    data(i).survey.teps = maxTEPS - data(i).survey.teps;
end

%% unroll survey
for i = 1:length(data)
    survey.scz(i,:) = data(i).survey.scz;
    survey.oci(i,:) = data(i).survey.oci;
    survey.phq(i,:) = data(i).survey.phq;
    survey.shaps(i,:) = data(i).survey.shaps;
    survey.teps(i,:) = data(i).survey.teps;
    survey.ami(i,:) = data(i).survey.ami;
end

%% reward and complexity (only baseline and random block condition) vs survey score
survey_name = {'SCZ','OCI-R','PHQ-9','SHAPS','TEPS','AMI'};
figure; hold on;
fn = fieldnames(survey);
for i = 1:length(fieldnames(survey))
    if(isnumeric(survey.(fn{i})))
        subplot(2,length(fn),i); hold on;
        plot(survey.(fn{i}),complexity,'.','MarkerSize',30); lsline;
        for c = 1:4
            [r,p] = corr(survey.(fn{i}), complexity(:,c),'Type', 'Pearson');
            x = xlim; y = ylim;
            if p<0.05; text(x(1),y(2),strcat('R = ',num2str(r)),'FontSize',14);
                text(mean(x),y(2),strcat('p = ',num2str(p)),'FontSize',14,'Color','r');
            end
        end
        ylabel('Policy Complexity')
        xlabel('Score')
        title(survey_name{i})
        
        subplot(2,length(fn),i+length(fn)); hold on;
        plot(survey.(fn{i}),reward,'.','MarkerSize',30); lsline;
        for c = 1:4
            [r,p] = corr(survey.(fn{i}),reward(:,c),'Type', 'Pearson');
            x = xlim; y = ylim;
            
            if p<0.05; text(x(1),y(2),strcat('R = ',num2str(r)),'FontSize',14);
                text(mean(x),y(2),strcat('p = ',num2str(p)),'FontSize',14,'Color','r');
            end
        end
        ylabel('Reward')
        xlabel('Score')
        
    end
end

set(gcf, 'Position',  [0, 100, 1700, 500])

%% reward and complexity (all block conditions) vs survey score
figure; hold on;
fn = fieldnames(survey);
for i = 1:length(fieldnames(survey))
    if(isnumeric(survey.(fn{i})))
        
        subplot(2,length(fn),i); hold on;
        plot(repmat(survey.(fn{i}),size(complexity,2),1),complexity(:),'k.','MarkerSize',30); lsline;
        [r,p] = corr(repmat(survey.(fn{i}),size(complexity,2),1),complexity(:), 'Type', 'Pearson');
        x = xlim; y = ylim;
        text(x(1),y(2),strcat('R = ',num2str(r)),'FontSize',14)
        if p<0.05; text(mean(x),y(2),strcat('p = ',num2str(p)),'FontSize',14,'Color','r');
        else; text(mean(x),y(2),strcat('p = ',num2str(p)),'FontSize',14); end
        ylabel('Policy Complexity'); title(survey_name{i})
        
        subplot(2,length(fn),i+length(fn)); hold on;
        plot(repmat(survey.(fn{i}),size(reward,2),1),reward(:),'k.','MarkerSize',30); lsline;
        [r,p] = corr(repmat(survey.(fn{i}),size(reward,2),1),reward(:), 'Type', 'Pearson');
        x = xlim; y = ylim;
        text(x(1),y(2),strcat('R = ',num2str(r)),'FontSize',14)
        if p<0.05; text(mean(x),y(2),strcat('p = ',num2str(p)),'FontSize',14,'Color','r');
        else; text(mean(x),y(2),strcat('p = ',num2str(p)),'FontSize',14); end
        ylabel('Reward');xlabel('Score')
        title(survey_name{i})
    end
end

set(gcf, 'Position',  [0, 300, 1700, 500])

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
        subplot(2,length(fn),i); hold on;
        h(1) = plot(survey.(fn{i}),load_manip(:,1),'b.','MarkerSize',30); lsline;
        [r,p] = corr(load_manip(:,1),survey.(fn{i}), 'Type', 'Pearson');
        x = xlim; y = ylim;
        text(x(1),y(2),strcat('R = ',num2str(r)),'FontSize',14)
        if p<0.05; text(mean(x),y(2),strcat('p = ',num2str(p)),'FontSize',14,'Color','r');
        else; text(mean(x),y(2),strcat('p = ',num2str(p)),'FontSize',14); end
        ylabel('\Delta Complexity')
        title(survey_name{i})
        
        subplot(2,length(fn),i+length(fn)); hold on;
        h(2) = plot(survey.(fn{i}),load_manip(:,2),'r.','MarkerSize',30); lsline;
        [r,p] = corr(load_manip(:,2),survey.(fn{i}), 'Type', 'Pearson');
        x = xlim; y = ylim;
        text(x(1),y(2),strcat('R = ',num2str(r)),'FontSize',14)
        if p<0.05; text(mean(x),y(2),strcat('p = ',num2str(p)),'FontSize',14,'Color','r');
        else; text(mean(x),y(2),strcat('p = ',num2str(p)),'FontSize',14); end
        ylabel('\Delta Reward')
        xlabel('Score')
        
    end
end
sgtitle('Load Manipulation','FontSize',23)
set(gcf, 'Position',  [0, 100, 1700, 500])

figure; hold on;
fn = fieldnames(survey);
for i = 1:length(fieldnames(survey))
    if(isnumeric(survey.(fn{i})))
        subplot(2,length(fn),i); hold on;
        h(1) = plot(survey.(fn{i}),incentive_manip(:,1),'b.','MarkerSize',30); lsline;
        [r,p] = corr(incentive_manip( :,1),survey.(fn{i}), 'Type', 'Pearson');
        x = xlim; y = ylim;
        text(x(1),y(2),strcat('R = ',num2str(r)),'FontSize',14)
        if p<0.05; text(mean(x),y(2),strcat('p = ',num2str(p)),'FontSize',14,'Color','r');
        else; text(mean(x),y(2),strcat('p = ',num2str(p)),'FontSize',14); end
        ylabel('\Delta Complexity')
        title(survey_name{i})
        
        subplot(2,length(fn),i+length(fn)); hold on;
        h(2) = plot(survey.(fn{i}),incentive_manip(:,2),'r.','MarkerSize',30); lsline;
        [r,p] = corr(incentive_manip(:,2),survey.(fn{i}), 'Type', 'Pearson');
        x = xlim; y = ylim;
        text(x(1),y(2),strcat('R = ',num2str(r)),'FontSize',14)
        if p<0.05; text(mean(x),y(2),strcat('p = ',num2str(p)),'FontSize',14,'Color','r');
        else; text(mean(x),y(2),strcat('p = ',num2str(p)),'FontSize',14); end
        ylabel('\Delta Reward')
        xlabel('Score')
        
    end
end
sgtitle('Incentive Manipulation','FontSize',23)
% scores vs reduction in ICRT

set(gcf, 'Position',  [0, 100, 1700, 500])

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