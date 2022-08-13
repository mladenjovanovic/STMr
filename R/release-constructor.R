new_STMr_release <- function(phase,
                             index,
                             total_index,
                             step,
                             set,
                             reps,
                             adjustment,
                             perc_1RM,
                             prescription_1RM,
                             weight,
                             load_1RM,
                             buffer) {
  release <- data.frame(
    phase = phase,
    index = index,
    total_index = total_index,
    step = step,
    set = set,
    reps = reps,
    adjustment = adjustment,
    perc_1RM = perc_1RM,
    prescription_1RM = prescription_1RM,
    weight = weight,
    load_1RM = load_1RM,
    buffer = buffer
  )

  class(release) <- c("STMr_release", class(release))

  release
}
