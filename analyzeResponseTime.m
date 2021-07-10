function analyzeResponseTime()
clear all;

load('actionChunk_data.mat');
nSubj = length(data);
nPresent = sum(data(1).s(strcmp(data(1).cond, 'Ns4,train'))==1);

stateConds = {'Ns4,baseline', 'Ns4,train'};
intraChunkState = [4 4];                % chunk: [2 1] for Ns=4, [5 4] for Ns=6
exoChunkState = {[1 2 3 5 6], [1 2 3 5 6]};
intraRT = nan(2, nSubj, nPresent);      % Dim1:block condition;  Dim2:subjects  Dim3:time
exoRT = nan(2, nSubj, nPresent);
for s = 1:nSubj
    for condIdx = 1:length(stateConds)
        state = data(s).s(strcmp(data(s).cond, stateConds{condIdx}));
        rt = data(s).rt(strcmp(data(s).cond, stateConds{condIdx}));
        intraRT(condIdx,s,:) = rt(state==intraChunkState(condIdx));
        exoChunk = exoChunkState{condIdx};
        exoRT_perState = nan(length(exoChunk), nPresent);
        for i = 1:length(exoChunk)
            %exoRT_perState(i,:) = rt(state==exoChunk(i));
        end
        exoRT(condIdx,s,:) = squeeze(mean(exoRT_perState,1));
    end
end
        
%% Time-averaged intrachunk RT VS exochunk RT within train block
%%
intraRT_timeDynamics = squeeze(nanmean(intraRT, 2));
exoRT_timeDynamics = squeeze(nanmean(exoRT, 2));
            
        
figure; hold on;
plot(intraRT_timeDynamics(1,:), 'LineWidth', 3);
plot(intraRT_timeDynamics(2,:), 'LineWidth', 3); 
legend('Ns6,baseline', 'Ns6,train');
  
    

