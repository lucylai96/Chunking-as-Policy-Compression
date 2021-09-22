# Chunking-as-Policy-Compression
Code for producing results in *Chunking as Policy Compression* project.

Questions? Contact zixiang.huang@mail.mcgill.ca.

## Main Functios for Experiment 1 (Set size manipulation)

### *analyze_rawdata.m*

First step of any analysis. It converts raw jsPsych experiment data saved in .csv files to MATLAB data structures. Usage:
```
data = analyze_rawdata('setsize_manip')
```

### *learning_curve.m*

Plot the task performance against the training length.

### *time_on_task.m*

Plot the average response time against the training length.

### *exploratory_analysis_exp1.m*

Exploratory analysis and plotting on the average accuracy, average RT, intrachunk RT in different blocks of experiment 1. Usage:
```
exploratory_analysis_exp1(plotCase, data)
```
where `plotCase` is a string of the analysis to be conducted. It can be `'avgAcc'`, `'avgRT'`, or `'intrachunkRT'`.

### *policy_complexity_analysis_exp1.m*

Analyses related to policy complexity, including average policy complexity in different blocks, reward-complexity curves, rain cloud plot of policy complexity distribution in different blocks, and a bunch of statistical tests.

### *fit_models.m*

Model fitting. Usage:
```
[results,bms_results] = fit_models(models, data)
```
where `models` is a cell array of names of the model variants to be fitted, including `"no_cost"`. `"no_cost_chunk"`, `"fixed"`, `"fixed_chunk"`, `"adaptive"`, `"adaptive_chunk"`.

### *sim_from_empirical.m*
Simulate data using fitted model parameters of the best fitted model. Usage:
```
simdata = sim_from_empirical()
```
We can then inspect the behavior of the simulated data using `exploratory_analysis_exp1()` and `learning_curve()`. 


## Main Functions for Experiment 2 (Load & Incentive manipulation)

### *analyze_rawdata.m*

Converts raw jsPsych experiment data saved in .csv files to MATLAB data structures. Usage:
```
data = analyze_rawdata('modified_freq_discr')
```
Use the specifier 'modified_freq_discr' for the load & incentive manipulation experiment with modified frequency discrimination task. 

### *exploratory_analysis_exp2.m*

Exploratory analysis and plotting on the average accuracy, average RT, intrachunk RT in different blocks of experiment 2. Usage:
```
exploratory_analysis_exp1(plotCase, data)
```
where `plotCase` is a string of the analysis to be conducted. It can be `'avgAcc'`, `'avgRT'`, or `'intrachunkRT'`.

### *policy_complexity_analysis_exp2.m*

Average policy complexity and reward-complexity curves in different blocks. 

### *sim_rc_tradeoff.m*

Simulate and plot the average reward, the policy complexity, and the reward-complexity tradeoff under the load and incentive manipulation conditions.
