#' @describeIn max_reps_tables Get maximum number of repetitions using the Relative Intensity (\code{adjustment})
#' @export
#' @examples
#' # Get max reps that can be done with 75% 1RM
#' get_max_reps_relInt(0.75)
#'
#' # Get max reps that can be done with 80% 1RM with 60% of Relative Intensity
#' get_max_reps_relInt(
#'   perc_1RM = 0.8,
#'   adjustment = 0.6
#' )
#'
#' # Get max reps that can be done with 90% 1RM with 60% of Relative Intensity
#' # using ballistic table
#' get_max_reps_relInt(
#'   perc_1RM = 0.9,
#'   adjustment = 0.6,
#'   type = "ballistic"
#' )
get_max_reps_relInt <- function(perc_1RM, adjustment = 1, type = "grinding") {
  switch(type,
    grinding = ((30.03 * adjustment) / perc_1RM) - 30.03,
    ballistic = ((15.015 * adjustment) / perc_1RM) - 15.015,
    stop("Invalid `type` value. Please use `grinding` or `ballistic`", call. = FALSE)
  )
}


#' @describeIn max_reps_tables Get maximum %1RM using the Relative Intensity (\code{adjustment})
#' @export
#' @examples
#' # Get max %1RM to be used when doing 5 reps to failure
#' get_max_perc_1RM_relInt(5)
#'
#' # Get max %1RM to be used when doing 3 reps with with 60% of Relative Intensity
#' get_max_perc_1RM_relInt(
#'   max_reps = 3,
#'   adjustment = 0.6,
#' )
#'
#' # Get max %1RM to be used when doing 2 reps with 60% of Relative Intensity
#' # using ballistic table
#' get_max_perc_1RM_relInt(
#'   max_reps = 3,
#'   adjustment = 0.6,
#'   type = "ballistic"
#' )
get_max_perc_1RM_relInt <- function(max_reps, adjustment = 1, type = "grinding") {
  switch(type,
    grinding = adjustment / (0.0333 * max_reps + 1),
    ballistic = adjustment / (0.0666 * max_reps + 1),
    stop("Invalid `type` value. Please use `grinding` or `ballistic`", call. = FALSE)
  )
}
