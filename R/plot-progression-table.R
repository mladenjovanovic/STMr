#' Plotting of the Progression Table
#'
#' Function for creating \code{ggplot2} plot of the Progression Table
#'
#' @param progression_table Function for creating progression table
#' @param signif_digits Rounding numbers for plotting. Default is 3
#' @param adjustment_multiplier Factor to multiply the adjustment. Useful when converting to percentage.
#'     Default is 1
#' @param plot Character string. Options include "%1RM" (default) and "adjustment"
#' @param font_size Numeric. Default is 14
#' @param ... Forwarded to the \code{\link{generate_progression_table}} function
#' @return \code{ggplot2} object
#' @export
#' @examples
#' plot_progression_table(progression_RIR_increment, "%1RM", reps = 1:5)
#' plot_progression_table(progression_RIR_increment, "adjustment", reps = 1:5)
#'
#' # Create progression pot by using specific reps-max table and klin value
#' plot_progression_table(
#'   progression_RIR,
#'   reps = 1:5,
#'   max_perc_1RM_func = max_perc_1RM_linear,
#'   klin = 36
#' )
plot_progression_table <- function(progression_table,
                                   plot = "%1RM",
                                   signif_digits = 3,
                                   adjustment_multiplier = 1,
                                   font_size = 14,
                                   ...) {

  # +++++++++++++++++++++++++++++++++++++++++++
  # Code chunk for dealing with R CMD check note
  perc_1RM <- NULL
  adjustment <- NULL
  step <- NULL
  reps <- NULL
  # +++++++++++++++++++++++++++++++++++++++++++

  progression_tbl <- generate_progression_table(
    progression_table = progression_table,
    ...
  )

  progression_tbl$volume <- factor(
    progression_tbl$volume,
    levels = c("intensive", "normal", "extensive")
  )

  progression_tbl$type <- factor(
    progression_tbl$type,
    levels = c("grinding", "ballistic", "conservative")
  )

  progression_tbl$reps <- factor(progression_tbl$reps)
  progression_tbl$step <- factor(progression_tbl$step)
  progression_tbl$perc_1RM <- signif(progression_tbl$perc_1RM * 100, signif_digits)
  progression_tbl$adjustment <- signif(
    progression_tbl$adjustment * adjustment_multiplier,
    signif_digits
  )

  gg <- switch(plot,
    "%1RM" = ggplot2::ggplot(progression_tbl, ggplot2::aes(x = step, y = reps)) +
      ggplot2::theme_linedraw(font_size) +
      ggplot2::geom_tile(fill = "transparent", color = "transparent") +
      ggfittext::geom_fit_text(ggplot2::aes(label = perc_1RM), min.size = 0) +
      ggplot2::scale_y_discrete(limits = rev(levels(progression_tbl$reps))) +
      ggplot2::theme(
        legend.position = "none",
        axis.title = ggplot2::element_blank(),
        # axis.text = element_blank(),
        axis.ticks = ggplot2::element_blank(),
        panel.grid.major = ggplot2::element_blank(),
        panel.grid.minor = ggplot2::element_blank()
      ) +
      ggplot2::xlab(NULL) +
      ggplot2::ylab(NULL) +
      ggplot2::ggtitle("%1RM"),
    "adjustment" = ggplot2::ggplot(progression_tbl, ggplot2::aes(x = step, y = reps)) +
      ggplot2::theme_linedraw(font_size) +
      ggplot2::geom_tile(fill = "transparent", color = "transparent") +
      ggfittext::geom_fit_text(ggplot2::aes(label = adjustment), min.size = 0) +
      ggplot2::scale_y_discrete(limits = rev(levels(progression_tbl$reps))) +
      ggplot2::theme(
        legend.position = "none",
        axis.title = ggplot2::element_blank(),
        # axis.text = ggplot2::element_blank(),
        axis.ticks = ggplot2::element_blank(),
        panel.grid.major = ggplot2::element_blank(),
        panel.grid.minor = ggplot2::element_blank()
      ) +
      ggplot2::xlab(NULL) +
      ggplot2::ylab(NULL) +
      ggplot2::ggtitle("Adjustment"),
    stop("Invalid `plot` value. Please use `%1RM` or `adjustment`", call. = FALSE)
  )

  if (length(unique(progression_tbl$type)) == 1 && length(unique(progression_tbl$volume)) > 1) {
    gg <- gg + ggplot2::facet_grid(~volume)
  } else if (length(unique(progression_tbl$type)) > 1 && length(unique(progression_tbl$volume)) == 1) {
    gg <- gg + ggplot2::facet_grid(~type)
  } else if (length(unique(progression_tbl$type)) > 1 && length(unique(progression_tbl$volume)) > 1) {
    gg <- gg + ggplot2::facet_grid(type ~ volume)
  }

  gg
}
