#' Plotting of the Release
#'
#' Function for creating \code{ggplot2} plot of the Release \code{STMr_release} object
#'
#' @param x \code{STMr_release} object
#' @param font_size Numeric. Default is 14
#' @param load_1RM_agg_func Function to aggregate step \code{load_1RM} from
#'     multiple sets. Default is \code{\link[base]{max}}
#' @param ... Forwarded to \code{\link[ggfittext]{geom_bar_text}} and
#'     \code{\link[ggfittext]{geom_fit_text}} functions. Can be used to se the highest
#'     labels size, for example, using \code{size=5}. See documentation for these two
#'     packages for more info
#' @return \code{ggplot2} object
#' @export
#' @examples
#' scheme1 <- scheme_step(vertical_planning = vertical_constant)
#' scheme2 <- scheme_step(vertical_planning = vertical_linear)
#' scheme3 <- scheme_step(vertical_planning = vertical_undulating)
#'
#' release_df <- release(
#'   scheme1, scheme2, scheme3,
#'   additive_1RM_adjustment = 2.5)
#'
#' plot(release_df)
plot.STMr_release <- function(x, font_size = 14, load_1RM_agg_func = max, ...) {

  # +++++++++++++++++++++++++++++++++++++++++++
  # Code chunk for dealing with R CMD check note
  phase <- NULL
  index <- NULL
  reps <- NULL
  set <- NULL
  perc_1RM <- NULL
  prescription_1RM <- NULL
  load_1RM <- NULL
  weight <- NULL
  phase_index <- NULL
  step_index <- NULL
  prescription_1RM_norm <- NULL
  load_1RM_norm <- NULL
  weight_norm <- NULL
  set_index <- NULL
  reps_norm <- NULL
  prescription_1RM_str <- NULL
  load_1RM_str <- NULL
  # +++++++++++++++++++++++++++++++++++++++++++


  phase_index_levels <- paste0("Phase #", sort(unique(x$phase)))
  step_index_levels <- paste0("Step #", sort(unique(x$index)))
  set_index_levels <-  sort(unique(x$set))

  weight.min <- min(c(x$weight, x$prescription_1RM, x$load_1RM))
  weight.max <- max(c(x$weight, x$prescription_1RM, x$load_1RM))

  # Prepare the data
  x <- x %>%
    dplyr::mutate(
      phase_index = factor(paste0("Phase #", phase), levels = phase_index_levels),
      step_index = factor(paste0("Step #", index), levels = step_index_levels),
      set_index = factor(set, levels = set_index_levels),
      perc_1RM = round(perc_1RM * 100, 0),
      prescription_1RM_norm = 1.35 + range01(prescription_1RM, .min = weight.min, .max = weight.max),
      load_1RM_norm = 1.35 + range01(load_1RM, .min = weight.min, .max = weight.max),
      weight_norm = 1.35 + range01(weight, .min = weight.min, .max = weight.max),
      reps_norm = 0.2 + range01(reps)
    )

  summary_1RM <- x %>%
    dplyr::group_by(phase_index, step_index) %>%
    dplyr::summarise(
      prescription_1RM = load_1RM_agg_func(prescription_1RM),
      prescription_1RM_norm = load_1RM_agg_func(prescription_1RM_norm),
      load_1RM = load_1RM_agg_func(load_1RM),
      load_1RM_norm = load_1RM_agg_func(load_1RM_norm)) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(
      load_1RM_str = round(load_1RM, 0))

  phase_1RM <- summary_1RM %>%
    dplyr::group_by(phase_index) %>%
    dplyr::summarise(
      step_index = step_index[[1]],
      prescription_1RM = load_1RM_agg_func(prescription_1RM),
      prescription_1RM_norm = load_1RM_agg_func(prescription_1RM_norm)
    ) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(
      prescription_1RM_str = round(prescription_1RM, 2))

    # Plot
  x %>%
    ggplot2::ggplot() +
    ggplot2::theme_grey(font_size) +

    # Weight
    ggplot2::geom_col(
      ggplot2::aes(x = step_index, y = weight_norm, group = set_index),
      fill = color_grey, position = ggplot2::position_dodge(0.9),
      width = 0.8, alpha = 0.7
    ) +
    ggfittext::geom_bar_text(
      ggplot2::aes(x = step_index, y = weight_norm, label = weight, group = set_index),
      place = "top", position = "dodge", color = color_black, min.size = 0, ...
    ) +

    # Reps
    ggplot2::geom_col(
      ggplot2::aes(x = step_index, y = reps_norm, group = set_index),
      fill = color_blue, position = ggplot2::position_dodge(0.9),
      width = 0.8, alpha = 0.7
    ) +
    ggfittext::geom_bar_text(
      ggplot2::aes(x = step_index, y = reps_norm, label = reps, group = set_index),
      place = "top", position = "dodge", color = color_black, min.size = 0, ...
    ) +

    # Prescription 1RM
    ggplot2::geom_step(
      data = summary_1RM,
      ggplot2::aes(x = step_index, y = prescription_1RM_norm),
      group = 1, linetype = "dashed"
    ) +
    ggplot2::geom_label(
      data = phase_1RM,
      ggplot2::aes(x = step_index, y = prescription_1RM_norm, label = prescription_1RM_str),
      size = font_size / 5
    ) +

    # Load 1RM
    ggplot2::geom_line(
      data = summary_1RM,
      ggplot2::aes(x = step_index, y = load_1RM_norm),
      group = 1
    ) +
    ggplot2::geom_label(
      data = summary_1RM,
      ggplot2::aes(x = step_index, y = load_1RM_norm, label = load_1RM_str),
      size = font_size / 5
    ) +
    ggplot2::ylab(NULL) +
    ggplot2::xlab(NULL) +
    ggplot2::facet_wrap(~phase_index, nrow = 1, strip.position = "bottom") +
    ggplot2::theme(
      legend.position = "none",
      strip.background = ggplot2::element_rect(fill = "white"),
      strip.text = ggplot2::element_text(color = "black"),
      axis.ticks.y = ggplot2::element_blank(),
      axis.text.y = ggplot2::element_blank(),
      axis.ticks.x = ggplot2::element_blank(),
      panel.background = ggplot2::element_rect(fill = "white"),
      panel.grid.major = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      strip.placement = "outside",
      panel.spacing.x = ggplot2::unit(0, "mm")
    )

}
