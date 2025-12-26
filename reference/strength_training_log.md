# Strength Training Log

A dataset containing strength training log for a single athlete.
Strength training program involves doing two strength training sessions,
over 12 week (4 phases of 3 weeks each). Session A involves linear
wave-loading pattern starting with 2x12/10/8 reps and reaching 2x8/6/4
reps. Session B involves constant wave-loading pattern using 2x3/2/1.
This dataset contains `weight` being used, as well as estimated
reps-in-reserve (eRIR), which represent subjective rating of the
proximity to failure

## Usage

``` r
strength_training_log
```

## Format

A data frame with 144 rows and 8 variables:

- phase:

  Phase index number. Numeric from 1 to 4

- week:

  Week index number (within phase). Numeric from 1 to 3

- day:

  Day (total) index number. Numeric from 1 to 3

- session:

  Name of the session. Can be "Session A" or "Session B"

- set:

  Set index number. Numeric from 1 to 6

- weight:

  Weight in kg being used

- reps:

  Number of reps being done

- eRIR:

  Estimated reps-in-reserve
