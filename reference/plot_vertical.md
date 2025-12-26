# Plotting of the Vertical Planning

Function for creating `ggplot2` plot of the Vertical Planning function

## Usage

``` r
plot_vertical(vertical_plan, reps = c(5, 5, 5), font_size = 14, ...)
```

## Arguments

- vertical_plan:

  Vertical Plan function

- reps:

  Numeric vector

- font_size:

  Numeric. Default is 14

- ...:

  Forwarded to `vertical_plan` function

## Examples

``` r
plot_vertical(vertical_block_undulating, reps = c(8, 6, 4))
```
