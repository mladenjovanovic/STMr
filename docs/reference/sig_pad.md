# Format to significant digits and pad to equal string width

Format to significant digits and pad to equal string width

## Usage

``` r
sig_pad(x, sig = 3L, na = NA_character_)
```

## Arguments

- x:

  Numeric vector.

- sig:

  Integer \>= 1. Significant digits.

- na:

  Character to use for NA values.

## Value

Character vector with equal nchar (non-NA values), left-padded with
spaces.
