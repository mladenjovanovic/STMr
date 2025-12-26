# Estimate relationship between reps and %1RM (or weight)

By default, target variable is the reps performed, while the predictors
is the `perc_1RM` or `weight`. To reverse this, use the `reverse = TRUE`
argument

## Usage

``` r
estimate_k_generic(
  perc_1RM,
  reps,
  eRIR = 0,
  k = 0.0333,
  reverse = FALSE,
  weighted = "none",
  ...
)

estimate_k_generic_1RM(
  weight,
  reps,
  eRIR = 0,
  k = 0.0333,
  reverse = FALSE,
  weighted = "none",
  ...
)

estimate_k(perc_1RM, reps, eRIR = 0, reverse = FALSE, weighted = "none", ...)

estimate_k_1RM(weight, reps, eRIR = 0, reverse = FALSE, weighted = "none", ...)

estimate_kmod(
  perc_1RM,
  reps,
  eRIR = 0,
  reverse = FALSE,
  weighted = "none",
  ...
)

estimate_kmod_1RM(
  weight,
  reps,
  eRIR = 0,
  reverse = FALSE,
  weighted = "none",
  ...
)

estimate_klin(
  perc_1RM,
  reps,
  eRIR = 0,
  reverse = FALSE,
  weighted = "none",
  ...
)

estimate_klin_1RM(
  weight,
  reps,
  eRIR = 0,
  reverse = FALSE,
  weighted = "none",
  ...
)

get_predicted_1RM_from_k_model(model)
```

## Arguments

- perc_1RM:

  %1RM

- reps:

  Number of repetitions done

- eRIR:

  Subjective estimation of reps-in-reserve (eRIR)

- k:

  Value for the generic Epley's equation, which is by default equal to
  0.0333

- reverse:

  Logical, default is `FALSE`. Should reps be used as predictor instead
  as a target?

- weighted:

  What weighting should be used for the non-linear regression? Default
  is "none". Other options include: "reps" (for 1/reps weighting),
  "load" (for using weight or %1RM), "eRIR" (for 1/(eRIR+1) weighting),
  "reps x load", "reps x eRIR", "load x eRIR", and "reps x load x eRIR"

- ...:

  Forwarded to [`nlsLM`](https://rdrr.io/pkg/minpack.lm/man/nlsLM.html)
  function

- weight:

  Weight used

- model:

  Object returned from the `estimate_k_1RM` function

## Value

[`nlsLM`](https://rdrr.io/pkg/minpack.lm/man/nlsLM.html) object

## Functions

- `estimate_k_generic()`: Provides the model with generic `k` parameter

- `estimate_k_generic_1RM()`: Provides the model with generic `k`
  parameter, as well as estimated `1RM`. This is a novel estimation
  function that uses the absolute weights.

- `estimate_k()`: Estimate the parameter `k` in the Epley's equation

- `estimate_k_1RM()`: Estimate the parameter `k` in the Epley's
  equation, as well as `1RM`. This is a novel estimation function that
  uses the absolute weights.

- `estimate_kmod()`: Estimate the parameter `kmod` in the modified
  Epley's equation

- `estimate_kmod_1RM()`: Estimate the parameter `kmod` in the modified
  Epley's equation, as well as `1RM`. This is a novel estimation
  function that uses the absolute weights

- `estimate_klin()`: Estimate the parameter `klin` using the
  Linear/Brzycki model

- `estimate_klin_1RM()`: Estimate the parameter `klin` in the
  Linear/Brzycki equation, as well as `1RM`. This is a novel estimation
  function that uses the absolute weights

- `get_predicted_1RM_from_k_model()`: Estimate the 1RM from
  `estimate_k_1RM` function

  The problem with Epley's estimation model (implemented in
  `estimate_k_1RM` function) is that it predicts the 1RM when nRM = 0.
  Thus, the estimated parameter in the model produced by the
  `estimate_k_1RM` function is not 1RM, but 0RM. This function
  calculates the weight at nRM = 1 for both the normal and reverse
  model. See Examples for code

## Examples

``` r
# ---------------------------------------------------------
# Generic Epley's model
m1 <- estimate_k_generic(
  perc_1RM = c(0.7, 0.8, 0.9),
  reps = c(10, 5, 3)
)

coef(m1)
#>      k 
#> 0.0333 
# ---------------------------------------------------------
# Generic Epley's model that also estimates 1RM
m1 <- estimate_k_generic_1RM(
  weight = c(70, 110, 140),
  reps = c(10, 5, 3)
)

coef(m1)
#>        k      0RM 
#>   0.0333 111.0413 
# ---------------------------------------------------------
# Epley's model
m1 <- estimate_k(
  perc_1RM = c(0.7, 0.8, 0.9),
  reps = c(10, 5, 3)
)

coef(m1)
#>          k 
#> 0.04404789 
# ---------------------------------------------------------
# Epley's model that also estimates 1RM
m1 <- estimate_k_1RM(
  weight = c(70, 110, 140),
  reps = c(10, 5, 3)
)

coef(m1)
#>           k         0RM 
#>   0.2542595 248.2568809 
# ---------------------------------------------------------
# Modified Epley's model
m1 <- estimate_kmod(
  perc_1RM = c(0.7, 0.8, 0.9),
  reps = c(10, 5, 3)
)

coef(m1)
#>       kmod 
#> 0.05089596 
# ---------------------------------------------------------
# Modified Epley's model that also estimates 1RM
m1 <- estimate_kmod_1RM(
  weight = c(70, 110, 140),
  reps = c(10, 5, 3)
)

coef(m1)
#>        kmod         1RM 
#>   0.2027168 197.9310344 
# ---------------------------------------------------------
# Linear/Brzycki model
m1 <- estimate_klin(
  perc_1RM = c(0.7, 0.8, 0.9),
  reps = c(10, 5, 3)
)

coef(m1)
#>     klin 
#> 26.42857 
# ---------------------------------------------------------
# Linear/Brzycki model thal also estimates 1RM
m1 <- estimate_klin_1RM(
  weight = c(70, 110, 140),
  reps = c(10, 5, 3)
)

coef(m1)
#>      klin       1RM 
#>  15.81081 156.00000 
# ---------------------------------------------------------
# Estimating 1RM from Epley's model
m1 <- estimate_k_1RM(150 * c(0.9, 0.8, 0.7), c(3, 6, 12))
m2 <- estimate_k_1RM(150 * c(0.9, 0.8, 0.7), c(3, 6, 12), reverse = TRUE)

# Estimated 0RM values from both model
c(coef(m1)[[1]], coef(m2)[[1]])
#> [1] 0.03433858 0.03518712

# But these are not 1RMs!!!
# Using the "reverse" model, where nRM is the predictor (in this case m2)
# makes it easier to predict 1RM
predict(m2, newdata = data.frame(nRM = 1))
#> [1] 142.9047

# But for the normal model it involve reversing the formula
# To spare you from the math pain, use this
get_predicted_1RM_from_k_model(m1)
#> [1] 142.3961

# It also works for the "reverse" model
get_predicted_1RM_from_k_model(m2)
#> [1] 142.9047
```
