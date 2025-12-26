# Estimate relationship between reps and weight using the non-linear mixed-effects regression

These functions provide estimated 1RM and parameter values using the
mixed-effect regression. By default, target variable is the reps
performed, while the predictor is the `perc_1RM` or `weight`. To reverse
this, use the `reverse = TRUE` argument

## Usage

``` r
estimate_k_mixed(athlete, perc_1RM, reps, eRIR = 0, reverse = FALSE, ...)

estimate_k_generic_1RM_mixed(
  athlete,
  weight,
  reps,
  eRIR = 0,
  k = 0.0333,
  reverse = FALSE,
  random = zeroRM ~ 1,
  ...
)

estimate_k_1RM_mixed(
  athlete,
  weight,
  reps,
  eRIR = 0,
  reverse = FALSE,
  random = k + zeroRM ~ 1,
  ...
)

estimate_kmod_mixed(athlete, perc_1RM, reps, eRIR = 0, reverse = FALSE, ...)

estimate_kmod_1RM_mixed(
  athlete,
  weight,
  reps,
  eRIR = 0,
  reverse = FALSE,
  random = kmod + oneRM ~ 1,
  ...
)

estimate_klin_mixed(athlete, perc_1RM, reps, eRIR = 0, reverse = FALSE, ...)

estimate_klin_1RM_mixed(
  athlete,
  weight,
  reps,
  eRIR = 0,
  reverse = FALSE,
  random = klin + oneRM ~ 1,
  ...
)
```

## Arguments

- athlete:

  Athlete identifier

- perc_1RM:

  %1RM

- reps:

  Number of repetitions done

- eRIR:

  Subjective estimation of reps-in-reserve (eRIR)

- reverse:

  Logical, default is `FALSE`. Should reps be used as predictor instead
  as a target?

