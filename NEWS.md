# STM 0.0.2.9000

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
