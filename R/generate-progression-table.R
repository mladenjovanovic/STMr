#' @describeIn progression_table Generates progression tables
#' @param progression_table Progression table function to use
#' @param ... Forwarded to \code{progression_table} for using different rep max function
#' @export
#' @examples
#' generate_progression_table(progression_RIR)
#'
#' generate_progression_table(
#'   progression_RIR,
#'   type = "grinding",
#'   volume = "normal",
#'   step_increment = 2
#' )
#'
#' # Create progression table using specific reps-max table and k value
#' generate_progression_table(
#'   progression_RIR,
#'   max_perc_1RM_func = max_perc_1RM_modified_epley,
#'   kmod = 0.0388
#' )
generate_progression_table <- function(progression_table,
                                       type = c("grinding", "ballistic", "conservative"),
                                       volume = c("intensive", "normal", "extensive"),
                                       reps = 1:12,
                                       step = seq(-3, 0, 1),
                                       ...) {

  # Perform checks
  check_volume(volume)
  check_type(type)

  df <- expand.grid(
    type = type,
    volume = volume,
    reps = reps,
    step = step,
    stringsAsFactors = FALSE
  ) %>%
    dplyr::mutate(
      data.frame(progression_table(reps = reps, step = step, volume = volume, type = type, ...))
    )

  df
}
