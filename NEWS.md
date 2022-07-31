# STMr 0.1.3.9000

* Fixed a bug in `scheme_rep_acc()` - now the END rep and step is used, and the reps are counted backwards as intended
* Added comment in the `vertical_generic()` and `vertical_rep_accumulation()` to avoid generating rep accumulation schme using those two functions, but rather using `scheme_rep_acc()`
* Formatting error in `scheme_()` functions
* Changed default progression table to `progression_perc_drop` in all `scheme_()` functions
* Changed default vertical planning to `vertical_const` in all `scheme_()` functions
* Fixed a bug in `scheme_light_heavy()` - now it takes the highest rep and use that to estimate %1RMs
* Added `scheme_ladder()` set and rep scheme
* Added `.vertical_rep_accumulation.post()` function. This functions is to be applied AFTER scheme is generated. Other options is to use `scheme_rep_acc()` function, that is flexible enough to generate most schemes, except for the `scheme_ladder()` and `scheme_light_heavy()`
* Added `vertical_block_undulating()` vertical planning function. This is a combination of Block Variant (undulation in the steps) and Undulating (undulation in reps)
* Fixed a "corner case" bug in `scheme_generic()`, where `vertical_set_accumulation` didn't repeat the adjustments, which cause problems if only single set is accumulated. This is because the adjustments were not accumulated, but rather "recycled". 
* Changed the parameter name from `accumulate_rep` to `accumulate_set` in `vertical_set_accumulation()` and `vertical_set_accumulation_reverse()` functions
* Expanded the README.Rmd to include the discussion on Rep Accumulation scheme
* Added extra features to `vertical_set_accumulation()` and `vertical_set_accumulation_reverse()` (see sequence argument)
* Fixed the default arguments for `adjustment` in the `scheme_` functions. Now they are flexible, depending on the `reps` argument, but follow the general logic of a given scheme.  
* Improved and simplified scheme plotting in `plot_scheme()` function. Removed {ggstance} from package dependencies
* Added `label_size` and `font_size` arguments to `plot_scheme()` and `plot_progression_table()` functions
* Removed default progression table from `generate_progression_table()`, `create_example()`, `plot_progression_table()` functions
* Added `plot_vertical()` function for plotting vertical plan

# STMr 0.1.3

* Changed the STMr to 'STMr' in the DESCRIPTION as per CRAN member recommendation
* Added documentation about the functions output/return values as per CRAN member recommendation. Documentation for the following functions has been updated: `create_example()`, `get_perc_1RM()`, `get_reps()`

# STMr 0.1.2

* Renamed the package to {STMr} since there is already a CRAN package STM
* Fixed a bug in `progression_rel_int()` function
* Renamed `nRM_testing` dataset to `RTF_testing`, as well as renamed the columns to be more descriptive
* Added mixed-level estimation functions for both simple and 1RM estimation: `estimate_k_mixed()`, `estimate_k_1RM_mixed()`, `estimate_kmod_mixed()`, `estimate_kmod_1RM_mixed()`, `estimate_klin_mixed()`, and `estimate_klin_1RM_mixed()`. These are implemented using the {nlme} package and `nlme::nlme()` function
* Improvements on the `strength_training_log` dataset. eRIR ratings are now halved, and everything over 5 is now `NA`
* Fixed examples in `get_reps()` function documentation
* Rewrote README.Rmd file

# STMr 0.1.1

* Added different weighting options for the `estimate_` family of functions. These include
  - "none" (for equal weight, or no weighting of the observations)
  - "reps" (for `1/reps` weighting)
  - "load" (for using weight or %1RM)
  - "eRIR" (for `1/(eRIR+1)` weighting)
  - "reps x load"
  - "reps x eRIR"
  - "load x eRIR"
  - "reps x load x eRIR"

* Added `strength_training_log` dataset. Single individual performing two strength training sessions per week,
over the course of 12 weeks (4 phases, each 3 weeks long). Individual eRIR (estimated reps-in-reserve) subjective rating is included in the dataset. This dataset is used to demonstrate techniques for *embedded* testing of the 1RM and individual profiles

* Added `estimate_k_quantile()`, `estimate_kmod_quantile()`, and `estimate_klin_quantile()` functions to implement non-linear quantile estimation of the parameters


# STMr 0.1.0

* REWRITTEN the whole package. This version will have compatibility issues with the previous version due to different naming of the functions. The package is now more modular, flexible, and can be parameterized more easily

* The functions are organized in the following manner:

  - estimation functions (start with `estimate_`)
  - reps-max functions (start with `max_`). Epley's, Modified Epley's and Linear/Brzycki's model are implemented
  - adjustment functions (start with `adj_`). Deducted Intensity (DI), Relative Intensity (RelInt), Reps In Reserve (RIR), and % Max Reps (%MR) methods are implemented
  - wrapper functions `get_reps()` and `get_perc_1RM()` are implemented to combine reps-max models as well as progression (adjustment) functions into easy to use format
  - progression functions (start with `progression_`) are implemented and allow easy parameterization to involve specific model and their estimated parameter values
  - *vertical planning* functions (start with `vertical_`)
  - *scheme function* (start with `scheme_`)
  - plotting and printing functions: `generate_progression_table()`, `plot_progression_table()`, `plot_scheme()`, and `create_example()`

* Fixed few typos in `citation()`
* Added sample data set `nRM_testing`, which contains reps max testing of 12 athletes using 70, 80, and 90% 1RM

# STMr 0.0.3

* Estimated `1RM` in `estimate_xxx_1RM()` functions is now in the second place in coefficient order
* Added `create_example()` function for quickly creating example using selected progression table

# STMr 0.0.2

* Added functionality to forward extra arguments to a custom max-reps functions (i.e., `get_max_perc_1RM()`). Also see `get_max_perc_1RM_k()` functions
* Added `get_max_perc_1RM_k()`, `get_max_reps_k()`, and `get_predicted_1RM_k()` functions that uses user defined `k` value/parameter. Together with the previous functionality, use is not able to easily create custom max-reps table functions with extra arguments. This provides great flexibility
* Added `get_max_perc_1RM_kmod()`, `get_max_reps_kmod()`, and `get_predicted_1RM_kmod()` functions that uses user defined `kmod` value/parameter for the modified Epley's equation
Added `get_max_perc_1RM_klin()`, `get_max_reps_klin()`, and `get_predicted_1RM_klin()` functions that uses user defined `klin` value/parameter for the linear equation
* Added `estimate_` family of functions to estimate Epley's, modified Epley's, and linear equation parameters, as well as novel estimation functions that uses absolute weight to estimate both `k`, `kmod`, `klin` and `1RM` parameters

# STMr 0.0.1

* Initial complete version of the package
* Added Relative Intensity and %MR progression tables
* Added plotting functions

# STMr 0.0.0.9000

* Added a `NEWS.md` file to track changes to the package.
