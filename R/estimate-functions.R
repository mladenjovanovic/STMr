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
#'     \code{1RM}. This is a novel estimation function that uses the absolute weights.
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
      nRM ~ (`0RM` - weight) / (k * weight),
      data =  df,
      start = list(k = 1, `0RM` = max(df$weight)),
      weights = df$reg_weights,
      ...
    )
  } else {
    m1 <- stats::nls(
      weight ~ `0RM` / (k * nRM + 1),
      data =  df,
      start = list(k = 1, `0RM` = max(df$weight)),
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
      nRM ~ ((kmod - 1) * weight + `1RM`) / (kmod * weight),
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

#' @describeIn estimate_functions Estimate the 1RM from \code{\link{estimate_k_1RM}} function
#'
#' The problem with Epley's estimation model (implemented in \code{\link{estimate_k_1RM}} function)
#'     is that it predicts the 1RM when nRM = 0. Thus, the estimated parameter in the model produced
#'     by the \code{\link{estimate_k_1RM}} function is not 1RM, but 0RM. This function calculates the
#'     weight at nRM = 1 for both the normal and reverse model. See Examples for code
#'
#' @param model Object returned from the  \code{\link{estimate_k_1RM}} function
#' @export
#' @examples
#' # ---------------------------------------------------------
#' # Estimating 1RM from Epley's model
#' m1 <- estimate_k_1RM(150 * c(0.9, 0.8, 0.7), c(3, 6, 12))
#' m2 <- estimate_k_1RM(150 * c(0.9, 0.8, 0.7), c(3, 6, 12), reverse = TRUE)
#'
#' # Estimated 0RM values from both model
#' c(coef(m1)[[1]], coef(m2)[[1]])
#'
#' # But these are not 1RMs!!!
#' # Using the "reverse" model, where nRM is the predictor (in this case m2)
#' # makes it easier to predict 1RM
#' predict(m2, newdata = data.frame(nRM = 1))
#'
#' # But for the normal model it involve reversing the formula
#' # To spare you from the math pain, use this
#' get_predicted_1RM_from_k_model(m1)
#'
#' # It also works for the "reverse" model
#' get_predicted_1RM_from_k_model(m2)
get_predicted_1RM_from_k_model <- function(model) {
  stats::coef(model)[[2]] / (stats::coef(model)[[1]] + 1)
}
