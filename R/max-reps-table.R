#' Family of functions to represent max reps tables
#'
#' @param perc_1RM Percent of 1RM
#' @param adjustment Adjustment to be implemented, specific to the method
#' @param max_reps Maximum repetitions
#' @param reps Number of repetitions done
#' @param weight Weight used
#' @param type Type of max rep table. Options are grinding (Default) and ballistic.
#' @param k User defined \code{k} parameter in the Epley's equation. Default is 0.0333
#' @param kmod User defined \code{kmod} parameter in the modified Epley's equation. Default is 0.0353
#' @param klin User defined \code{klin} parameter in the linear equation. Default is 33
#' @name max_reps_tables
NULL

#' @describeIn max_reps_tables Get maximum number of repetitions using the RIR method (\code{adjustment})
#' @export
#' @examples
#' # Get max reps that can be done with 75% 1RM
#' get_max_reps(0.75)
#'
#' # Get max reps that can be done with 80% 1RM with 2 reps in reserve
#' get_max_reps(
#'   perc_1RM = 0.8,
#'   adjustment = 3
#' )
#'
#' # Get max reps that can be done with 90% 1RM with 2 reps in reserve
#' # using ballistic table
#' get_max_reps(
#'   perc_1RM = 0.9,
#'   adjustment = 2,
#'   type = "ballistic"
#' )
get_max_reps <- function(perc_1RM, adjustment = 0, type = "grinding") {
  switch(type,
    grinding = (30.03 / perc_1RM) - (30.03 + adjustment),
    ballistic = (15.015 / perc_1RM) - (15.015 + adjustment),
    stop("Invalid `type` value. Please use `grinding` or `ballistic`", call. = FALSE)
  )
}

#' @describeIn max_reps_tables Get maximum %1RM using the RIR method (\code{adjustment})
#' @export
#' @examples
#' # Get max %1RM to be used when doing 5 reps to failure
#' get_max_perc_1RM(5)
#'
#' # Get max %1RM to be used when doing 3 reps with 2 reps in reserve
#' get_max_perc_1RM(
#'   max_reps = 3,
#'   adjustment = 2
#' )
#'
#' # Get max %1RM to be used when doing 2 reps with 3 reps in reserve
#' # using ballistic table
#' get_max_perc_1RM(
#'   max_reps = 3,
#'   adjustment = 2,
#'   type = "ballistic"
#' )
get_max_perc_1RM <- function(max_reps, adjustment = 0, type = "grinding") {
  switch(type,
    grinding = 1 / (0.0333 * (max_reps + adjustment) + 1),
    ballistic = 1 / (0.0666 * (max_reps + adjustment) + 1),
    stop("Invalid `type` value. Please use `grinding` or `ballistic`", call. = FALSE)
  )
}

#' @describeIn max_reps_tables Get predicted 1RM using the RIR method (\code{adjustment})
#' @export
#' @examples
#' # Get predicted 1RM when lifting 100kg for 5 reps to failure
#' get_predicted_1RM(
#'   weight = 100,
#'   reps = 5
#' )
#'
#' # Get predicted 1RM when lifting 120kg for 3 reps with 2 reps in reserve
#' get_predicted_1RM(
#'   weight = 120,
#'   reps = 3,
#'   adjustment = 2
#' )
#'
#' # Get predicted 1RM when lifting 120kg for 2 reps with 1 reps in reserve
#' # using ballistic table
#' get_predicted_1RM(
#'   weight = 120,
#'   reps = 2,
#'   adjustment = 1,
#'   type = "ballistic"
#' )
get_predicted_1RM <- function(weight, reps, adjustment = 0, type = "grinding") {
  switch(type,
    grinding = (weight * (reps + adjustment) * 0.0333) + weight,
    ballistic = (weight * (reps + adjustment) * 0.0666) + weight,
    stop("Invalid `type` value. Please use `grinding` or `ballistic`", call. = FALSE)
  )
}
