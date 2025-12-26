# Family of functions to adjust %1RM

Family of functions to adjust %1RM

## Usage

``` r
adj_perc_1RM_RIR(
  reps,
  adjustment = 0,
  mfactor = 1,
  max_perc_1RM_func = max_perc_1RM_epley,
  ...
)

adj_perc_1RM_DI(
  reps,
  adjustment = 0,
  mfactor = 1,
  max_perc_1RM_func = max_perc_1RM_epley,
  ...
)

adj_perc_1RM_rel_int(
  reps,
  adjustment = 1,
  mfactor = 1,
  max_perc_1RM_func = max_perc_1RM_epley,
  ...
)

adj_perc_1RM_perc_MR(
  reps,
  adjustment = 1,
  mfactor = 1,
  max_perc_1RM_func = max_perc_1RM_epley,
  ...
)
```

## Arguments

- reps:

  Numeric vector. Number of repetition to be performed

- adjustment:

  Numeric vector. Adjustment to be implemented

- mfactor:

  Numeric vector. Default is 1 (i.e., no adjustment). Use `mfactor = 2`
  to generate ballistic adjustment and tables, and `mfactor = 3` to
  generate conservative adjustment and tables

- max_perc_1RM_func:

  Max %1RM function to be used. Default is
  [`max_perc_1RM_epley`](https://mladenjovanovic.github.io/STMr/reference/max_perc_1RM.md)

- ...:

  Forwarded to `max_perc_1RM_func`. Usually the parameter value. For
  example `klin = 36` when using
  [`max_perc_1RM_linear`](https://mladenjovanovic.github.io/STMr/reference/max_perc_1RM.md)
  as `max_perc_1RM_func` function

## Value

Numeric vector. Predicted perc 1RM

## Functions

- `adj_perc_1RM_RIR()`: Adjust max %1RM using the Reps In Reserve (RIR)
  approach

- `adj_perc_1RM_DI()`: Adjust max %1RM using the Deducted Intensity (DI)
  approach. This approach simple deducts `adjustment` from estimated
  %1RM

- `adj_perc_1RM_rel_int()`: Adjust max perc 1RM using the Relative
  Intensity (RelInt) approach. This approach simple multiplies estimated
  perc 1RM with `adjustment`

- `adj_perc_1RM_perc_MR()`: Adjust max perc 1RM using the %Max Reps
  (%MR) approach. This approach simple divides target reps with
  `adjustment`

## Examples

``` r
# ------------------------------------------
# Adjustment using Reps In Reserve (RIR)
adj_perc_1RM_RIR(5)
#> [1] 0.8572653

# Use ballistic adjustment (this implies doing half the reps)
adj_perc_1RM_RIR(5, mfactor = 2)
#> [1] 0.7501875

# Use 2 reps in reserve
adj_perc_1RM_RIR(5, adjustment = 2)
#> [1] 0.8109642

# Use Linear model
adj_perc_1RM_RIR(5, max_perc_1RM_func = max_perc_1RM_linear, adjustment = 2)
#> [1] 0.8181818

# Use Modifed Epley's equation with a custom parameter values
adj_perc_1RM_RIR(
  5,
  max_perc_1RM_func = max_perc_1RM_modified_epley,
  adjustment = 2,
  kmod = 0.06
)
#> [1] 0.7352941
# ------------------------------------------
# Adjustment using Deducted Intensity (DI)
adj_perc_1RM_DI(5)
#> [1] 0.8572653

# Use ballistic adjustment (this implies doing half the reps)
adj_perc_1RM_DI(5, mfactor = 2)
#> [1] 0.7501875

# Use 10 perc deducted intensity
adj_perc_1RM_DI(5, adjustment = -0.1)
#> [1] 0.7572653

# Use Linear model
adj_perc_1RM_DI(5, max_perc_1RM_func = max_perc_1RM_linear, adjustment = -0.1)
#> [1] 0.7787879

# Use Modifed Epley's equation with a custom parameter values
adj_perc_1RM_DI(
  5,
  max_perc_1RM_func = max_perc_1RM_modified_epley,
  adjustment = -0.1,
  kmod = 0.06
)
#> [1] 0.7064516
# ------------------------------------------
# Adjustment using Relative Intensity (RelInt)
adj_perc_1RM_rel_int(5)
#> [1] 0.8572653

# Use ballistic adjustment (this implies doing half the reps)
adj_perc_1RM_rel_int(5, mfactor = 2)
#> [1] 0.7501875

# Use 90 perc  relative intensity
adj_perc_1RM_rel_int(5, adjustment = 0.9)
#> [1] 0.7715388

# Use Linear model
adj_perc_1RM_rel_int(5, max_perc_1RM_func = max_perc_1RM_linear, adjustment = 0.9)
#> [1] 0.7909091

# Use Modifed Epley's equation with a custom parameter values
adj_perc_1RM_rel_int(
  5,
  max_perc_1RM_func = max_perc_1RM_modified_epley,
  adjustment = 0.9,
  kmod = 0.06
)
#> [1] 0.7258065
# ------------------------------------------
# Adjustment using % max reps (%MR)
adj_perc_1RM_perc_MR(5)
#> [1] 0.8572653

# Use ballistic adjustment (this implies doing half the reps)
adj_perc_1RM_perc_MR(5, mfactor = 2)
#> [1] 0.7501875

# Use 70 perc max reps
adj_perc_1RM_perc_MR(5, adjustment = 0.7)
#> [1] 0.8078477

# Use Linear model
adj_perc_1RM_perc_MR(5, max_perc_1RM_func = max_perc_1RM_linear, adjustment = 0.7)
#> [1] 0.8138528

# Use Modifed Epley's equation with a custom parameter values
adj_perc_1RM_perc_MR(
  5,
  max_perc_1RM_func = max_perc_1RM_modified_epley,
  adjustment = 0.7,
  kmod = 0.06
)
#> [1] 0.7306889
```
