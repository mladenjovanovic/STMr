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

#######
# Frederics metrics
# Use single values, not vectors
frederick <- function(load, reps, RIR) {
  # Create a sequence
  df <- data.frame(rep_num = seq(1, reps)) %>%
    mutate(
      RIR_num = reps + RIR - rep_num,
      weight = exp(-0.215 * RIR_num),
      XL = load * weight,
      volume = load)

    list(
      XLp = sum(df$XL),
      XLc = mean(df$XL),
      volume = sum(df$volume),
      df = df
    )
}

frederick_integral <- function(load, reps, RIR) {
  k <- 0.215
  rir_end <- reps + RIR
  rir_start <- RIR
  area <- (exp(-k * rir_start) - exp(-k * rir_end)) / k

  list(
    XLp = area * load,
    XLc = area * load / reps
  )
}

frederick(100, 6.2, 2)

frederick_integral(100, 6.2, 10)
frederick_integral(100, 6.2, 2)

# Check
nreps <- 6
perc1RM <- progression_DI(
  nreps,
  step = -2,
  max_perc_1RM_func = max_perc_1RM_modified_epley)$perc_1RM
maxReps <- max_reps_modified_epley(perc1RM)
estRIR <- maxReps - nreps

frederick(perc1RM*100, nreps, estRIR)
frederick(perc1RM*100, maxReps, 0)

# Simpler
XLp <- function(load, reps, RIR) {
  frederick(load, reps, RIR)$XLp
}

XLc <- function(load, reps, RIR) {
  frederick(load, reps, RIR)$XLc
}

volume <- function(load, reps, RIR) {
  frederick(load, reps, RIR)$volume
}

# Test
frederick(120, 5, 10)
XLp(120, 5, 10)

df <- expand_grid(reps = 1:10, RIR = 5:0) %>%
  mutate(perc1RM = 100 * max_perc_1RM_modified_epley(reps + RIR)) %>%
  rowwise() %>%
  mutate(
    XLp = XLp(perc1RM, reps, RIR),
    XLc = XLc(perc1RM, reps, RIR)
  ) %>%
  ungroup() %>%
  mutate(
    XLp_int = frederick_integral(perc1RM, reps, RIR)$XLp,
    XLc_int = frederick_integral(perc1RM, reps, RIR)$XLc
  )

df %>%
  ggplot(aes(x = XLc, y = XLc_int)) +
  geom_point(alpha = 0.5)

# Get collectinve %1RM adjustement
progression_tbl <- progression_tbl %>%
  mutate(
    max_perc_1RM = max_perc_1RM_modified_epley(reps),
    max_reps = max_reps_modified_epley(perc_1RM),
    adjustment_perc = max_perc_1RM - perc_1RM,
    adjustment_RIR = max_reps - reps,
    adjustment_rel_int = perc_1RM / max_perc_1RM * 100,
    adjustment_perc_MR = reps / max_reps * 100,

    XLperi = frederick_integral(perc_1RM * 100, reps, adjustment_RIR)$XLp,
    maxXLperi = frederick_integral(perc_1RM * 100, max_reps, 0)$XLp,
    percXLperi = XLperi / maxXLperi,

    XLcent = frederick_integral(perc_1RM * 100, reps, adjustment_RIR)$XLc,
    maxXLcent = frederick_integral(perc_1RM * 100, max_reps, 0)$XLc,
    percXLcent = XLcent / maxXLcent,

    Vol = perc_1RM * 100 * reps,
    maxVol = perc_1RM * 100 * max_reps,
    percVol = Vol / maxVol

  ) %>%
  # Add Frederic metrics
  #rowwise() %>%
  #mutate(
  #  XLperi = XLp(perc_1RM * 100, reps, adjustment_RIR),
  #  maxXLperi = XLp(perc_1RM * 100, max_reps, 0),
  #  percXLperi = XLperi / maxXLperi,

  #  XLcent = XLc(perc_1RM * 100, reps, adjustment_RIR),
  #  maxXLcent = XLc(perc_1RM * 100, max_reps, 0),
  #  percXLcent = XLcent / maxXLcent,

  #  Vol = volume(perc_1RM * 100, reps, adjustment_RIR),
  #  maxVol = volume(perc_1RM * 100, max_reps, 0),
  #  percVol = Vol / maxVol
  #) %>%
  #ungroup()
  filter(reps <= 10, step > -3)

