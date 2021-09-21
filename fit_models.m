function [results,bms_results] = fit_models(models, data)
    %{
    Fit data to the models you specify. 

    no_cost / no_cost_chunk (2 free params)
        agent.lrate_theta:  actor learning rate
        agent.lrate_V:      critic learning rate

    reduced_fixed / reduced_fixed_chunk (3 free params)
        agent.beta:         fitted value of beta
        agent.lrate_theta:  actor learning rate
        agent.lrate_V:      critic learning rate

    fixed / fixed_chunk (4 free params)
        agent.beta:         fitted value of beta
        agent.lrate_theta:  actor learning rate
        agent.lrate_V:      critic learning rate
        agent.lrate_p:      learning rate for marginal action probability

    reduced_adaptive / reduced_adaptive_chunk (5 free params)
        agent.C:            capacity
        agent.beta0:        initial beta value
        agent.lrate_theta:  actor learning rate
        agent.lrate_V:      critic learning rate
        agent.lrate_beta:   learning rate for beta

    adaptive / adaptive_chunk (6 free params)
        agent.C:            capacity
        agent.beta0:        initial beta value
        agent.lrate_theta:  actor learning rate
        agent.lrate_V:      critic learning rate
        agent.lrate_beta:   learning rate for beta
        agent.lrate_p:      learning rate for marginal action probability

    %}

    addpath('/Users/ann/Desktop/CCN_Lab/BehavioralExperiment/Ns6_FinalVersion/mfit');

    if nargin < 2; load('actionChunk_data.mat'); end
    idx = 1;
    for i = 1:length(models)
        clear param;
        m = models{i};
        a = 2; b = 2; %beta prior

        if contains(m, 'no_cost')
            param(1) = struct('name','lrate_theta','lb',0,'ub',1,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','lrate_{\theta}');
            param(2) = struct('name','lrate_V','lb',0,'ub',1,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','lrate_V');

        elseif contains(m, 'fixed')
            btmin = 1e-3; btmax = 50;
            param(1) = struct('name','beta','logpdf',@(x) 0,'lb',btmin,'ub',btmax,'label','\beta');
            param(2) = struct('name','lrate_theta','lb',0,'ub',1,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','lrate_{\theta}');
            param(3) = struct('name','lrate_V','lb',0,'ub',1,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','lrate_V');
            if ~contains(m, 'reduced')
                param(4) = struct('name','lrate_p','lb',0,'ub',1,'logpdf',@(x) 0, 'label', 'lrate_p');
            end

        elseif contains(m, 'adaptive')
            btmin = 1e-3; btmax = 50;
            param(1) = struct('name','C','lb',0.01,'ub',log(20),'logpdf',@(x) 0,'label','C');
            param(2) = struct('name','beta0','logpdf',@(x) 0,'lb',btmin,'ub',btmax,'label','\beta');
            param(3) = struct('name','lrate_theta','lb',0,'ub',1,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','lrate_{\theta}');
            param(4) = struct('name','lrate_V','lb',0,'ub',1,'logpdf',@(x) sum(log(betapdf(x,a,b))),'label','lrate_V');
            param(5) = struct('name','lrate_beta','lb',0,'ub',1,'logpdf',@(x) 0,'label','lrate_{\beta}');
            if ~contains(m, 'reduced')
                param(6) = struct('name','lrate_p','lb',0,'ub',1,'logpdf',@(x) 0, 'label', 'lrate_p');
            end
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