#' Estimate the rolling profile and 1RM
#' @param weight Weight used
#' @param reps Number of repetitions done
#' @param eRIR Subjective estimation of reps-in-reserve (eRIR)
#' @param day_index Day index used to estimate rolling window
#' @param window Width of the rolling window. Default is 14
#' @param estimate_function Estimation function to be used. Default is
#'     \code{\link{estimate_k_1RM}}
#' @param ... Forwarded to \code{estimate_function} function
#' @return Data frame with day index and coefficients returned by the \code{estimate_function} function
#' @export
#' @examples
#' estimate_rolling_1RM(
#'   weight = strength_training_log$weight,
#'   reps = strength_training_log$reps,
#'   eRIR = strength_training_log$eRIR,
#'   day_index = strength_training_log$day,
#'   window = 10,
#'   estimate_function = estimate_k_1RM_quantile,
#'   tau = 0.9
#' )
estimate_rolling_1RM <- function(weight,
                                 reps,
                                 eRIR = 0,
                                 day_index,
                                 window = 14,
                                 estimate_function = estimate_k_1RM,
                                 ...) {
  # +++++++++++++++++++++++++++++++++++++++++++
  # Code chunk for dealing with R CMD check note
  `.` <- NULL
  # +++++++++++++++++++++++++++++++++++++++++++


  df <- data.frame(
    weight = weight,
    reps = reps,
    eRIR = eRIR,
    day_index = day_index
  )

  unique_days <- data.frame(
    day_index = order(unique(df$day_index))
  ) %>%
    dplyr::filter(day_index >= min(day_index) + window - 1)

  # Go over each unique day and perform the analysis
  make_model <- function(.x) {
    # Filter out days
    prev_days <- df %>%
      dplyr::filter(day_index <= .x$day_index & day_index > .x$day_index - window)

    # Make a model
    m1 <- estimate_function(
      weight =  prev_days$weight,
      reps = prev_days$reps,
      eRIR = prev_days$eRIR,
      ...
    )

    res <- data.frame(
      day_index = .x$day_index,
      t(stats::coef(m1))
    )

    colnames(res) <- c("day_index", names(stats::coef(m1)))

    res
  }

  res <- unique_days %>%
    dplyr::rowwise() %>%
    dplyr::do(make_model(.)) %>%
    dplyr::ungroup()

  res
}
