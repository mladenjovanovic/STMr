#' Plotting of th Progression Table
#'
#' Functions for creating \code{ggplot2} plot of the Progression Table
#'
#' @param progression_table Function for creating progression table. Default is \code{\link{RIR_increment}}
#' @param type Character string. Options include "%1RM" (default) and "adjustment"
#' @return \code{ggplot2} object
#' @export
#' @examples
#' plot_progression_table(RIR_increment, "%1RM")
#' plot_progression_table(RIR_increment, "adjustment")

plot_progression_table <- function(progression_table = RIR_increment, type = "%1RM") {

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
  progression_tbl$perc_1RM <- signif(progression_tbl$perc_1RM * 100, 3)
  progression_tbl$adjustment <- signif(progression_tbl$adjustment, 3)

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
