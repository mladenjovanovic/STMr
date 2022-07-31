new_STMr_scheme <- function(reps, index, step, adjustment, perc_1RM) {
  scheme <- data.frame(
    reps = reps,
    index = index,
    step = step,
    adjustment = adjustment,
    perc_1RM = perc_1RM
  )

  class(scheme) <- c("STMr_scheme", class(scheme))

  scheme
}
