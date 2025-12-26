# Get %1RM

Function `get_perc_1RM` represent a wrapper function

## Usage

``` r
get_perc_1RM(reps, method = "RIR", model = "epley", ...)
```

## Arguments

- reps:

  Numeric vector. Number of repetition to be performed

- method:

  Character vector. Default is "RIR". Other options are "DI", "RelInt",
  "%MR"

- model:

  Character vector. Default is "epley". Other options are "modified
  epley", "linear"

- ...:

  Forwarded to selected `adj_perc_1RM` function

## Value

Numeric vector. Predicted %1RM

## Examples

``` r
get_perc_1RM(5)
#> [1] 0.8572653

# # Use ballistic adjustment (this implies doing half the reps)
get_perc_1RM(5, mfactor = 2)
#> [1] 0.7501875

# Use perc MR adjustment method
get_perc_1RM(5, "%MR", adjustment = 0.8)
#> [1] 0.8277289

# Use linear model with use defined klin values
get_perc_1RM(5, "%MR", model = "linear", adjustment = 0.8, klin = 36)
#> [1] 0.8541667
```
