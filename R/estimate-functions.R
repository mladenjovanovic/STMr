#' Estimate relationship between reps and %1RM (or weight)
#'
#' By default, target variable is the reps performed, while the predictors is the \code{perc_1RM} or
#'       \code{weight}. To reverse this, use the \code{reverse = TRUE} argument
#'
#' @param weight Weight used
#' @param perc_1RM %1RM
#' @param reps Number of repetitions done
#' @param eRIR Subjective estimation of reps-in-reserve (eRIR)
#' @param reverse Logical, default is \code{FALSE}. Should reps be used as predictor instead as a target?
#' @param weighted What weighting should be used for the non-linear regression? Default is "none". Other options include:
#'     "reps" (for 1/reps weighting), "load" (for using weight or %1RM), "eRIR" (for 1/(eRIR+1) weighting),
#'     "reps x load", "reps x eRIR", "load x eRIR", and "reps x load x eRIR"
#' @param ... Forwarded to \code{\link[stats]{nls}} function
#' @return \code{\link[stats]{nls}} object
#' @name estimate_functions
NULL


#' @describeIn estimate_functions Estimate the parameter \code{k} in the Epley's equation
#' @export
#' @examples
#' # ---------------------------------------------------------
#' # Epley's model
#' m1 <- estimate_k(
#'   perc_1RM = c(0.7, 0.8, 0.9),
#'   reps = c(10, 5, 3)
#' )
#'
#' coef(m1)
estimate_k <- function(perc_1RM, reps, eRIR = 0, reverse = FALSE, weighted = "none", ...) {

  # Do checks
  check_weighting(weighted)

  df <- data.frame(perc_1RM = perc_1RM, reps = reps, eRIR = eRIR, weighted = weighted) %>%
    dplyr::mutate(
      nRM = reps + eRIR,
      reg_weights = get_weighting(weighted, reps, perc_1RM, eRIR)
    )

  if (reverse == FALSE) {
    m1 <- stats::nls(
      nRM ~ (1 - perc_1RM) / (k * perc_1RM),
      data =  df,
      start = list(k = 1),
      weights = df$reg_weights,
      ...
    )
  } else {
    m1 <- stats::nls(
      perc_1RM ~ 1 / (k * nRM + 1),
      data =  df,
      start = list(k = 1),
      weights = df$reg_weights,
      ...
    )
  }

  m1
}

#' @describeIn estimate_functions Estimate the parameter \code{k} in the Epley's equation, as well as
#'     \code{1RM}. This is a novel estimation function that uses the absolute weights
#' @export
#' @examples
#' # ---------------------------------------------------------
#' # Epley's model that also estimates 1RM
#' m1 <- estimate_k_1RM(
#'   weight = c(70, 110, 140),
#'   reps = c(10, 5, 3)
#' )
#'
#' coef(m1)
estimate_k_1RM <- function(weight, reps, eRIR = 0, reverse = FALSE, weighted = "none", ...) {

  # Do checks
  check_weighting(weighted)

  df <- data.frame(weight = weight, reps = reps, eRIR = eRIR, weighted = weighted) %>%
    dplyr::mutate(
      nRM = reps + eRIR,
      reg_weights = get_weighting(weighted, reps, weight, eRIR)
    )

  if (reverse == FALSE) {
    m1 <- stats::nls(
      nRM ~ (k * `1RM` + `1RM` - weight)/(k  * weight),
      data =  df,
      start = list(k = 1, `1RM` = max(df$weight)),
      weights = df$reg_weights,
      ...
    )
  } else {
    m1 <- stats::nls(
      weight ~ ((k + 1) * `1RM`)/(k * nRM + 1),
      data =  df,
      start = list(k = 1, `1RM` = max(df$weight)),
      weights = df$reg_weights,
      ...
    )
  }

  m1
}

#' @describeIn estimate_functions Estimate the parameter \code{kmod} in the modified Epley's equation
#' @export
#' @examples
#' # ---------------------------------------------------------
#' # Modified Epley's model
#' m1 <- estimate_kmod(
#'   perc_1RM = c(0.7, 0.8, 0.9),
#'   reps = c(10, 5, 3)
#' )
#'
#' coef(m1)
estimate_kmod <- function(perc_1RM, reps, eRIR = 0, reverse = FALSE, weighted = "none", ...) {

  # Do checks
  check_weighting(weighted)

  df <- data.frame(perc_1RM = perc_1RM, reps = reps, eRIR = eRIR, weighted = weighted) %>%
    dplyr::mutate(
      nRM = reps + eRIR,
      reg_weights = get_weighting(weighted, reps, perc_1RM, eRIR)
    )

  if (reverse == FALSE) {
    m1 <- stats::nls(
      nRM ~ ((kmod - 1) * perc_1RM + 1) / (kmod * perc_1RM),
      data =  df,
      start = list(kmod = 1),
      weights = df$reg_weights,
      ...
    )
  } else {
    m1 <- stats::nls(
      perc_1RM ~ 1 / (kmod * (nRM - 1) + 1),
      data =  df,
      start = list(kmod = 1),
      weights = df$reg_weights,
      ...
    )
  }

  m1
}

