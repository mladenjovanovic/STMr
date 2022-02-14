#' Estimate relationship between reps and weight using the non-linear quantile regression
#'
#' These functions provide estimate 1RM and parameter values using the quantile regression. By default,
#' target variable is the reps performed, while the predictors is the \code{perc_1RM} or
#' \code{weight}. To reverse this, use the \code{reverse = TRUE} argument
#'
#' @param perc_1RM %1RM
#' @param weight Weight used
#' @param reps Number of repetitions done
#' @param eRIR Subjective estimation of reps-in-reserve (eRIR)
#' @param reverse Logical, default is \code{FALSE}. Should reps be used as predictor instead as a target?
#' @param tau Vector of quantiles to be estimated. Default is 0.5
#' @param control Control object for the \code{\link[quantreg]{nlrq}} function. Default is:
#'     \code{quantreg::nlrq.control(maxiter = 10^4, InitialStepSize = 0)}
#' @param ... Forwarded to \code{\link[quantreg]{nlrq}} function
#' @return \code{\link[quantreg]{nlrq}} object
#' @name estimate_functions_quantile
NULL

#' @describeIn estimate_functions_quantile Estimate the parameter \code{k} in the Epley's equation
#' @export
#' @examples
#' # ---------------------------------------------------------
#' # Epley's model
#' m1 <- estimate_k_quantile(
#'   perc_1RM = c(0.7, 0.8, 0.9),
#'   reps = c(10, 5, 3)
#' )
#'
#' coef(m1)
estimate_k_quantile <- function(perc_1RM,
                                reps,
                                eRIR = 0,
                                tau = 0.5,
                                reverse = FALSE,
                                control = quantreg::nlrq.control(maxiter = 10^4, InitialStepSize = 0),
                                ...) {
  df <- data.frame(perc_1RM = perc_1RM, reps = reps, eRIR = eRIR) %>%
    dplyr::mutate(
      nRM = reps + eRIR
    )

  if (reverse == FALSE) {
    m1 <- quantreg::nlrq(
      nRM ~ (1 - perc_1RM) / (k * perc_1RM),
      data =  df,
      start = list(k = 1),
      tau = tau,
      control = control,
      ...
    )
  } else {
    m1 <- quantreg::nlrq(
      perc_1RM ~ 1 / (k * nRM + 1),
      data =  df,
      start = list(k = 1),
      tau = tau,
      control = control,
      ...
    )
  }

  m1
}



#' @describeIn estimate_functions_quantile Estimate the parameter \code{k} in the Epley's equation, as well as
#'     \code{1RM}. This is a novel estimation function that uses the absolute weights
#' @export
#' @examples
#' # ---------------------------------------------------------
#' # Epley's model that also estimates 1RM
#' m1 <- estimate_k_1RM_quantile(
#'   weight = c(70, 110, 140),
#'   reps = c(10, 5, 3)
#' )
#'
#' coef(m1)
estimate_k_1RM_quantile <- function(weight,
                                    reps,
                                    eRIR = 0,
                                    tau = 0.5,
                                    reverse = FALSE,
                                    control = quantreg::nlrq.control(maxiter = 10^4, InitialStepSize = 0),
                                    ...) {
  df <- data.frame(weight = weight, reps = reps, eRIR = eRIR) %>%
    dplyr::mutate(
      nRM = reps + eRIR
    )

  if (reverse == FALSE) {
    m1 <- quantreg::nlrq(
      nRM ~ (k * `1RM` + `1RM` - weight) / (k * weight),
      data =  df,
      start = list(k = 1, `1RM` = max(df$weight)),
      tau = tau,
      control = control,
      ...
    )
  } else {
    m1 <- quantreg::nlrq(
      weight ~ ((k + 1) * `1RM`) / (k * nRM + 1),
      data =  df,
      start = list(k = 1, `1RM` = max(df$weight)),
      tau = tau,
      control = control,
      ...
    )
  }

  m1
}

#' @describeIn estimate_functions_quantile Estimate the parameter \code{kmod} in the modified Epley's equation
#' @export
#' @examples
#' # ---------------------------------------------------------
#' # Modified Epley's model
#' m1 <- estimate_kmod_quantile(
#'   perc_1RM = c(0.7, 0.8, 0.9),
#'   reps = c(10, 5, 3)
#' )
#'
#' coef(m1)
estimate_kmod_quantile <- function(perc_1RM,
                                   reps,
                                   eRIR = 0,
                                   tau = 0.5,
                                   reverse = FALSE,
                                   control = quantreg::nlrq.control(maxiter = 10^4, InitialStepSize = 0),
                                   ...) {
  df <- data.frame(perc_1RM = perc_1RM, reps = reps, eRIR = eRIR) %>%
    dplyr::mutate(
      nRM = reps + eRIR
    )

  if (reverse == FALSE) {
    m1 <- quantreg::nlrq(
      nRM ~ ((kmod - 1) * perc_1RM + 1) / (kmod * perc_1RM),
      data =  df,
      start = list(kmod = 1),
      tau = tau,
      control = control,
      ...
    )
  } else {
    m1 <- quantreg::nlrq(
      perc_1RM ~ 1 / (kmod * (nRM - 1) + 1),
      data =  df,
      start = list(kmod = 1),
      tau = tau,
      control = control,
      ...
    )
  }

  m1
}

