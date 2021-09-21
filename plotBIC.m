function plotBIC()

    %{
    Plot the BIC for each fitted model variant for the set size
    manipulation experiment

    USAGE:  plotBIC()

    Called by: plot_all_figures()
    %}

    addpath([pwd '/Violinplot/']);
    addpath([pwd '/matlab_data/']);
    load('model_fitting_all.mat');
    
    for m = 1:length(results)
        bic(:,m) = results(m).bic;
        aic(:,m) = results(m).aic;
    end

    figure;
    colororder([141 182 205
                69 139 116]/255);
    violinplot(bic);
    ylim([0 4000]); ylabel('BIC'); 
    set(gca, 'XTick',1:6, 'XTickLabel', {'noCost,noChunk', 'noCost,Chunk', 'Fixed,noChunk', 'Fixed,Chunk', 'Adaptive,noChunk', 'Adaptive,Chunk'});
