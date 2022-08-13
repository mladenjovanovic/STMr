#' Create a Release period
#'
#' Release combines multiple schemes together with \code{prescription_1RM},
#'    \code{additive_1RM_adjustment}, and \code{multiplicative_1RM_adjustment}
#'    parameters to calculate working \code{weight}, \code{load_1RM}, and
#'    \code{buffer}
#'
#' @param ... \code{STMr_scheme} objects create by \code{scheme_} functions
#' @param prescription_1RM Initial prescription planning 1RM to calculate weight
#'     Default is 100
#' @param additive_1RM_adjustment Additive 1RM adjustment across phases. Default is 2.5
#' @param multiplicative_1RM_adjustment multiplicative 1RM adjustment across phases.
#'     Default is 1 (i.e., no adjustment)
#' @param rounding Rounding for the calculated weight. Default is 2.5
#' @param max_perc_1RM_func Max Perc 1RM function to use when calculating
#'     \code{load_1RM}. Default is \code{\link{max_perc_1RM_epley}}
#' @return \code{STMr_relase} data frame
#' @export
#' @examples
#' scheme1 <- scheme_step(vertical_planning = vertical_constant)
#' scheme2 <- scheme_step(vertical_planning = vertical_linear)
#' scheme3 <- scheme_step(vertical_planning = vertical_undulating)
#'
#' release_df <- release(
#'   scheme1, scheme2, scheme3,
#'   additive_1RM_adjustment = 2.5)
#'
#' plot(release_df)
release <- function(...,
                    prescription_1RM = 100,
                    additive_1RM_adjustment = 2.5,
                    multiplicative_1RM_adjustment = 1,
                    rounding = 2.5,
                    max_perc_1RM_func = max_perc_1RM_epley) {

  # +++++++++++++++++++++++++++++++++++++++++++
  # Code chunk for dealing with R CMD check note
  phase <- NULL
  index <- NULL
  max_index <- NULL
  index_start <- NULL
  perc_1RM <- NULL
  weight <- NULL
  reps <- NULL
  load_1RM <- NULL
  # +++++++++++++++++++++++++++++++++++++++++++


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
