#' @export
plot.STMr_release <- function(x, font_size = 12, ...) {
  phase_index_levels <- paste0("Phase #", sort(unique(x$phase)))
  set_index_levels <-  sort(unique(x$set))
  step_index_levels <- paste0("Step #", sort(unique(x$index)))
  total_step_index_levels <- paste0("Step #", sort(unique(x$total_index)))

  x$phase_step_set <- paste0(x$phase, "_", x$index, "_", x$set)

  x$phase_step_set <- factor(
    x$phase_step_set,
    levels = unique(x$phase_step_set))

  weight.min <- min(c(x$weight, x$prescription_1RM, x$load_1RM))
  weight.max <- max(c(x$weight, x$prescription_1RM, x$load_1RM))

  x %>%
    dplyr::mutate(
      phase_index = factor(paste0("Phase #", phase), levels = phase_index_levels),
      set_index = factor(set, levels = set_index_levels)) %>%
    dplyr::mutate(
      buffer = round(buffer * 100, 0),
      perc_1RM = round(perc_1RM * 100, 0)) %>%
    dplyr::mutate(
      step_index = factor(paste0("Step #", index), levels = step_index_levels),
      total_step_index = factor(paste0("Step #", total_index), levels = total_step_index_levels),
      presc_1RM_norm = 1.35 + range01(prescription_1RM, .min = weight.min, .max = weight.max),
      load_1RM_norm = 1.35 + range01(load_1RM, .min = weight.min, .max = weight.max),
      weight_norm = 1.35 + range01(weight, .min = weight.min, .max = weight.max),
      reps_norm = 0.2 + range01(reps)
    ) %>%
    # Plot
    ggplot2::ggplot() +
    ggplot2::theme_grey(font_size) +

    # Prescription 1RM
    ggplot2::geom_line(
      ggplot2::aes( x = set_index, y = presc_1RM_norm),
      group = 1
    ) +

    # Load 1RM
    ggplot2::geom_line(
      ggplot2::aes( x = set_index, y = load_1RM_norm),
      group = 1, linetype = "dashed"
    ) +

    ggplot2::geom_point(
      ggplot2::aes( x = set_index, y = load_1RM_norm),
      shape = 21, fill = "white"
    ) +

    # Weight
    ggplot2::geom_col(
      ggplot2::aes(x = set_index, y = weight_norm),
      fill = color_grey,
      width = 0.8, alpha = 0.7
    ) +
    ggfittext::geom_bar_text(
      ggplot2::aes(x = set_index, y = weight_norm, label = weight),
      place = "top", color = color_black, min.size = 0, ...
    ) +

    # Reps
    ggplot2::geom_col(
      ggplot2::aes(x = set_index, y = reps_norm),
      fill = color_blue,
      width = 0.8, alpha = 0.7
    ) +
    ggfittext::geom_bar_text(
      ggplot2::aes(x = set_index, y = reps_norm, label = reps),
      place = "top", color = color_black, min.size = 0, ...
    ) +
    ggplot2::ylab(NULL) +
    ggplot2::xlab(NULL) +
    ggh4x::facet_nested_wrap(
      ~phase_index + step_index,
      nrow =  1, strip.position = "bottom", drop = TRUE, scales = "free_x") +
    ggplot2::theme(
      legend.position = "none",
      strip.background = ggplot2::element_rect(fill = "white"),
      strip.text = ggplot2::element_text(color = "black"),
      axis.ticks.y = ggplot2::element_blank(),
      axis.text.y = ggplot2::element_blank(),
      axis.ticks.x = ggplot2::element_blank(),
      axis.text.x = ggplot2::element_blank(),
      panel.background = ggplot2::element_rect(fill = "white"),
      panel.grid.major = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      strip.placement = "outside",
      panel.spacing = ggplot2::unit(0, "mm")
    )

}
