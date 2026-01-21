library(tidyverse)
library(STMr)

DI_progression <- function(reps,
                           step = 0,
                           mfactor = 1,
                           volume = "intensive",
                           step_increment = 0.025,
                           volume_increment = 0.025) {

  adjustment <- step * step_increment

  if (volume == "intensive") {
    adjustment <- adjustment - 0
  } else if (volume == "normal") {
    adjustment <- adjustment - (1 * volume_increment)
  } else if (volume == "extensive") {
    adjustment <- adjustment - (2 * volume_increment)
  } else {
    stop("Unknown volume")
  }

  adj_perc_1RM_DI(reps, adjustment, mfactor, max_perc_1RM_func = max_perc_1RM_modified_epley)
}

DI_progression(5) * 100
DI_progression(5, step = 0, volume = "extensive") * 100

# Find Optimal
reps <- 2:10
perc1RM <- max_perc_1RM_epley(reps)

err_func <- function(kmod = 0.0353) {
  sum((1/reps^2) * (perc1RM - max_perc_1RM_modified_epley(reps, kmod))^2)
}

res <- optim(par = 0.0353, fn = err_func, method = "Brent", lower = 0, upper = 1)

df <- data.frame(reps = 2:12) %>%
  mutate(
    orig = 100 * max_perc_1RM_epley(reps),
    mod = 100 * max_perc_1RM_modified_epley(reps, res$par),
    diff = mod - orig)

round(df, 2)
res$par

# Find 80% reps param value
err_func <- function(kmod = 0.0353, TR = 8) {
  (TR - max_reps_modified_epley(0.8, kmod))^2
}

res <- optim(par = 0.0353, fn = err_func, method = "Brent", lower = 0, upper = 1, TR = 6)
res$par

# Find function
find_optim_kmod <- function(TR = 8) {
  res <- optim(par = 0.0353, fn = err_func, method = "Brent", lower = 0, upper = 1, TR = TR)
  res$par
}

rel_df <- data.frame(reps_80 = seq(2, 15, by = 1)) %>%
  rowwise() %>%
  mutate(kmod = find_optim_kmod(reps_80)) %>%
  ungroup() %>%
  mutate(pred = 0.25 / (reps_80 - 1))

rel_df %>%
  ggplot(aes(x = reps_80, y = kmod)) +
  geom_point() +
  geom_line(aes(y = pred), col = "red")

# potimal kmod based on reps at 80%
optimal_kmod <- function(reps_at_80 = 6) {
  0.25 / (reps_at_80 - 1)
}

optimal_kmod(10)
