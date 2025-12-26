# Estimate relationship between reps and weight using the non-linear quantile regression

These functions provide estimate 1RM and parameter values using the
quantile regression. By default, target variable is the reps performed,
while the predictors is the `perc_1RM` or `weight`. To reverse this, use
the `reverse = TRUE` argument

## Usage

``` r
estimate_k_quantile(
  perc_1RM,
  reps,
  eRIR = 0,
  tau = 0.5,
  reverse = FALSE,
  control = quantreg::nlrq.control(maxiter = 10^4, InitialStepSize = 0),
  ...
)

estimate_k_generic_1RM_quantile(
  weight,
  reps,
  eRIR = 0,
  k = 0.0333,
  tau = 0.5,
  reverse = FALSE,
  control = quantreg::nlrq.control(maxiter = 10^4, InitialStepSize = 0),
  ...
)

estimate_k_1RM_quantile(
  weight,
  reps,
  eRIR = 0,
  tau = 0.5,
  reverse = FALSE,
  control = quantreg::nlrq.control(maxiter = 10^4, InitialStepSize = 0),
  ...
)

estimate_kmod_quantile(
  perc_1RM,
  reps,
  eRIR = 0,
  tau = 0.5,
  reverse = FALSE,
  control = quantreg::nlrq.control(maxiter = 10^4, InitialStepSize = 0),
  ...
)

estimate_kmod_1RM_quantile(
  weight,
  reps,
  eRIR = 0,
  tau = 0.5,
  reverse = FALSE,
  control = quantreg::nlrq.control(maxiter = 10^4, InitialStepSize = 0),
  ...
)

estimate_klin_quantile(
  perc_1RM,
  reps,
  eRIR = 0,
  tau = 0.5,
  reverse = FALSE,
  control = quantreg::nlrq.control(maxiter = 10^4, InitialStepSize = 0),
  ...
)

estimate_klin_1RM_quantile(
  weight,
  reps,
  eRIR = 0,
  tau = 0.5,
  reverse = FALSE,
  control = quantreg::nlrq.control(maxiter = 10^4, InitialStepSize = 0),
  ...
)
```

## Arguments

- perc_1RM:

  %1RM

- reps:

  Number of repetitions done

- eRIR:

  Subjective estimation of reps-in-reserve (eRIR)

- tau:

  Vector of quantiles to be estimated. Default is 0.5

- reverse:

  Logical, default is `FALSE`. Should reps be used as predictor instead
  as a target?

- control:

  Control object for the
  [`nlrq`](https://rdrr.io/pkg/quantreg/man/nlrq.html) function. Default
  is: `quantreg::nlrq.control(maxiter = 10^4, InitialStepSize = 0)`

- ...:

  Forwarded to [`nlrq`](https://rdrr.io/pkg/quantreg/man/nlrq.html)
  function

- weight:

  Weight used

- k:

  Value for the generic Epley's equation, which is by default equal to
  0.0333

## Value

[`nlrq`](https://rdrr.io/pkg/quantreg/man/nlrq.html) object

## Functions

- `estimate_k_quantile()`: Estimate the parameter `k` in the Epley's
  equation

- `estimate_k_generic_1RM_quantile()`: Provides the model with generic
  `k` parameter, as well as estimated `1RM`. This is a novel estimation
  function that uses the absolute weights

- `estimate_k_1RM_quantile()`: Estimate the parameter `k` in the Epley's
  equation, as well as `1RM`. This is a novel estimation function that
  uses the absolute weights

- `estimate_kmod_quantile()`: Estimate the parameter `kmod` in the
  modified Epley's equation

- `estimate_kmod_1RM_quantile()`: Estimate the parameter `kmod` in the
  modified Epley's equation, as well as `1RM`. This is a novel
  estimation function that uses the absolute weights

- `estimate_klin_quantile()`: Estimate the parameter `klin` in the
  Linear/Brzycki equation

- `estimate_klin_1RM_quantile()`: Estimate the parameter `klin` in the
  Linear/Brzycki equation, as well as `1RM`. This is a novel estimation
  function that uses the absolute weights

## Examples

``` r
# ---------------------------------------------------------
# Epley's model
m1 <- estimate_k_quantile(
  perc_1RM = c(0.7, 0.8, 0.9),
  reps = c(10, 5, 3)
)

coef(m1)
#>          k 
#> 0.04285747 
# ---------------------------------------------------------
# Epley's model that also estimates 1RM
m1 <- estimate_k_generic_1RM_quantile(
  weight = c(70, 110, 140),
  reps = c(10, 5, 3)
)

coef(m1)
#>     0RM 
#> 128.315 
# ---------------------------------------------------------
# Epley's model that also estimates 1RM
m1 <- estimate_k_1RM_quantile(
  weight = c(70, 110, 140),
  reps = c(10, 5, 3)
)

coef(m1)
#>           k         0RM 
#>   0.2499988 245.0003205 
# ---------------------------------------------------------
# Modified Epley's model
m1 <- estimate_kmod_quantile(
  perc_1RM = c(0.7, 0.8, 0.9),
  reps = c(10, 5, 3)
)

coef(m1)
#>       kmod 
#> 0.04762194 
# ---------------------------------------------------------
# Modified Epley's model that also estimates 1RM
m1 <- estimate_kmod_1RM_quantile(
  weight = c(70, 110, 140),
  reps = c(10, 5, 3)
)

coef(m1)
#>        kmod         1RM 
#>   0.1999983 196.0002286 
# ---------------------------------------------------------
# Linear/Brzycki model
m1 <- estimate_klin_quantile(
  perc_1RM = c(0.7, 0.8, 0.9),
  reps = c(10, 5, 3)
)

coef(m1)
#>     klin 
#> 25.51547 
# ---------------------------------------------------------
# Linear/Brzycki model thal also estimates 1RM
m1 <- estimate_klin_1RM_quantile(
  weight = c(70, 110, 140),
  reps = c(10, 5, 3)
)

coef(m1)
#> klin  1RM 
#>   16  160 
```
