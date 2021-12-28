#' Estimate relationship between reps and %1RM used using Epley's and modified
#'     Epley's equation, as well as using the linear model.
#'
#' By default, target variable is the reps performed, while the predictors is the \code{perc_1RM} or
#'       \code{weight}. To reverse this, use the \code{reverse = TRUE} argument
#'
#' @param weight Weight used
#' @param perc_1RM Percent of 1RM
#' @param reps Number of repetitions done
#' @param adjustment Subjective estimation of reps-in-reserve (eRIR)
#' @param reverse Logical, default is \code{FALSE}. Should reps be used as predictor instead as a target?
#' @param ... Forwarded to \code{\link[stats]{nls}} functions
#' @return \code{\link[stats]{nls}} object
#' @name estimate_functions
NULL


#' @describeIn estimate_functions Estimate the parameter \code{k} in the Epley's equation
#' @export
#' @examples
#'
#' m1 <- estimate_k(
#'   perc_1RM = c(0.7, 0.8, 0.9),
#'   reps = c(10, 5, 3)
#' )
#'
#' coef(m1)
estimate_k <- function(perc_1RM, reps, adjustment = 0, reverse = FALSE, ...) {
  df <- data.frame(perc_1RM = perc_1RM, reps = reps, adjustment = adjustment)

  df$nRM <- df$reps + df$adjustment

  if (reverse == FALSE) {
    m1 <- stats::nls(
      nRM ~ (1 - perc_1RM) / (k * perc_1RM),
      data =  df,
      start = list(k = 1),
      ...
    )
  } else {
    m1 <- stats::nls(
      perc_1RM ~ 1 / (k * nRM + 1),
      data =  df,
      start = list(k = 1),
      ...
    )
  }

  m1
}

#' @describeIn estimate_functions Estimate the parameter \code{kmod} in the modified Epley's equation
#' @export
#' @examples
#'
#' m1 <- estimate_kmod(
#'   perc_1RM = c(0.7, 0.8, 0.9),
#'   reps = c(10, 5, 3)
#' )
#'
#' coef(m1)
estimate_kmod <- function(perc_1RM, reps, adjustment = 0, reverse = FALSE, ...) {
  df <- data.frame(perc_1RM = perc_1RM, reps = reps, adjustment = adjustment)

  df$nRM <- df$reps + df$adjustment

  if (reverse == FALSE) {
    m1 <- stats::nls(
      nRM ~ ((kmod - 1) * perc_1RM + 1) / (kmod * perc_1RM),
      data =  df,
      start = list(kmod = 1),
      ...
    )
  } else {
    m1 <- stats::nls(
      perc_1RM ~ 1 / (kmod * (nRM - 1) + 1),
      data =  df,
      start = list(kmod = 1),
      ...
    )
  }

  m1
}

#' @describeIn estimate_functions Estimate the parameter \code{k} in the Epley's equation, as well as
#'     \code{1RM}. This is a novel estimation function that uses the absolute weights
#' @export
#' @examples
#'
#' m1 <- estimate_k_1RM(
#'   weight = c(70, 110, 140),
#'   reps = c(10, 5, 3)
#' )
#'
#' coef(m1)
estimate_k_1RM <- function(weight, reps, adjustment = 0, reverse = FALSE, ...) {
  df <- data.frame(weight = weight, reps = reps, adjustment = adjustment)

  df$nRM <- df$reps + df$adjustment

  if (reverse == FALSE) {
    m1 <- stats::nls(
      nRM ~ ((1 / k) / (weight / `1RM`)) - (1 / k),
      data =  df,
      start = list(`1RM` = max(weight), k = 1),
      ...
    )
  } else {
    m1 <- stats::nls(
      weight ~ `1RM` / (k * nRM + 1),
      data =  df,
      start = list(`1RM` = max(weight), k = 1),
      ...
    )
  }

  m1
}

#' @describeIn estimate_functions Estimate the parameter \code{kmod} in the modified Epley's equation, as well as
#'     \code{1RM}. This is a novel estimation function that uses the absolute weights
#' @export
#' @examples
#'
#' m1 <- estimate_kmod_1RM(
#'   weight = c(70, 110, 140),
#'   reps = c(10, 5, 3)
#' )
#'
#' coef(m1)
estimate_kmod_1RM <- function(weight, reps, adjustment = 0, reverse = FALSE, ...) {
  df <- data.frame(weight = weight, reps = reps, adjustment = adjustment)

  df$nRM <- df$reps + df$adjustment

  if (reverse == FALSE) {
    m1 <- stats::nls(
      nRM ~ (((weight / `1RM`) * (kmod - 1)) + 1) / (kmod * (weight / `1RM`)),
      data =  df,
      start = list(`1RM` = max(weight), kmod = 1),
      ...
    )
  } else {
    m1 <- stats::nls(
      weight ~ `1RM` / (kmod * (nRM - 1) + 1),
      data =  df,
      start = list(`1RM` = max(weight), kmod = 1),
      ...
    )
  }


  m1
}

#' @describeIn estimate_functions Estimate the parameter \code{klin} using the linear model
#' @export
#' @examples
#'
#' m1 <- estimate_klin(
#'   perc_1RM = c(0.7, 0.8, 0.9),
#'   reps = c(10, 5, 3)
#' )
#'
#' coef(m1)
estimate_klin <- function(perc_1RM, reps, adjustment = 0, reverse = FALSE, ...) {
  df <- data.frame(perc_1RM = perc_1RM, reps = reps, adjustment = adjustment)

  df$nRM <- df$reps + df$adjustment

  if (reverse == FALSE) {
    m1 <- stats::nls(
      nRM ~ (1 - perc_1RM) * klin + 1,
      data =  df,
      start = list(klin = 1),
      ...
    )
  } else {
    m1 <- stats::nls(
      perc_1RM ~ (klin - nRM + 1) / klin,
      data =  df,
      start = list(klin = 1),
      ...
    )
  }


  m1
}

#' @describeIn estimate_functions Estimate the parameter \code{klin} in the linear equation, as well as
#'     \code{1RM}. This is a novel estimation function that uses the absolute weights
#' @export
#' @examples
#'
#' m1 <- estimate_klin_1RM(
#'   weight = c(70, 110, 140),
#'   reps = c(10, 5, 3)
#' )
#'
#' coef(m1)
estimate_klin_1RM <- function(weight, reps, adjustment = 0, reverse = FALSE, ...) {
  df <- data.frame(weight = weight, reps = reps, adjustment = adjustment)

  df$nRM <- df$reps + df$adjustment

  if (reverse == FALSE) {
    m1 <- stats::nls(
      nRM ~ (1 - (weight / `1RM`)) * klin + 1,
      data =  df,
      start = list(`1RM` = max(weight), klin = 1),
      ...
    )
  } else {
    m1 <- stats::nls(
      weight ~ (`1RM` * (klin - nRM + 1)) / klin,
      data =  df,
      start = list(`1RM` = max(weight), klin = 1),
      ...
    )
  }

  m1
}
