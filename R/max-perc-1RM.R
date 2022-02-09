#' Family of functions to estimate max %1RM
#'
#' @param reps Numeric vector. Number of repetition to be performed
#' @param k User defined \code{k} parameter in the Epley's equation. Default is 0.0333
#' @param kmod User defined \code{kmod} parameter in the Modified Epley's equation. Default is 0.0353
#' @param klin User defined \code{klin} parameter in the Linear equation. Default is 33
#' @return Numeric vector. Predicted %1RM
#' @name max_perc_1RM
NULL

#' @describeIn max_perc_1RM Estimate max %1RM using the Epley's equation
#' @export
#' @examples
#' # ------------------------------------------
#' # Epley equation
#' max_perc_1RM_epley(1:10)
#' max_perc_1RM_epley(1:10, k = 0.04)
max_perc_1RM_epley <- function(reps, k = 0.0333) {
  1 / (k * reps + 1)
}

#' @describeIn max_perc_1RM Estimate max %1RM using the Modified Epley's equation
#' @export
#' @examples
#' # ------------------------------------------
#' # Modified Epley equation
#' max_perc_1RM_modified_epley(1:10)
#' max_perc_1RM_modified_epley(1:10, kmod = 0.05)
max_perc_1RM_modified_epley <- function(reps, kmod = 0.0353) {
  1 / (kmod * (reps - 1) + 1)
}

#' @describeIn max_perc_1RM Estimate max %1RM using the Linear (or Brzycki's) equation
#' @export
#' @examples
#' # ------------------------------------------
#' # Linear/Brzycki equation
#' max_perc_1RM_linear(1:10)
#' max_perc_1RM_linear(1:10, klin = 36)
max_perc_1RM_linear <- function(reps, klin = 33) {
  (klin - reps + 1) / klin
}
