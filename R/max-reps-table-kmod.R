#' @describeIn max_reps_tables Get maximum number of repetitions using the RIR method (\code{adjustment}), but
#'     with user provided \code{kmod} parameter using modified Epley's equation
#' @export
#' @examples
#' # Get max reps that can be done with 75% 1RM
#' get_max_reps_kmod(0.75, kmod = 0.05)
#'
#' # Get max reps that can be done with 80% 1RM with 2 reps in reserve
#' get_max_reps_kmod(
#'   perc_1RM = 0.8,
#'   adjustment = 3,
#'   kmod = 0.05
#' )
#'
#' # Get max reps that can be done with 90% 1RM with 2 reps in reserve
#' # using ballistic table
#' get_max_reps_kmod(
#'   perc_1RM = 0.9,
#'   adjustment = 2,
#'   type = "ballistic",
#'   kmod = 0.05
#' )
get_max_reps_kmod <- function(perc_1RM, adjustment = 0, type = "grinding", kmod = 0.0353) {
  switch(type,
    grinding = ((perc_1RM * (-adjustment * kmod + kmod - 1)) + 1) / (kmod * perc_1RM),
    ballistic = ((perc_1RM * (-adjustment * 2 * kmod + 2 * kmod - 1)) + 1) / (2 * kmod * perc_1RM),
    stop("Invalid `type` value. Please use `grinding` or `ballistic`", call. = FALSE)
  )
}

#' @describeIn max_reps_tables Get maximum %1RM using the RIR method (\code{adjustment}), but
#'     with user provided \code{kmod} parameter using modified Epley's equation
#' @export
#' @examples
#' # Get max %1RM to be used when doing 5 reps to failure
#' get_max_perc_1RM_kmod(5, kmod = 0.0353)
#'
#' # Get max %1RM to be used when doing 3 reps with 2 reps in reserve
#' get_max_perc_1RM_kmod(
#'   max_reps = 3,
#'   adjustment = 2,
#'   kmod = 0.05
#' )
#'
#' # Get max %1RM to be used when doing 2 reps with 3 reps in reserve
#' # using ballistic table
#' get_max_perc_1RM_kmod(
#'   max_reps = 3,
#'   adjustment = 2,
#'   type = "ballistic",
#'   kmod = 0.05
#' )
get_max_perc_1RM_kmod <- function(max_reps, adjustment = 0, type = "grinding", kmod = 0.0353) {
  switch(type,
    grinding = 1 / (kmod * (max_reps + adjustment - 1) + 1),
    ballistic = 1 / (2 * kmod * (max_reps + adjustment - 1) + 1),
    stop("Invalid `type` value. Please use `grinding` or `ballistic`", call. = FALSE)
  )
}

#' @describeIn max_reps_tables Get predicted 1RM using the RIR method (\code{adjustment}), but
#'     with user provided \code{kmod} parameter using modified Epley's equation
#' @export
#' @examples
#' # Get predicted 1RM when lifting 100kg for 5 reps to failure
#' get_predicted_1RM_kmod(
#'   weight = 100,
#'   reps = 5,
#'   kmod = 0.05
#' )
#'
#' # Get predicted 1RM when lifting 120kg for 3 reps with 2 reps in reserve
#' get_predicted_1RM_kmod(
#'   weight = 120,
#'   reps = 3,
#'   adjustment = 2,
#'   kmod = 0.05
#' )
#'
#' # Get predicted 1RM when lifting 120kg for 2 reps with 1 reps in reserve
#' # using ballistic table
#' get_predicted_1RM_kmod(
#'   weight = 120,
#'   reps = 2,
#'   adjustment = 1,
#'   type = "ballistic",
#'   kmod = 0.05
#' )
get_predicted_1RM_kmod <- function(weight, reps, adjustment = 0, type = "grinding", kmod = 0.0353) {
  switch(type,
    grinding = (weight * (reps + adjustment - 1) * kmod) + weight,
    ballistic = (weight * (reps + adjustment - 1) * kmod * 2) + weight,
    stop("Invalid `type` value. Please use `grinding` or `ballistic`", call. = FALSE)
  )
}
