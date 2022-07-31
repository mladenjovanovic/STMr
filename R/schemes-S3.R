#' Plotting of the Set and Reps Scheme
#'
#' Functions for creating \code{ggplot2} plot of the Set and Reps Scheme
#'
#' @param x \code{STMr_scheme} object. See examples
#' @param font_size Numeric. Default is 8
#' @param label_size Numeric. Default is 2.5
#' @param ... Not used
#' @return \code{ggplot2} object
#' @export
#' @examples
#' scheme <- scheme_wave(
#'   reps = c(10, 8, 6, 10, 8, 6),
#'   # Adjusting sets to use lower %1RM (RIR Inc method used, so RIR adjusted)
#'   adjustment = c(4, 2, 0, 6, 4, 2),
#'   vertical_planning = vertical_linear,
#'   vertical_planning_control = list(reps_change = c(0, -2, -4)),
#'   progression_table = progression_RIR_increment,
#'   progression_table_control = list(volume = "extensive")
#' )
#'
#' plot(scheme)
plot.STMr_scheme <- function(x, font_size = 8, label_size = 2.5, ...) {
  plot_scheme_(scheme = x, font_size = font_size, label_size = label_size)
}