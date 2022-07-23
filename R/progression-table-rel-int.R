#' @describeIn progression_table Relative Intensity progression table. Use \code{step_increment}
#'     and  \code{volume_increment} parameters to utilize needed increments
#' @export
#' @examples
#' # ------------------------------------------
#' # Progression Relative Intensity
#' progression_rel_int(10, step = seq(-3, 0, 1))
#' progression_rel_int(10, step = seq(-3, 0, 1), volume = "extensive")
#' progression_rel_int(5, step = seq(-3, 0, 1), type = "ballistic")
#'
#' # Generate progression table
#' generate_progression_table(progression_rel_int, type = "grinding", volume = "normal")
#' generate_progression_table(progression_rel_int, step_increment = -0.1, volume_increment = 0.15)
#'
#' # Use different reps-max model
#' generate_progression_table(
#'   progression_rel_int,
#'   type = "grinding",
#'   volume = "normal",
#'   max_perc_1RM_func = max_perc_1RM_linear,
#'   klin = 36
#' )
#'
#' # Plot progression table
#' plot_progression_table(progression_rel_int)
#' plot_progression_table(progression_rel_int, "adjustment")
progression_rel_int <- function(reps,
                                step = 0,
                                volume = "normal",
                                adjustment = 0,
                                type = "grinding",
                                mfactor = NULL,
                                step_increment = -0.05,
                                volume_increment = -0.075,
                                ...) {


  # +++++++++++++++++++++++++++++++++++++++++++
  # Code chunk for dealing with R CMD check note
  rep_start <- NULL
  rep_step <- NULL
  inc_start <- NULL
  inc_step <- NULL
  post_adjustment <- NULL
  total_adjustment <- NULL
  rep_RI <- NULL
  step_RI <- NULL
  # +++++++++++++++++++++++++++++++++++++++++++

  # Perform checks
  check_volume(volume)
  check_type(type)

  if (is.null(mfactor)) mfactor <- get_mfactor(type)

  df <- data.frame(
    reps = reps,
    step = step,
    volume = volume,
    type = type,
    post_adjustment = adjustment,
    mfactor = mfactor
  )

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
      rep_RI = rep_start + (reps - 1) * rep_step,
      step_RI = 1 - step * (inc_start + (reps - 1) * inc_step),
      adjustment = (rep_RI + step_RI),
      total_adjustment = adjustment + post_adjustment,
      perc_1RM = adj_perc_1RM_rel_int(
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
