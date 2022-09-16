## code to prepare `strength_training_log` dataset goes here
require(STMr)
require(tidyverse)

mround <- function(x, m = 2.5) {
  round(x / m) * m
}

session_A <- scheme_wave(
  reps = c(12, 10, 8, 12, 10, 8),
  # Adjusting using lower %1RM (RIR Increment method used)
  adjustment = c(4, 2, 0, 6, 4, 2),
  vertical_planning = vertical_linear,
  vertical_planning_control = list(reps_change = c(0, -2, -4)),
  progression_table = progression_RIR_increment,
  progression_table_control = list(volume = "extensive")
) %>% mutate(
  session = "Session A"
)

session_B <- scheme_wave(
  reps = c(3, 2, 1, 3, 2, 1),
  # Adjusting using lower %1RM (RIR Increment method used)
  adjustment = c(6, 4, 2, 4, 2, 0),
  vertical_planning = vertical_constant,
  vertical_planning_control = list(n_steps = 3),
  progression_table = progression_RIR_increment,
  progression_table_control = list(volume = "normal")
) %>% mutate(
  session = "Session B"
)

phase_df <- tibble(
  phase = 1:4,
  `1RM` = c(105, 110, 112.5, 115)
)

phase_session_A <- expand_grid(phase_df, session_A)
phase_session_B <- expand_grid(phase_df, session_B)

strength_training_log <- rbind(phase_session_A, phase_session_B)

strength_training_log <- strength_training_log %>%
  mutate(
    weight = mround(`1RM` * perc_1RM)
  )

# Effect on eRIR
eRIR_df <- strength_training_log %>%
  group_by(phase, session, index) %>%
  summarise(n = n()) %>%
  ungroup() %>%
  select(-n) %>%
  mutate(
    systematic_effect = 0.5 * (index - 1),
    random_effect = runif(n(), min = -1, max = 1),
    total_effect = systematic_effect + random_effect
  ) %>%
  select(-systematic_effect, -random_effect)

strength_training_log <- strength_training_log %>%
  left_join(
    eRIR_df,
    by = c("phase", "session", "index")
  )

strength_training_log <- strength_training_log %>%
  mutate(
    eRIR = adjustment + total_effect,
    eRIR = eRIR / 2,
    eRIR = floor(eRIR),
    eRIR = ifelse(eRIR >= 6, NA, eRIR)
  ) %>%
  rename(week = index) %>%
  group_by(phase, session, week) %>%
  mutate(
    set = seq(1, n())) %>%
  ungroup() %>%

  # Calculate day
  mutate(
    day = ((phase - 1) * 6) + ((week - 1) * 2) + ifelse(session == "Session A", 1, 2)
  ) %>%
  select(phase, week, day, session, set, weight, reps, eRIR) %>%
  arrange(phase, week, day, session, set)

usethis::use_data(strength_training_log, overwrite = TRUE)
