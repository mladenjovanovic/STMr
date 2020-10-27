
<!-- README.md is generated from README.Rmd. Please edit that file -->

# STM <img src="inst/figures/logo.png" align="right" width="200" />

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/STM)](https://CRAN.R-project.org/package=STM)
<!-- badges: end -->

The goal of `STM` is to provide the readers of the [Strength Training
Manual](https://amzn.to/3owbBr6) a list of functions to help them
re-create set and rep schemes as well as to create their own in
reproducible and open-source environment.

## Installation

You can install the released version (once released) of `STM` from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("STM")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("mladenjovanovic/STM")
```

## Examples

This is a quick example, more are coming.

``` r
require(tidyverse)
require(ggstance)
require(STM)

# Plot scheme function
plot_scheme <- function(scheme, label_size = 3) {
  # Reorganize the data
  scheme <- scheme %>%
    group_by(index) %>%
    mutate(
      set = row_number(),
      adjustment = round(adjustment, 1),
      perc_1RM = round(perc_1RM * 100),
      index = paste0("Week ", index)
    ) %>%
    rename(
      RIR = adjustment,
      `%1RM` = perc_1RM
    ) %>%
    pivot_longer(cols = c("reps", "RIR", "%1RM"), names_to = "param") %>%
    mutate(param = factor(param, levels = c("reps", "RIR", "%1RM")))

  # Plot
  ggplot(scheme, aes(x = value, y = set, fill = param)) +
    theme_linedraw() +
    geom_barh(stat = "identity") +
    geom_text(aes(label = value), hjust = 1.1, size = label_size) +
    facet_grid(index ~ param, scales = "free_x") +
    scale_y_reverse() +
    theme(
      legend.position = "none",
      axis.title = element_blank(),
      axis.text = element_blank(),
      axis.ticks = element_blank(),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank()
    ) +
    scale_fill_brewer(palette = "Accent") +
    xlab(NULL) +
    ylab(NULL)
}
```

Wave Set and Rep Scheme

``` r
# Wave set and rep scheme
scheme <- scheme_wave(
  reps = c(10, 8, 6, 10, 8, 6),
  # Adjusting using lower %1RM (perc_drop method used)
  adjustment = c(4, 2, 0, 6, 4, 2),
  vertical_planning = vertical_linear,
  vertical_planning_control = list(reps_change = c(0, -2, -4)),
  progression_table = RIR_increment,
  progression_table_control = list(volume = "extensive")
)

plot_scheme(scheme)
```

<img src="man/figures/README-unnamed-chunk-3-1.png" width="100%" />

Set Accumulation Wave Scheme

``` r
scheme <- scheme_wave(
  reps = c(10, 8, 6),
  # Needed to remove default scheme_wave adjustment
  adjustment = 0,
  vertical_planning = vertical_set_accumulation,
  vertical_planning_control = list(accumulate_rep = c(1, 2, 3)),
  progression_table = RIR_increment,
  progression_table_control = list(volume = "extensive"))

plot_scheme(scheme, label_size = 2.5)
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" />
