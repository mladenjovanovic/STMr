#' Plotting of the Vertical Planning
#'
#' Function for creating \code{ggplot2} plot of the Vertical Planning function
#'
#' @param vertical_plan Vertical Plan functions
#' @param reps Numeric vector
#' @param font_size Numeric. Default is 8
#' @param label_size Numeric. Default is 2.5
#' @param ... Forwarded to \code{vertical_plan} function
#' @export
#' @examples
#' plot_vertical(vertical_block_undulating)
plot_vertical <- function(vertical_plan,
                          reps = c(5, 5, 5),
                          font_size = 8,
                          label_size = 2.5,
                          ...) {


  # +++++++++++++++++++++++++++++++++++++++++++
  # Code chunk for dealing with R CMD check note
  index <- NULL
  step <- NULL
  step_index <- NULL
  step_norm <- NULL
  set_index <- NULL
  step_str <- NULL
  reps_norm <- NULL
  # +++++++++++++++++++++++++++++++++++++++++++

  vertical_plan(reps = reps, ...) %>%
    dplyr::group_by(index) %>%
    dplyr::mutate(set_index = seq_along(reps)) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(
      step_index = paste0("Step #", index),
      reps_norm = 0.2 + range01(reps),
      step_norm = 1.35 + range01(step),
      step_str =  step
    ) %>%
    # Plot
    ggplot2::ggplot() +
    ggplot2::theme_grey(font_size) +

    # Step
    ggplot2::geom_bar(
      ggplot2::aes(x = step_index, y = step_norm, group = set_index),
      fill = color_purple,
      stat = "identity", width = 0.8, position = ggplot2::position_dodge(0.9), alpha = 0.7
    ) +
    ggplot2::geom_text(
      ggplot2::aes(x = step_index, y = step_norm, group = set_index, label = step_str),
      position = ggplot2::position_dodge(0.9), vjust = 1.5, size = label_size
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
