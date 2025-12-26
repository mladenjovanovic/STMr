# Family of functions to estimate max %1RM

Family of functions to estimate max %1RM

## Usage

``` r
max_perc_1RM_epley(reps, k = 0.0333)

max_perc_1RM_modified_epley(reps, kmod = 0.0353)

max_perc_1RM_linear(reps, klin = 33)
```

## Arguments

- reps:

  Numeric vector. Number of repetition to be performed

- k:

  User defined `k` parameter in the Epley's equation. Default is 0.0333

- kmod:

  User defined `kmod` parameter in the Modified Epley's equation.
  Default is 0.0353

- klin:

  User defined `klin` parameter in the Linear equation. Default is 33

## Value

Numeric vector. Predicted %1RM

## Functions

- `max_perc_1RM_epley()`: Estimate max %1RM using the Epley's equation

- `max_perc_1RM_modified_epley()`: Estimate max %1RM using the Modified
  Epley's equation

- `max_perc_1RM_linear()`: Estimate max %1RM using the Linear (or
  Brzycki's) equation

## Examples

``` r
# ------------------------------------------
# Epley equation
max_perc_1RM_epley(1:10)
#>  [1] 0.9677732 0.9375586 0.9091736 0.8824568 0.8572653 0.8334722 0.8109642
#>  [8] 0.7896399 0.7694083 0.7501875
max_perc_1RM_epley(1:10, k = 0.04)
#>  [1] 0.9615385 0.9259259 0.8928571 0.8620690 0.8333333 0.8064516 0.7812500
#>  [8] 0.7575758 0.7352941 0.7142857
# ------------------------------------------
# Modified Epley equation
max_perc_1RM_modified_epley(1:10)
#>  [1] 1.0000000 0.9659036 0.9340557 0.9042409 0.8762706 0.8499788 0.8252187
#>  [8] 0.8018603 0.7797879 0.7588981
max_perc_1RM_modified_epley(1:10, kmod = 0.05)
#>  [1] 1.0000000 0.9523810 0.9090909 0.8695652 0.8333333 0.8000000 0.7692308
#>  [8] 0.7407407 0.7142857 0.6896552
# ------------------------------------------
# Linear/Brzycki equation
max_perc_1RM_linear(1:10)
#>  [1] 1.0000000 0.9696970 0.9393939 0.9090909 0.8787879 0.8484848 0.8181818
#>  [8] 0.7878788 0.7575758 0.7272727
max_perc_1RM_linear(1:10, klin = 36)
#>  [1] 1.0000000 0.9722222 0.9444444 0.9166667 0.8888889 0.8611111 0.8333333
#>  [8] 0.8055556 0.7777778 0.7500000
```
