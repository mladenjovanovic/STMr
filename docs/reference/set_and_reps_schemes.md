# Set and Rep Schemes

Set and Rep Schemes

## Usage

``` r
scheme_generic(
  reps,
  adjustment,
  vertical_planning,
  vertical_planning_control = list(),
  progression_table,
  progression_table_control = list()
)

scheme_wave(
  reps = c(10, 8, 6),
  adjustment = -rev((seq_along(reps) - 1) * 5)/100,
  vertical_planning = vertical_constant,
  vertical_planning_control = list(),
  progression_table = progression_perc_drop,
  progression_table_control = list(volume = "normal")
)

scheme_plateau(
  reps = c(5, 5, 5),
  vertical_planning = vertical_constant,
  vertical_planning_control = list(),
  progression_table = progression_perc_drop,
  progression_table_control = list(volume = "normal")
)

scheme_step(
  reps = c(5, 5, 5),
  adjustment = -rev((seq_along(reps) - 1) * 10)/100,
  vertical_planning = vertical_constant,
  vertical_planning_control = list(),
  progression_table = progression_perc_drop,
  progression_table_control = list(volume = "intensive")
)

scheme_step_reverse(
  reps = c(5, 5, 5),
  adjustment = -((seq_along(reps) - 1) * 10)/100,
  vertical_planning = vertical_constant,
  vertical_planning_control = list(),
  progression_table = progression_perc_drop,
  progression_table_control = list(volume = "intensive")
)

scheme_wave_descending(
  reps = c(6, 8, 10),
  adjustment = -rev((seq_along(reps) - 1) * 5)/100,
  vertical_planning = vertical_constant,
  vertical_planning_control = list(),
  progression_table = progression_perc_drop,
  progression_table_control = list(volume = "normal")
)

scheme_light_heavy(
  reps = c(10, 5, 10, 5),
  adjustment = c(-0.1, 0)[(seq_along(reps)%%2) + 1],
  vertical_planning = vertical_constant,
  vertical_planning_control = list(),
  progression_table = progression_perc_drop,
  progression_table_control = list(volume = "normal")
)

scheme_pyramid(
  reps = c(12, 10, 8, 10, 12),
  adjustment = 0,
  vertical_planning = vertical_constant,
  vertical_planning_control = list(),
  progression_table = progression_perc_drop,
  progression_table_control = list(volume = "extensive")
)

scheme_pyramid_reverse(
  reps = c(8, 10, 12, 10, 8),
  adjustment = 0,
  vertical_planning = vertical_constant,
  vertical_planning_control = list(),
  progression_table = progression_perc_drop,
  progression_table_control = list(volume = "extensive")
)

scheme_rep_acc(
  reps = c(10, 10, 10),
  adjustment = 0,
  vertical_planning_control = list(step = rep(0, 4)),
  progression_table = progression_perc_drop,
  progression_table_control = list(volume = "normal")
)

scheme_ladder(
  reps = c(3, 5, 10),
  adjustment = 0,
  vertical_planning = vertical_constant,
  vertical_planning_control = list(),
  progression_table = progression_perc_drop,
  progression_table_control = list(volume = "normal")
)

scheme_manual(
  index = NULL,
  step,
  sets = 1,
  reps,
  adjustment = 0,
  perc_1RM = NULL,
  progression_table = progression_perc_drop,
  progression_table_control = list(volume = "normal")
)

scheme_perc_1RM(reps = c(5, 5, 5), perc_1RM = c(0.4, 0.5, 0.6), n_steps = 4)
```

## Arguments

- reps:

  Numeric vector indicating reps prescription

- adjustment:

  Numeric vector indicating adjustments. Forwarded to
  `progression_table`.

