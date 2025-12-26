# Plotting of the Release

Function for creating `ggplot2` plot of the Release `STMr_release`
object

## Usage

``` r
# S3 method for class 'STMr_release'
plot(x, font_size = 14, load_1RM_agg_func = max, ...)
```

## Arguments

- x:

  `STMr_release` object

- font_size:

  Numeric. Default is 14

- load_1RM_agg_func:

  Function to aggregate step `load_1RM` from multiple sets. Default is
  [`max`](https://rdrr.io/r/base/Extremes.html)

- ...:

  Forwarded to
  [`geom_bar_text`](https://wilkox.org/ggfittext/reference/geom_fit_text.html)
  and
  [`geom_fit_text`](https://wilkox.org/ggfittext/reference/geom_fit_text.html)
  functions. Can be used to se the highest labels size, for example,
  using `size=5`. See documentation for these two packages for more info

## Value

`ggplot2` object

## Examples

``` r
scheme1 <- scheme_step(vertical_planning = vertical_constant)
scheme2 <- scheme_step(vertical_planning = vertical_linear)
scheme3 <- scheme_step(vertical_planning = vertical_undulating)

release_df <- release(
  scheme1, scheme2, scheme3,
  additive_1RM_adjustment = 2.5
)

plot(release_df)
```
