## code to prepare `nRM_testing` dataset goes here
require(tidyverse)

# Rounding function
round_plates <- function(x, plate = 2.5, func = round) func(x / plate) * plate

nRM_testing <- tribble(
  ~Athlete, ~k, ~`1RM`,
  "Athlete A", 0.02, 100,
  "Athlete B", 0.0333, 95,
  "Athlete C", 0.0666, 120,
  "Athlete D", 0.027, 105,
  "Athlete E", 0.041, 110,
  "Athlete F", 0.025, 90,
  "Athlete G", 0.035, 102.5,
  "Athlete H", 0.029, 130,
  "Athlete I", 0.022, 107.5,
  "Athlete J", 0.047, 92.5,
  "Athlete K", 0.055, 102.5,
  "Athlete L", 0.039, 140
) %>%
  expand_grid(
    `Goal %1RM` = c(0.9, 0.8, 0.7)
  ) %>%
  mutate(
    Weight = round_plates(`Goal %1RM` * `1RM`, 2.5),
    `Observed %1RM` = Weight / `1RM`,
    nRM = round(get_max_reps_k(`Observed %1RM`, k = k) + runif(n(), -0.5, 0.5), 0)
  ) %>%
  select(-k)

usethis::use_data(nRM_testing, overwrite = TRUE)