progression_tbl$reps <- factor(progression_tbl$reps)
progression_tbl$step <- factor(progression_tbl$step)
progression_tbl$perc_1RM <- format(round(progression_tbl$perc_1RM * 100, 0), nsmall = 0)
progression_tbl$adjustment_perc <- format(round(progression_tbl$adjustment_perc * 100, 1), nsmall = 1)
progression_tbl$adjustment_RIR <- format(round(progression_tbl$adjustment_RIR, 1), nsmall = 1)
progression_tbl$max_reps <- format(round(progression_tbl$max_reps, 1), nsmall = 1)
progression_tbl$adjustment_rel_int <- format(round(progression_tbl$adjustment_rel_int, 0), nsmall = 0)
progression_tbl$adjustment_perc_MR <- format(round(progression_tbl$adjustment_perc_MR, 0), nsmall = 0)

progression_tbl$XLc <- format(round(progression_tbl$XLcent, 0), nsmall = 0)
progression_tbl$XLp <- format(round(progression_tbl$XLperi, 0), nsmall = 0)
progression_tbl$VOL <- format(round(progression_tbl$Vol, 0), nsmall = 0)

progression_tbl$adjustment_XLc <- format(round(progression_tbl$percXLcent * 100, 0), nsmall = 0)
progression_tbl$adjustment_XLp <- format(round(progression_tbl$percXLperi * 100, 0), nsmall = 0)
progression_tbl$adjustment_VOL <- format(round(progression_tbl$percVol * 100, 0), nsmall = 0)

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

plot_stuff(XLc, "XLc")
plot_stuff(XLp, "XLp")
plot_stuff(VOL, "Vol")

gg1 <- plot_stuff(perc_1RM, "%1RM")
gg2 <- plot_stuff(adjustment_perc, "Adjustment %1RM (deducted intensity)")
gg3 <- plot_stuff(adjustment_RIR, "Reps In Reserve (RIR)")
gg4 <- plot_stuff(adjustment_rel_int, "Relative Intensity (%)")
gg5 <- plot_stuff(adjustment_perc_MR, "% Maximum Number of Reps")
gg6 <- plot_stuff(adjustment_XLc, "% XLc")
gg7 <- plot_stuff(adjustment_XLp, "% XLp")

gg <- gg1 + gg2 + gg3 + gg4 + gg5 + gg6 + gg7 + plot_layout(ncol = 7)

ggsave("dev/Progressions.pdf", gg, width = 20, height = 7)

gg6a <- plot_stuff(XLc, "XLc")
gg7a <- plot_stuff(XLp, "XLp")

ggsave(
  "dev/Frederics.pdf",
  gg1 + gg6a + gg6 + gg7a + gg7 + plot_layout(ncol = 5),
  width = 15, height = 7)

# Save to CSV
progression_tbl_long <- progression_tbl %>%
  select(-type, -adjustment, -max_reps, -max_perc_1RM) %>%
  pivot_longer(
    cols = c(
      perc_1RM,
      adjustment_perc,
      adjustment_RIR,
      adjustment_rel_int,
      adjustment_perc_MR,
      XLc,
      adjustment_XLc,
      XLp,
      adjustment_XLp),
    names_to = "variable", values_to = "value") %>%
  mutate(week = paste0("Wk", 3 + as.numeric(as.character(step)))) %>%
  select(Progression, reps, volume, week, variable, value) %>%
  mutate(variable = factor(variable, levels = c(
    "perc_1RM",
    "adjustment_perc",
    "adjustment_RIR",
    "adjustment_rel_int",
    "adjustment_perc_MR",
    "XLc",
    "adjustment_XLc",
    "XLp",
    "adjustment_XLp"
  )))

progression_tbl_wide <- progression_tbl_long %>%
  pivot_wider(
    id_cols = c(Progression, reps),
    names_from = c(variable, volume, week), names_sort = TRUE,
    values_from = value)

write_csv(progression_tbl_wide, "dev/progressions.csv")

