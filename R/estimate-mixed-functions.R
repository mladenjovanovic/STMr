#' Estimate relationship between reps and weight using the non-linear mixed-effects regression
#'
#' These functions provide estimated 1RM and parameter values using the mixed-effect regression. By default,
#' target variable is the reps performed, while the predictor is the \code{perc_1RM} or
#' \code{weight}. To reverse this, use the \code{reverse = TRUE} argument
#'
#' @param athlete Athlete identifier
#' @param perc_1RM %1RM
#' @param weight Weight used
#' @param reps Number of repetitions done
#' @param eRIR Subjective estimation of reps-in-reserve (eRIR)
#' @param reverse Logical, default is \code{FALSE}. Should reps be used as predictor instead as a target?
#' @param random Random parameter forwarded to \code{\link[nlme]{nlme}} function. Default is \code{k + zeroRM ~ 1} for,
#'     \code{\link{estimate_k_mixed}} function, or \code{k + oneRM ~ 1} for \code{\link{estimate_kmod_mixed}} and
#'     \code{\link{estimate_klin_mixed}} functions
#' @param ... Forwarded to \code{\link[nlme]{nlme}} function
#' @return \code{\link[nlme]{nlme}} object
#' @name estimate_functions_mixed
NULL

#' @describeIn estimate_functions_mixed Estimate the parameter \code{k} in the Epley's equation
#' @export
#' @examples
#' # ---------------------------------------------------------
#' # Epley's model
#' m1 <- estimate_k_mixed(
#'   athlete = RTF_testing$Athlete,
#'   perc_1RM = RTF_testing$`Real %1RM`,
#'   reps = RTF_testing$nRM
#' )
#'
#' coef(m1)
estimate_k_mixed <- function(athlete,
                             perc_1RM,
                             reps,
                             eRIR = 0,
                             reverse = FALSE,
                             ...) {
  df <- data.frame(athlete = athlete, perc_1RM = perc_1RM, reps = reps, eRIR = eRIR) %>%
    dplyr::mutate(
      nRM = reps + eRIR
    )

  if (reverse == FALSE) {
    m1 <- nlme::nlme(
      nRM ~ (1 - perc_1RM) / (k * perc_1RM),
      data = df,
      start = c(k = 1),
      groups = ~athlete,
      fixed = k ~ 1,
      random = k ~ 1,
      ...
    )
  } else {
    m1 <- nlme::nlme(
      perc_1RM ~ 1 / (k * nRM + 1),
      data = df,
      start = c(k = 1),
      groups = ~athlete,
      fixed = k ~ 1,
      random = k ~ 1,
      ...
    )
  }

  m1
}

#' @describeIn estimate_functions_mixed Provides the model with generic \code{k} parameter, as well as
#'     estimated \code{1RM}. This is a novel estimation function that uses the absolute weights
#' @param k Value for the generic Epley's equation, which is by default equal to 0.0333
#' @export
#' @examples
#' # ---------------------------------------------------------
#' # Generic Epley's model that also estimates 1RM
#' m1 <- estimate_k_generic_1RM_mixed(
#'   athlete = RTF_testing$Athlete,
#'   weight = RTF_testing$`Real Weight`,
#'   reps = RTF_testing$nRM
#' )
#'
#' coef(m1)
estimate_k_generic_1RM_mixed <- function(athlete,
                                         weight,
                                         reps,
                                         eRIR = 0,
                                         k = 0.0333,
                                         reverse = FALSE,
                                         random = zeroRM ~ 1,
                                         ...) {
  df <- data.frame(athlete = athlete, weight = weight, reps = reps, eRIR = eRIR) %>%
    dplyr::mutate(
      nRM = reps + eRIR,
      k = k
    )

  if (reverse == FALSE) {
    m1 <- nlme::nlme(
      nRM ~ (zeroRM - weight) / (k * weight),
      data = df,
      start = c(zeroRM = max(df$weight)),
      groups = ~athlete,
      fixed = zeroRM ~ 1,
      random = random,
      ...
    )
  } else {
    m1 <- nlme::nlme(
      weight ~ zeroRM / (k * nRM + 1),
      data = df,
      start = c(zeroRM = max(df$weight)),
      groups = ~athlete,
      fixed = zeroRM ~ 1,
      random = random,
      ...
    )
  }

  m1
}


