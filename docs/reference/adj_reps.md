# Family of functions to adjust number of repetition

These functions are reverse version of the
[`adj_perc_1RM`](https://mladenjovanovic.github.io/STMr/reference/adj_perc_1RM.md)
family of functions. Use these when you want to estimate number of
repetitions to be used when using the known %1RM and level of adjustment

## Usage

``` r
adj_reps_RIR(
  perc_1RM,
  adjustment = 0,
  mfactor = 1,
  max_reps_func = max_reps_epley,
  ...
)

adj_reps_DI(
  perc_1RM,
  adjustment = 1,
  mfactor = 1,
  max_reps_func = max_reps_epley,
  ...
)

adj_reps_rel_int(
  perc_1RM,
  adjustment = 1,
  mfactor = 1,
  max_reps_func = max_reps_epley,
  ...
)

adj_reps_perc_MR(
  perc_1RM,
  adjustment = 1,
  mfactor = 1,
  max_reps_func = max_reps_epley,
  ...
)
```

## Arguments

- perc_1RM:

  Numeric vector. %1RM used (use 0.5 for 50%, 0.9 for 90%)

- adjustment:

  Numeric vector. Adjustment to be implemented

- mfactor:

  Numeric vector. Default is 1 (i.e., no adjustment). Use `mfactor = 2`
  to generate ballistic adjustment and tables, and `mfactor = 3` to
  generate conservative adjustment and tables

- max_reps_func:

  Max reps function to be used. Default is
  [`max_reps_epley`](https://mladenjovanovic.github.io/STMr/reference/max_reps.md)

- ...:

  Forwarded to `max_reps_func`. Usually the parameter value. For example
  `klin = 36` when using
  [`max_reps_linear`](https://mladenjovanovic.github.io/STMr/reference/max_reps.md)
  as `max_reps_func` function

## Value

Numeric vector. Predicted number of repetitions to be performed

## Functions

- `adj_reps_RIR()`: Adjust number of repetitions using the Reps In
  Reserve (RIR) approach

- `adj_reps_DI()`: Adjust number of repetitions using the Deducted
  Intensity (DI) approach

- `adj_reps_rel_int()`: Adjust number of repetitions using the Relative
  Intensity (RelInt) approach

- `adj_reps_perc_MR()`: Adjust number of repetitions using the % max
  reps (%MR) approach

## Examples

``` r
# ------------------------------------------
# Adjustment using Reps In Reserve (RIR)
adj_reps_RIR(0.75)
#> [1] 10.01001

# Use ballistic adjustment (this implies doing half the reps)
adj_reps_RIR(0.75, mfactor = 2)
#> [1] 5.005005

# Use 2 reps in reserve
adj_reps_RIR(0.75, adjustment = 2)
#> [1] 8.01001

# Use Linear model
adj_reps_RIR(0.75, max_reps_func = max_reps_linear, adjustment = 2)
#> [1] 7.25

# Use Modifed Epley's equation with a custom parameter values
adj_reps_RIR(
  0.75,
  max_reps_func = max_reps_modified_epley,
  adjustment = 2,
  kmod = 0.06
)
#> [1] 4.555556
# ------------------------------------------
# Adjustment using Deducted Intensity (DI)
adj_reps_DI(0.75)
#> [1] -150.1502

# Use ballistic adjustment (this implies doing half the reps)
adj_reps_DI(0.75, mfactor = 2)
#> [1] -75.07508

# Use 10% deducted intensity
adj_reps_DI(0.75, adjustment = -0.1)
#> [1] 5.299417

# Use Linear model
adj_reps_DI(0.75, max_reps_func = max_reps_linear, adjustment = -0.1)
#> [1] 5.95

# Use Modifed Epley's equation with a custom parameter values
adj_reps_DI(
  0.75,
  max_reps_func = max_reps_modified_epley,
  adjustment = -0.1,
  kmod = 0.06
)
#> [1] 3.941176
# ------------------------------------------
# Adjustment using Relative Intensity (RelInt)
adj_reps_rel_int(0.75)
#> [1] 10.01001

# Use ballistic adjustment (this implies doing half the reps)
adj_reps_rel_int(0.75, mfactor = 2)
#> [1] 5.005005

# Use 85% relative intensity
adj_reps_rel_int(0.75, adjustment = 0.85)
#> [1] 4.004004

# Use Linear model
adj_reps_rel_int(0.75, max_reps_func = max_reps_linear, adjustment = 0.85)
#> [1] 4.882353

# Use Modifed Epley's equation with a custom parameter values
adj_reps_rel_int(
  0.75,
  max_reps_func = max_reps_modified_epley,
  adjustment = 0.85,
  kmod = 0.06
)
#> [1] 3.222222
# ------------------------------------------
# Adjustment using % max reps (%MR)
adj_reps_perc_MR(0.75)
#> [1] 10.01001

# Use ballistic adjustment (this implies doing half the reps)
adj_reps_perc_MR(0.75, mfactor = 2)
#> [1] 5.005005

# Use 85% of max reps
adj_reps_perc_MR(0.75, adjustment = 0.85)
#> [1] 8.508509

# Use Linear model
adj_reps_perc_MR(0.75, max_reps_func = max_reps_linear, adjustment = 0.85)
#> [1] 7.8625

# Use Modifed Epley's equation with a custom parameter values
adj_reps_perc_MR(
  0.75,
  max_reps_func = max_reps_modified_epley,
  adjustment = 0.85,
  kmod = 0.06
)
#> [1] 5.572222
```
