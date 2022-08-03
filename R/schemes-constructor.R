new_STMr_scheme <- function(index, step, set, reps, adjustment, perc_1RM) {
  scheme <- data.frame(
    index = index,
    step = step,
    set = set,
    reps = reps,
    adjustment = adjustment,
    perc_1RM = perc_1RM
  )

  class(scheme) <- c("STMr_scheme", class(scheme))

  scheme
}
