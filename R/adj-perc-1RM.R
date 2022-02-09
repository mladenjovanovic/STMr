#' Family of functions to adjust %1RM
#'
#' @param reps Numeric vector. Number of repetition to be performed
#' @param max_perc_1RM_func Max perc 1RM function to be used. Default is \code{\link{max_perc_1RM_epley}}
#' @param adjustment Numeric vector. Adjustment to be implemented
#' @param mfactor Numeric vector. Default is 1 (i.e., no adjustment).
#'     Use \code{mfactor = 2} to generate ballistic adjustment and tables
#' @param ... Forwarded to \code{max_perc_1RM_func}. Usually the parameter value.
#'     For example \code{klin = 36} when using \code{\link{max_perc_1RM_linear}} as
#'     \code{max_perc_1RM_func} function
#' @return Numeric vector. Predicted perc 1RM
#' @name adj_perc_1RM
NULL

#' @describeIn adj_perc_1RM Adjust max perc 1RM using the Reps In Reserve (RIR) approach
#' @export
#' @examples
#' # ------------------------------------------
#' # Adjustment using Reps In Reserve (RIR)
#' adj_perc_1RM_RIR(5)
#'
#' # Use ballistic adjustment (this implies doing half the reps)
#' adj_perc_1RM_RIR(5, mfactor = 2)
#'
#' # Use 2 reps in reserve
#' adj_perc_1RM_RIR(5, adjustment = 2)
#'
#' # Use Linear model
#' adj_perc_1RM_RIR(5, max_perc_1RM_func = max_perc_1RM_linear, adjustment = 2)
#'
#' # Use Modifed Epley's equation with a custom parameter values
#' adj_perc_1RM_RIR(
#'   5,
#'   max_perc_1RM_func = max_perc_1RM_modified_epley,
#'   adjustment = 2,
#'   kmod = 0.06
#' )
adj_perc_1RM_RIR <- function(reps,
                             adjustment = 0,
                             mfactor = 1,
                             max_perc_1RM_func = max_perc_1RM_epley,
                             ...) {
  # Adjust the reps
  adj_reps <- (reps + adjustment) * mfactor

  max_perc_1RM_func(adj_reps, ...)
}

#' @describeIn adj_perc_1RM Adjust max perc 1RM using the Deducted Intensity (DI) approach.
#'     This approach simple deducts \code{adjustment} from estimated perc 1RM
#' @export
#' @examples
#' # ------------------------------------------
#' # Adjustment using Deducted Intensity (DI)
#' adj_perc_1RM_DI(5)
#'
#' # Use ballistic adjustment (this implies doing half the reps)
#' adj_perc_1RM_DI(5, mfactor = 2)
#'
#' # Use 10 perc deducted intensity
#' adj_perc_1RM_DI(5, adjustment = -0.1)
#'
#' # Use Linear model
#' adj_perc_1RM_DI(5, max_perc_1RM_func = max_perc_1RM_linear, adjustment = -0.1)
#'
#' # Use Modifed Epley's equation with a custom parameter values
#' adj_perc_1RM_DI(
#'   5,
#'   max_perc_1RM_func = max_perc_1RM_modified_epley,
#'   adjustment = -0.1,
#'   kmod = 0.06
#' )
adj_perc_1RM_DI <- function(reps,
                            adjustment = 0,
                            mfactor = 1,
                            max_perc_1RM_func = max_perc_1RM_epley,
                            ...) {
  # Adjust the reps
  adj_reps <- reps * mfactor

  max_perc_1RM_func(adj_reps, ...) + adjustment
}

#' @describeIn adj_perc_1RM Adjust max perc 1RM using the Relative Intensity (RelInt) approach.
#'     This approach simple multiplies estimated perc 1RM with \code{adjustment}
#' @export
#' @examples
#' # ------------------------------------------
#' # Adjustment using Relative Intensity (RelInt)
#' adj_perc_1RM_rel_int(5)
#'
#' # Use ballistic adjustment (this implies doing half the reps)
#' adj_perc_1RM_rel_int(5, mfactor = 2)
#'
#' # Use 90 perc  relative intensity
#' adj_perc_1RM_rel_int(5, adjustment = 0.9)
#'
#' # Use Linear model
#' adj_perc_1RM_rel_int(5, max_perc_1RM_func = max_perc_1RM_linear, adjustment = 0.9)
#'
#' # Use Modifed Epley's equation with a custom parameter values
#' adj_perc_1RM_rel_int(
#'   5,
#'   max_perc_1RM_func = max_perc_1RM_modified_epley,
#'   adjustment = 0.9,
#'   kmod = 0.06
#' )
adj_perc_1RM_rel_int <- function(reps,
                            adjustment = 1,
                            mfactor = 1,
                            max_perc_1RM_func = max_perc_1RM_epley,
                            ...) {
  # Adjust the reps
  adj_reps <- reps * mfactor

  adjustment * max_perc_1RM_func(adj_reps, ...)
}

#' @describeIn adj_perc_1RM Adjust max perc 1RM using the perc Max Reps (percMR) approach.
#'     This approach simple divides target reps with \code{adjustment}
#' @export
#' @examples
#' # ------------------------------------------
#' # Adjustment using percent of max reps (percMR)
#' adj_perc_1RM_perc_MR(5)
#'
#' # Use ballistic adjustment (this implies doing half the reps)
#' adj_perc_1RM_perc_MR(5, mfactor = 2)
#'
#' # Use 70 perc max reps
#' adj_perc_1RM_perc_MR(5, adjustment = 0.7)
#'
#' # Use Linear model
#' adj_perc_1RM_perc_MR(5, max_perc_1RM_func = max_perc_1RM_linear, adjustment = 0.7)
#'
#' # Use Modifed Epley's equation with a custom parameter values
#' adj_perc_1RM_perc_MR(
#'   5,
#'   max_perc_1RM_func = max_perc_1RM_modified_epley,
#'   adjustment = 0.7,
#'   kmod = 0.06
#' )
adj_perc_1RM_perc_MR <- function(reps,
                                 adjustment = 1,
                                 mfactor = 1,
                                 max_perc_1RM_func = max_perc_1RM_epley,
                                 ...) {
  # Adjust the reps
  adj_reps <- reps * mfactor / adjustment

  max_perc_1RM_func(adj_reps, ...)
}