#' @describeIn estimate_functions Estimate the parameter \code{kmod} in the modified Epley's equation, as well as
#'     \code{1RM}. This is a novel estimation function that uses the absolute weights
#' @export
#' @examples
#' # ---------------------------------------------------------
#' # Modified Epley's model that also estimates 1RM
#' m1 <- estimate_kmod_1RM(
#'   weight = c(70, 110, 140),
#'   reps = c(10, 5, 3)
#' )
#'
#' coef(m1)
estimate_kmod_1RM <- function(weight, reps, eRIR = 0, reverse = FALSE, weighted = "none", ...) {

  # Do checks
  check_weighting(weighted)

  df <- data.frame(weight = weight, reps = reps, eRIR = eRIR, weighted = weighted) %>%
    dplyr::mutate(
      nRM = reps + eRIR,
      reg_weights = get_weighting(weighted, reps, weight, eRIR)
    )

  if (reverse == FALSE) {
    m1 <- stats::nls(
      nRM ~ (((weight / `1RM`) * (kmod - 1)) + 1) / (kmod * (weight / `1RM`)),
      data =  df,
      start = list(kmod = 1, `1RM` = max(df$weight)),
      weights = df$reg_weights,
      ...
    )
  } else {
    m1 <- stats::nls(
      weight ~ `1RM` / (kmod * (nRM - 1) + 1),
      data =  df,
      start = list(kmod = 1, `1RM` = max(df$weight)),
      weights = df$reg_weights,
      ...
    )
  }


  m1
}

#' @describeIn estimate_functions Estimate the parameter \code{klin} using the Linear/Brzycki model
#' @export
#' @examples
#' # ---------------------------------------------------------
#' # Linear/Brzycki model
#' m1 <- estimate_klin(
#'   perc_1RM = c(0.7, 0.8, 0.9),
#'   reps = c(10, 5, 3)
#' )
#'
#' coef(m1)
estimate_klin <- function(perc_1RM, reps, eRIR = 0, reverse = FALSE, weighted = "none", ...) {

  # Do checks
  check_weighting(weighted)

  df <- data.frame(perc_1RM = perc_1RM, reps = reps, eRIR = eRIR, weighted = weighted) %>%
    dplyr::mutate(
      nRM = reps + eRIR,
      reg_weights = get_weighting(weighted, reps, perc_1RM, eRIR)
    )

  if (reverse == FALSE) {
    m1 <- stats::nls(
      nRM ~ (1 - perc_1RM) * klin + 1,
      data =  df,
      start = list(klin = 1),
      weights = df$reg_weights,
      ...
    )
  } else {
    m1 <- stats::nls(
      perc_1RM ~ (klin - nRM + 1) / klin,
      data =  df,
      start = list(klin = 1),
      weights = df$reg_weights,
      ...
    )
  }


  m1
}

#' @describeIn estimate_functions Estimate the parameter \code{klin} in the Linear/Brzycki equation, as well as
#'     \code{1RM}. This is a novel estimation function that uses the absolute weights
#' @export
#' @examples
#' # ---------------------------------------------------------
#' # Linear/Brzycki model thal also estimates 1RM
#' m1 <- estimate_klin_1RM(
#'   weight = c(70, 110, 140),
#'   reps = c(10, 5, 3)
#' )
#'
#' coef(m1)
estimate_klin_1RM <- function(weight, reps, eRIR = 0, reverse = FALSE, weighted = "none", ...) {

  # Do checks
  check_weighting(weighted)

  df <- data.frame(weight = weight, reps = reps, eRIR = eRIR, weighted = weighted) %>%
    dplyr::mutate(
      nRM = reps + eRIR,
      reg_weights = get_weighting(weighted, reps, weight, eRIR)
    )

  if (reverse == FALSE) {
    m1 <- stats::nls(
      nRM ~ (1 - (weight / `1RM`)) * klin + 1,
      data =  df,
      start = list(klin = 1, `1RM` = max(df$weight)),
      weights = df$reg_weights,
      ...
    )
  } else {
    m1 <- stats::nls(
      weight ~ (`1RM` * (klin - nRM + 1)) / klin,
      data =  df,
      start = list(klin = 1, `1RM` = max(df$weight)),
      weights = df$reg_weights,
      ...
    )
  }

  m1
}
