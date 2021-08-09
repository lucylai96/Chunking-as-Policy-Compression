function corrcoef = model_recovery()

modelIdx = 2; 
models = {'fixed_chunk'};
load('actionChunk_data.mat');
emp_results = load('results_chunk_best').results_chunk_best;
simdata = sim_from_empirical(modelIdx, data, emp_results);
[sim_results, bms_results] = fit_models(models, simdata);

[corrcoef, pval] = corr(sim_results.x, emp_results(modelIdx).x);
