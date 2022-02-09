#' Get %1RM
#'
#' Function \code{get_perc_1RM} represent a wrapper function
#'
#' @param reps Numeric vector. Number of repetition to be performed
#' @param method Character vector. Default is "RIR". Other options are
#'     "DI", "RelInt", "%MR"
#' @param model Character vector. Default is "epley". Other options are
#'     "modified epley", "linear"
#' @param ... Forwarded to selected \code{adj_perc_1RM} function
#' @export
#' @examples
#' get_perc_1RM(5)
#'
#' # # Use ballistic adjustment (this implies doing half the reps)
#' get_perc_1RM(5, mfactor = 2)
#'
#' # Use perc MR adjustment method
#' get_perc_1RM(5, "%MR", adjustment = 0.8)
#'
#' # Use linear model with use defined klin values
#' get_perc_1RM(5, "%MR", model = "linear", adjustment = 0.8, klin = 36)
get_perc_1RM <- function(reps,
                         method = "RIR",
                         model = "epley",
                         ...) {

  # Perform checks
  check_method(method)
  check_model(model)

  max_perc_1RM_func <- switch(model,
    "epley" = max_perc_1RM_epley,
    "modified epley" = max_perc_1RM_modified_epley,
    "linear" = max_perc_1RM_linear
  )

  adj_func <- switch(method,
    "RIR" = adj_perc_1RM_RIR,
    "DI" = adj_perc_1RM_DI,
    "RelInt" = adj_perc_1RM_rel_int,
    "%MR" = adj_perc_1RM_perc_MR
  )

  adj_func(reps = reps, max_perc_1RM_func = max_perc_1RM_func, ...)
}
