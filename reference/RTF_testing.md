# Reps to failure testing of 12 athletes

A dataset containing reps to failure testing for 12 athletes using 70,
80, and 90% of 1RM

## Usage

``` r
RTF_testing
```

## Format

A data frame with 36 rows and 6 variables:

- Athlete:

  Name of the athlete; ID

- 1RM:

  Maximum weight the athlete can lift correctly for a single rep

- Target %1RM:

  %1RM we want to use for testing; 70, 80, or 90%

- Target Weight:

  Estimated weight to be lifted

- Real Weight:

  Weight that is estimated to be lifted, but rounded to closest 2.5

- Real %1RM:

  Recalculated %1RM after rounding the weight

- nRM:

  Reps-to-failure (RTF), or the number of maximum repetitions (nRM)
  performed