- vertical_planning:

  Vertical planning function. Default is
  [`vertical_constant`](https://mladenjovanovic.github.io/STMr/reference/vertical_planning_functions.md)

- vertical_planning_control:

  Arguments forwarded to the
  [`vertical_planning`](https://mladenjovanovic.github.io/STMr/reference/vertical_planning_functions.md)
  function

- progression_table:

  Progression table function. Default is
  [`progression_perc_drop`](https://mladenjovanovic.github.io/STMr/reference/progression_table.md)

- progression_table_control:

  Arguments forwarded to the
  [`progression_table`](https://mladenjovanovic.github.io/STMr/reference/progression_table.md)
  function

- index:

  Numeric vector. If not provided, index will be create using sequence
  of `step`

- step:

  Numeric vector

- sets:

  Numeric vector. Used to replicate reps and adjustments

- perc_1RM:

  Numeric vector of user provided 1RM percentage

- n_steps:

  How many progression steps to generate? Default is 4

## Value

Data frame with the following columns: `reps`, `index`, `step`,
`adjustment`, and `perc_1RM`.

## Functions

- `scheme_generic()`: Generic set and rep scheme. `scheme_generic` is
  called in all other set and rep schemes - only the default parameters
  differ to make easier and quicker schemes writing and groupings

- `scheme_wave()`: Wave set and rep scheme

- `scheme_plateau()`: Plateau set and rep scheme

- `scheme_step()`: Step set and rep scheme

- `scheme_step_reverse()`: Reverse Step set and rep scheme

- `scheme_wave_descending()`: Descending Wave set and rep scheme

- `scheme_light_heavy()`: Light-Heavy set and rep scheme. Please note
  that the `adjustment` column in the output will be wrong, hence set to
  `NA`

- `scheme_pyramid()`: Pyramid set and rep scheme

- `scheme_pyramid_reverse()`: Reverse Pyramid set and rep scheme

- `scheme_rep_acc()`: Rep Accumulation set and rep scheme

- `scheme_ladder()`: Ladder set and rep scheme. Please note that the
  `adjustment` column in the output will be wrong, hence set to `NA`

- `scheme_manual()`: Manual set and rep scheme

- `scheme_perc_1RM()`: Manual %1RM set and rep scheme

## Examples

``` r
scheme_generic(
  reps = c(8, 6, 4, 8, 6, 4),
  # Adjusting using lower %1RM (RIR Increment method used)
  adjustment = c(4, 2, 0, 6, 4, 2),
  vertical_planning = vertical_linear,
  vertical_planning_control = list(reps_change = c(0, -2, -4)),
  progression_table = progression_RIR_increment,
  progression_table_control = list(volume = "extensive")
)
#>    index step set reps adjustment  perc_1RM
#> 1      1   -2   1    8  11.818182 0.6024294
#> 2      1   -2   2    6   8.727273 0.6709526
#> 3      1   -2   3    4   5.636364 0.7570648
#> 4      1   -2   4    8  13.818182 0.5791912
#> 5      1   -2   5    6  10.727273 0.6422533
#> 6      1   -2   6    4   7.636364 0.7207254
#> 7      2   -1   1    6   9.272727 0.6628742
#> 8      2   -1   2    4   6.363636 0.7434341
#> 9      2   -1   3    2   3.454545 0.8462840
#> 10     2   -1   4    6  11.272727 0.6348473
#> 11     2   -1   5    4   8.363636 0.7083612
#> 12     2   -1   6    2   5.454545 0.8011303
#> 13     3    0   1    4   7.090909 0.7302856
#> 14     3    0   2    2   4.363636 0.8251444
#> 15     3    0   3    0   1.636364 0.9483249
#> 16     3    0   4    4   9.090909 0.6964141
#> 17     3    0   5    2   6.363636 0.7821610
#> 18     3    0   6    0   3.636364 0.8919883

# Wave set and rep schemes
# --------------------------
scheme_wave()
#>    index step set reps  adjustment  perc_1RM
#> 1      1   -3   1   10 -0.28181818 0.4683694
#> 2      1   -3   2    8 -0.21363636 0.5760036
#> 3      1   -3   3    6 -0.14545455 0.6880177
#> 4      2   -2   1   10 -0.23636364 0.5138239
#> 5      2   -2   2    8 -0.17272727 0.6169127
#> 6      2   -2   3    6 -0.10909091 0.7243813
#> 7      3   -1   1   10 -0.19090909 0.5592785
#> 8      3   -1   2    8 -0.13181818 0.6578217
#> 9      3   -1   3    6 -0.07272727 0.7607450
#> 10     4    0   1   10 -0.14545455 0.6047330
#> 11     4    0   2    8 -0.09090909 0.6987308
#> 12     4    0   3    6 -0.03636364 0.7971086

scheme_wave(
  reps = c(8, 6, 4, 8, 6, 4),
  # Second wave with higher intensity
  adjustment = c(-0.25, -0.15, 0.05, -0.2, -0.1, 0),
  vertical_planning = vertical_block,
  progression_table = progression_perc_drop,
  progression_table_control = list(type = "ballistic")
)
#>    index step set reps adjustment  perc_1RM
#> 1      1   -2   1    8    -0.4125 0.2399008
#> 2      1   -2   2    6    -0.2875 0.4269899
#> 3      1   -2   3    4    -0.0625 0.7271399
#> 4      1   -2   4    8    -0.3625 0.2899008
#> 5      1   -2   5    6    -0.2375 0.4769899
#> 6      1   -2   6    4    -0.1125 0.6771399
#> 7      2   -1   1    8    -0.3525 0.2999008
#> 8      2   -1   2    6    -0.2375 0.4769899
#> 9      2   -1   3    4    -0.0225 0.7671399
#> 10     2   -1   4    8    -0.3025 0.3499008
#> 11     2   -1   5    6    -0.1875 0.5269899
#> 12     2   -1   6    4    -0.0725 0.7171399
#> 13     3    0   1    8    -0.2925 0.3599008
#> 14     3    0   2    6    -0.1875 0.5269899
#> 15     3    0   3    4     0.0175 0.8071399
#> 16     3    0   4    8    -0.2425 0.4099008
#> 17     3    0   5    6    -0.1375 0.5769899
#> 18     3    0   6    4    -0.0325 0.7571399
#> 19     4   -3   1    8    -0.4725 0.1799008
#> 20     4   -3   2    6    -0.3375 0.3769899
#> 21     4   -3   3    4    -0.1025 0.6871399
#> 22     4   -3   4    8    -0.4225 0.2299008
#> 23     4   -3   5    6    -0.2875 0.4269899
#> 24     4   -3   6    4    -0.1525 0.6371399

# Adjusted second wave
# and using 3 steps progression
scheme_wave(
  reps = c(8, 6, 4, 8, 6, 4),
  # Adjusting using lower %1RM (progression_perc_drop method used)
  adjustment = c(0, 0, 0, -0.1, -0.1, -0.1),
  vertical_planning = vertical_linear,
  vertical_planning_control = list(reps_change = c(0, -2, -4)),
  progression_table = progression_perc_drop,
  progression_table_control = list(volume = "extensive")
)
#>    index step set reps  adjustment  perc_1RM
#> 1      1   -2   1    8 -0.16363636 0.6260036
#> 2      1   -2   2    6 -0.14545455 0.6880177
#> 3      1   -2   3    4 -0.12727273 0.7551840
#> 4      1   -2   4    8 -0.26363636 0.5260036
#> 5      1   -2   5    6 -0.24545455 0.5880177
#> 6      1   -2   6    4 -0.22727273 0.6551840
#> 7      2   -1   1    6 -0.10909091 0.7243813
#> 8      2   -1   2    4 -0.09545455 0.7870022
#> 9      2   -1   3    2 -0.08181818 0.8557404
#> 10     2   -1   4    6 -0.20909091 0.6243813
#> 11     2   -1   5    4 -0.19545455 0.6870022
#> 12     2   -1   6    2 -0.18181818 0.7557404
#> 13     3    0   1    4 -0.06363636 0.8188204
#> 14     3    0   2    2 -0.05454545 0.8830131
#> 15     3    0   3    0 -0.04545455 0.9545455
#> 16     3    0   4    4 -0.16363636 0.7188204
#> 17     3    0   5    2 -0.15454545 0.7830131
#> 18     3    0   6    0 -0.14545455 0.8545455

# Adjusted using RIR inc
# This time we adjust first wave as well, first two sets easier
scheme <- scheme_wave(
  reps = c(8, 6, 4, 8, 6, 4),
  # Adjusting using lower %1RM (RIR Increment method used)
  adjustment = c(4, 2, 0, 6, 4, 2),
  vertical_planning = vertical_linear,
  vertical_planning_control = list(reps_change = c(0, -2, -4)),
  progression_table = progression_RIR_increment,
  progression_table_control = list(volume = "extensive")
)
plot(scheme)


# Plateau set and rep schemes
# --------------------------
scheme_plateau()
#>    index step set reps  adjustment  perc_1RM
#> 1      1   -3   1    5 -0.13636364 0.7209017
#> 2      1   -3   2    5 -0.13636364 0.7209017
#> 3      1   -3   3    5 -0.13636364 0.7209017
#> 4      2   -2   1    5 -0.10227273 0.7549926
#> 5      2   -2   2    5 -0.10227273 0.7549926
#> 6      2   -2   3    5 -0.10227273 0.7549926
#> 7      3   -1   1    5 -0.06818182 0.7890835
#> 8      3   -1   2    5 -0.06818182 0.7890835
#> 9      3   -1   3    5 -0.06818182 0.7890835
#> 10     4    0   1    5 -0.03409091 0.8231744
#> 11     4    0   2    5 -0.03409091 0.8231744
#> 12     4    0   3    5 -0.03409091 0.8231744

scheme <- scheme_plateau(
  reps = c(3, 3, 3),
  progression_table_control = list(type = "ballistic")
)
plot(scheme)


# Step set and rep schemes
# --------------------------
scheme_step()
#>    index step set reps  adjustment  perc_1RM
#> 1      1   -3   1    5 -0.30227273 0.5549926
#> 2      1   -3   2    5 -0.20227273 0.6549926
#> 3      1   -3   3    5 -0.10227273 0.7549926
#> 4      2   -2   1    5 -0.26818182 0.5890835
#> 5      2   -2   2    5 -0.16818182 0.6890835
#> 6      2   -2   3    5 -0.06818182 0.7890835
#> 7      3   -1   1    5 -0.23409091 0.6231744
#> 8      3   -1   2    5 -0.13409091 0.7231744
#> 9      3   -1   3    5 -0.03409091 0.8231744
#> 10     4    0   1    5 -0.20000000 0.6572653
#> 11     4    0   2    5 -0.10000000 0.7572653
#> 12     4    0   3    5  0.00000000 0.8572653

scheme <- scheme_step(
  reps = c(2, 2, 2),
  adjustment = c(-0.1, -0.05, 0),
  vertical_planning = vertical_linear_reverse,
  progression_table_control = list(type = "ballistic")
)
plot(scheme)


# Reverse Step set and rep schemes
#- -------------------------
scheme <- scheme_step_reverse()
plot(scheme)


# Descending Wave set and rep schemes
# --------------------------
scheme <- scheme_wave_descending()
plot(scheme)


# Light-Heavy set and rep schemes
# --------------------------
scheme <- scheme_light_heavy()
plot(scheme)


# Pyramid set and rep schemes
# --------------------------
scheme <- scheme_pyramid()
plot(scheme)


# Reverse Pyramid set and rep schemes
# --------------------------
scheme <- scheme_pyramid_reverse()
plot(scheme)


# Rep Accumulation set and rep schemes
# --------------------------
scheme_rep_acc()
#>    index step set reps  adjustment perc_1RM
#> 1      1    0   1    7 -0.04545455 0.704733
#> 2      1    0   2    7 -0.04545455 0.704733
#> 3      1    0   3    7 -0.04545455 0.704733
#> 4      2    0   1    8 -0.04545455 0.704733
#> 5      2    0   2    8 -0.04545455 0.704733
#> 6      2    0   3    8 -0.04545455 0.704733
#> 7      3    0   1    9 -0.04545455 0.704733
#> 8      3    0   2    9 -0.04545455 0.704733
#> 9      3    0   3    9 -0.04545455 0.704733
#> 10     4    0   1   10 -0.04545455 0.704733
#> 11     4    0   2   10 -0.04545455 0.704733
#> 12     4    0   3   10 -0.04545455 0.704733

# Generate Wave scheme with rep accumulation vertical progression
# This functions doesn't allow you to use different vertical planning
# options
scheme <- scheme_rep_acc(reps = c(10, 8, 6), adjustment = c(-0.1, -0.05, 0))
plot(scheme)


# Other options is to use `.vertical_rep_accumulation.post()` and
# apply it after
# The default vertical progression is `vertical_const()`
scheme <- scheme_wave(reps = c(10, 8, 6), adjustment = c(-0.1, -0.05, 0))

.vertical_rep_accumulation.post(scheme)
#>    index step set reps adjustment  perc_1RM
#> 1      1    0   1    7         NA 0.6047330
#> 2      1    0   2    5         NA 0.6987308
#> 3      1    0   3    3         NA 0.7971086
#> 4      2    0   1    8         NA 0.6047330
#> 5      2    0   2    6         NA 0.6987308
#> 6      2    0   3    4         NA 0.7971086
#> 7      3    0   1    9         NA 0.6047330
#> 8      3    0   2    7         NA 0.6987308
#> 9      3    0   3    5         NA 0.7971086
#> 10     4    0   1   10         NA 0.6047330
#> 11     4    0   2    8         NA 0.6987308
#> 12     4    0   3    6         NA 0.7971086

# We can also create "undulating" rep decrements
.vertical_rep_accumulation.post(
  scheme,
  rep_decrement = c(-3, -1, -2, 0)
)
#>    index step set reps adjustment  perc_1RM
#> 1      1    0   1    7         NA 0.6047330
#> 2      1    0   2    5         NA 0.6987308
#> 3      1    0   3    3         NA 0.7971086
#> 4      2    0   1    9         NA 0.6047330
#> 5      2    0   2    7         NA 0.6987308
#> 6      2    0   3    5         NA 0.7971086
#> 7      3    0   1    8         NA 0.6047330
#> 8      3    0   2    6         NA 0.6987308
#> 9      3    0   3    4         NA 0.7971086
#> 10     4    0   1   10         NA 0.6047330
#> 11     4    0   2    8         NA 0.6987308
#> 12     4    0   3    6         NA 0.7971086

# `scheme_rep_acc` will not allow you to generate `scheme_ladder()`
# and `scheme_scheme_light_heavy()`
# You must use `.vertical_rep_accumulation.post()` to do so
scheme <- scheme_ladder()
scheme <- .vertical_rep_accumulation.post(scheme)
plot(scheme)


# Please note that reps < 1 are removed. If you do not want this,
# use `remove_reps = FALSE` parameter
scheme <- scheme_ladder()
scheme <- .vertical_rep_accumulation.post(scheme, remove_reps = FALSE)
plot(scheme)


# Ladder set and rep schemes
# --------------------------
scheme <- scheme_ladder()
plot(scheme)


# Manual set and rep schemes
# --------------------------
scheme_df <- data.frame(
  index = 1, # Use this just as an example
  step = c(-3, -2, -1, 0),
  # Sets are just an easy way to repeat reps and adjustment
  sets = c(5, 4, 3, 2),
  reps = c(5, 4, 3, 2),
  adjustment = 0
)

# Step index is estimated to be sequences of steps
# If you want specific indexes, use it as an argument (see next example)
scheme <- scheme_manual(
  step = scheme_df$step,
  sets = scheme_df$sets,
  reps = scheme_df$reps,
  adjustment = scheme_df$adjustment
)

plot(scheme)


# Here we are going to provide our own index
scheme <- scheme_manual(
  index = scheme_df$index,
  step = scheme_df$step,
  sets = scheme_df$sets,
  reps = scheme_df$reps,
  adjustment = scheme_df$adjustment
)

plot(scheme)


# More complicated example
scheme_df <- data.frame(
  step = c(-3, -3, -3, -3, -2, -2, -2, -1, -1, 0),
  sets = 1,
  reps = c(5, 5, 5, 5, 3, 2, 1, 2, 1, 1),
  adjustment = c(0, -0.05, -0.1, -0.15, -0.1, -0.05, 0, -0.1, 0, 0)
)

scheme_df
#>    step sets reps adjustment
#> 1    -3    1    5       0.00
#> 2    -3    1    5      -0.05
#> 3    -3    1    5      -0.10
#> 4    -3    1    5      -0.15
#> 5    -2    1    3      -0.10
#> 6    -2    1    2      -0.05
#> 7    -2    1    1       0.00
#> 8    -1    1    2      -0.10
#> 9    -1    1    1       0.00
#> 10    0    1    1       0.00

scheme <- scheme_manual(
  step = scheme_df$step,
  sets = scheme_df$sets,
  reps = scheme_df$reps,
  adjustment = scheme_df$adjustment,

  # Select another progression table
  progression_table = progression_DI,
  # Extra parameters for the progression table
  progression_table_control = list(
    volume = "extensive",
    type = "ballistic",
    max_perc_1RM_func = max_perc_1RM_linear,
    klin = 36
  )
)

plot(scheme)


# Provide %1RM manually

scheme_df <- data.frame(
  index = rep(c(1, 2, 3, 4), each = 3),
  reps = rep(c(5, 5, 5), 4),
  perc_1RM = rep(c(0.4, 0.5, 0.6), 4)
)

warmup_scheme <- scheme_manual(
  index = scheme_df$index,
  reps = scheme_df$reps,
  perc_1RM = scheme_df$perc_1RM
)

plot(warmup_scheme)

# Manual %1RM set and rep schemes
# --------------------------
warmup_scheme <- scheme_perc_1RM(
  reps = c(10, 8, 6),
  perc_1RM = c(0.4, 0.5, 0.6),
  n_steps = 3
)

plot(warmup_scheme)
```
