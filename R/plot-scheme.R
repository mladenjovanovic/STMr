plot_scheme_ <- function(scheme,
                        font_size = 8,
                        label_size = 2.5) {

  # +++++++++++++++++++++++++++++++++++++++++++
  # Code chunk for dealing with R CMD check note
  index <- NULL
  reps <- NULL
  perc_1RM <- NULL
  reps_norm <- NULL
  perc_1RM_norm <- NULL
  perc_1RM_str <- NULL
  set_index <- NULL
  step_index <- NULL
  # +++++++++++++++++++++++++++++++++++++++++++


  # Prepare the scheme df
  scheme %>%
    dplyr::group_by(index) %>%
    dplyr::mutate(set_index = seq_along(reps)) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(perc_1RM = round(perc_1RM * 100, 0)) %>%
    dplyr::mutate(
      step_index = paste0("Step #", index),
      reps_norm = 0.2 + range01(reps),
      perc_1RM_norm = 1.35 + range01(perc_1RM),
      perc_1RM_str = paste0(perc_1RM, "%")
    ) %>%
    # Remove reps
    #dplyr::mutate(
    #  reps = ifelse(reps >= 1, reps, NA),
    #  reps_norm = ifelse(reps >= 1, reps_norm, NA),
    #  perc_1RM_norm = ifelse(reps >= 1, perc_1RM_norm, NA),
    #  perc_1RM = ifelse(reps >= 1, perc_1RM, NA),
    #  perc_1RM_str = ifelse(reps >= 1, perc_1RM_str, "")
    #) %>%
    # Plot
    ggplot2::ggplot() +
    ggplot2::theme_grey(font_size) +

    # %1RM
    ggplot2::geom_bar(
      ggplot2::aes(x = step_index, y = perc_1RM_norm, group = set_index),
      fill = color_orange,
      stat = "identity", width = 0.8, position = ggplot2::position_dodge(0.9), alpha = 0.7
    ) +
    ggplot2::geom_text(
      ggplot2::aes(x = step_index, y = perc_1RM_norm, group = set_index, label = perc_1RM_str),
      position = ggplot2::position_dodge(0.9), vjust = 1.5, size = label_size * 0.75
    ) +

    # Reps
    ggplot2::geom_bar(
      ggplot2::aes(x = step_index, y = reps_norm, group = set_index),
      fill = color_blue,
      stat = "identity", width = 0.8, position = ggplot2::position_dodge(0.9), alpha = 0.8
    ) +
    ggplot2::geom_text(
      ggplot2::aes(x = step_index, y = reps_norm, group = set_index, label = reps),
      position = ggplot2::position_dodge(0.9), vjust = 1.5, size = label_size
    ) +
    ggplot2::ylab(NULL) +
    ggplot2::xlab(NULL) +
    ggplot2::theme(
      legend.position = "none",
      strip.background = ggplot2::element_rect(fill = "black"),
      strip.text = ggplot2::element_text(color = "white"),
      axis.ticks.y = ggplot2::element_blank(),
      axis.text.y = ggplot2::element_blank(),
      axis.ticks.x = ggplot2::element_blank(),
      panel.background = ggplot2::element_rect(fill = "white"),
      panel.grid.major = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank()
    )
}



#' Plotting of the Set and Reps Scheme
#'
#' Functions for creating \code{ggplot2} plot of the Set and Reps Scheme
#'
#' @param scheme Data Frame create by one of the package functions. See examples
#' @param font_size Numeric. Default is 8
#' @param label_size Numeric. Default is 2.5
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
#' plot_scheme(scheme)
plot_scheme <- function(scheme,
                        font_size = 8,
                        label_size = 2.5) {

  warning("`plot_scheme()` is deprecated as of STMr 0.1.4. Please use S3 `plot()` method instead.", call. = FALSE, immediate. = TRUE)
  plot_scheme_(
    scheme = scheme,
    font_size = font_size,
    label_size = label_size)
}
