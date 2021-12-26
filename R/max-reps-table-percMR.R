#' @describeIn max_reps_tables Get maximum number of repetitions using the %MR (\code{adjustment})
#' @export
#' @examples
#' # Get max reps that can be done with 75% 1RM
#' get_max_reps_percMR(0.75)
#'
#' # Get max reps that can be done with 80% 1RM with 60% of maximum reps
#' get_max_reps_percMR(
#'   perc_1RM = 0.8,
#'   adjustment = 0.6
#' )
#'
#' # Get max reps that can be done with 90% 1RM with 60% of maximum reps
#' # using ballistic table
#' get_max_reps_percMR(
#'   perc_1RM = 0.9,
#'   adjustment = 0.6,
#'   type = "ballistic"
#' )
get_max_reps_percMR <- function(perc_1RM, adjustment = 1, type = "grinding") {
  switch(type,
    grinding = (adjustment * (30.03 - 30.03 * perc_1RM)) / perc_1RM,
    ballistic = (adjustment * (15.015 - 15.015 * perc_1RM)) / perc_1RM,
    stop("Invalid `type` value. Please use `grinding` or `ballistic`", call. = FALSE)
  )
}


#' @describeIn max_reps_tables Get maximum %1RM using the %MR (\code{adjustment})
#' @export
#' @examples
#' # Get max %1RM to be used when doing 5 reps to failure
#' get_max_perc_1RM_percMR(5)
#'
#' # Get max %1RM to be used when doing 3 reps with with 60% of maximum reps
#' get_max_perc_1RM_percMR(
#'   max_reps = 3,
#'   adjustment = 0.6,
#' )
#'
#' # Get max %1RM to be used when doing 2 reps with 60% of maximum reps
#' # using ballistic table
#' get_max_perc_1RM_percMR(
#'   max_reps = 3,
#'   adjustment = 0.6,
#'   type = "ballistic"
#' )
get_max_perc_1RM_percMR <- function(max_reps, adjustment = 1, type = "grinding") {
  switch(type,
    grinding = adjustment / (adjustment + 0.0333 * max_reps),
    ballistic = adjustment / (adjustment + 0.0666 * max_reps),
    stop("Invalid `type` value. Please use `grinding` or `ballistic`", call. = FALSE)
  )
}

#' @describeIn max_reps_tables Get predicted 1RM using the %MR (\code{adjustment})
#' @export
#' @examples
#' # Get predicted 1RM when lifting 100kg for 5 reps to failure
#' get_predicted_1RM_percMR(
#'   weight = 100,
#'   reps = 5
#' )
#'
#' # Get predicted 1RM when lifting 120kg for 3 reps with 60% of maximum reps
#' get_predicted_1RM_percMR(
#'   weight = 120,
#'   reps = 3,
#'   adjustment = 0.6
#' )
#'
#' # Get predicted 1RM when lifting 120kg for 2 reps with 60% of maximum reps
#' # using ballistic table
#' get_predicted_1RM_percMR(
#'   weight = 120,
#'   reps = 2,
#'   adjustment = 0.6,
#'   type = "ballistic"
#' )
get_predicted_1RM_percMR <- function(weight, reps, adjustment = 1, type = "grinding") {
  switch(type,
    grinding = (weight * (reps / adjustment) * 0.0333) + weight,
    ballistic = (weight * (reps / adjustment) * 0.0666) + weight,
    stop("Invalid `type` value. Please use `grinding` or `ballistic`", call. = FALSE)
  )
}
