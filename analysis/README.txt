### Computational verification ###

1_comp_ver.RMD: code to run the computational verification on the original Buetti et al (2019) data. (See associated html file for output).
1_comp_ver_small_n.RMD: code to run the computational verification on the original Buetti et al (2019) data using a reduced number of observations per person. (See associated html file for output).
import_and_tidy.R: helper function to import data - used in above RMD files.

### Pilot analysis ###

1_pre_process_pilot.R: code that pre-processes pilot data.
2_fit_pilot_models.R: code that fits and save various pilot data models.
3_pilot_analysis.RMD: code to run supplementary materials: pilot analysis. (See associated html file for output).

### Main analysis ###

1_pre_process_data.R: code that pre-processes main experimental data.
2_fit_models.R: code that fits and saves various main experimental data models.
2b_model_comparison.R: code that runs model comparisons for the main experimental data. Results are saved in model_comp_hyp1.csv, model_comp_hyp2.csv and model_comp_ring.csv.
3_registered_analysis.RMD: code to run supplementary materials: registered analysis. (See associated html file for output).
4_planned_explorations.RMD: code to run supplementary materials: planned explorations. (See associated html file for output).
5_suggestions_from_reviewers.RMD: code to run supplementary materials: suggestions from reviewers. (See associated html file for output).

### Scripts ###
n_trial_sims.R: script to create n_trials.pdf (Figure 3 in the main manuscript).
our_functions.R: helper functions used in our analyses.
pred_rt_functions.R: helper functions for predicting reaction times, used in our analyses.
repimplementation.R: helper functions used for the computational verification re-analyses.
