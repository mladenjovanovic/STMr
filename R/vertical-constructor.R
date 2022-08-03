new_STMr_vertical <- function(index, step, set, set_id, reps, adjustment, perc_1RM) {
  scheme <- data.frame(
    index = index,
    step = step,
    set = set,
    set_id = set_id,
    reps = reps
  )

  class(scheme) <- c("STMr_vertical", class(scheme))

  scheme
}
