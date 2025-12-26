# Create Example

This function create simple example using `progression_table`

## Usage

``` r
create_example(
  progression_table,
  reps = c(3, 5, 10),
  volume = c("intensive", "normal", "extensive"),
  type = c("grinding", "ballistic"),
  ...
)
```

## Arguments

- progression_table:

  Progression table function

- reps:

  Numeric vector. Default is `c(3, 5, 10)`

- volume:

  Character vector. Default is `c("intensive", "normal", "extensive")`

- type:

  Character vector. Type of max rep table. Options are grinding
  (Default), ballistic, and conservative

- ...:

  Extra arguments forwarded to `progression_table`

## Value

Data frame with the following structure

- type:

  Type of the set and rep scheme

- reps:

  Number of reps performed

- volume:

  Volume type of the set and rep scheme

- Step 1:

  First progression step %1RM

- Step 2:

  Second progression step %1RM

- Step 3:

  Third progression step %1RM

- Step 4:

  Fourth progression step %1RM

- Step 2-1 Diff:

  Difference in %1RM between second and first progression step

- Step 3-2 Diff:

  Difference in %1RM between third and second progression step

- Step 4-3 Diff:

  Difference in %1RM between fourth and third progression step

## Examples

``` r
create_example(progression_RIR)
#> # A tibble: 18 × 10
#>    type       reps volume    `Step 1` `Step 2` `Step 3` `Step 4` `Step 2-1 Diff`
#>    <chr>     <dbl> <chr>        <dbl>    <dbl>    <dbl>    <dbl>           <dbl>
#>  1 grinding      3 intensive     83.3     85.7     88.2     90.9            2.38
#>  2 grinding      3 normal        81.1     83.3     85.7     88.2            2.25
#>  3 grinding      3 extensive     79.0     81.1     83.3     85.7            2.13
#>  4 grinding      5 intensive     79.0     81.1     83.3     85.7            2.13
#>  5 grinding      5 normal        76.9     79.0     81.1     83.3            2.02
#>  6 grinding      5 extensive     75.0     76.9     79.0     81.1            1.92
#>  7 grinding     10 intensive     69.8     71.4     73.2     75.0            1.66
#>  8 grinding     10 normal        68.2     69.8     71.4     73.2            1.59
#>  9 grinding     10 extensive     66.7     68.2     69.8     71.4            1.51
#> 10 ballistic     3 intensive     71.4     75.0     79.0     83.3            3.57
#> 11 ballistic     3 normal        68.2     71.4     75.0     79.0            3.25
#> 12 ballistic     3 extensive     65.2     68.2     71.4     75.0            2.96
#> 13 ballistic     5 intensive     65.2     68.2     71.4     75.0            2.96
#> 14 ballistic     5 normal        62.5     65.2     68.2     71.4            2.72
#> 15 ballistic     5 extensive     60.0     62.5     65.2     68.2            2.50
#> 16 ballistic    10 intensive     53.6     55.6     57.7     60.0            1.98
#> 17 ballistic    10 normal        51.7     53.6     55.6     57.7            1.85
#> 18 ballistic    10 extensive     50.0     51.7     53.6     55.6            1.72
#> # ℹ 2 more variables: `Step 3-2 Diff` <dbl>, `Step 4-3 Diff` <dbl>

# Create example using specific reps-max table and k value
create_example(
  progression_RIR,
  max_perc_1RM_func = max_perc_1RM_modified_epley,
  kmod = 0.0388
)
#> # A tibble: 18 × 10
#>    type       reps volume    `Step 1` `Step 2` `Step 3` `Step 4` `Step 2-1 Diff`
#>    <chr>     <dbl> <chr>        <dbl>    <dbl>    <dbl>    <dbl>           <dbl>
#>  1 grinding      3 intensive     83.8     86.6     89.6     92.8            2.81
#>  2 grinding      3 normal        81.1     83.8     86.6     89.6            2.64
#>  3 grinding      3 extensive     78.6     81.1     83.8     86.6            2.48
#>  4 grinding      5 intensive     78.6     81.1     83.8     86.6            2.48
#>  5 grinding      5 normal        76.3     78.6     81.1     83.8            2.33
#>  6 grinding      5 extensive     74.1     76.3     78.6     81.1            2.19
#>  7 grinding     10 intensive     68.2     70.1     72.0     74.1            1.86
#>  8 grinding     10 normal        66.5     68.2     70.1     72.0            1.76
#>  9 grinding     10 extensive     64.8     66.5     68.2     70.1            1.67
#> 10 ballistic     3 intensive     70.1     74.1     78.6     83.8            4.03
#> 11 ballistic     3 normal        66.5     70.1     74.1     78.6            3.62
#> 12 ballistic     3 extensive     63.2     66.5     70.1     74.1            3.26
#> 13 ballistic     5 intensive     63.2     66.5     70.1     74.1            3.26
#> 14 ballistic     5 normal        60.3     63.2     66.5     70.1            2.96
#> 15 ballistic     5 extensive     57.6     60.3     63.2     66.5            2.69
#> 16 ballistic    10 intensive     50.8     52.8     55.1     57.6            2.08
#> 17 ballistic    10 normal        48.8     50.8     52.8     55.1            1.92
#> 18 ballistic    10 extensive     47.1     48.8     50.8     52.8            1.78
#> # ℹ 2 more variables: `Step 3-2 Diff` <dbl>, `Step 4-3 Diff` <dbl>
```