#' @describeIn estimate_functions_mixed Estimate the parameter \code{k} in the Epley's equation, as well as
#'     \code{1RM}. This is a novel estimation function that uses the absolute weights
#' @export
#' @examples
#' # ---------------------------------------------------------
#' # Epley's model that also estimates 1RM
#' m1 <- estimate_k_1RM_mixed(
#'   athlete = RTF_testing$Athlete,
#'   weight = RTF_testing$`Real Weight`,
#'   reps = RTF_testing$nRM
#' )
#'
#' coef(m1)
estimate_k_1RM_mixed <- function(athlete,
                                 weight,
                                 reps,
                                 eRIR = 0,
                                 reverse = FALSE,
                                 random = k + zeroRM ~ 1,
                                 ...) {
  df <- data.frame(athlete = athlete, weight = weight, reps = reps, eRIR = eRIR) %>%
    dplyr::mutate(
      nRM = reps + eRIR
    )

  if (reverse == FALSE) {
    m1 <- nlme::nlme(
      nRM ~ (zeroRM - weight) / (k * weight),
      data = df,
      start = c(k = 1, zeroRM = max(df$weight)),
      groups = ~athlete,
      fixed = k + zeroRM ~ 1,
      random = random,
      ...
    )
  } else {
    m1 <- nlme::nlme(
      weight ~ zeroRM / (k * nRM + 1),
      data = df,
      start = c(k = 1, zeroRM = max(df$weight)),
      groups = ~athlete,
      fixed = k + zeroRM ~ 1,
      random = random,
      ...
    )
  }

  m1
}

#' @describeIn estimate_functions_mixed Estimate the parameter \code{kmod} in the Modified Epley's equation
#' @export
#' @examples
#' # ---------------------------------------------------------
#' # Modifed Epley's model
#' m1 <- estimate_kmod_mixed(
#'   athlete = RTF_testing$Athlete,
#'   perc_1RM = RTF_testing$`Real %1RM`,
#'   reps = RTF_testing$nRM
#' )
#'
#' coef(m1)
estimate_kmod_mixed <- function(athlete,
                                perc_1RM,
                                reps,
                                eRIR = 0,
                                reverse = FALSE,
                                ...) {
  df <- data.frame(athlete = athlete, perc_1RM = perc_1RM, reps = reps, eRIR = eRIR) %>%
    dplyr::mutate(
      nRM = reps + eRIR
    )

  if (reverse == FALSE) {
    m1 <- nlme::nlme(
      nRM ~ ((kmod - 1) * perc_1RM + 1) / (kmod * perc_1RM),
      data = df,
      start = c(kmod = 1),
      groups = ~athlete,
      fixed = kmod ~ 1,
      random = kmod ~ 1,
      ...
    )
  } else {
    m1 <- nlme::nlme(
      perc_1RM ~ 1 / (kmod * (nRM - 1) + 1),
      data = df,
      start = c(kmod = 1),
      groups = ~athlete,
      fixed = kmod ~ 1,
      random = kmod ~ 1,
      ...
    )
  }

  m1
}

