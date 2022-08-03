new_STMr_vertical <- function(index, step, set, reps, adjustment, perc_1RM) {
  scheme <- data.frame(
    index = index,
    step = step,
    set = set,
    reps = reps
  )

  class(scheme) <- c("STMr_vertical", class(scheme))

  scheme
}
