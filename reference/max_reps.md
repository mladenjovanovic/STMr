# Family of functions to estimate max number of repetition (nRM)

Family of functions to estimate max number of repetition (nRM)

## Usage

``` r
max_reps_epley(perc_1RM, k = 0.0333)

max_reps_modified_epley(perc_1RM, kmod = 0.0353)

max_reps_linear(perc_1RM, klin = 33)
```

## Arguments

- perc_1RM:

  Numeric vector. % 1RM used (use 0.5 for 50 %, 0.9 for 90 %)

- k:

  User defined `k` parameter in the Epley's equation. Default is 0.0333

- kmod:

  User defined `kmod` parameter in the Modified Epley's equation.
  Default is 0.0353

- klin:

  User defined `klin` parameter in the Linear equation. Default is 33

## Value

Numeric vector. Predicted maximal number of repetitions (nRM)

## Functions

- `max_reps_epley()`: Estimate max number of repetition (nRM) using the
  Epley's equation

- `max_reps_modified_epley()`: Estimate max number of repetition (nRM)
  using the Modified Epley's equation

- `max_reps_linear()`: Estimate max number of repetition (nRM) using the
  Linear/Brzycki's equation

## Examples

``` r
# ------------------------------------------
# Epley equation
max_reps_epley(0.85)
#> [1] 5.299417
max_reps_epley(c(0.75, 0.85), k = 0.04)
#> [1] 8.333333 4.411765
# ------------------------------------------
# Modified Epley equation
max_reps_modified_epley(0.85)
#> [1] 5.999167
max_reps_modified_epley(c(0.75, 0.85), kmod = 0.05)
#> [1] 7.666667 4.529412
# ------------------------------------------
# Linear/Brzycki's equation
max_reps_linear(0.85)
#> [1] 5.95
max_reps_linear(c(0.75, 0.85), klin = 36)
#> [1] 10.0  6.4
```
