library(tidyverse)
library(patchwork)


round(max_perc_1RM_modified_epley(1:10, 0.0353) * 100)

progression_tbl <- rbind(
  # Deducted Intensity
  generate_progression_table(
    progression_table = progression_DI,
    max_perc_1RM_func = max_perc_1RM_modified_epley,
    type = "grinding"
  ) %>%
    mutate(Progression = "Deducted Intensity"),

  # Simple RIR
  generate_progression_table(
    progression_table = progression_RIR,
    max_perc_1RM_func = max_perc_1RM_modified_epley,
    type = "grinding"
  ) %>%
    mutate(Progression = "RIR"),

  # Relative Intensity
  generate_progression_table(
    progression_table = progression_rel_int,
    max_perc_1RM_func = max_perc_1RM_modified_epley,
    type = "grinding",
    step_increment = -0.025,
    volume_increment = -0.05
  ) %>%
    mutate(Progression = "Relative Intensity"),

  # Percent Maximum Reps
  generate_progression_table(
    progression_table = progression_perc_MR,
    max_perc_1RM_func = max_perc_1RM_modified_epley,
    type = "grinding"
  ) %>%
    mutate(Progression = "Perc Max Reps"),

  # Percent Drop
  generate_progression_table(
    progression_table = progression_perc_drop,
    max_perc_1RM_func = max_perc_1RM_modified_epley,
    type = "grinding"
  ) %>%
    mutate(Progression = "Perc Drop"),

  # RIR Inc
  generate_progression_table(
    progression_table = progression_RIR_increment,
    max_perc_1RM_func = max_perc_1RM_modified_epley,
    type = "grinding"
  ) %>%
    mutate(Progression = "RIR Increment")

  # Variable DI
  #generate_progression_table(
  #  progression_table = progression_variable_DI,
  #  max_perc_1RM_func = max_perc_1RM_modified_epley,
  #  type = "grinding"
  #) %>%
   # mutate(Progression = "Variable DI"),

  # Variable perc MR
  #generate_progression_table(
  #  progression_table = progression_perc_MR_variable,
  #  max_perc_1RM_func = max_perc_1RM_modified_epley,
  #  type = "grinding"
  #) %>%
  #  mutate(Progression = "Variable Perc MR")
) %>%
  # Organize levels
  mutate(
    volume = factor(volume, levels = c("extensive", "normal", "intensive")),
    Progression = factor(Progression, levels = c(
      "Deducted Intensity",
      "RIR",
      "Relative Intensity",
      "Perc Max Reps",
      "Perc Drop",
      "RIR Increment",
      "Variable DI",
      "Variable Perc MR"
    ))
  )

# Get collectinve %1RM adjustement
progression_tbl <- progression_tbl %>%
  mutate(
    max_perc_1RM = max_perc_1RM_modified_epley(reps),
    max_reps = max_reps_modified_epley(perc_1RM),
    adjustment_perc = max_perc_1RM - perc_1RM,
    adjustment_RIR = max_reps - reps,
    adjustment_rel_int = perc_1RM / max_perc_1RM * 100,
    adjustment_perc_MR = reps / max_reps * 100
  ) %>%
  filter(reps <= 10, step > -3)

progression_tbl$reps <- factor(progression_tbl$reps)
progression_tbl$step <- factor(progression_tbl$step)
progression_tbl$perc_1RM <- format(round(progression_tbl$perc_1RM * 100, 0), nsmall = 0)
progression_tbl$adjustment_perc <- format(round(progression_tbl$adjustment_perc * 100, 1), nsmall = 1)
progression_tbl$adjustment_RIR <- format(round(progression_tbl$adjustment_RIR, 1), nsmall = 1)
progression_tbl$adjustment_rel_int <- format(round(progression_tbl$adjustment_rel_int, 0), nsmall = 0)
progression_tbl$adjustment_perc_MR <- format(round(progression_tbl$adjustment_perc_MR, 0), nsmall = 0)

# Plot
plot_stuff <- function(variable, title) {
  ggplot2::ggplot(progression_tbl, ggplot2::aes(x = step, y = reps)) +
  ggplot2::theme_linedraw(6) +
  ggplot2::geom_tile(fill = "transparent", color = "transparent") +
  ggplot2::geom_text(aes(label = {{ variable }}), size = 2, hjust = 1) +
  # ggfittext::geom_fit_text(ggplot2::aes(label = perc_1RM), min.size = 0) +
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
  ggplot2::ggtitle(title) +
  ggplot2::facet_grid(Progression ~volume)
}

gg1 <- plot_stuff(perc_1RM, "%1RM")
gg2 <- plot_stuff(adjustment_perc, "Adjustment %1RM (deducted intensity)")
gg3 <- plot_stuff(adjustment_RIR, "Reps In Reserve (RIR)")
gg4 <- plot_stuff(adjustment_rel_int, "Relative Intensity (%)")
gg5 <- plot_stuff(adjustment_perc_MR, "% Maximum Number of Reps")



gg <- gg1 + gg2 + gg3 + gg4 + gg5 + plot_layout(ncol = 5)

ggsave("dev/Progressions.pdf", gg, width = 16, height = 7)

# Save to CSV
progression_tbl_long <- progression_tbl %>%
  select(-type, -adjustment, -max_reps, -max_perc_1RM) %>%
  pivot_longer(
    cols = c(perc_1RM, adjustment_perc, adjustment_RIR, adjustment_rel_int, adjustment_perc_MR),
    names_to = "variable", values_to = "value") %>%
  mutate(week = paste0("Wk", 3 + as.numeric(as.character(step)))) %>%
  select(Progression, reps, volume, week, variable, value) %>%
  mutate(variable = factor(variable, levels = c(
    "perc_1RM",
    "adjustment_perc",
    "adjustment_RIR",
    "adjustment_rel_int",
    "adjustment_perc_MR"
  )))

progression_tbl_wide <- progression_tbl_long %>%
  pivot_wider(
    id_cols = c(Progression, reps),
    names_from = c(variable, volume, week), names_sort = TRUE,
    values_from = value)

write_csv(progression_tbl_wide, "dev/progressions.csv")

# Colors
library("scales")
library(ggthemes)
show_col(few_pal()(7))

show_col(few_pal("Dark")(7))

show_col(few_pal("Light")(9))
