function plot_all_figures(experiment)
    
    %{
    A wrapper function that plots all figures for the experiments. 
    STILL DEBUGGING & ADDING CODE!

    USAGE:
    plot_all_figures({'setsize'})
    plot_all_figures({'load_incentive_manip'})
    plot_all_figures({'probabilisitc_transition'})
    %}

    if nargin==0
        experiment = {'setsize', 'load_incentive_manip', 'probabilistic_transition'};
    end
    
    for i = 1:length(experiment)
        exp = experiment{i};
        
        switch exp
            case 'setsize'
                learning_curve()                                % learning curve
                exploratory_analysis_exp1('avgAcc')             % average accuracy
                exploratory_analysis_exp1('avgRT')              % average RT
                exploratory_analysis_exp1('intrachunkRT')       % ICRT
                
                policy_complexity_exp1("avgComplexity")         % average complexity    
                %policy_complexity_exp1("RC_curves")             % reward-complexity curves
                policy_complexity_exp1("rainCloud_complexity")  % complexity distribution
                
                plotBIC()                                       % model fitting result shown by BIC
            
                %analyze_simdata_exp1() 
                
            case 'load_incentive_manip'
                exploratory_analysis_exp2('avgAcc')             % average accuracy  
                exploratory_analysis_exp2('avgRT')              % average RT
                exploratory_analysis_exp2('intrachunkRT')       % ICRT
                
                policy_complexity_exp()                         % average complexity & reward-complexity curves
                
                %analyze_simdata_exp2()   
                
            case 'probabilistic_transition'
                analyze_probabilistic_transition()              % plot the ICRT and IC_accuracy
        end
    end
    
end
                
                
    