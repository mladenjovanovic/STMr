# Changelog

## STMR 0.1.6.9000

- Added `conservative` option when generating progression tables, which
  is equal to `mfactor = 3`
- In function
  [`plot_progression_table()`](https://mladenjovanovic.github.io/STMr/reference/plot_progression_table.md),
  renamed `adjustment_multiplier` to `multiplier`, due to R “error” of
  assuming user-provided `adjustment` parameter to be
  `adjustment_multiplier`.
- Updated READMER.Rmd file

## STMr 0.1.6

CRAN release: 2023-11-02

- Changed from [`stats::nlm()`](https://rdrr.io/r/stats/nlm.html) to
  [`minpack.lm::nlsLM()`](https://rdrr.io/pkg/minpack.lm/man/nlsLM.html)
  function for estimating parameters in
  [`estimate_k()`](https://mladenjovanovic.github.io/STMr/reference/estimate_functions.md),
  [`estimate_k_1RM()`](https://mladenjovanovic.github.io/STMr/reference/estimate_functions.md),
  [`estimate_kmod()`](https://mladenjovanovic.github.io/STMr/reference/estimate_functions.md),
  [`estimate_kmod_1RM()`](https://mladenjovanovic.github.io/STMr/reference/estimate_functions.md),
  [`estimate_klin()`](https://mladenjovanovic.github.io/STMr/reference/estimate_functions.md),
  and
  [`estimate_klin_1RM()`](https://mladenjovanovic.github.io/STMr/reference/estimate_functions.md)
  functions.
- Added
  [`estimate_k_generic()`](https://mladenjovanovic.github.io/STMr/reference/estimate_functions.md)
  and
  [`estimate_k_generic_1RM()`](https://mladenjovanovic.github.io/STMr/reference/estimate_functions.md).
  These functions return the model object, but use the default `k` value
  of 0.0333
- Added
  [`estimate_k_generic_1RM_mixed()`](https://mladenjovanovic.github.io/STMr/reference/estimate_functions_mixed.md)
  which uses generic `k` value of 0.0333 to predict the `0RM`
- Added
  [`estimate_k_generic_1RM_quantile()`](https://mladenjovanovic.github.io/STMr/reference/estimate_functions_quantile.md)
  which uses generic `k` value of 0.0333 to predict the `0RM`

## STMr 0.1.5

CRAN release: 2022-09-17

- Added day counter (`day`) in the `strength_training_log` dataset. This
  will be used for an example on how to use the rolling estimation
- Added
  [`estimate_rolling_1RM()`](https://mladenjovanovic.github.io/STMr/reference/estimate_rolling_1RM.md)
  function. This is used to implement “embedded testing” using training
  logs to estimate both reps-max profiles and 1RMs
- Updated the README.Rmd file with the above additions
- Added TOC to README.Rmd

## STMr 0.1.4

CRAN release: 2022-08-31

- Fixed a bug in
  [`scheme_rep_acc()`](https://mladenjovanovic.github.io/STMr/reference/set_and_reps_schemes.md) -
  now the END rep and step is used, and the reps are counted backwards
  as intended
- Added comment in the `vertical_generic()` and
  [`vertical_rep_accumulation()`](https://mladenjovanovic.github.io/STMr/reference/vertical_planning_functions.md)
  to avoid generating rep accumulation schme using those two functions,
  but rather using
  [`scheme_rep_acc()`](https://mladenjovanovic.github.io/STMr/reference/set_and_reps_schemes.md)
- Formatting error in `scheme_()` functions
- Changed default progression table to `progression_perc_drop` in all
  `scheme_()` functions
- Changed default vertical planning to `vertical_const` in all
  `scheme_()` functions
- Fixed a bug in
  [`scheme_light_heavy()`](https://mladenjovanovic.github.io/STMr/reference/set_and_reps_schemes.md) -
  now it takes the highest rep and use that to estimate %1RMs
- Added
  [`scheme_ladder()`](https://mladenjovanovic.github.io/STMr/reference/set_and_reps_schemes.md)
  set and rep scheme
- Added
  [`.vertical_rep_accumulation.post()`](https://mladenjovanovic.github.io/STMr/reference/vertical_planning_functions.md)
  function. This functions is to be applied AFTER scheme is generated.
  Other options is to use
  [`scheme_rep_acc()`](https://mladenjovanovic.github.io/STMr/reference/set_and_reps_schemes.md)
  function, that is flexible enough to generate most schemes, except for
  the
  [`scheme_ladder()`](https://mladenjovanovic.github.io/STMr/reference/set_and_reps_schemes.md)
  and
  [`scheme_light_heavy()`](https://mladenjovanovic.github.io/STMr/reference/set_and_reps_schemes.md)
- Added
  [`vertical_block_undulating()`](https://mladenjovanovic.github.io/STMr/reference/vertical_planning_functions.md)
  vertical planning function. This is a combination of Block Variant
  (undulation in the steps) and Undulating (undulation in reps)
- Fixed a “corner case” bug in
  [`scheme_generic()`](https://mladenjovanovic.github.io/STMr/reference/set_and_reps_schemes.md),
  where `vertical_set_accumulation` didn’t repeat the adjustments, which
  cause problems if only single set is accumulated. This is because the
  adjustments were not accumulated, but rather “recycled”.
- Changed the parameter name from `accumulate_rep` to `accumulate_set`
  in
  [`vertical_set_accumulation()`](https://mladenjovanovic.github.io/STMr/reference/vertical_planning_functions.md)
  and
  [`vertical_set_accumulation_reverse()`](https://mladenjovanovic.github.io/STMr/reference/vertical_planning_functions.md)
  functions
- Expanded the README.Rmd to include the discussion on Rep Accumulation
  scheme
- Added extra features to
  [`vertical_set_accumulation()`](https://mladenjovanovic.github.io/STMr/reference/vertical_planning_functions.md)
  and
  [`vertical_set_accumulation_reverse()`](https://mladenjovanovic.github.io/STMr/reference/vertical_planning_functions.md)
  (see sequence argument)
- Fixed the default arguments for `adjustment` in the `scheme_`
  functions. Now they are flexible, depending on the `reps` argument,
  but follow the general logic of a given scheme.  
- Improved and simplified scheme plotting in
  [`plot_scheme()`](https://mladenjovanovic.github.io/STMr/reference/plot_scheme.md)
  function. Removed {ggstance} from package dependencies
- Added `font_size` arguments to
  [`plot_scheme()`](https://mladenjovanovic.github.io/STMr/reference/plot_scheme.md)
  and
  [`plot_progression_table()`](https://mladenjovanovic.github.io/STMr/reference/plot_progression_table.md)
  functions
- Removed default progression table from
  [`generate_progression_table()`](https://mladenjovanovic.github.io/STMr/reference/progression_table.md),
  [`create_example()`](https://mladenjovanovic.github.io/STMr/reference/create_example.md),
  [`plot_progression_table()`](https://mladenjovanovic.github.io/STMr/reference/plot_progression_table.md)
  functions
- Added
  [`plot_vertical()`](https://mladenjovanovic.github.io/STMr/reference/plot_vertical.md)
  function for plotting vertical plan
- Created `STMr_scheme` class (subclass of data frame), and now scheme
  can be plotted by using simple S3 `plot` method.
  [`plot_scheme()`](https://mladenjovanovic.github.io/STMr/reference/plot_scheme.md)
  function is now deprecated. Added three types of plots: `bar`,
  `vertical`, and `fraction`. The `STMr_scheme` class has now the
  following columns: `index`, `step`, `set`, `reps`, `adjustment`, and
  `perc_1RM`.
- Added `STMr_vertical` constructor. Now the `vertical_` functions
  return `STMr_vertical` data frame object with following column names:
  `index`, `step`, `set`, `set_id`, and `reps`. `set_id` is needed to
  sort out an issue (see above) for the
  [`vertical_set_accumulation()`](https://mladenjovanovic.github.io/STMr/reference/vertical_planning_functions.md)
  and
  [`vertical_set_accumulation_reverse()`](https://mladenjovanovic.github.io/STMr/reference/vertical_planning_functions.md)
  vertical plans when adjustment is applied inside
  [`scheme_generic()`](https://mladenjovanovic.github.io/STMr/reference/set_and_reps_schemes.md)
  function
- In the output of the
  [`scheme_light_heavy()`](https://mladenjovanovic.github.io/STMr/reference/set_and_reps_schemes.md)
  and
  [`scheme_ladder()`](https://mladenjovanovic.github.io/STMr/reference/set_and_reps_schemes.md)
  functions, I have set `adjustment` to `NA` since to avoid confusing
  the user. This is because due to the modifications that these
  functions does to the “light” sets, the adjustment is not applicable
  and not related to selected progression table
- Added [ggfittext](https://wilkox.org/ggfittext/) package dependency,
  so the plot labels are now flexible and fit the “container”. This can
  be useful when set accumulation is used, so the labels do not go
  outside of the bars
- Added `reps_change` to
  [`vertical_set_accumulation()`](https://mladenjovanovic.github.io/STMr/reference/vertical_planning_functions.md)
  and
  [`vertical_set_accumulation_reverse()`](https://mladenjovanovic.github.io/STMr/reference/vertical_planning_functions.md),
  making them really flexible functions
- Added
  [`scheme_manual()`](https://mladenjovanovic.github.io/STMr/reference/set_and_reps_schemes.md)
  for manual generation of the scheme, which provides for the ultimate
  flexibility
- Added `perc_str` argument to
  [`plot()`](https://rdrr.io/r/graphics/plot.default.html) S3 method,
  which allows the user to remove “%” and thus have more space for label
- Created `release` function and S3 `plot` method for merging multiple
  schemes (i.e., blocks or phases) into one release. This is used to
  inspect how multiple back-to-back phases mold together
- Added `perc_1RM` argument to
  [`scheme_manual()`](https://mladenjovanovic.github.io/STMr/reference/set_and_reps_schemes.md)
  for the user to provide manual 1RM percentages, rather than to be
  estimated
- Added
  [`scheme_perc_1RM()`](https://mladenjovanovic.github.io/STMr/reference/set_and_reps_schemes.md)
  which is simpler
  [`scheme_manual()`](https://mladenjovanovic.github.io/STMr/reference/set_and_reps_schemes.md)
  for manually entering 1RM percentages. For example creating simple
  warm-up scheme
- Added `+` method for `STMr_scheme` objects. This allows for easy
  modular adding of the schemes

## STMr 0.1.3

CRAN release: 2022-03-16

- Changed the STMr to ‘STMr’ in the DESCRIPTION as per CRAN member
  recommendation
- Added documentation about the functions output/return values as per
  CRAN member recommendation. Documentation for the following functions
  has been updated:
  [`create_example()`](https://mladenjovanovic.github.io/STMr/reference/create_example.md),
  [`get_perc_1RM()`](https://mladenjovanovic.github.io/STMr/reference/get_perc_1RM.md),
  [`get_reps()`](https://mladenjovanovic.github.io/STMr/reference/get_reps.md)

## STMr 0.1.2

- Renamed the package to {STMr} since there is already a CRAN package
  STM
- Fixed a bug in
  [`progression_rel_int()`](https://mladenjovanovic.github.io/STMr/reference/progression_table.md)
  function
- Renamed `nRM_testing` dataset to `RTF_testing`, as well as renamed the
  columns to be more descriptive
- Added mixed-level estimation functions for both simple and 1RM
  estimation:
  [`estimate_k_mixed()`](https://mladenjovanovic.github.io/STMr/reference/estimate_functions_mixed.md),
  [`estimate_k_1RM_mixed()`](https://mladenjovanovic.github.io/STMr/reference/estimate_functions_mixed.md),
  [`estimate_kmod_mixed()`](https://mladenjovanovic.github.io/STMr/reference/estimate_functions_mixed.md),
  [`estimate_kmod_1RM_mixed()`](https://mladenjovanovic.github.io/STMr/reference/estimate_functions_mixed.md),
  [`estimate_klin_mixed()`](https://mladenjovanovic.github.io/STMr/reference/estimate_functions_mixed.md),
  and
  [`estimate_klin_1RM_mixed()`](https://mladenjovanovic.github.io/STMr/reference/estimate_functions_mixed.md).
  These are implemented using the {nlme} package and
  [`nlme::nlme()`](https://rdrr.io/pkg/nlme/man/nlme.html) function
- Improvements on the `strength_training_log` dataset. eRIR ratings are
  now halved, and everything over 5 is now `NA`
- Fixed examples in
  [`get_reps()`](https://mladenjovanovic.github.io/STMr/reference/get_reps.md)
  function documentation
- Rewrote README.Rmd file

## STMr 0.1.1

- Added different weighting options for the `estimate_` family of
  functions. These include

  - “none” (for equal weight, or no weighting of the observations)
  - “reps” (for `1/reps` weighting)
  - “load” (for using weight or %1RM)
  - “eRIR” (for `1/(eRIR+1)` weighting)
  - “reps x load”
  - “reps x eRIR”
  - “load x eRIR”
  - “reps x load x eRIR”

- Added `strength_training_log` dataset. Single individual performing
  two strength training sessions per week, over the course of 12 weeks
  (4 phases, each 3 weeks long). Individual eRIR (estimated
  reps-in-reserve) subjective rating is included in the dataset. This
  dataset is used to demonstrate techniques for *embedded* testing of
  the 1RM and individual profiles

- Added
  [`estimate_k_quantile()`](https://mladenjovanovic.github.io/STMr/reference/estimate_functions_quantile.md),
  [`estimate_kmod_quantile()`](https://mladenjovanovic.github.io/STMr/reference/estimate_functions_quantile.md),
  and
  [`estimate_klin_quantile()`](https://mladenjovanovic.github.io/STMr/reference/estimate_functions_quantile.md)
  functions to implement non-linear quantile estimation of the
  parameters

## STMr 0.1.0

- REWRITTEN the whole package. This version will have compatibility
  issues with the previous version due to different naming of the
  functions. The package is now more modular, flexible, and can be
  parameterized more easily

- The functions are organized in the following manner:

  - estimation functions (start with `estimate_`)
  - reps-max functions (start with `max_`). Epley’s, Modified Epley’s
    and Linear/Brzycki’s model are implemented
  - adjustment functions (start with `adj_`). Deducted Intensity (DI),
    Relative Intensity (RelInt), Reps In Reserve (RIR), and % Max Reps
    (%MR) methods are implemented
  - wrapper functions
    [`get_reps()`](https://mladenjovanovic.github.io/STMr/reference/get_reps.md)
    and
    [`get_perc_1RM()`](https://mladenjovanovic.github.io/STMr/reference/get_perc_1RM.md)
    are implemented to combine reps-max models as well as progression
    (adjustment) functions into easy to use format
  - progression functions (start with `progression_`) are implemented
    and allow easy parameterization to involve specific model and their
    estimated parameter values
  - *vertical planning* functions (start with `vertical_`)
  - *scheme function* (start with `scheme_`)
  - plotting and printing functions:
    [`generate_progression_table()`](https://mladenjovanovic.github.io/STMr/reference/progression_table.md),
    [`plot_progression_table()`](https://mladenjovanovic.github.io/STMr/reference/plot_progression_table.md),
    [`plot_scheme()`](https://mladenjovanovic.github.io/STMr/reference/plot_scheme.md),
    and
    [`create_example()`](https://mladenjovanovic.github.io/STMr/reference/create_example.md)

- Fixed few typos in
  [`citation()`](https://rdrr.io/r/utils/citation.html)

- Added sample data set `nRM_testing`, which contains reps max testing
  of 12 athletes using 70, 80, and 90% 1RM

## STMr 0.0.3

- Estimated `1RM` in `estimate_xxx_1RM()` functions is now in the second
  place in coefficient order
- Added
  [`create_example()`](https://mladenjovanovic.github.io/STMr/reference/create_example.md)
  function for quickly creating example using selected progression table

## STMr 0.0.2

- Added functionality to forward extra arguments to a custom max-reps
  functions (i.e., `get_max_perc_1RM()`). Also see
  `get_max_perc_1RM_k()` functions
- Added `get_max_perc_1RM_k()`, `get_max_reps_k()`, and
  `get_predicted_1RM_k()` functions that uses user defined `k`
  value/parameter. Together with the previous functionality, use is not
  able to easily create custom max-reps table functions with extra
  arguments. This provides great flexibility
- Added `get_max_perc_1RM_kmod()`, `get_max_reps_kmod()`, and
  `get_predicted_1RM_kmod()` functions that uses user defined `kmod`
  value/parameter for the modified Epley’s equation Added
  `get_max_perc_1RM_klin()`, `get_max_reps_klin()`, and
  `get_predicted_1RM_klin()` functions that uses user defined `klin`
  value/parameter for the linear equation
- Added `estimate_` family of functions to estimate Epley’s, modified
  Epley’s, and linear equation parameters, as well as novel estimation
  functions that uses absolute weight to estimate both `k`, `kmod`,
  `klin` and `1RM` parameters
- Added missing `font_size` when plotting adjustments using
  [`plot_progression_table()`](https://mladenjovanovic.github.io/STMr/reference/plot_progression_table.md)

## STMr 0.0.1

- Initial complete version of the package
- Added Relative Intensity and %MR progression tables
- Added plotting functions

## STMr 0.0.0.9000

- Added a `NEWS.md` file to track changes to the package.
