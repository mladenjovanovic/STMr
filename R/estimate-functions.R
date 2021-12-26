#' Estimate relationship between reps and %1RM used using Epley's and modified
#'     Epley's equation
#' @param perc_1RM Percent of 1RM
#' @param reps Number of repetitions done
#' @param adjustment Adjustment to be implemented, specific to the method
#' @param ... Forwarded to \code{\link[stats]{nls}} functions
#' @return \code{\link[stats]{nls}} object
#' @name estimate_functions
NULL


#' @describeIn estimate_functions Estimate the parameter k in the Epley's equation
#' @export
#' @examples
#'
#' m1 <- estimate_k(
#'   perc_1RM = c(0.7, 0.8, 0.9),
#'   reps = c(10, 5, 3)
#' )
#'
#' coef(m1)
estimate_k <- function(perc_1RM, reps, adjustment = 0, ...) {
  df <- data.frame(perc_1RM = perc_1RM, reps = reps, adjustment = adjustment)

  df$nRM <- df$reps + df$adjustment

  m1 <- stats::nls(
    nRM ~ (1 - perc_1RM) / (k * perc_1RM),
    data =  df,
    start = list(k = 1),
    ...
  )

  m1
}

#' @describeIn estimate_functions Estimate the parameter kmod in the modified Epley's equation
#' @export
#' @examples
#'
#' m1 <- estimate_kmod(
#'   perc_1RM = c(0.7, 0.8, 0.9),
#'   reps = c(10, 5, 3)
#' )
#'
#' coef(m1)
estimate_kmod <- function(perc_1RM, reps, adjustment = 0, ...) {
  df <- data.frame(perc_1RM = perc_1RM, reps = reps, adjustment = adjustment)

  df$nRM <- df$reps + df$adjustment

  m1 <- stats::nls(
    nRM ~ ((kmod - 1) * perc_1RM + 1) / (kmod * perc_1RM),
    data =  df,
    start = list(kmod = 1),
    ...
  )

  m1
}
