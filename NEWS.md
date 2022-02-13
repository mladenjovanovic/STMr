# STM 0.1.2.9000

* Fixed a bug in `progression_rel_int()` function
* Renamed `nRM_testing` dataset to `RTF_testing`, as well as renamed the columns to be more descriptive

# STM 0.1.1

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


# STM 0.1.0

* REWRITTEN the whole package. This version will have compatibility issues with the previous version due to different naming of the functions. The package is now more modular, flexible, and can be parameterized more easily

* The functions are organized in the following manner:

  - estimation functions (start with `estimate_`)
  - reps-max functions (start with `max_`). Epley's, Modified Epley's and Linear/Brzycki's model as implemented
  - adjustment functions (start with `adj_`). Deducted Intensity (DI), Relative Intensity (RelInt), Reps In Reserve (RIR), and % Max Reps (%MR) methods are implemented
  - wrapper functions `get_reps()` and `get_perc_1RM()` are implemented to combine reps-max models ad well as progression (adjustment) functions into easy to use format
  - progression functions (start with `progression_`) are implemented and allow easy parameterization to involve specific model and their estimated parameter values
  - *vertical planning* functions (start with `vertical_`)
  - *scheme function* (start with `scheme_`)
  - plotting and printing functions: `generate_progression_table()`, `plot_progression_table()`, `plot_scheme()`, and `create_example()`

* Fixed few typos in `citation()`
* Added sample data set `nRM_testing`, which contains reps max testing of 12 athletes using 70, 80, and 90% 1RM

# STM 0.0.3

* Estimated `1RM` in `estimate_xxx_1RM()` functions is now in the second place in coefficient order
* Added `create_example()` function for quickly creating example using selected progression table

# STM 0.0.2

* Added functionality to forward extra arguments to a custom max-reps functions (i.e., `get_max_perc_1RM()`). Also see `get_max_perc_1RM_k()` functions
* Added `get_max_perc_1RM_k()`, `get_max_reps_k()`, and `get_predicted_1RM_k()` functions that uses user defined `k` value/parameter. Together with the previous functionality, use is not able to easily create custom max-reps table functions with extra arguments. This provides great flexibility
* Added `get_max_perc_1RM_kmod()`, `get_max_reps_kmod()`, and `get_predicted_1RM_kmod()` functions that uses user defined `kmod` value/parameter for the modified Epley's equation
Added `get_max_perc_1RM_klin()`, `get_max_reps_klin()`, and `get_predicted_1RM_klin()` functions that uses user defined `klin` value/parameter for the linear equation
* Added `estimate_` family of functions to estimate Epley's, modified Epley's, and linear equation parameters, as well as novel estimation functions that uses absolute weight to estimate both `k`, `kmod`, `klin` and `1RM` parameters

# STM 0.0.1

* Initial complete version of the package
* Added Relative Intensity and %MR progression tables
* Added plotting functions

# STM 0.0.0.9000

* Added a `NEWS.md` file to track changes to the package.
