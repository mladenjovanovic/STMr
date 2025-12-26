#' @describeIn progression_table Perc Drop progression table (see Strength Training Manual)
#' @export
#' @references
#'     Jovanović M. 2020. Strength Training Manual: The Agile Periodization Approach.
#'     Independently published.
#'
#' @examples
#' # ------------------------------------------
#' # Progression Perc Drop
#' progression_perc_drop(10, step = seq(-3, 0, 1))
#' progression_perc_drop(10, step = seq(-3, 0, 1), volume = "extensive")
#' progression_perc_drop(5, step = seq(-3, 0, 1), type = "ballistic")
#'
#' # Generate progression table
#' generate_progression_table(progression_perc_drop, type = "grinding", volume = "normal")
#'
#' # Use different reps-max model
#' generate_progression_table(
#'   progression_perc_drop,
#'   type = "grinding",
#'   volume = "normal",
#'   max_perc_1RM_func = max_perc_1RM_linear,
#'   klin = 36
#' )
progression_perc_drop <- function(reps,
                                  step = 0,
                                  volume = "normal",
                                  adjustment = 0,
                                  type = "grinding",
                                  mfactor = NULL,
                                  ...) {


  # +++++++++++++++++++++++++++++++++++++++++++
  # Code chunk for dealing with R CMD check note
  rep_start <- NULL
  rep_step <- NULL
  inc_start <- NULL
  inc_step <- NULL
  post_adjustment <- NULL
  total_adjustment <- NULL
  rep_perc_drop <- NULL
  step_perc_drop <- NULL
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

  params <- data.frame(
    volume = c("intensive", "normal", "extensive",
               "intensive", "normal", "extensive",
               "intensive", "normal", "extensive"),
    type = c("grinding", "grinding", "grinding",
             "ballistic", "ballistic", "ballistic",
             "conservative", "conservative", "conservative"),
    # For conservative, I am simply copying ballistic adjustments
    rep_start = c(0, -0.025, -0.05, 0, -0.025, -0.05, 0, -0.025, -0.05),
    rep_step = c(0, ((-0.05 - -0.025) / 11), ((-0.1 - -0.05) / 11), 0, -0.0025, -0.005, 0, -0.0025, -0.005),
    inc_start = c(-0.025, -0.025, -0.025, -0.025, -0.025, -0.025, -0.025, -0.025, -0.025),
    inc_step = c(((-0.05 - -0.025) / 11), ((-0.05 - -0.025) / 11), ((-0.05 - -0.025) / 11), -0.005, -0.005, -0.005, -0.005, -0.005, -0.005)
  )

  # Merge them together
  df <- df %>%
    dplyr::left_join(params, by = c("volume", "type"))

  # Calculate
  df <- df %>%
    dplyr::mutate(
      rep_perc_drop = rep_start + (reps - 1) * rep_step,
      step_perc_drop = -1 * step * (inc_start + (reps - 1) * inc_step),
      adjustment = rep_perc_drop + step_perc_drop,
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
