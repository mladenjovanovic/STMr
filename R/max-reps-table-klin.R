#' @describeIn max_reps_tables Get maximum number of repetitions using the RIR method (\code{adjustment}), but
#'     with user provided \code{klin} parameter using linear equation
#' @export
#' @examples
#' # Get max reps that can be done with 75% 1RM
#' get_max_reps_klin(0.75, klin = 33)
#'
#' # Get max reps that can be done with 80% 1RM with 2 reps in reserve
#' get_max_reps_klin(
#'   perc_1RM = 0.8,
#'   adjustment = 3,
#'   klin = 33
#' )
#'
#' # Get max reps that can be done with 90% 1RM with 2 reps in reserve
#' # using ballistic table
#' get_max_reps_klin(
#'   perc_1RM = 0.9,
#'   adjustment = 2,
#'   type = "ballistic",
#'   klin = 33
#' )
get_max_reps_klin <- function(perc_1RM, adjustment = 0, type = "grinding", klin = 33) {
  switch(type,
    grinding = (1 - perc_1RM) * klin + 1 - adjustment,
    ballistic = ((1 - perc_1RM) * klin + 1) / 2 - adjustment,
    stop("Invalid `type` value. Please use `grinding` or `ballistic`", call. = FALSE)
  )
}

#' @describeIn max_reps_tables Get maximum %1RM using the RIR method (\code{adjustment}), but
#'     with user provided \code{klin} parameter using linear equation
#' @export
#' @examples
#' # Get max %1RM to be used when doing 5 reps to failure
#' get_max_perc_1RM_klin(5, klin = 33)
#'
#' # Get max %1RM to be used when doing 3 reps with 2 reps in reserve
#' get_max_perc_1RM_klin(
#'   max_reps = 3,
#'   adjustment = 2,
#'   klin = 33
#' )
#'
#' # Get max %1RM to be used when doing 2 reps with 3 reps in reserve
#' # using ballistic table
#' get_max_perc_1RM_klin(
#'   max_reps = 3,
#'   adjustment = 2,
#'   type = "ballistic",
#'   klin = 33
#' )
get_max_perc_1RM_klin <- function(max_reps, adjustment = 0, type = "grinding", klin = 33) {
  switch(type,
    grinding = (-adjustment + klin - max_reps + 1) / klin,
    ballistic = (-2 * adjustment + klin - 2 * max_reps + 1) / klin,
    stop("Invalid `type` value. Please use `grinding` or `ballistic`", call. = FALSE)
  )
}

#' @describeIn max_reps_tables Get predicted 1RM using the RIR method (\code{adjustment}), but
#'     with user provided \code{klin} parameter using linear equation
#' @export
#' @examples
#' # Get predicted 1RM when lifting 100kg for 5 reps to failure
#' get_predicted_1RM_klin(
#'   weight = 100,
#'   reps = 5,
#'   klin = 33
#' )
#'
#' # Get predicted 1RM when lifting 120kg for 3 reps with 2 reps in reserve
#' get_predicted_1RM_klin(
#'   weight = 120,
#'   reps = 3,
#'   adjustment = 2,
#'   klin = 33
#' )
#'
#' # Get predicted 1RM when lifting 120kg for 2 reps with 1 reps in reserve
#' # using ballistic table
#' get_predicted_1RM_klin(
#'   weight = 120,
#'   reps = 2,
#'   adjustment = 1,
#'   type = "ballistic",
#'   klin = 33
#' )
get_predicted_1RM_klin <- function(weight, reps, adjustment = 0, type = "grinding", klin = 33) {
  weight / get_max_perc_1RM_klin(max_reps = reps, adjustment = adjustment, type = type, klin = klin)
}

#' @describeIn max_reps_tables Get maximum %1RM using the Relative Intensity (\code{adjustment}), but
#'     with user provided \code{klin} parameter using linear equation
#' @export
#' @examples
#' # Get max %1RM to be used when doing 5 reps to failure
#' get_max_perc_1RM_klin_relInt(5, klin = 35)
#'
#' # Get max %1RM to be used when doing 3 reps with 60% of Relative Intensity
#' get_max_perc_1RM_klin_relInt(
#'   max_reps = 3,
#'   adjustment = 0.6,
#'   klin = 35
#' )
#'
#' # Get max %1RM to be used when doing 2 reps with 60% of Relative Intensity
#' # using ballistic table
#' get_max_perc_1RM_klin_relInt(
#'   max_reps = 3,
#'   adjustment = 0.6,
#'   type = "ballistic",
#'   klin = 35
#' )
get_max_perc_1RM_klin_relInt <- function(max_reps, adjustment = 1, type = "grinding", klin = 33) {
  get_max_perc_1RM_klin(max_reps = max_reps, adjustment = 0, type = type, klin = klin) * adjustment
}


#' @describeIn max_reps_tables Get maximum %1RM using the %MR (\code{adjustment}), but
#'     with user provided \code{klin} parameter using linear equation
#' @export
#' @examples
#' # Get max %1RM to be used when doing 5 reps to failure
#' get_max_perc_1RM_klin_percMR(5, klin = 35)
#'
#' # Get max %1RM to be used when doing 3 reps with 60% of maximum reps
#' get_max_perc_1RM_klin_percMR(
#'   max_reps = 3,
#'   adjustment = 0.6,
#'   klin = 35
#' )
#'
#' # Get max %1RM to be used when doing 2 reps with 60% of maximum reps
#' # using ballistic table
#' get_max_perc_1RM_klin_percMR(
#'   max_reps = 3,
#'   adjustment = 0.6,
#'   type = "ballistic",
#'   klin = 35
#' )
get_max_perc_1RM_klin_percMR <- function(max_reps, adjustment = 1, type = "grinding", klin = 33) {
  get_max_perc_1RM_klin(max_reps = max_reps / adjustment, adjustment = 0, type = type, klin = klin)
}
