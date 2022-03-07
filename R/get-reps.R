#' Get Reps
#'
#' Function \code{get_reps} represent a wrapper function. This function is the
#'     reverse version of the \code{\link{get_perc_1RM}} function. Use it when
#'     you want to estimate number of repetitions to be used when using the
#'     known %1RM and level of adjustment
#'
#' @param perc_1RM Numeric vector. %1RM used (use 0.5 for 50 perc, 0.9 for 90 perc)
#' @param method Character vector. Default is "RIR". Other options are
#'     "DI", "RelInt", "%MR"
#' @param model Character vector. Default is "epley". Other options are
#'     "modified epley", "linear"
#' @param ... Forwarded to selected \code{adj_reps} function
#' @export
#' @examples
#' get_reps(0.75)
#'
#' # # Use ballistic adjustment (this implies doing half the reps)
#' get_reps(0.75, mfactor = 2)
#'
#' # Use %MR adjustment method
#' get_reps(0.75, "%MR", adjustment = 0.8)
#'
#' # Use linear model with use defined klin values
#' get_reps(0.75, "%MR", model = "linear", adjustment = 0.8, klin = 36)
get_reps <- function(perc_1RM,
                     method = "RIR",
                     model = "epley",
                     ...) {

  # Perform checks
  check_method(method)
  check_model(model)

  max_reps_func <- switch(model,
    "epley" = max_reps_epley,
    "modified epley" = max_reps_modified_epley,
    "linear" = max_reps_linear
  )

  adj_func <- switch(method,
    "RIR" = adj_reps_RIR,
    "DI" = adj_reps_DI,
    "RelInt" = adj_reps_rel_int,
    "%MR" = adj_reps_perc_MR
  )

  adj_func(perc_1RM = perc_1RM, max_reps_func = max_reps_func, ...)
}