#' @describeIn estimate_functions_mixed Estimate the parameter \code{kmod} in the Modified Epley's equation, as well as
#'     \code{1RM}. This is a novel estimation function that uses the absolute weights
#' @export
#' @examples
#' # ---------------------------------------------------------
#' # Modified Epley's model that also estimates 1RM
#' m1 <- estimate_kmod_1RM_mixed(
#'   athlete = RTF_testing$Athlete,
#'   weight = RTF_testing$`Real Weight`,
#'   reps = RTF_testing$nRM
#' )
#'
#' coef(m1)
estimate_kmod_1RM_mixed <- function(athlete,
                                    weight,
                                    reps,
                                    eRIR = 0,
                                    reverse = FALSE,
                                    random = kmod + oneRM ~ 1,
                                    ...) {
  df <- data.frame(athlete = athlete, weight = weight, reps = reps, eRIR = eRIR) %>%
    dplyr::mutate(
      nRM = reps + eRIR
    )

  if (reverse == FALSE) {
    m1 <- nlme::nlme(
      nRM ~ ((kmod - 1) * weight + oneRM) / (kmod * weight),
      data = df,
      start = c(kmod = 1, oneRM = max(df$weight)),
      groups = ~athlete,
      fixed = kmod + oneRM ~ 1,
      random = random,
      ...
    )
  } else {
    m1 <- nlme::nlme(
      weight ~ oneRM / (kmod * (nRM - 1) + 1),
      data = df,
      start = c(kmod = 1, oneRM = max(df$weight)),
      groups = ~athlete,
      fixed = kmod + oneRM ~ 1,
      random = random,
      ...
    )
  }

  m1
}

#' @describeIn estimate_functions_mixed Estimate the parameter \code{klin} in the Linear/Brzycki's equation
#' @export
#' @examples
#' # ---------------------------------------------------------
#' # Linear/Brzycki model
#' m1 <- estimate_klin_mixed(
#'   athlete = RTF_testing$Athlete,
#'   perc_1RM = RTF_testing$`Real %1RM`,
#'   reps = RTF_testing$nRM
#' )
#'
#' coef(m1)
estimate_klin_mixed <- function(athlete,
                                perc_1RM,
                                reps,
                                eRIR = 0,
                                reverse = FALSE,
                                ...) {
  df <- data.frame(athlete = athlete, perc_1RM = perc_1RM, reps = reps, eRIR = eRIR) %>%
    dplyr::mutate(
      nRM = reps + eRIR
    )

  if (reverse == FALSE) {
    m1 <- nlme::nlme(
      nRM ~ (1 - perc_1RM) * klin + 1,
      data = df,
      start = c(klin = 1),
      groups = ~athlete,
      fixed = klin ~ 1,
      random = klin ~ 1,
      ...
    )
  } else {
    m1 <- nlme::nlme(
      perc_1RM ~ (klin - nRM + 1) / klin,
      data = df,
      start = c(klin = 1),
      groups = ~athlete,
      fixed = klin ~ 1,
      random = klin ~ 1,
      ...
    )
  }

  m1
}

#' @describeIn estimate_functions_mixed Estimate the parameter \code{klin} in the Linear/Brzycki equation, as well as
#'     \code{1RM}. This is a novel estimation function that uses the absolute weights
#' @export
#' @examples
#' # ---------------------------------------------------------
#' # Linear/Brzycki model that also estimates 1RM
#' m1 <- estimate_klin_1RM_mixed(
#'   athlete = RTF_testing$Athlete,
#'   weight = RTF_testing$`Real Weight`,
#'   reps = RTF_testing$nRM
#' )
#'
#' coef(m1)
estimate_klin_1RM_mixed <- function(athlete,
                                    weight,
                                    reps,
                                    eRIR = 0,
                                    reverse = FALSE,
                                    random = klin + oneRM ~ 1,
                                    ...) {
  df <- data.frame(athlete = athlete, weight = weight, reps = reps, eRIR = eRIR) %>%
    dplyr::mutate(
      nRM = reps + eRIR
    )

  if (reverse == FALSE) {
    m1 <- nlme::nlme(
      nRM ~ (1 - (weight / oneRM)) * klin + 1,
      data = df,
      start = c(klin = 1, oneRM = max(df$weight)),
      groups = ~athlete,
      fixed = klin + oneRM ~ 1,
      random = random,
      ...
    )
  } else {
    m1 <- nlme::nlme(
      weight ~ (oneRM * (klin - nRM + 1)) / klin,
      data = df,
      start = c(klin = 1, oneRM = max(df$weight)),
      groups = ~athlete,
      fixed = klin + oneRM ~ 1,
      random = random,
      ...
    )
  }

  m1
}
