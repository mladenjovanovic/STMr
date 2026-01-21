#' @describeIn progression_table Variable RIR progression table. This function
#'      allows you to generate variable RIR progression table, with adjustments linearly
#'      increasing for both step progressions as well volume increment based on the reps done.
#' @param rep_1_step_increment Numeric vector. Default 1
#' @param rep_12_step_increment Numeric vector. Default 2
#' @param rep_1_volume_increment Numeric vector. Default 1
#' @param rep_12_volume_increment Numeric vector. Default 2
#' @export
#' @examples
#' # ------------------------------------------
#' # Progression Variable RIR
#' progression_variable_RIR(10, step = seq(-3, 0, 1))
#' progression_variable_RIR(10, step = seq(-3, 0, 1), volume = "extensive")
#' progression_variable_RIR(5, step = seq(-3, 0, 1), type = "ballistic")
#' progression_variable_RIR(
#'   5,
#'   step = seq(-3, 0, 1),
#'   type = "grinding",
#'   rep_1_step_increment = 1,
#'   rep_12_step_increment = 2,
#'   rep_1_volume_increment = 2,
#'   rep_12_volume_increment = 4
#' )
#'
#'
#' # Generate progression table
#' generate_progression_table(
#'   progression_variable_DI,
#'   type = "grinding",
#'   volume = "normal"
#' )
#'
#' # Use different reps-max model
#' generate_progression_table(
#'   progression_variable_RIR,
#'   type = "grinding",
#'   volume = "normal",
#'   max_perc_1RM_func = max_perc_1RM_linear,
#'   klin = 36
#' )
#'
#' # Recreate "progression_RIR_increment()" for grinding
#' setequal(
#'   generate_progression_table(
#'     progression_variable_RIR,
#'     type = "grinding",
#'     rep_1_step_increment = 1,
#'     rep_12_step_increment = 2,
#'     rep_1_volume_increment = 1,
#'     rep_12_volume_increment = 3
#'   ),
#'   generate_progression_table(
#'     progression_RIR_increment,
#'     type = "grinding"
#'   )
#' )
#'
progression_variable_RIR <- function(reps,
                                     step = 0,
                                     volume = "normal",
                                     adjustment = 0,
                                     type = "grinding",
                                     mfactor = NULL,
                                     rep_1_step_increment = 1,
                                     rep_12_step_increment = 2,
                                     rep_1_volume_increment = 1,
                                     rep_12_volume_increment = 2,
                                     ...) {
  # +++++++++++++++++++++++++++++++++++++++++++
  # Code chunk for dealing with R CMD check note
  rep_start <- NULL
  rep_step <- NULL
  inc_start <- NULL
  inc_step <- NULL
  post_adjustment <- NULL
  total_adjustment <- NULL
  rep_volume_adjustement <- NULL
  rep_adjustment <- NULL
  volume_adjustment <- NULL
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
    rep_1_step_increment = rep_1_step_increment,
    rep_12_step_increment = rep_12_step_increment,
    rep_1_volume_increment = rep_1_volume_increment,
    rep_12_volume_increment = rep_12_volume_increment
  ) %>%
    dplyr::mutate(
      rep_volume_adjustement = (reps - 1) * ((rep_12_volume_increment - rep_1_volume_increment) / 11),
      volume_adjustment = dplyr::case_when(
        volume == "intensive" ~ 0,
        volume == "normal" ~ rep_1_volume_increment + rep_volume_adjustement,
        volume == "extensive" ~ 2 * (rep_1_volume_increment + rep_volume_adjustement),
      ),

      # Calculate
      rep_adjustment = (-1 * step) * ((reps - 1) * ((rep_12_step_increment - rep_1_step_increment) / 11) + rep_1_step_increment),
      total_adjustment = rep_adjustment + volume_adjustment + post_adjustment,
      perc_1RM = adj_perc_1RM_RIR(
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
