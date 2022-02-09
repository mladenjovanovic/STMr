#' @describeIn progression_table Constant \%MR Step progression table. This variant have constant \%MR
#'     increment across reps from phases to phases and \%MR difference between extensive, normal, and
#'     intensive schemes. Use \code{step_increment} and  \code{volume_increment} parameters to
#'     utilize needed increments
#' @export
#' @examples
#' # ------------------------------------------
#' # Progression %MR Step Const
#' progression_perc_MR(10, step = seq(-3, 0, 1))
#' progression_perc_MR(10, step = seq(-3, 0, 1), volume = "extensive")
#' progression_perc_MR(5, step = seq(-3, 0, 1), type = "ballistic", step_increment = -0.2)
#' progression_perc_MR(
#'   5,
#'   step = seq(-3, 0, 1),
#'   type = "ballistic",
#'   step_increment = -0.15,
#'   volume_increment = -0.25)
#'
#' # Generate progression table
#' generate_progression_table(progression_perc_MR, type = "grinding", volume = "normal")
#'
#' # Use different reps-max model
#' generate_progression_table(
#'   progression_perc_MR,
#'   type = "grinding",
#'   volume = "normal",
#'   max_perc_1RM_func = max_perc_1RM_linear,
#'   klin = 36
#' )
#'
#' # Plot progression table
#' plot_progression_table(progression_perc_MR)
#' plot_progression_table(progression_perc_MR, "adjustment")
#'
progression_perc_MR <- function(reps,
                                step = 0,
                                volume = "normal",
                                adjustment = 0,
                                type = "grinding",
                                mfactor = NULL,
                                step_increment = -0.1,
                                volume_increment = -0.2,
                                ...) {

  # +++++++++++++++++++++++++++++++++++++++++++
  # Code chunk for dealing with R CMD check note
  rep_start <- NULL
  rep_step <- NULL
  inc_start <- NULL
  inc_step <- NULL
  post_adjustment <- NULL
  total_adjustment <- NULL
  rep_MR <- NULL
  step_MR <- NULL
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
        volume == "extensive" ~ volume_increment * 2,
      ),
      rep_step = 0,
      inc_start = step_increment,
      inc_step = 0,

      # Calculate
      rep_MR = rep_start + (reps - 1) * rep_step,
      step_MR = 1 - step * (inc_start + (reps - 1) * inc_step),
      adjustment = (rep_MR + step_MR),
      total_adjustment = adjustment + post_adjustment,
      perc_1RM = adj_perc_1RM_perc_MR(
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

#' @describeIn progression_table Variable \%MR Step progression table
#' @export
#' @examples
#' # ------------------------------------------
#' # Progression %MR Step Variable
#' progression_perc_MR_variable(10, step = seq(-3, 0, 1))
#' progression_perc_MR_variable(10, step = seq(-3, 0, 1), volume = "extensive")
#' progression_perc_MR_variable(5, step = seq(-3, 0, 1), type = "ballistic")

#' # Generate progression table
#' generate_progression_table(progression_perc_MR_variable, type = "grinding", volume = "normal")
#'
#' # Use different reps-max model
#' generate_progression_table(
#'   progression_perc_MR_variable,
#'   type = "grinding",
#'   volume = "normal",
#'   max_perc_1RM_func = max_perc_1RM_linear,
#'   klin = 36
#' )
#'
#' # Plot progression table
#' plot_progression_table(progression_perc_MR_variable)
#' plot_progression_table(progression_perc_MR_variable, "adjustment")
#'
progression_perc_MR_variable <- function(reps,
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
  rep_MR <- NULL
  step_MR <- NULL
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
    volume = c("intensive", "normal", "extensive", "intensive", "normal", "extensive"),
    type = c("grinding", "grinding", "grinding", "ballistic", "ballistic", "ballistic"),
    rep_start = c(0, 0.3, 0.5, 0, 0.3, 0.5),
    rep_step = c(0, -(0.1 / 11), -(0.1 / 11), 0, -(0.1 / 11), -(0.1 / 11)),
    inc_start = c(-0.4 / 3, -0.3 / 3, -0.3 / 3, -0.4 / 3, -0.3 / 3, -0.3 / 3),
    inc_step = c((0.7 - 0.6) / (11 * 3), (0.5 - 0.5) / (11 * 3), (0.3 - 0.3) / (11 * 3), (0.7 - 0.6) / (11 * 3), (0.5 - 0.5) / (11 * 3), (0.3 - 0.3) / (11 * 3))
  )

  # Merge them together
  df <- df %>%
    dplyr::left_join(params, by = c("volume", "type"))

  # Calculate
  df <- df %>%
    dplyr::mutate(
      rep_MR = rep_start + (reps - 1) * rep_step,
      step_MR = step * (inc_start + (reps - 1) * inc_step),
      adjustment = 1 - (rep_MR + step_MR),
      total_adjustment = adjustment + post_adjustment,
      perc_1RM = adj_perc_1RM_perc_MR(
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
