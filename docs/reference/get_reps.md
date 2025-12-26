# Get Reps

Function `get_reps` represent a wrapper function. This function is the
reverse version of the
[`get_perc_1RM`](https://mladenjovanovic.github.io/STMr/reference/get_perc_1RM.md)
function. Use it when you want to estimate number of repetitions to be
used when using the known %1RM and level of adjustment

## Usage

``` r
get_reps(perc_1RM, method = "RIR", model = "epley", ...)
```

## Arguments

- perc_1RM:

  Numeric vector. %1RM used (use 0.5 for 50 perc, 0.9 for 90 perc)

- method:

  Character vector. Default is "RIR". Other options are "DI", "RelInt",
  "%MR"

- model:

  Character vector. Default is "epley". Other options are "modified
  epley", "linear"

- ...:

  Forwarded to selected `adj_reps` function

## Value

Numeric vector Predicted repetitions

## Examples

``` r
get_reps(0.75)
#> [1] 10.01001

# # Use ballistic adjustment (this implies doing half the reps)
get_reps(0.75, mfactor = 2)
#> [1] 5.005005

# Use %MR adjustment method
get_reps(0.75, "%MR", adjustment = 0.8)
#> [1] 8.008008

# Use linear model with use defined klin values
get_reps(0.75, "%MR", model = "linear", adjustment = 0.8, klin = 36)
#> [1] 8
```
