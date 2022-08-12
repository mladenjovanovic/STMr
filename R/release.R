#' @export
release <- function(...,
                    prescription_1RM = 100,
                    additive_1RM_adjustment = 2.5,
                    multiplicative_1RM_adjustment = 1,
                    rounding = 2.5,
                    max_perc_1RM_func = max_perc_1RM_epley) {

  phase_counter <- 1

  # Create counter
  phases_list <- lapply(list(...), function(x) {
    df <- data.frame(phase = phase_counter, x)
    phase_counter <<- phase_counter + 1
    df
  })

  phases_df <- do.call(rbind, phases_list)

  phases_index <- phases_df %>%
    dplyr::group_by(phase) %>%
    dplyr::summarize(max_index = max(index)) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(index_start = cumsum(max_index) - max_index) %>%
    dplyr::select(-max_index)

  release_df <- phases_df %>%
    dplyr::left_join(phases_index, by = "phase") %>%
    dplyr::mutate(
      total_index = index + index_start,
      prescription_1RM = prescription_1RM * (multiplicative_1RM_adjustment ^ (phase - 1)) +
                         (additive_1RM_adjustment * (phase - 1)),
      weight = mround(prescription_1RM * perc_1RM, rounding),
      load_1RM = weight / max_perc_1RM_func(reps),
      buffer = (prescription_1RM - load_1RM) / prescription_1RM
    )

  # Call constructor
  new_STMr_release(
    phase = release_df$phase,
    index = release_df$index,
    total_index = release_df$total_index,
    step = release_df$step,
    set = release_df$set,
    reps = release_df$reps,
    adjustment = release_df$adjustment,
    perc_1RM = release_df$perc_1RM,
    prescription_1RM = release_df$prescription_1RM,
    weight = release_df$weight,
    load_1RM = release_df$load_1RM,
    buffer = release_df$buffer
  )
}
