#' Plotting of the Progression Table
#'
#' Functions for creating \code{ggplot2} plot of the Progression Table
#'
#' @param progression_table Function for creating progression table. Default is \code{\link{RIR_increment}}
#' @param signif_digits Rounding numbers for plotting. Default is 3
#' @param adjustment_multiplier Factor to multiply the adjustment. Useful when converting to percentage.
#'     Default is 1
#' @param type Character string. Options include "%1RM" (default) and "adjustment"
#' @return \code{ggplot2} object
#' @export
#' @examples
#' plot_progression_table(RIR_increment, "%1RM")
#' plot_progression_table(RIR_increment, "adjustment")

plot_progression_table <- function(
  progression_table = RIR_increment,
  type = "%1RM",
  signif_digits = 3,
  adjustment_multiplier = 1) {

  # +++++++++++++++++++++++++++++++++++++++++++
  # Code chunk for dealing with R CMD check note
  perc_1RM <- NULL
  adjustment <- NULL
  step <- NULL
  reps <- NULL
  # +++++++++++++++++++++++++++++++++++++++++++

  progression_tbl <- generate_progression_table(
    progression_table = progression_table)

  progression_tbl$volume <- factor(
    progression_tbl$volume,
    levels = c("intensive", "normal", "extensive"))

  progression_tbl$type <- factor(
    progression_tbl$type,
    levels = c("grinding", "ballistic")
  )

  progression_tbl$reps <- factor(progression_tbl$reps)
  progression_tbl$step <- factor(progression_tbl$step)
  progression_tbl$perc_1RM <- signif(progression_tbl$perc_1RM * 100, signif_digits)
  progression_tbl$adjustment <- signif(
    progression_tbl$adjustment * adjustment_multiplier,
    signif_digits)

  switch(type,
         "%1RM" = ggplot2::ggplot(progression_tbl, ggplot2::aes(x = step, y = reps)) +
           ggplot2::theme_linedraw() +
           #geom_tile(fill = "transparent", color = "black") +
           ggplot2::geom_text(ggplot2::aes(label = perc_1RM)) +
           ggplot2::facet_grid(type~volume) +
           ggplot2::scale_y_discrete(limits = rev(levels(progression_tbl$reps))) +
           ggplot2::theme(
             legend.position = "none",
             axis.title = ggplot2::element_blank(),
             #axis.text = element_blank(),
             axis.ticks = ggplot2::element_blank(),
             panel.grid.major = ggplot2::element_blank(),
             panel.grid.minor = ggplot2::element_blank()
           ) +
           ggplot2::xlab(NULL) +
           ggplot2::ylab(NULL) +
           ggplot2::ggtitle("%1RM"),

         "adjustment" = ggplot2::ggplot(progression_tbl, ggplot2::aes(x = step, y = reps)) +
           ggplot2::theme_linedraw() +
           #ggplot2::geom_tile(fill = "transparent", color = "black") +
           ggplot2::geom_text(ggplot2::aes(label = adjustment)) +
           ggplot2::facet_grid(type~volume) +
           ggplot2::scale_y_discrete(limits = rev(levels(progression_tbl$reps))) +
           ggplot2::theme(
             legend.position = "none",
             axis.title = ggplot2::element_blank(),
             #axis.text = ggplot2::element_blank(),
             axis.ticks = ggplot2::element_blank(),
             panel.grid.major = ggplot2::element_blank(),
             panel.grid.minor = ggplot2::element_blank()
           ) +
           ggplot2::xlab(NULL) +
           ggplot2::ylab(NULL) +
           ggplot2::ggtitle("Adjustment", "Depends on the progression table utilized"),
         stop("Invalid `type` value. Please use `%1RM` or `adjustment`", call. = FALSE)
  )
}

#' Plotting of the Set and Reps Scheme
#'
#' Functions for creating \code{ggplot2} plot of the Set and Reps Scheme
#'
#' @param scheme Data Frame create by one of the package functions. See examples
#' @param label_size Numeric. Default is 3
#' @param signif_digits Rounding numbers for plotting. Default is 3
#' @param adjustment_multiplier Factor to multiply the adjustment. Useful when converting to percentage.
#'     Default is 1
#' @return \code{ggplot2} object
#' @export
#' @examples
#' scheme <- scheme_wave(
#'   reps = c(10, 8, 6, 10, 8, 6),
#'   # Adjusting sets to use lower %1RM (RIR Inc method used, so RIR adjusted)
#'   adjustment = c(4, 2, 0, 6, 4, 2),
#'   vertical_planning = vertical_linear,
#'   vertical_planning_control = list(reps_change = c(0, -2, -4)),
#'   progression_table = RIR_increment,
#'   progression_table_control = list(volume = "extensive")
#' )
#'
#' plot_scheme(scheme)

plot_scheme <- function(scheme,
                        label_size = 3,
                        signif_digits = 3,
                        adjustment_multiplier = 1) {

  # +++++++++++++++++++++++++++++++++++++++++++
  # Code chunk for dealing with R CMD check note
  perc_1RM <- NULL
  adjustment <- NULL
  step <- NULL
  reps <- NULL
  hjust <- NULL
  param <- NULL
  index <- NULL
  set <- NULL
  value <- NULL
  # +++++++++++++++++++++++++++++++++++++++++++

  # Reorganize the data
  scheme <- scheme %>%
    dplyr::group_by(index) %>%
    dplyr::mutate(
      set = dplyr::row_number(),
      adjustment = signif(adjustment * adjustment_multiplier, signif_digits),
      perc_1RM = signif(perc_1RM * 100, signif_digits),
      index = paste0("Step ", index)
    ) %>%
    dplyr::rename(
      Reps = reps,
      Adjustment = adjustment,
      `%1RM` = perc_1RM
    ) %>%
    tidyr::pivot_longer(cols = c("Reps", "Adjustment", "%1RM"), names_to = "param") %>%
    dplyr::mutate(
      param = factor(param, levels = c("Reps", "Adjustment", "%1RM")),
      hjust = ifelse(value < 0, -0.5, 1.5))

  # Plot
  ggplot2::ggplot(scheme, ggplot2::aes(x = value, y = set, fill = param)) +
    ggplot2::theme_linedraw() +
    ggstance::geom_barh(stat = "identity") +
    ggplot2::geom_text(ggplot2::aes(label = value, hjust = hjust), size = label_size) +
    ggplot2::facet_grid(index ~ param, scales = "free_x") +
    ggplot2::scale_y_reverse() +
    ggplot2::theme(
      legend.position = "none",
      axis.title = ggplot2::element_blank(),
      axis.text = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank(),
      panel.grid.major = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank()
    ) +
    ggplot2::scale_fill_brewer(palette = "Accent") +
    ggplot2::xlab(NULL) +
    ggplot2::ylab(NULL)
}
