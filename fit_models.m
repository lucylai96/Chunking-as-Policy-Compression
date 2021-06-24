function [results,bms_results] = fit_models(models)
%{
model 4: fixed model free parameters
    agent.beta0:         fitted value of beta
    agent.lrate_theta:  actor learning rate
    agent.lrate_V:      critic learning rate
    agent.lrate_p:      learning rate for marginal action probability

model 5: reduced adaptive model free parameters
    agent.lrate_theta:  actor learning rate
    agent.lrate_V:      critic learning rate
    agent.lrate_beta:   learning rate for beta
    agent.beta0:        initial beta value
    agent.C:            capacity

model 6: adaptive model free parameters
    agent.C:            capacity
    agent.lrate_theta:  actor learning rate
    agent.lrate_V:      critic learning rate
    agent.lrate_p:      learning rate for marginal action probability
    agent.lrate_beta:   learning rate for beta
    agent.beta0:        initial beta value
%}

addpath('/Users/ann/Desktop/CCN_Lab/BehavioralExperiment/Ns6_Baseline/mfit');
   
load('actionChunk_data.mat');
idx = 1;


for m = models
    a = 2; b = 2; %beta prior
    
    if contains(m, 'no_cost')         % NO COST model; free params: lrate_theta, lrate_V
        param(1) = struct('name','lrate_theta','lb',0,'ub',1,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','lrate_{\theta}');
        param(2) = struct('name','lrate_V','lb',0,'ub',1,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','lrate_V');
        
    elseif contains(m, 'capacity')         %
        param(1) = struct('name','lrate_theta','lb',0,'ub',1,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','lrate_{\theta}');
        param(2) = struct('name','lrate_V','lb',0,'ub',1,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','lrate_V');
        param(3) = struct('name','C','lb',0.01,'ub',log(20),'logpdf',@(x) 0,'label','C');
        
    elseif contains(m, 'fixed')         % fixed model
        btmin = 1e-3; btmax = 50;
        param(1) = struct('name','lrate_theta','lb',0,'ub',1,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','lrate_{\theta}');
        param(2) = struct('name','lrate_V','lb',0,'ub',1,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','lrate_V');
        param(3) = struct('name','invtemp','logpdf',@(x) 0,'lb',btmin,'ub',btmax,'label','\beta');
        %param(4) = struct('name','C','lb',0.01,'ub',log(20),'logpdf',@(x) 0,'label','C');
        param(4) = struct('name','lrate_p','lb',0,'ub',1,'logpdf',@(x) 0, 'label', 'lrate_p');
        
    elseif contains(m, 'reduced_adaptive')         % adaptive model
        btmin = 1e-3; btmax = 50;
        param(1) = struct('name','lrate_theta','lb',0,'ub',1,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','lrate_{\theta}');
        param(2) = struct('name','lrate_V','lb',0,'ub',1,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','lrate_V');
        param(3) = struct('name','lrate_beta','lb',0,'ub',1,'logpdf',@(x) 0,'label','lrate_{\beta}');
        param(4) = struct('name','invtemp','logpdf',@(x) 0,'lb',btmin,'ub',btmax,'label','\beta');
        param(5) = struct('name','C','lb',0.01,'ub',log(20),'logpdf',@(x) 0,'label','C');
    end
    
    if contains(m, 'chunk')
        likfun = @likelihood_fun_chunk;
    else
        likfun = @actor_critic_lik;
    end
    
    results(idx) = mfit_optimize(likfun,param,data);
    idx = idx + 1;
end

bms_results = mfit_bms(results);

end