- ...:

  Forwarded to [`nlme`](https://rdrr.io/pkg/nlme/man/nlme.html) function

- weight:

  Weight used

- k:

  Value for the generic Epley's equation, which is by default equal to
  0.0333

- random:

  Random parameter forwarded to
  [`nlme`](https://rdrr.io/pkg/nlme/man/nlme.html) function. Default is
  `k + zeroRM ~ 1` for, `estimate_k_mixed` function, or `k + oneRM ~ 1`
  for `estimate_kmod_mixed` and `estimate_klin_mixed` functions

## Value

[`nlme`](https://rdrr.io/pkg/nlme/man/nlme.html) object

## Functions

- `estimate_k_mixed()`: Estimate the parameter `k` in the Epley's
  equation

- `estimate_k_generic_1RM_mixed()`: Provides the model with generic `k`
  parameter, as well as estimated `1RM`. This is a novel estimation
  function that uses the absolute weights

- `estimate_k_1RM_mixed()`: Estimate the parameter `k` in the Epley's
  equation, as well as `1RM`. This is a novel estimation function that
  uses the absolute weights

- `estimate_kmod_mixed()`: Estimate the parameter `kmod` in the Modified
  Epley's equation

- `estimate_kmod_1RM_mixed()`: Estimate the parameter `kmod` in the
  Modified Epley's equation, as well as `1RM`. This is a novel
  estimation function that uses the absolute weights

- `estimate_klin_mixed()`: Estimate the parameter `klin` in the
  Linear/Brzycki's equation

- `estimate_klin_1RM_mixed()`: Estimate the parameter `klin` in the
  Linear/Brzycki equation, as well as `1RM`. This is a novel estimation
  function that uses the absolute weights

## Examples

``` r
# ---------------------------------------------------------
# Epley's model
m1 <- estimate_k_mixed(
  athlete = RTF_testing$Athlete,
  perc_1RM = RTF_testing$`Real %1RM`,
  reps = RTF_testing$nRM
)

coef(m1)
#>                    k
#> Athlete A 0.01937865
#> Athlete B 0.03403605
#> Athlete C 0.06747237
#> Athlete D 0.02754989
#> Athlete E 0.04001677
#> Athlete F 0.02442086
#> Athlete G 0.03584091
#> Athlete H 0.02952992
#> Athlete I 0.02172886
#> Athlete J 0.04741195
#> Athlete K 0.05844494
#> Athlete L 0.03987504
# ---------------------------------------------------------
# Generic Epley's model that also estimates 1RM
m1 <- estimate_k_generic_1RM_mixed(
  athlete = RTF_testing$Athlete,
  weight = RTF_testing$`Real Weight`,
  reps = RTF_testing$nRM
)

coef(m1)
#>              zeroRM
#> Athlete A 115.60573
#> Athlete B  94.61033
#> Athlete C 106.24996
#> Athlete D 110.00999
#> Athlete E 106.53626
#> Athlete F  97.34956
#> Athlete G 100.87702
#> Athlete H 133.10815
#> Athlete I 119.93968
#> Athlete J  86.68878
#> Athlete K  93.39298
#> Athlete L 133.96571
# ---------------------------------------------------------
# Epley's model that also estimates 1RM
m1 <- estimate_k_1RM_mixed(
  athlete = RTF_testing$Athlete,
  weight = RTF_testing$`Real Weight`,
  reps = RTF_testing$nRM
)
#> Warning: Iteration 1, LME step: nlminb() did not converge (code = 1). PORT message: false convergence (8)

coef(m1)
#>                    k    zeroRM
#> Athlete A 0.02009569 100.90930
#> Athlete B 0.03190397  93.57043
#> Athlete C 0.05145745 112.78532
#> Athlete D 0.02931850 106.70531
#> Athlete E 0.04598428 114.11861
#> Athlete F 0.02445763  90.03294
#> Athlete G 0.03320944 100.69127
#> Athlete H 0.03081954 131.42120
#> Athlete I 0.02224392 108.13537
#> Athlete J 0.04190871  89.90767
#> Athlete K 0.05472408 101.01400
#> Athlete L 0.03821821 138.52855
# ---------------------------------------------------------
# Modifed Epley's model
m1 <- estimate_kmod_mixed(
  athlete = RTF_testing$Athlete,
  perc_1RM = RTF_testing$`Real %1RM`,
  reps = RTF_testing$nRM
)

coef(m1)
#>                 kmod
#> Athlete A 0.02061064
#> Athlete B 0.03816219
#> Athlete C 0.07955734
#> Athlete D 0.03001988
#> Athlete E 0.04559265
#> Athlete F 0.02638650
#> Athlete G 0.04044088
#> Athlete H 0.03240645
#> Athlete I 0.02325264
#> Athlete J 0.05521785
#> Athlete K 0.06915300
#> Athlete L 0.04531026
# ---------------------------------------------------------
# Modified Epley's model that also estimates 1RM
m1 <- estimate_kmod_1RM_mixed(
  athlete = RTF_testing$Athlete,
  weight = RTF_testing$`Real Weight`,
  reps = RTF_testing$nRM
)
#> Warning: Iteration 1, LME step: nlminb() did not converge (code = 1). PORT message: false convergence (8)

coef(m1)
#>                 kmod     oneRM
#> Athlete A 0.03015293 109.90580
#> Athlete B 0.03302723  91.99507
#> Athlete C 0.03135530 102.41449
#> Athlete D 0.03086471 105.47097
#> Athlete E 0.03133870 102.51784
#> Athlete F 0.03261364  94.57201
#> Athlete G 0.03213294  97.56801
#> Athlete H 0.02771254 125.11431
#> Athlete I 0.02956091 113.59525
#> Athlete J 0.03421875  84.57014
#> Athlete K 0.03325588  90.57076
#> Athlete L 0.02747218 126.61258
# ---------------------------------------------------------
# Linear/Brzycki model
m1 <- estimate_klin_mixed(
  athlete = RTF_testing$Athlete,
  perc_1RM = RTF_testing$`Real %1RM`,
  reps = RTF_testing$nRM
)

coef(m1)
#>               klin
#> Athlete A 64.11011
#> Athlete B 35.11002
#> Athlete C 16.22552
#> Athlete D 45.24156
#> Athlete E 30.05447
#> Athlete F 50.70299
#> Athlete G 33.20719
#> Athlete H 41.90200
#> Athlete I 57.35190
#> Athlete J 24.65495
#> Athlete K 19.43184
#> Athlete L 30.18074
# ---------------------------------------------------------
# Linear/Brzycki model that also estimates 1RM
m1 <- estimate_klin_1RM_mixed(
  athlete = RTF_testing$Athlete,
  weight = RTF_testing$`Real Weight`,
  reps = RTF_testing$nRM
)
#> Warning: Iteration 1, LME step: nlminb() did not converge (code = 1). PORT message: false convergence (8)

coef(m1)
#>               klin     oneRM
#> Athlete A 75.15769  96.19463
#> Athlete B 45.44975  88.91455
#> Athlete C 25.33309 107.11406
#> Athlete D 53.32681 100.49170
#> Athlete E 33.89090 106.06520
#> Athlete F 62.45929  85.33938
#> Athlete G 43.19576  95.83903
#> Athlete H 50.16078 123.79762
#> Athlete I 67.24280 103.20196
#> Athlete J 34.37575  84.98052
#> Athlete K 24.84090  95.45042
#> Athlete L 39.44232 130.14431
```
