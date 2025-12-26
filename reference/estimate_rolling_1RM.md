# Estimate the rolling profile and 1RM

Estimate the rolling profile and 1RM

## Usage

``` r
estimate_rolling_1RM(
  weight,
  reps,
  eRIR = 0,
  day_index,
  window = 14,
  estimate_function = estimate_k_1RM,
  ...
)
```

## Arguments

- weight:

  Weight used

- reps:

  Number of repetitions done

- eRIR:

  Subjective estimation of reps-in-reserve (eRIR)

- day_index:

  Day index used to estimate rolling window

- window:

  Width of the rolling window. Default is 14

- estimate_function:

  Estimation function to be used. Default is
  [`estimate_k_1RM`](https://mladenjovanovic.github.io/STMr/reference/estimate_functions.md)

- ...:

  Forwarded to `estimate_function` function

## Value

Data frame with day index and coefficients returned by the
`estimate_function` function

## Examples

``` r
estimate_rolling_1RM(
  weight = strength_training_log$weight,
  reps = strength_training_log$reps,
  eRIR = strength_training_log$eRIR,
  day_index = strength_training_log$day,
  window = 10,
  estimate_function = estimate_k_1RM_quantile,
  tau = 0.9
)
#> # A tibble: 15 × 3
#>    day_index      k `0RM`
#>        <int>  <dbl> <dbl>
#>  1        10 0.0448  109.
#>  2        11 0.0451  109.
#>  3        12 0.0476  111.
#>  4        13 0.0417  109.
#>  5        14 0.0417  109.
#>  6        15 0.0400  108.
#>  7        16 0.0439  111.
#>  8        17 0.0437  111.
#>  9        18 0.0437  111.
#> 10        19 0.0427  111.
#> 11        20 0.0433  111.
#> 12        21 0.0396  111.
#> 13        22 0.0396  111.
#> 14        23 0.0378  110.
#> 15        24 0.0397  112.
```
