#' Family of functions to adjust number of repetition
#'
#' These functions are reverse version of the \code{\link{adj_perc_1RM}}
#'     family of functions. Use these when you want to estimate number of
#'     repetitions to be used when using the known %1RM and level of
#'     adjustment
#'
#' @param perc_1RM Numeric vector. %1RM used (use 0.5 for 50%, 0.9 for 90%)
#' @param max_reps_func Max reps function to be used. Default is \code{\link{max_reps_epley}}
#' @param adjustment Numeric vector. Adjustment to be implemented
#' @param mfactor Numeric vector. Default is 1 (i.e., no adjustment).
#'     Use \code{mfactor = 2} to generate ballistic adjustment and tables,
#'     and \code{mfactor = 3} to generate conservative adjustment and tables
#' @param ... Forwarded to \code{max_reps_func}. Usually the parameter value.
#'     For example \code{klin = 36} when using \code{\link{max_reps_linear}} as
#'     \code{max_reps_func} function
#' @return Numeric vector. Predicted number of repetitions to be performed
#' @name adj_reps
NULL

#' @describeIn adj_reps Adjust number of repetitions using the Reps In Reserve (RIR) approach
#' @export
#' @examples
#' # ------------------------------------------
#' # Adjustment using Reps In Reserve (RIR)
#' adj_reps_RIR(0.75)
#'
#' # Use ballistic adjustment (this implies doing half the reps)
#' adj_reps_RIR(0.75, mfactor = 2)
#'
#' # Use 2 reps in reserve
#' adj_reps_RIR(0.75, adjustment = 2)
#'
#' # Use Linear model
#' adj_reps_RIR(0.75, max_reps_func = max_reps_linear, adjustment = 2)
#'
#' # Use Modifed Epley's equation with a custom parameter values
#' adj_reps_RIR(
#'   0.75,
#'   max_reps_func = max_reps_modified_epley,
#'   adjustment = 2,
#'   kmod = 0.06
#' )
adj_reps_RIR <- function(perc_1RM,
                         adjustment = 0,
                         mfactor = 1,
                         max_reps_func = max_reps_epley,
                         ...) {
  max_reps_func(perc_1RM, ...) / mfactor - adjustment
}


#' @describeIn adj_reps Adjust number of repetitions using the Deducted Intensity (DI) approach
#' @export
#' @examples
#' # ------------------------------------------
#' # Adjustment using Deducted Intensity (DI)
#' adj_reps_DI(0.75)
#'
#' # Use ballistic adjustment (this implies doing half the reps)
#' adj_reps_DI(0.75, mfactor = 2)
#'
#' # Use 10% deducted intensity
#' adj_reps_DI(0.75, adjustment = -0.1)
#'
#' # Use Linear model
#' adj_reps_DI(0.75, max_reps_func = max_reps_linear, adjustment = -0.1)
#'
#' # Use Modifed Epley's equation with a custom parameter values
#' adj_reps_DI(
#'   0.75,
#'   max_reps_func = max_reps_modified_epley,
#'   adjustment = -0.1,
#'   kmod = 0.06
#' )
adj_reps_DI <- function(perc_1RM,
                        adjustment = 1,
                        mfactor = 1,
                        max_reps_func = max_reps_epley,
                        ...) {
  max_reps_func(perc_1RM - adjustment, ...) / mfactor
}

#' @describeIn adj_reps Adjust number of repetitions using the Relative Intensity (RelInt) approach
#' @export
#' @examples
#' # ------------------------------------------
#' # Adjustment using Relative Intensity (RelInt)
#' adj_reps_rel_int(0.75)
#'
#' # Use ballistic adjustment (this implies doing half the reps)
#' adj_reps_rel_int(0.75, mfactor = 2)
#'
#' # Use 85% relative intensity
#' adj_reps_rel_int(0.75, adjustment = 0.85)
#'
#' # Use Linear model
#' adj_reps_rel_int(0.75, max_reps_func = max_reps_linear, adjustment = 0.85)
#'
#' # Use Modifed Epley's equation with a custom parameter values
#' adj_reps_rel_int(
#'   0.75,
#'   max_reps_func = max_reps_modified_epley,
#'   adjustment = 0.85,
#'   kmod = 0.06
#' )
adj_reps_rel_int <- function(perc_1RM,
                             adjustment = 1,
                             mfactor = 1,
                             max_reps_func = max_reps_epley,
                             ...) {
  max_reps_func(perc_1RM / adjustment, ...) / mfactor
}

#' @describeIn adj_reps Adjust number of repetitions using the % max reps (%MR) approach
#' @export
#' @examples
#' # ------------------------------------------
#' # Adjustment using % max reps (%MR)
#' adj_reps_perc_MR(0.75)
#'
#' # Use ballistic adjustment (this implies doing half the reps)
#' adj_reps_perc_MR(0.75, mfactor = 2)
#'
#' # Use 85% of max reps
#' adj_reps_perc_MR(0.75, adjustment = 0.85)
#'
#' # Use Linear model
#' adj_reps_perc_MR(0.75, max_reps_func = max_reps_linear, adjustment = 0.85)
#'
#' # Use Modifed Epley's equation with a custom parameter values
#' adj_reps_perc_MR(
#'   0.75,
#'   max_reps_func = max_reps_modified_epley,
#'   adjustment = 0.85,
#'   kmod = 0.06
#' )
adj_reps_perc_MR <- function(perc_1RM,
                             adjustment = 1,
                             mfactor = 1,
                             max_reps_func = max_reps_epley,
                             ...) {
  max_reps_func(perc_1RM, ...) / mfactor * adjustment
}
