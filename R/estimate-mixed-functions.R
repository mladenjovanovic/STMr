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
#' @param weighted What weighting should be used for the non-linear regression? Default is "none". Other options include:
#'     "reps" (for 1/reps weighting), "load" (for using weight or %1RM), "eRIR" (for 1/(eRIR+1) weighting),
#'     "reps x load", "reps x eRIR", "load x eRIR", and "reps x load x eRIR"
#' @param random Random parameter forwarded to \code{\link[nlme]{nlme}} function. Default is \code{k + zeroRM ~ 1}
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
                             weighted = "none",
                             ...) {

  # Do checks
  check_weighting(weighted)

  df <- data.frame(athlete = athlete, perc_1RM = perc_1RM, reps = reps, eRIR = eRIR, weighted = weighted) %>%
    dplyr::mutate(
      nRM = reps + eRIR,
      reg_weights = get_weighting(weighted, reps, perc_1RM, eRIR)
    )

  if (reverse == FALSE) {
    m1 <- nlme::nlme(
      nRM ~ (1 - perc_1RM) / (k * perc_1RM),
      data =  df,
      start = c(k = 1),
      groups = ~athlete,
      fixed = k ~ 1,
      random = k ~ 1,
      weights = ~reg_weights,
      ...
    )
  } else {
    m1 <- nlme::nlme(
      perc_1RM ~ 1 / (k * nRM + 1),
      data =  df,
      start = c(k = 1),
      groups = ~athlete,
      fixed = k ~ 1,
      random = k ~ 1,
      weights = ~reg_weights,
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
                                 weighted = "none",
                                 random = k + zeroRM ~ 1,
                                 ...) {

  # Do checks
  check_weighting(weighted)

  df <- data.frame(athlete = athlete, weight = weight, reps = reps, eRIR = eRIR, weighted = weighted) %>%
    dplyr::mutate(
      nRM = reps + eRIR,
      reg_weights = get_weighting(weighted, reps, weight, eRIR)
    )

  if (reverse == FALSE) {
    m1 <- nlme::nlme(
      nRM ~ ((1 / k) / (weight / zeroRM)) - (1 / k),
      data =  df,
      start = c(k = 1, zeroRM = max(df$weight)),
      groups = ~athlete,
      fixed = k + zeroRM ~ 1,
      random = random,
      weights = ~reg_weights,
      ...
    )
  } else {
    m1 <- nlme::nlme(
      weight ~ zeroRM / (k * nRM + 1),
      data =  df,
      start = c(k = 1, zeroRM = max(df$weight)),
      groups = ~athlete,
      fixed = k + zeroRM ~ 1,
      random = random,
      weights = ~reg_weights,
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
                                weighted = "none",
                                ...) {

  # Do checks
  check_weighting(weighted)

  df <- data.frame(athlete = athlete, perc_1RM = perc_1RM, reps = reps, eRIR = eRIR, weighted = weighted) %>%
    dplyr::mutate(
      nRM = reps + eRIR,
      reg_weights = get_weighting(weighted, reps, perc_1RM, eRIR)
    )

  if (reverse == FALSE) {
    m1 <- nlme::nlme(
      nRM ~ ((kmod - 1) * perc_1RM + 1) / (kmod * perc_1RM),
      data =  df,
      start = c(kmod = 1),
      groups = ~athlete,
      fixed = kmod ~ 1,
      random = kmod ~ 1,
      weights = ~reg_weights,
      ...
    )
  } else {
    m1 <- nlme::nlme(
      perc_1RM ~ 1 / (kmod * (nRM - 1) + 1),
      data =  df,
      start = c(kmod = 1),
      groups = ~athlete,
      fixed = kmod ~ 1,
      random = kmod ~ 1,
      weights = ~reg_weights,
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
                                    weighted = "none",
                                    random = kmod + oneRM ~ 1,
                                    ...) {

  # Do checks
  check_weighting(weighted)

  df <- data.frame(athlete = athlete, weight = weight, reps = reps, eRIR = eRIR, weighted = weighted) %>%
    dplyr::mutate(
      nRM = reps + eRIR,
      reg_weights = get_weighting(weighted, reps, weight, eRIR)
    )

  if (reverse == FALSE) {
    m1 <- nlme::nlme(
      nRM ~ (((weight / oneRM) * (kmod - 1)) + 1) / (kmod * (weight / oneRM)),
      data =  df,
      start = c(kmod = 1, oneRM = max(df$weight)),
      groups = ~athlete,
      fixed = kmod + oneRM ~ 1,
      random = random,
      weights = ~reg_weights,
      ...
    )
  } else {
    m1 <- nlme::nlme(
      weight ~ oneRM / (kmod * (nRM - 1) + 1),
      data =  df,
      start = c(kmod = 1, oneRM = max(df$weight)),
      groups = ~athlete,
      fixed = kmod + oneRM ~ 1,
      random = random,
      weights = ~reg_weights,
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
                                weighted = "none",
                                ...) {

  # Do checks
  check_weighting(weighted)

  df <- data.frame(athlete = athlete, perc_1RM = perc_1RM, reps = reps, eRIR = eRIR, weighted = weighted) %>%
    dplyr::mutate(
      nRM = reps + eRIR,
      reg_weights = get_weighting(weighted, reps, perc_1RM, eRIR)
    )

  if (reverse == FALSE) {
    m1 <- nlme::nlme(
      nRM ~ (1 - perc_1RM) * klin + 1,
      data =  df,
      start = c(klin = 1),
      groups = ~athlete,
      fixed = klin ~ 1,
      random = klin ~ 1,
      weights = ~reg_weights,
      ...
    )
  } else {
    m1 <- nlme::nlme(
      perc_1RM ~ (klin - nRM + 1) / klin,
      data =  df,
      start = c(klin = 1),
      groups = ~athlete,
      fixed = klin ~ 1,
      random = klin ~ 1,
      weights = ~reg_weights,
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
                                    weighted = "none",
                                    random = klin + oneRM ~ 1,
                                    ...) {

  # Do checks
  check_weighting(weighted)

  df <- data.frame(athlete = athlete, weight = weight, reps = reps, eRIR = eRIR, weighted = weighted) %>%
    dplyr::mutate(
      nRM = reps + eRIR,
      reg_weights = get_weighting(weighted, reps, weight, eRIR)
    )

  if (reverse == FALSE) {
    m1 <- nlme::nlme(
      nRM ~ (1 - (weight / oneRM)) * klin + 1,
      data =  df,
      start = c(klin = 1, oneRM = max(df$weight)),
      groups = ~athlete,
      fixed = klin + oneRM ~ 1,
      random = random,
      weights = ~reg_weights,
      ...
    )
  } else {
    m1 <- nlme::nlme(
      weight ~ (oneRM * (klin - nRM + 1)) / klin,
      data =  df,
      start = c(klin = 1, oneRM = max(df$weight)),
      groups = ~athlete,
      fixed = klin + oneRM ~ 1,
      random = random,
      weights = ~reg_weights,
      ...
    )
  }

  m1
}
