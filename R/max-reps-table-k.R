#' @describeIn max_reps_tables Get maximum number of repetitions using the RIR method (\code{adjustment}), but
#'     with user provided \code{k} parameter
#' @export
#' @examples
#' # Get max reps that can be done with 75% 1RM
#' get_max_reps_k(0.75, k = 0.05)
#'
#' # Get max reps that can be done with 80% 1RM with 2 reps in reserve
#' get_max_reps_k(
#'   perc_1RM = 0.8,
#'   adjustment = 3,
#'   k = 0.05
#' )
#'
#' # Get max reps that can be done with 90% 1RM with 2 reps in reserve
#' # using ballistic table
#' get_max_reps_k(
#'   perc_1RM = 0.9,
#'   adjustment = 2,
#'   type = "ballistic",
#'   k = 0.05
#' )
get_max_reps_k <- function(perc_1RM, adjustment = 0, type = "grinding", k = 0.0333) {
  switch(type,
    grinding = ((1 / k) / perc_1RM) - ((1 / k) + adjustment),
    ballistic = ((1 / (k * 2)) / perc_1RM) - ((1 / (k * 2)) + adjustment),
    stop("Invalid `type` value. Please use `grinding` or `ballistic`", call. = FALSE)
  )
}

#' @describeIn max_reps_tables Get maximum %1RM using the RIR method (\code{adjustment}), but
#'     with user provided \code{k} parameter
#' @export
#' @examples
#' # Get max %1RM to be used when doing 5 reps to failure
#' get_max_perc_1RM_k(5, k = 0.0333)
#'
#' # Get max %1RM to be used when doing 3 reps with 2 reps in reserve
#' get_max_perc_1RM_k(
#'   max_reps = 3,
#'   adjustment = 2,
#'   k = 0.05
#' )
#'
#' # Get max %1RM to be used when doing 2 reps with 3 reps in reserve
#' # using ballistic table
#' get_max_perc_1RM_k(
#'   max_reps = 3,
#'   adjustment = 2,
#'   type = "ballistic",
#'   k = 0.05
#' )
get_max_perc_1RM_k <- function(max_reps, adjustment = 0, type = "grinding", k = 0.0333) {
  switch(type,
    grinding = 1 / (k * (max_reps + adjustment) + 1),
    ballistic = 1 / (2 * k * (max_reps + adjustment) + 1),
    stop("Invalid `type` value. Please use `grinding` or `ballistic`", call. = FALSE)
  )
}

#' @describeIn max_reps_tables Get predicted 1RM using the RIR method (\code{adjustment}), but
#'     with user provided \code{k} parameter
#' @export
#' @examples
#' # Get predicted 1RM when lifting 100kg for 5 reps to failure
#' get_predicted_1RM_k(
#'   weight = 100,
#'   reps = 5,
#'   k = 0.05
#' )
#'
#' # Get predicted 1RM when lifting 120kg for 3 reps with 2 reps in reserve
#' get_predicted_1RM_k(
#'   weight = 120,
#'   reps = 3,
#'   adjustment = 2,
#'   k = 0.05
#' )
#'
#' # Get predicted 1RM when lifting 120kg for 2 reps with 1 reps in reserve
#' # using ballistic table
#' get_predicted_1RM_k(
#'   weight = 120,
#'   reps = 2,
#'   adjustment = 1,
#'   type = "ballistic",
#'   k = 0.05
#' )
get_predicted_1RM_k <- function(weight, reps, adjustment = 0, type = "grinding", k = 0.0333) {
  switch(type,
    grinding = (weight * (reps + adjustment) * k) + weight,
    ballistic = (weight * (reps + adjustment) * k * 2) + weight,
    stop("Invalid `type` value. Please use `grinding` or `ballistic`", call. = FALSE)
  )
}
