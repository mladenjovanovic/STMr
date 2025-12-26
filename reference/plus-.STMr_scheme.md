# Method for adding set and rep schemes

Method for adding set and rep schemes

## Usage

``` r
# S3 method for class 'STMr_scheme'
lhs + rhs
```

## Arguments

- lhs:

  `STMr_scheme` object

- rhs:

  `STMr_scheme` object

## Value

`STMr_scheme` object

## Examples

``` r
scheme1 <- scheme_wave()
warmup_scheme <- scheme_perc_1RM()
plot(warmup_scheme + scheme1)
```
