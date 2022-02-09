#' @describeIn progression_table Constant RIR Increment progression table. This variant have constant RIR
#'     increment across reps from phases to phases and RIR difference between extensive, normal, and
#'     intensive schemes. Use \code{step_increment} and  \code{volume_increment} parameters to
#'     utilize needed increments
#'
#' @export
#' @examples
#' # ------------------------------------------
#' # Progression RIR Constant
#' progression_RIR(10, step = seq(-3, 0, 1))
#' progression_RIR(10, step = seq(-3, 0, 1), volume = "extensive")
#' progression_RIR(5, step = seq(-3, 0, 1), type = "ballistic", step_increment = 2)
#' progression_RIR(
#'   5,
#'   step = seq(-3, 0, 1),
#'   type = "ballistic",
#'   step_increment = 3)
#'
#' # Generate progression table
#' generate_progression_table(progression_RIR, type = "grinding", volume = "normal")
#'
#' # Use different reps-max model
#' generate_progression_table(
#'   progression_RIR,
#'   type = "grinding",
#'   volume = "normal",
#'   max_perc_1RM_func = max_perc_1RM_linear,
#'   klin = 36
#' )
#'
#' # Plot progression table
#' plot_progression_table(progression_RIR)
#' plot_progression_table(progression_RIR, "adjustment")
#'
progression_RIR <- function(reps,
                                  step = 0,
                                  volume = "normal",
                                  adjustment = 0,
                                  type = "grinding",
                                  mfactor = NULL,
                                  step_increment = 1,
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
  rep_RIR <- NULL
  step_RIR <- NULL
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
        volume == "extensive" ~ volume_increment * 2,
      ),
      rep_step = 0,
      inc_start = step_increment,
      inc_step = 0,

      # Calculate
      rep_RIR = rep_start + (reps - 1) * rep_step,
      step_RIR = -1 * step * (inc_start + (reps - 1) * inc_step),
      adjustment = rep_RIR + step_RIR,
      total_adjustment = adjustment + post_adjustment,
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


#' @describeIn progression_table RIR Increment progression table (see Strength Training Manual)
#' @export
#' @references
#'     Jovanović M. 2020. Strength Training Manual: The Agile Periodization Approach.
#'     Independently published.
#'
#' @examples
#' # ------------------------------------------
#' # Progression RIR Increment
#' progression_RIR_increment(10, step = seq(-3, 0, 1))
#' progression_RIR_increment(10, step = seq(-3, 0, 1), volume = "extensive")
#' progression_RIR_increment(5, step = seq(-3, 0, 1), type = "ballistic")
#'
#' # Generate progression table
#' generate_progression_table(progression_RIR_increment, type = "grinding", volume = "normal")
#'
#' # Use different reps-max model
#' generate_progression_table(
#'   progression_RIR_increment,
#'   type = "grinding",
#'   volume = "normal",
#'   max_perc_1RM_func = max_perc_1RM_linear,
#'   klin = 36
#' )
#'
#' # Plot progression table
#' plot_progression_table(progression_RIR_increment)
#' plot_progression_table(progression_RIR_increment, "adjustment")
#'
progression_RIR_increment <- function(reps,
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
  rep_RIR <- NULL
  step_RIR <- NULL
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
    rep_start = c(0, 1, 2, 0, 1, 2),
    rep_step = c(0, ((3 - 1) / 11), ((6 - 2) / 11), 0, 0.2, 0.4),
    inc_start = c(1, 1, 1, 1, 1, 1),
    inc_step = c(((2 - 1) / 11), ((2 - 1) / 11), ((2 - 1) / 11), 0.2, 0.2, 0.2)
  )

  # Merge them together
  df <- df %>%
    dplyr::left_join(params, by = c("volume", "type"))

  # Calculate
  df <- df %>%
    dplyr::mutate(
      rep_RIR = rep_start + (reps - 1) * rep_step,
      step_RIR = -1 * step * (inc_start + (reps - 1) * inc_step),
      adjustment = rep_RIR + step_RIR,
      total_adjustment = adjustment + post_adjustment,
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
