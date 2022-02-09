#' Family of functions to estimate max number of repetition (nRM)
#'
#' @param perc_1RM Numeric vector. % 1RM used (use 0.5 for 50 %, 0.9 for 90 %)
#' @param k User defined \code{k} parameter in the Epley's equation. Default is 0.0333
#' @param kmod User defined \code{kmod} parameter in the Modified Epley's equation. Default is 0.0353
#' @param klin User defined \code{klin} parameter in the Linear equation. Default is 33
#' @return Numeric vector. Predicted maximal number of repetitions (nRM)
#' @name max_reps
NULL

#' @describeIn max_reps Estimate max number of repetition (nRM) using the Epley's equation
#' @export
#' @examples
#' # ------------------------------------------
#' # Epley equation
#' max_reps_epley(0.85)
#' max_reps_epley(c(0.75, 0.85), k = 0.04)
max_reps_epley <- function(perc_1RM, k = 0.0333) {
  (1 - perc_1RM) / (k * perc_1RM)
}

#' @describeIn max_reps Estimate max number of repetition (nRM) using the Modified Epley's equation
#' @export
#' @examples
#' # ------------------------------------------
#' # Modified Epley equation
#' max_reps_modified_epley(0.85)
#' max_reps_modified_epley(c(0.75, 0.85), kmod = 0.05)
max_reps_modified_epley <- function(perc_1RM, kmod = 0.0353) {
  ((kmod - 1) * perc_1RM + 1) / (kmod * perc_1RM)
}

#' @describeIn max_reps Estimate max number of repetition (nRM) using the Linear/Brzycki's equation
#' @export
#' @examples
#' # ------------------------------------------
#' # Linear/Brzycki's equation
#' max_reps_linear(0.85)
#' max_reps_linear(c(0.75, 0.85), klin = 36)
max_reps_linear <- function(perc_1RM, klin = 33) {
  (1 - perc_1RM) * klin + 1
}
