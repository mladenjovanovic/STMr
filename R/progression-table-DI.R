#' @describeIn progression_table Deducted Intensity progression table. This simplest progression
#'     table simply deducts intensity to progress. Adjust this deducted by using the
#'     \code{deduction} parameter (default is equal to -0.025)
#' @export
#' @examples
#' # ------------------------------------------
#' # Progression Deducted Intensity
#' progression_DI(10, step = seq(-3, 0, 1))
#' progression_DI(10, step = seq(-3, 0, 1), volume = "extensive")
#' progression_DI(5, step = seq(-3, 0, 1), type = "ballistic", step_increment = -0.05)
#' progression_DI(
#'   5,
#'   step = seq(-3, 0, 1),
#'   type = "ballistic",
#'   step_increment = -0.05,
#'   volume_increment = -0.1
#' )
#'
#' # Generate progression table
#' generate_progression_table(progression_DI, type = "grinding", volume = "normal")
#'
#' # Use different reps-max model
#' generate_progression_table(
#'   progression_DI,
#'   type = "grinding",
#'   volume = "normal",
#'   max_perc_1RM_func = max_perc_1RM_linear,
#'   klin = 36
#' )
#'
progression_DI <- function(reps,
                           step = 0,
                           volume = "normal",
                           adjustment = 0,
                           type = "grinding",
                           mfactor = NULL,
                           step_increment = -0.025,
                           volume_increment = step_increment,
                           ...) {
  # +++++++++++++++++++++++++++++++++++++++++++
  # Code chunk for dealing with R CMD check note
  rep_start <- NULL
  rep_step <- NULL
  inc_start <- NULL
  inc_step <- NULL
  post_adjustment <- NULL
  total_adjustment <- NULL
  rep_DI <- NULL
  step_DI <- NULL
  # +++++++++++++++++++++++++++++++++++++++++++

  # Perform checks
  check_volume(volume)
  check_type(type)

  if (is.null(mfactor)) mfactor <- get_mfactor(type)

  df <- data.frame(
    reps = reps,
    step = step,
    volume = volume,
    post_adjustment = adjustment,
    mfactor = mfactor,
    volume_increment = volume_increment,
    step_increment = step_increment
  ) %>%
    dplyr::mutate(
      rep_start = dplyr::case_when(
        volume == "intensive" ~ 0,
        volume == "normal" ~ volume_increment,
        volume == "extensive" ~ volume_increment * 2
      ),
      rep_step = 0,
      inc_start = step_increment,
      inc_step = 0,

      # Calculate
      rep_DI = rep_start + (reps - 1) * rep_step,
      step_DI = -1 * step * (inc_start + (reps - 1) * inc_step),
      adjustment = (rep_DI + step_DI),
      total_adjustment = adjustment + post_adjustment,
      perc_1RM = adj_perc_1RM_DI(
        reps = reps,
        adjustment = total_adjustment,
        mfactor = mfactor,
        ...
      )
    )

  return(list(
    adjustment = df$total_adjustment,
    perc_1RM = df$perc_1RM
  ))
}
