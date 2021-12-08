#' Max-Reps Tables
#'
#' Family of functions to represent max reps tables
#'
#' @param perc_1RM Percent of 1RM
#' @param RIR Reps In Reserve
#' @param max_reps Maximum repetitions
#' @param reps Number of repetitions done
#' @param weight Weight used
#' @param type Type of max rep table. Options are grinding (Default) and ballistic.
#' @param percMR Percent of maximum repetitions
#' @name max_reps_tables
NULL

#' @describeIn max_reps_tables Get maximum number of repetitions
#' @export
#' @examples
#' # Get max reps that can be done with 75% 1RM
#' get_max_reps(0.75)
#'
#' # Get max reps that can be done with 80% 1RM with 2 reps in reserve
#' get_max_reps(
#'   perc_1RM = 0.8,
#'   RIR = 3
#' )
#'
#' # Get max reps that can be done with 90% 1RM with 2 reps in reserve
#' # using ballistic table
#' get_max_reps(
#'   perc_1RM = 0.9,
#'   RIR = 2,
#'   type = "ballistic"
#' )
get_max_reps <- function(perc_1RM, RIR = 0, type = "grinding") {
  switch(type,
    grinding = (30.03 / perc_1RM) - (30.03 + RIR),
    ballistic = (15.015 / perc_1RM) - (15.015 + RIR),
    stop("Invalid `type` value. Please use `grinding` or `ballistic`", call. = FALSE)
  )
}

#' @describeIn max_reps_tables Get maximum %1RM
#' @export
#' @examples
#' # Get max %1RM to be used when doing 5 reps to failure
#' get_max_perc_1RM(5)
#'
#' # Get max %1RM to be used when doing 3 reps with 2 reps in reserve
#' get_max_perc_1RM(
#'   max_reps = 3,
#'   RIR = 2
#' )
#'
#' # Get max %1RM to be used when doing 2 reps with 3 reps in reserve
#' # using ballistic table
#' get_max_perc_1RM(
#'   max_reps = 3,
#'   RIR = 2,
#'   type = "ballistic"
#' )
get_max_perc_1RM <- function(max_reps, RIR = 0, type = "grinding") {
  switch(type,
    grinding = 1 / (0.0333 * (max_reps + RIR) + 1),
    ballistic = 1 / (0.0666 * (max_reps + RIR) + 1),
    stop("Invalid `type` value. Please use `grinding` or `ballistic`", call. = FALSE)
  )
}

#' @describeIn max_reps_tables Get predicted 1RM
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
#'   RIR = 2
#' )
#'
#' # Get predicted 1RM when lifting 120kg for 2 reps with 1 reps in reserve
#' # using ballistic table
#' get_predicted_1RM(
#'   weight = 120,
#'   reps = 2,
#'   RIR = 1,
#'   type = "ballistic"
#' )
get_predicted_1RM <- function(weight, reps, RIR = 0, type = "grinding") {
  switch(type,
    grinding = (weight * (reps + RIR) * 0.0333) + weight,
    ballistic = (weight * (reps + RIR) * 0.0666) + weight,
    stop("Invalid `type` value. Please use `grinding` or `ballistic`", call. = FALSE)
  )
}