#' @describeIn estimate_functions_quantile Estimate the parameter \code{kmod} in the modified Epley's equation, as well as
#'     \code{1RM}. This is a novel estimation function that uses the absolute weights
#' @export
#' @examples
#' # ---------------------------------------------------------
#' # Modified Epley's model that also estimates 1RM
#' m1 <- estimate_kmod_1RM_quantile(
#'   weight = c(70, 110, 140),
#'   reps = c(10, 5, 3)
#' )
#'
#' coef(m1)
estimate_kmod_1RM_quantile <- function(weight,
                                       reps,
                                       eRIR = 0,
                                       tau = 0.5,
                                       reverse = FALSE,
                                       control = quantreg::nlrq.control(maxiter = 10^4, InitialStepSize = 0),
                                       ...) {
  df <- data.frame(weight = weight, reps = reps, eRIR = eRIR) %>%
    dplyr::mutate(
      nRM = reps + eRIR
    )

  if (reverse == FALSE) {
    m1 <- quantreg::nlrq(
      nRM ~ (((weight / `1RM`) * (kmod - 1)) + 1) / (kmod * (weight / `1RM`)),
      data =  df,
      start = list(kmod = 1, `1RM` = max(df$weight)),
      tau = tau,
      control = control,
      ...
    )
  } else {
    m1 <- quantreg::nlrq(
      weight ~ `1RM` / (kmod * (nRM - 1) + 1),
      data =  df,
      start = list(kmod = 1, `1RM` = max(df$weight)),
      tau = tau,
      control = control,
      ...
    )
  }

  m1
}

#' @describeIn estimate_functions_quantile Estimate the parameter \code{klin} in the Linear/Brzycki equation
#' @export
#' @examples
#' # ---------------------------------------------------------
#' # Linear/Brzycki model
#' m1 <- estimate_klin_quantile(
#'   perc_1RM = c(0.7, 0.8, 0.9),
#'   reps = c(10, 5, 3)
#' )
#'
#' coef(m1)
estimate_klin_quantile <- function(perc_1RM,
                                   reps,
                                   eRIR = 0,
                                   tau = 0.5,
                                   reverse = FALSE,
                                   control = quantreg::nlrq.control(maxiter = 10^4, InitialStepSize = 0),
                                   ...) {
  df <- data.frame(perc_1RM = perc_1RM, reps = reps, eRIR = eRIR) %>%
    dplyr::mutate(
      nRM = reps + eRIR
    )

  if (reverse == FALSE) {
    m1 <- quantreg::nlrq(
      nRM ~ (1 - perc_1RM) * klin + 1,
      data =  df,
      start = list(klin = 1),
      tau = tau,
      control = control,
      ...
    )
  } else {
    m1 <- quantreg::nlrq(
      perc_1RM ~ (klin - nRM + 1) / klin,
      data =  df,
      start = list(klin = 1),
      tau = tau,
      control = control,
      ...
    )
  }

  m1
}

#' @describeIn estimate_functions_quantile Estimate the parameter \code{klin} in the Linear/Brzycki equation, as well as
#'     \code{1RM}. This is a novel estimation function that uses the absolute weights
#' @export
#' @examples
#' # ---------------------------------------------------------
#' # Linear/Brzycki model thal also estimates 1RM
#' m1 <- estimate_klin_1RM_quantile(
#'   weight = c(70, 110, 140),
#'   reps = c(10, 5, 3)
#' )
#'
#' coef(m1)
estimate_klin_1RM_quantile <- function(weight,
                                       reps,
                                       eRIR = 0,
                                       tau = 0.5,
                                       reverse = FALSE,
                                       control = quantreg::nlrq.control(maxiter = 10^4, InitialStepSize = 0),
                                       ...) {
  df <- data.frame(weight = weight, reps = reps, eRIR = eRIR) %>%
    dplyr::mutate(
      nRM = reps + eRIR
    )

  if (reverse == FALSE) {
    m1 <- quantreg::nlrq(
      nRM ~ (1 - (weight / `1RM`)) * klin + 1,
      data =  df,
      start = list(klin = 1, `1RM` = max(df$weight)),
      tau = tau,
      control = control,
      ...
    )
  } else {
    m1 <- quantreg::nlrq(
      weight ~ (`1RM` * (klin - nRM + 1)) / klin,
      data =  df,
      start = list(klin = 1, `1RM` = max(df$weight)),
      tau = tau,
      control = control,
      ...
    )
  }

  m1
}
