plot_progression_table(
  progression_variable_DI, plot = "%1RM", signif_digits = 2,
  reps = 1:12, type = 'conservative', multiplier = 100,
  max_perc_1RM_func = max_perc_1RM_modified_epley,
  rep_1_step_increment = -0.02,
  rep_12_step_increment = -0.04,
  rep_1_volume_increment = -0.02,
  rep_12_volume_increment = -0.04
)
