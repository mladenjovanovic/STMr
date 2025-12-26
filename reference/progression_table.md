# Family of functions to create progression tables

Family of functions to create progression tables

## Usage

``` r
generate_progression_table(
  progression_table,
  type = c("grinding", "ballistic", "conservative"),
  volume = c("intensive", "normal", "extensive"),
  reps = 1:12,
  step = seq(-3, 0, 1),
  ...
)

progression_DI(
  reps,
  step = 0,
  volume = "normal",
  adjustment = 0,
  type = "grinding",
  mfactor = NULL,
  step_increment = -0.025,
  volume_increment = step_increment,
  ...
)

progression_RIR(
  reps,
  step = 0,
  volume = "normal",
  adjustment = 0,
  type = "grinding",
  mfactor = NULL,
  step_increment = 1,
  volume_increment = step_increment,
  ...
)

progression_RIR_increment(
  reps,
  step = 0,
  volume = "normal",
  adjustment = 0,
  type = "grinding",
  mfactor = NULL,
  ...
)

progression_perc_MR(
  reps,
  step = 0,
  volume = "normal",
  adjustment = 0,
  type = "grinding",
  mfactor = NULL,
  step_increment = -0.1,
  volume_increment = -0.2,
  ...
)

progression_perc_MR_variable(
  reps,
  step = 0,
  volume = "normal",
  adjustment = 0,
  type = "grinding",
  mfactor = NULL,
  ...
)

progression_perc_drop(
  reps,
  step = 0,
  volume = "normal",
  adjustment = 0,
  type = "grinding",
  mfactor = NULL,
  ...
)

progression_rel_int(
  reps,
  step = 0,
  volume = "normal",
  adjustment = 0,
  type = "grinding",
  mfactor = NULL,
  step_increment = -0.05,
  volume_increment = -0.075,
  ...
)
```

## Arguments

- progression_table:

  Progression table function to use

- type:

  Character vector. Type of max rep table. Options are grinding
  (Default), ballistic, and conservative.

- volume:

  Character vector: 'intensive', 'normal' (Default), or 'extensive'

- reps:

  Numeric vector. Number of repetition to be performed

- step:

  Numeric vector. Progression step. Default is 0. Use negative numbers
  (i.e., -1, -2)

- ...:

  Extra arguments forwarded to
  [`adj_perc_1RM`](https://mladenjovanovic.github.io/STMr/reference/adj_perc_1RM.md)
  family of functions Use this to supply different parameter value
  (i.e., `k = 0.035`), or model function (i.e.,
  `max_perc_1RM_func = max_perc_1RM_linear)`

- adjustment:

  Numeric vector. Additional post adjustment applied to sets. Default is
  none (value depends on the method).

- mfactor:

  Numeric vector. Factor to adjust max rep table. Used instead of `type`
  parameter, unless `NULL`

- step_increment, volume_increment:

  Numeric vector. Used to adjust specific progression methods

## Value

List with two elements: `adjustment` and `perc_1RM`

## Functions

- `generate_progression_table()`: Generates progression tables

- `progression_DI()`: Deducted Intensity progression table. This
  simplest progression table simply deducts intensity to progress.
  Adjust this deducted by using the `deduction` parameter (default is
  equal to -0.025)

- `progression_RIR()`: Constant RIR Increment progression table. This
  variant have constant RIR increment across reps from phases to phases
  and RIR difference between extensive, normal, and intensive schemes.
  Use `step_increment` and `volume_increment` parameters to utilize
  needed increments

- `progression_RIR_increment()`: RIR Increment progression table (see
  Strength Training Manual)

- `progression_perc_MR()`: Constant %MR Step progression table. This
  variant have constant %MR increment across reps from phases to phases
  and %MR difference between extensive, normal, and intensive schemes.
  Use `step_increment` and `volume_increment` parameters to utilize
  needed increments

- `progression_perc_MR_variable()`: Variable %MR Step progression table

- `progression_perc_drop()`: Perc Drop progression table (see Strength
  Training Manual)

- `progression_rel_int()`: Relative Intensity progression table. Use
  `step_increment` and `volume_increment` parameters to utilize needed
  increments

## References

    Jovanović M. 2020. Strength Training Manual: The Agile Periodization Approach.
    Independently published.

    Jovanović M. 2020. Strength Training Manual: The Agile Periodization Approach.
    Independently published.

## Examples

``` r
generate_progression_table(progression_RIR)
#>             type    volume reps step adjustment  perc_1RM
#> 1       grinding intensive    1   -3          3 0.8824568
#> 2      ballistic intensive    1   -3          3 0.7896399
#> 3   conservative intensive    1   -3          3 0.7144899
#> 4       grinding    normal    1   -3          4 0.8572653
#> 5      ballistic    normal    1   -3          4 0.7501875
#> 6   conservative    normal    1   -3          4 0.6668890
#> 7       grinding extensive    1   -3          5 0.8334722
#> 8      ballistic extensive    1   -3          5 0.7144899
#> 9   conservative extensive    1   -3          5 0.6252345
#> 10      grinding intensive    2   -3          3 0.8572653
#> 11     ballistic intensive    2   -3          3 0.7501875
#> 12  conservative intensive    2   -3          3 0.6668890
#> 13      grinding    normal    2   -3          4 0.8334722
#> 14     ballistic    normal    2   -3          4 0.7144899
#> 15  conservative    normal    2   -3          4 0.6252345
#> 16      grinding extensive    2   -3          5 0.8109642
#> 17     ballistic extensive    2   -3          5 0.6820352
#> 18  conservative extensive    2   -3          5 0.5884776
#> 19      grinding intensive    3   -3          3 0.8334722
#> 20     ballistic intensive    3   -3          3 0.7144899
#> 21  conservative intensive    3   -3          3 0.6252345
#> 22      grinding    normal    3   -3          4 0.8109642
#> 23     ballistic    normal    3   -3          4 0.6820352
#> 24  conservative    normal    3   -3          4 0.5884776
#> 25      grinding extensive    3   -3          5 0.7896399
#> 26     ballistic extensive    3   -3          5 0.6524008
#> 27  conservative extensive    3   -3          5 0.5558026
#> 28      grinding intensive    4   -3          3 0.8109642
#> 29     ballistic intensive    4   -3          3 0.6820352
#> 30  conservative intensive    4   -3          3 0.5884776
#> 31      grinding    normal    4   -3          4 0.7896399
#> 32     ballistic    normal    4   -3          4 0.6524008
#> 33  conservative    normal    4   -3          4 0.5558026
#> 34      grinding extensive    4   -3          5 0.7694083
#> 35     ballistic extensive    4   -3          5 0.6252345
#> 36  conservative extensive    4   -3          5 0.5265652
#> 37      grinding intensive    5   -3          3 0.7896399
#> 38     ballistic intensive    5   -3          3 0.6524008
#> 39  conservative intensive    5   -3          3 0.5558026
#> 40      grinding    normal    5   -3          4 0.7694083
#> 41     ballistic    normal    5   -3          4 0.6252345
#> 42  conservative    normal    5   -3          4 0.5265652
#> 43      grinding extensive    5   -3          5 0.7501875
#> 44     ballistic extensive    5   -3          5 0.6002401
#> 45  conservative extensive    5   -3          5 0.5002501
#> 46      grinding intensive    6   -3          3 0.7694083
#> 47     ballistic intensive    6   -3          3 0.6252345
#> 48  conservative intensive    6   -3          3 0.5265652
#> 49      grinding    normal    6   -3          4 0.7501875
#> 50     ballistic    normal    6   -3          4 0.6002401
#> 51  conservative    normal    6   -3          4 0.5002501
#> 52      grinding extensive    6   -3          5 0.7319037
#> 53     ballistic extensive    6   -3          5 0.5771673
#> 54  conservative extensive    6   -3          5 0.4764400
#> 55      grinding intensive    7   -3          3 0.7501875
#> 56     ballistic intensive    7   -3          3 0.6002401
#> 57  conservative intensive    7   -3          3 0.5002501
#> 58      grinding    normal    7   -3          4 0.7319037
#> 59     ballistic    normal    7   -3          4 0.5771673
#> 60  conservative    normal    7   -3          4 0.4764400
#> 61      grinding extensive    7   -3          5 0.7144899
#> 62     ballistic extensive    7   -3          5 0.5558026
#> 63  conservative extensive    7   -3          5 0.4547935
#> 64      grinding intensive    8   -3          3 0.7319037
#> 65     ballistic intensive    8   -3          3 0.5771673
#> 66  conservative intensive    8   -3          3 0.4764400
#> 67      grinding    normal    8   -3          4 0.7144899
#> 68     ballistic    normal    8   -3          4 0.5558026
#> 69  conservative    normal    8   -3          4 0.4547935
#> 70      grinding extensive    8   -3          5 0.6978854
#> 71     ballistic extensive    8   -3          5 0.5359631
#> 72  conservative extensive    8   -3          5 0.4350285
#> 73      grinding intensive    9   -3          3 0.7144899
#> 74     ballistic intensive    9   -3          3 0.5558026
#> 75  conservative intensive    9   -3          3 0.4547935
#> 76      grinding    normal    9   -3          4 0.6978854
#> 77     ballistic    normal    9   -3          4 0.5359631
#> 78  conservative    normal    9   -3          4 0.4350285
#> 79      grinding extensive    9   -3          5 0.6820352
#> 80     ballistic extensive    9   -3          5 0.5174912
#> 81  conservative extensive    9   -3          5 0.4169099
#> 82      grinding intensive   10   -3          3 0.6978854
#> 83     ballistic intensive   10   -3          3 0.5359631
#> 84  conservative intensive   10   -3          3 0.4350285
#> 85      grinding    normal   10   -3          4 0.6820352
#> 86     ballistic    normal   10   -3          4 0.5174912
#> 87  conservative    normal   10   -3          4 0.4169099
#> 88      grinding extensive   10   -3          5 0.6668890
#> 89     ballistic extensive   10   -3          5 0.5002501
#> 90  conservative extensive   10   -3          5 0.4002401
#> 91      grinding intensive   11   -3          3 0.6820352
#> 92     ballistic intensive   11   -3          3 0.5174912
#> 93  conservative intensive   11   -3          3 0.4169099
#> 94      grinding    normal   11   -3          4 0.6668890
#> 95     ballistic    normal   11   -3          4 0.5002501
#> 96  conservative    normal   11   -3          4 0.4002401
#> 97      grinding extensive   11   -3          5 0.6524008
#> 98     ballistic extensive   11   -3          5 0.4841208
#> 99  conservative extensive   11   -3          5 0.3848522
#> 100     grinding intensive   12   -3          3 0.6668890
#> 101    ballistic intensive   12   -3          3 0.5002501
#> 102 conservative intensive   12   -3          3 0.4002401
#> 103     grinding    normal   12   -3          4 0.6524008
#> 104    ballistic    normal   12   -3          4 0.4841208
#> 105 conservative    normal   12   -3          4 0.3848522
#> 106     grinding extensive   12   -3          5 0.6385288
#> 107    ballistic extensive   12   -3          5 0.4689992
#> 108 conservative extensive   12   -3          5 0.3706037
#> 109     grinding intensive    1   -2          2 0.9091736
#> 110    ballistic intensive    1   -2          2 0.8334722
#> 111 conservative intensive    1   -2          2 0.7694083
#> 112     grinding    normal    1   -2          3 0.8824568
#> 113    ballistic    normal    1   -2          3 0.7896399
#> 114 conservative    normal    1   -2          3 0.7144899
#> 115     grinding extensive    1   -2          4 0.8572653
#> 116    ballistic extensive    1   -2          4 0.7501875
#> 117 conservative extensive    1   -2          4 0.6668890
#> 118     grinding intensive    2   -2          2 0.8824568
#> 119    ballistic intensive    2   -2          2 0.7896399
#> 120 conservative intensive    2   -2          2 0.7144899
#> 121     grinding    normal    2   -2          3 0.8572653
#> 122    ballistic    normal    2   -2          3 0.7501875
#> 123 conservative    normal    2   -2          3 0.6668890
#> 124     grinding extensive    2   -2          4 0.8334722
#> 125    ballistic extensive    2   -2          4 0.7144899
#> 126 conservative extensive    2   -2          4 0.6252345
#> 127     grinding intensive    3   -2          2 0.8572653
#> 128    ballistic intensive    3   -2          2 0.7501875
#> 129 conservative intensive    3   -2          2 0.6668890
#> 130     grinding    normal    3   -2          3 0.8334722
#> 131    ballistic    normal    3   -2          3 0.7144899
#> 132 conservative    normal    3   -2          3 0.6252345
#> 133     grinding extensive    3   -2          4 0.8109642
#> 134    ballistic extensive    3   -2          4 0.6820352
#> 135 conservative extensive    3   -2          4 0.5884776
#> 136     grinding intensive    4   -2          2 0.8334722
#> 137    ballistic intensive    4   -2          2 0.7144899
#> 138 conservative intensive    4   -2          2 0.6252345
#> 139     grinding    normal    4   -2          3 0.8109642
#> 140    ballistic    normal    4   -2          3 0.6820352
#> 141 conservative    normal    4   -2          3 0.5884776
#> 142     grinding extensive    4   -2          4 0.7896399
#> 143    ballistic extensive    4   -2          4 0.6524008
#> 144 conservative extensive    4   -2          4 0.5558026
#> 145     grinding intensive    5   -2          2 0.8109642
#> 146    ballistic intensive    5   -2          2 0.6820352
#> 147 conservative intensive    5   -2          2 0.5884776
#> 148     grinding    normal    5   -2          3 0.7896399
#> 149    ballistic    normal    5   -2          3 0.6524008
#> 150 conservative    normal    5   -2          3 0.5558026
#> 151     grinding extensive    5   -2          4 0.7694083
#> 152    ballistic extensive    5   -2          4 0.6252345
#> 153 conservative extensive    5   -2          4 0.5265652
#> 154     grinding intensive    6   -2          2 0.7896399
#> 155    ballistic intensive    6   -2          2 0.6524008
#> 156 conservative intensive    6   -2          2 0.5558026
#> 157     grinding    normal    6   -2          3 0.7694083
#> 158    ballistic    normal    6   -2          3 0.6252345
#> 159 conservative    normal    6   -2          3 0.5265652
#> 160     grinding extensive    6   -2          4 0.7501875
#> 161    ballistic extensive    6   -2          4 0.6002401
#> 162 conservative extensive    6   -2          4 0.5002501
#> 163     grinding intensive    7   -2          2 0.7694083
#> 164    ballistic intensive    7   -2          2 0.6252345
#> 165 conservative intensive    7   -2          2 0.5265652
#> 166     grinding    normal    7   -2          3 0.7501875
#> 167    ballistic    normal    7   -2          3 0.6002401
#> 168 conservative    normal    7   -2          3 0.5002501
#> 169     grinding extensive    7   -2          4 0.7319037
#> 170    ballistic extensive    7   -2          4 0.5771673
#> 171 conservative extensive    7   -2          4 0.4764400
#> 172     grinding intensive    8   -2          2 0.7501875
#> 173    ballistic intensive    8   -2          2 0.6002401
#> 174 conservative intensive    8   -2          2 0.5002501
#> 175     grinding    normal    8   -2          3 0.7319037
#> 176    ballistic    normal    8   -2          3 0.5771673
#> 177 conservative    normal    8   -2          3 0.4764400
#> 178     grinding extensive    8   -2          4 0.7144899
#> 179    ballistic extensive    8   -2          4 0.5558026
#> 180 conservative extensive    8   -2          4 0.4547935
#> 181     grinding intensive    9   -2          2 0.7319037
#> 182    ballistic intensive    9   -2          2 0.5771673
#> 183 conservative intensive    9   -2          2 0.4764400
#> 184     grinding    normal    9   -2          3 0.7144899
#> 185    ballistic    normal    9   -2          3 0.5558026
#> 186 conservative    normal    9   -2          3 0.4547935
#> 187     grinding extensive    9   -2          4 0.6978854
#> 188    ballistic extensive    9   -2          4 0.5359631
#> 189 conservative extensive    9   -2          4 0.4350285
#> 190     grinding intensive   10   -2          2 0.7144899
#> 191    ballistic intensive   10   -2          2 0.5558026
#> 192 conservative intensive   10   -2          2 0.4547935
#> 193     grinding    normal   10   -2          3 0.6978854
#> 194    ballistic    normal   10   -2          3 0.5359631
#> 195 conservative    normal   10   -2          3 0.4350285
#> 196     grinding extensive   10   -2          4 0.6820352
#> 197    ballistic extensive   10   -2          4 0.5174912
#> 198 conservative extensive   10   -2          4 0.4169099
#> 199     grinding intensive   11   -2          2 0.6978854
#> 200    ballistic intensive   11   -2          2 0.5359631
#> 201 conservative intensive   11   -2          2 0.4350285
#> 202     grinding    normal   11   -2          3 0.6820352
#> 203    ballistic    normal   11   -2          3 0.5174912
#> 204 conservative    normal   11   -2          3 0.4169099
#> 205     grinding extensive   11   -2          4 0.6668890
#> 206    ballistic extensive   11   -2          4 0.5002501
#> 207 conservative extensive   11   -2          4 0.4002401
#> 208     grinding intensive   12   -2          2 0.6820352
#> 209    ballistic intensive   12   -2          2 0.5174912
#> 210 conservative intensive   12   -2          2 0.4169099
#> 211     grinding    normal   12   -2          3 0.6668890
#> 212    ballistic    normal   12   -2          3 0.5002501
#> 213 conservative    normal   12   -2          3 0.4002401
#> 214     grinding extensive   12   -2          4 0.6524008
#> 215    ballistic extensive   12   -2          4 0.4841208
#> 216 conservative extensive   12   -2          4 0.3848522
#> 217     grinding intensive    1   -1          1 0.9375586
#> 218    ballistic intensive    1   -1          1 0.8824568
#> 219 conservative intensive    1   -1          1 0.8334722
#> 220     grinding    normal    1   -1          2 0.9091736
#> 221    ballistic    normal    1   -1          2 0.8334722
#> 222 conservative    normal    1   -1          2 0.7694083
#> 223     grinding extensive    1   -1          3 0.8824568
#> 224    ballistic extensive    1   -1          3 0.7896399
#> 225 conservative extensive    1   -1          3 0.7144899
#> 226     grinding intensive    2   -1          1 0.9091736
#> 227    ballistic intensive    2   -1          1 0.8334722
#> 228 conservative intensive    2   -1          1 0.7694083
#> 229     grinding    normal    2   -1          2 0.8824568
#> 230    ballistic    normal    2   -1          2 0.7896399
#> 231 conservative    normal    2   -1          2 0.7144899
#> 232     grinding extensive    2   -1          3 0.8572653
#> 233    ballistic extensive    2   -1          3 0.7501875
#> 234 conservative extensive    2   -1          3 0.6668890
#> 235     grinding intensive    3   -1          1 0.8824568
#> 236    ballistic intensive    3   -1          1 0.7896399
#> 237 conservative intensive    3   -1          1 0.7144899
#> 238     grinding    normal    3   -1          2 0.8572653
#> 239    ballistic    normal    3   -1          2 0.7501875
#> 240 conservative    normal    3   -1          2 0.6668890
#> 241     grinding extensive    3   -1          3 0.8334722
#> 242    ballistic extensive    3   -1          3 0.7144899
#> 243 conservative extensive    3   -1          3 0.6252345
#> 244     grinding intensive    4   -1          1 0.8572653
#> 245    ballistic intensive    4   -1          1 0.7501875
#> 246 conservative intensive    4   -1          1 0.6668890
#> 247     grinding    normal    4   -1          2 0.8334722
#> 248    ballistic    normal    4   -1          2 0.7144899
#> 249 conservative    normal    4   -1          2 0.6252345
#> 250     grinding extensive    4   -1          3 0.8109642
#> 251    ballistic extensive    4   -1          3 0.6820352
#> 252 conservative extensive    4   -1          3 0.5884776
#> 253     grinding intensive    5   -1          1 0.8334722
#> 254    ballistic intensive    5   -1          1 0.7144899
#> 255 conservative intensive    5   -1          1 0.6252345
#> 256     grinding    normal    5   -1          2 0.8109642
#> 257    ballistic    normal    5   -1          2 0.6820352
#> 258 conservative    normal    5   -1          2 0.5884776
#> 259     grinding extensive    5   -1          3 0.7896399
#> 260    ballistic extensive    5   -1          3 0.6524008
#> 261 conservative extensive    5   -1          3 0.5558026
#> 262     grinding intensive    6   -1          1 0.8109642
#> 263    ballistic intensive    6   -1          1 0.6820352
#> 264 conservative intensive    6   -1          1 0.5884776
#> 265     grinding    normal    6   -1          2 0.7896399
#> 266    ballistic    normal    6   -1          2 0.6524008
#> 267 conservative    normal    6   -1          2 0.5558026
#> 268     grinding extensive    6   -1          3 0.7694083
#> 269    ballistic extensive    6   -1          3 0.6252345
#> 270 conservative extensive    6   -1          3 0.5265652
#> 271     grinding intensive    7   -1          1 0.7896399
#> 272    ballistic intensive    7   -1          1 0.6524008
#> 273 conservative intensive    7   -1          1 0.5558026
#> 274     grinding    normal    7   -1          2 0.7694083
#> 275    ballistic    normal    7   -1          2 0.6252345
#> 276 conservative    normal    7   -1          2 0.5265652
#> 277     grinding extensive    7   -1          3 0.7501875
#> 278    ballistic extensive    7   -1          3 0.6002401
#> 279 conservative extensive    7   -1          3 0.5002501
#> 280     grinding intensive    8   -1          1 0.7694083
#> 281    ballistic intensive    8   -1          1 0.6252345
#> 282 conservative intensive    8   -1          1 0.5265652
#> 283     grinding    normal    8   -1          2 0.7501875
#> 284    ballistic    normal    8   -1          2 0.6002401
#> 285 conservative    normal    8   -1          2 0.5002501
#> 286     grinding extensive    8   -1          3 0.7319037
#> 287    ballistic extensive    8   -1          3 0.5771673
#> 288 conservative extensive    8   -1          3 0.4764400
#> 289     grinding intensive    9   -1          1 0.7501875
#> 290    ballistic intensive    9   -1          1 0.6002401
#> 291 conservative intensive    9   -1          1 0.5002501
#> 292     grinding    normal    9   -1          2 0.7319037
#> 293    ballistic    normal    9   -1          2 0.5771673
#> 294 conservative    normal    9   -1          2 0.4764400
#> 295     grinding extensive    9   -1          3 0.7144899
#> 296    ballistic extensive    9   -1          3 0.5558026
#> 297 conservative extensive    9   -1          3 0.4547935
#> 298     grinding intensive   10   -1          1 0.7319037
#> 299    ballistic intensive   10   -1          1 0.5771673
#> 300 conservative intensive   10   -1          1 0.4764400
#> 301     grinding    normal   10   -1          2 0.7144899
#> 302    ballistic    normal   10   -1          2 0.5558026
#> 303 conservative    normal   10   -1          2 0.4547935
#> 304     grinding extensive   10   -1          3 0.6978854
#> 305    ballistic extensive   10   -1          3 0.5359631
#> 306 conservative extensive   10   -1          3 0.4350285
#> 307     grinding intensive   11   -1          1 0.7144899
#> 308    ballistic intensive   11   -1          1 0.5558026
#> 309 conservative intensive   11   -1          1 0.4547935
#> 310     grinding    normal   11   -1          2 0.6978854
#> 311    ballistic    normal   11   -1          2 0.5359631
#> 312 conservative    normal   11   -1          2 0.4350285
#> 313     grinding extensive   11   -1          3 0.6820352
#> 314    ballistic extensive   11   -1          3 0.5174912
#> 315 conservative extensive   11   -1          3 0.4169099
#> 316     grinding intensive   12   -1          1 0.6978854
#> 317    ballistic intensive   12   -1          1 0.5359631
#> 318 conservative intensive   12   -1          1 0.4350285
#> 319     grinding    normal   12   -1          2 0.6820352
#> 320    ballistic    normal   12   -1          2 0.5174912
#> 321 conservative    normal   12   -1          2 0.4169099
#> 322     grinding extensive   12   -1          3 0.6668890
#> 323    ballistic extensive   12   -1          3 0.5002501
#> 324 conservative extensive   12   -1          3 0.4002401
#> 325     grinding intensive    1    0          0 0.9677732
#> 326    ballistic intensive    1    0          0 0.9375586
#> 327 conservative intensive    1    0          0 0.9091736
#> 328     grinding    normal    1    0          1 0.9375586
#> 329    ballistic    normal    1    0          1 0.8824568
#> 330 conservative    normal    1    0          1 0.8334722
#> 331     grinding extensive    1    0          2 0.9091736
#> 332    ballistic extensive    1    0          2 0.8334722
#> 333 conservative extensive    1    0          2 0.7694083
#> 334     grinding intensive    2    0          0 0.9375586
#> 335    ballistic intensive    2    0          0 0.8824568
#> 336 conservative intensive    2    0          0 0.8334722
#> 337     grinding    normal    2    0          1 0.9091736
#> 338    ballistic    normal    2    0          1 0.8334722
#> 339 conservative    normal    2    0          1 0.7694083
#> 340     grinding extensive    2    0          2 0.8824568
#> 341    ballistic extensive    2    0          2 0.7896399
#> 342 conservative extensive    2    0          2 0.7144899
#> 343     grinding intensive    3    0          0 0.9091736
#> 344    ballistic intensive    3    0          0 0.8334722
#> 345 conservative intensive    3    0          0 0.7694083
#> 346     grinding    normal    3    0          1 0.8824568
#> 347    ballistic    normal    3    0          1 0.7896399
#> 348 conservative    normal    3    0          1 0.7144899
#> 349     grinding extensive    3    0          2 0.8572653
#> 350    ballistic extensive    3    0          2 0.7501875
#> 351 conservative extensive    3    0          2 0.6668890
#> 352     grinding intensive    4    0          0 0.8824568
#> 353    ballistic intensive    4    0          0 0.7896399
#> 354 conservative intensive    4    0          0 0.7144899
#> 355     grinding    normal    4    0          1 0.8572653
#> 356    ballistic    normal    4    0          1 0.7501875
#> 357 conservative    normal    4    0          1 0.6668890
#> 358     grinding extensive    4    0          2 0.8334722
#> 359    ballistic extensive    4    0          2 0.7144899
#> 360 conservative extensive    4    0          2 0.6252345
#> 361     grinding intensive    5    0          0 0.8572653
#> 362    ballistic intensive    5    0          0 0.7501875
#> 363 conservative intensive    5    0          0 0.6668890
#> 364     grinding    normal    5    0          1 0.8334722
#> 365    ballistic    normal    5    0          1 0.7144899
#> 366 conservative    normal    5    0          1 0.6252345
#> 367     grinding extensive    5    0          2 0.8109642
#> 368    ballistic extensive    5    0          2 0.6820352
#> 369 conservative extensive    5    0          2 0.5884776
#> 370     grinding intensive    6    0          0 0.8334722
#> 371    ballistic intensive    6    0          0 0.7144899
#> 372 conservative intensive    6    0          0 0.6252345
#> 373     grinding    normal    6    0          1 0.8109642
#> 374    ballistic    normal    6    0          1 0.6820352
#> 375 conservative    normal    6    0          1 0.5884776
#> 376     grinding extensive    6    0          2 0.7896399
#> 377    ballistic extensive    6    0          2 0.6524008
#> 378 conservative extensive    6    0          2 0.5558026
#> 379     grinding intensive    7    0          0 0.8109642
#> 380    ballistic intensive    7    0          0 0.6820352
#> 381 conservative intensive    7    0          0 0.5884776
#> 382     grinding    normal    7    0          1 0.7896399
#> 383    ballistic    normal    7    0          1 0.6524008
#> 384 conservative    normal    7    0          1 0.5558026
#> 385     grinding extensive    7    0          2 0.7694083
#> 386    ballistic extensive    7    0          2 0.6252345
#> 387 conservative extensive    7    0          2 0.5265652
#> 388     grinding intensive    8    0          0 0.7896399
#> 389    ballistic intensive    8    0          0 0.6524008
#> 390 conservative intensive    8    0          0 0.5558026
#> 391     grinding    normal    8    0          1 0.7694083
#> 392    ballistic    normal    8    0          1 0.6252345
#> 393 conservative    normal    8    0          1 0.5265652
#> 394     grinding extensive    8    0          2 0.7501875
#> 395    ballistic extensive    8    0          2 0.6002401
#> 396 conservative extensive    8    0          2 0.5002501
#> 397     grinding intensive    9    0          0 0.7694083
#> 398    ballistic intensive    9    0          0 0.6252345
#> 399 conservative intensive    9    0          0 0.5265652
#> 400     grinding    normal    9    0          1 0.7501875
#> 401    ballistic    normal    9    0          1 0.6002401
#> 402 conservative    normal    9    0          1 0.5002501
#> 403     grinding extensive    9    0          2 0.7319037
#> 404    ballistic extensive    9    0          2 0.5771673
#> 405 conservative extensive    9    0          2 0.4764400
#> 406     grinding intensive   10    0          0 0.7501875
#> 407    ballistic intensive   10    0          0 0.6002401
#> 408 conservative intensive   10    0          0 0.5002501
#> 409     grinding    normal   10    0          1 0.7319037
#> 410    ballistic    normal   10    0          1 0.5771673
#> 411 conservative    normal   10    0          1 0.4764400
#> 412     grinding extensive   10    0          2 0.7144899
#> 413    ballistic extensive   10    0          2 0.5558026
#> 414 conservative extensive   10    0          2 0.4547935
#> 415     grinding intensive   11    0          0 0.7319037
#> 416    ballistic intensive   11    0          0 0.5771673
#> 417 conservative intensive   11    0          0 0.4764400
#> 418     grinding    normal   11    0          1 0.7144899
#> 419    ballistic    normal   11    0          1 0.5558026
#> 420 conservative    normal   11    0          1 0.4547935
#> 421     grinding extensive   11    0          2 0.6978854
#> 422    ballistic extensive   11    0          2 0.5359631
#> 423 conservative extensive   11    0          2 0.4350285
#> 424     grinding intensive   12    0          0 0.7144899
#> 425    ballistic intensive   12    0          0 0.5558026
#> 426 conservative intensive   12    0          0 0.4547935
#> 427     grinding    normal   12    0          1 0.6978854
#> 428    ballistic    normal   12    0          1 0.5359631
#> 429 conservative    normal   12    0          1 0.4350285
#> 430     grinding extensive   12    0          2 0.6820352
#> 431    ballistic extensive   12    0          2 0.5174912
#> 432 conservative extensive   12    0          2 0.4169099

generate_progression_table(
  progression_RIR,
  type = "grinding",
  volume = "normal",
  step_increment = 2
)
#>        type volume reps step adjustment  perc_1RM
#> 1  grinding normal    1   -3          8 0.7694083
#> 2  grinding normal    2   -3          8 0.7501875
#> 3  grinding normal    3   -3          8 0.7319037
#> 4  grinding normal    4   -3          8 0.7144899
#> 5  grinding normal    5   -3          8 0.6978854
#> 6  grinding normal    6   -3          8 0.6820352
#> 7  grinding normal    7   -3          8 0.6668890
#> 8  grinding normal    8   -3          8 0.6524008
#> 9  grinding normal    9   -3          8 0.6385288
#> 10 grinding normal   10   -3          8 0.6252345
#> 11 grinding normal   11   -3          8 0.6124824
#> 12 grinding normal   12   -3          8 0.6002401
#> 13 grinding normal    1   -2          6 0.8109642
#> 14 grinding normal    2   -2          6 0.7896399
#> 15 grinding normal    3   -2          6 0.7694083
#> 16 grinding normal    4   -2          6 0.7501875
#> 17 grinding normal    5   -2          6 0.7319037
#> 18 grinding normal    6   -2          6 0.7144899
#> 19 grinding normal    7   -2          6 0.6978854
#> 20 grinding normal    8   -2          6 0.6820352
#> 21 grinding normal    9   -2          6 0.6668890
#> 22 grinding normal   10   -2          6 0.6524008
#> 23 grinding normal   11   -2          6 0.6385288
#> 24 grinding normal   12   -2          6 0.6252345
#> 25 grinding normal    1   -1          4 0.8572653
#> 26 grinding normal    2   -1          4 0.8334722
#> 27 grinding normal    3   -1          4 0.8109642
#> 28 grinding normal    4   -1          4 0.7896399
#> 29 grinding normal    5   -1          4 0.7694083
#> 30 grinding normal    6   -1          4 0.7501875
#> 31 grinding normal    7   -1          4 0.7319037
#> 32 grinding normal    8   -1          4 0.7144899
#> 33 grinding normal    9   -1          4 0.6978854
#> 34 grinding normal   10   -1          4 0.6820352
#> 35 grinding normal   11   -1          4 0.6668890
#> 36 grinding normal   12   -1          4 0.6524008
#> 37 grinding normal    1    0          2 0.9091736
#> 38 grinding normal    2    0          2 0.8824568
#> 39 grinding normal    3    0          2 0.8572653
#> 40 grinding normal    4    0          2 0.8334722
#> 41 grinding normal    5    0          2 0.8109642
#> 42 grinding normal    6    0          2 0.7896399
#> 43 grinding normal    7    0          2 0.7694083
#> 44 grinding normal    8    0          2 0.7501875
#> 45 grinding normal    9    0          2 0.7319037
#> 46 grinding normal   10    0          2 0.7144899
#> 47 grinding normal   11    0          2 0.6978854
#> 48 grinding normal   12    0          2 0.6820352

# Create progression table using specific reps-max table and k value
generate_progression_table(
  progression_RIR,
  max_perc_1RM_func = max_perc_1RM_modified_epley,
  kmod = 0.0388
)
#>             type    volume reps step adjustment  perc_1RM
#> 1       grinding intensive    1   -3          3 0.8957363
#> 2      ballistic intensive    1   -3          3 0.7864108
#> 3   conservative intensive    1   -3          3 0.7008691
#> 4       grinding    normal    1   -3          4 0.8656510
#> 5      ballistic    normal    1   -3          4 0.7411800
#> 6   conservative    normal    1   -3          4 0.6480041
#> 7       grinding extensive    1   -3          5 0.8375209
#> 8      ballistic extensive    1   -3          5 0.7008691
#> 9   conservative extensive    1   -3          5 0.6025548
#> 10      grinding intensive    2   -3          3 0.8656510
#> 11     ballistic intensive    2   -3          3 0.7411800
#> 12  conservative intensive    2   -3          3 0.6480041
#> 13      grinding    normal    2   -3          4 0.8375209
#> 14     ballistic    normal    2   -3          4 0.7008691
#> 15  conservative    normal    2   -3          4 0.6025548
#> 16      grinding extensive    2   -3          5 0.8111616
#> 17     ballistic extensive    2   -3          5 0.6647168
#> 18  conservative extensive    2   -3          5 0.5630631
#> 19      grinding intensive    3   -3          3 0.8375209
#> 20     ballistic intensive    3   -3          3 0.7008691
#> 21  conservative intensive    3   -3          3 0.6025548
#> 22      grinding    normal    3   -3          4 0.8111616
#> 23     ballistic    normal    3   -3          4 0.6647168
#> 24  conservative    normal    3   -3          4 0.5630631
#> 25      grinding extensive    3   -3          5 0.7864108
#> 26     ballistic extensive    3   -3          5 0.6321113
#> 27  conservative extensive    3   -3          5 0.5284295
#> 28      grinding intensive    4   -3          3 0.8111616
#> 29     ballistic intensive    4   -3          3 0.6647168
#> 30  conservative intensive    4   -3          3 0.5630631
#> 31      grinding    normal    4   -3          4 0.7864108
#> 32     ballistic    normal    4   -3          4 0.6321113
#> 33  conservative    normal    4   -3          4 0.5284295
#> 34      grinding extensive    4   -3          5 0.7631258
#> 35     ballistic extensive    4   -3          5 0.6025548
#> 36  conservative extensive    4   -3          5 0.4978096
#> 37      grinding intensive    5   -3          3 0.7864108
#> 38     ballistic intensive    5   -3          3 0.6321113
#> 39  conservative intensive    5   -3          3 0.5284295
#> 40      grinding    normal    5   -3          4 0.7631258
#> 41     ballistic    normal    5   -3          4 0.6025548
#> 42  conservative    normal    5   -3          4 0.4978096
#> 43      grinding extensive    5   -3          5 0.7411800
#> 44     ballistic extensive    5   -3          5 0.5756390
#> 45  conservative extensive    5   -3          5 0.4705439
#> 46      grinding intensive    6   -3          3 0.7631258
#> 47     ballistic intensive    6   -3          3 0.6025548
#> 48  conservative intensive    6   -3          3 0.4978096
#> 49      grinding    normal    6   -3          4 0.7411800
#> 50     ballistic    normal    6   -3          4 0.5756390
#> 51  conservative    normal    6   -3          4 0.4705439
#> 52      grinding extensive    6   -3          5 0.7204611
#> 53     ballistic extensive    6   -3          5 0.5510249
#> 54  conservative extensive    6   -3          5 0.4461099
#> 55      grinding intensive    7   -3          3 0.7411800
#> 56     ballistic intensive    7   -3          3 0.5756390
#> 57  conservative intensive    7   -3          3 0.4705439
#> 58      grinding    normal    7   -3          4 0.7204611
#> 59     ballistic    normal    7   -3          4 0.5510249
#> 60  conservative    normal    7   -3          4 0.4461099
#> 61      grinding extensive    7   -3          5 0.7008691
#> 62     ballistic extensive    7   -3          5 0.5284295
#> 63  conservative extensive    7   -3          5 0.4240882
#> 64      grinding intensive    8   -3          3 0.7204611
#> 65     ballistic intensive    8   -3          3 0.5510249
#> 66  conservative intensive    8   -3          3 0.4461099
#> 67      grinding    normal    8   -3          4 0.7008691
#> 68     ballistic    normal    8   -3          4 0.5284295
#> 69  conservative    normal    8   -3          4 0.4240882
#> 70      grinding extensive    8   -3          5 0.6823144
#> 71     ballistic extensive    8   -3          5 0.5076142
#> 72  conservative extensive    8   -3          5 0.4041384
#> 73      grinding intensive    9   -3          3 0.7008691
#> 74     ballistic intensive    9   -3          3 0.5284295
#> 75  conservative intensive    9   -3          3 0.4240882
#> 76      grinding    normal    9   -3          4 0.6823144
#> 77     ballistic    normal    9   -3          4 0.5076142
#> 78  conservative    normal    9   -3          4 0.4041384
#> 79      grinding extensive    9   -3          5 0.6647168
#> 80     ballistic extensive    9   -3          5 0.4883766
#> 81  conservative extensive    9   -3          5 0.3859812
#> 82      grinding intensive   10   -3          3 0.6823144
#> 83     ballistic intensive   10   -3          3 0.5076142
#> 84  conservative intensive   10   -3          3 0.4041384
#> 85      grinding    normal   10   -3          4 0.6647168
#> 86     ballistic    normal   10   -3          4 0.4883766
#> 87  conservative    normal   10   -3          4 0.3859812
#> 88      grinding extensive   10   -3          5 0.6480041
#> 89     ballistic extensive   10   -3          5 0.4705439
#> 90  conservative extensive   10   -3          5 0.3693853
#> 91      grinding intensive   11   -3          3 0.6647168
#> 92     ballistic intensive   11   -3          3 0.4883766
#> 93  conservative intensive   11   -3          3 0.3859812
#> 94      grinding    normal   11   -3          4 0.6480041
#> 95     ballistic    normal   11   -3          4 0.4705439
#> 96  conservative    normal   11   -3          4 0.3693853
#> 97      grinding extensive   11   -3          5 0.6321113
#> 98     ballistic extensive   11   -3          5 0.4539677
#> 99  conservative extensive   11   -3          5 0.3541578
#> 100     grinding intensive   12   -3          3 0.6480041
#> 101    ballistic intensive   12   -3          3 0.4705439
#> 102 conservative intensive   12   -3          3 0.3693853
#> 103     grinding    normal   12   -3          4 0.6321113
#> 104    ballistic    normal   12   -3          4 0.4539677
#> 105 conservative    normal   12   -3          4 0.3541578
#> 106     grinding extensive   12   -3          5 0.6169793
#> 107    ballistic extensive   12   -3          5 0.4385196
#> 108 conservative extensive   12   -3          5 0.3401361
#> 109     grinding intensive    1   -2          2 0.9279881
#> 110    ballistic intensive    1   -2          2 0.8375209
#> 111 conservative intensive    1   -2          2 0.7631258
#> 112     grinding    normal    1   -2          3 0.8957363
#> 113    ballistic    normal    1   -2          3 0.7864108
#> 114 conservative    normal    1   -2          3 0.7008691
#> 115     grinding extensive    1   -2          4 0.8656510
#> 116    ballistic extensive    1   -2          4 0.7411800
#> 117 conservative extensive    1   -2          4 0.6480041
#> 118     grinding intensive    2   -2          2 0.8957363
#> 119    ballistic intensive    2   -2          2 0.7864108
#> 120 conservative intensive    2   -2          2 0.7008691
#> 121     grinding    normal    2   -2          3 0.8656510
#> 122    ballistic    normal    2   -2          3 0.7411800
#> 123 conservative    normal    2   -2          3 0.6480041
#> 124     grinding extensive    2   -2          4 0.8375209
#> 125    ballistic extensive    2   -2          4 0.7008691
#> 126 conservative extensive    2   -2          4 0.6025548
#> 127     grinding intensive    3   -2          2 0.8656510
#> 128    ballistic intensive    3   -2          2 0.7411800
#> 129 conservative intensive    3   -2          2 0.6480041
#> 130     grinding    normal    3   -2          3 0.8375209
#> 131    ballistic    normal    3   -2          3 0.7008691
#> 132 conservative    normal    3   -2          3 0.6025548
#> 133     grinding extensive    3   -2          4 0.8111616
#> 134    ballistic extensive    3   -2          4 0.6647168
#> 135 conservative extensive    3   -2          4 0.5630631
#> 136     grinding intensive    4   -2          2 0.8375209
#> 137    ballistic intensive    4   -2          2 0.7008691
#> 138 conservative intensive    4   -2          2 0.6025548
#> 139     grinding    normal    4   -2          3 0.8111616
#> 140    ballistic    normal    4   -2          3 0.6647168
#> 141 conservative    normal    4   -2          3 0.5630631
#> 142     grinding extensive    4   -2          4 0.7864108
#> 143    ballistic extensive    4   -2          4 0.6321113
#> 144 conservative extensive    4   -2          4 0.5284295
#> 145     grinding intensive    5   -2          2 0.8111616
#> 146    ballistic intensive    5   -2          2 0.6647168
#> 147 conservative intensive    5   -2          2 0.5630631
#> 148     grinding    normal    5   -2          3 0.7864108
#> 149    ballistic    normal    5   -2          3 0.6321113
#> 150 conservative    normal    5   -2          3 0.5284295
#> 151     grinding extensive    5   -2          4 0.7631258
#> 152    ballistic extensive    5   -2          4 0.6025548
#> 153 conservative extensive    5   -2          4 0.4978096
#> 154     grinding intensive    6   -2          2 0.7864108
#> 155    ballistic intensive    6   -2          2 0.6321113
#> 156 conservative intensive    6   -2          2 0.5284295
#> 157     grinding    normal    6   -2          3 0.7631258
#> 158    ballistic    normal    6   -2          3 0.6025548
#> 159 conservative    normal    6   -2          3 0.4978096
#> 160     grinding extensive    6   -2          4 0.7411800
#> 161    ballistic extensive    6   -2          4 0.5756390
#> 162 conservative extensive    6   -2          4 0.4705439
#> 163     grinding intensive    7   -2          2 0.7631258
#> 164    ballistic intensive    7   -2          2 0.6025548
#> 165 conservative intensive    7   -2          2 0.4978096
#> 166     grinding    normal    7   -2          3 0.7411800
#> 167    ballistic    normal    7   -2          3 0.5756390
#> 168 conservative    normal    7   -2          3 0.4705439
#> 169     grinding extensive    7   -2          4 0.7204611
#> 170    ballistic extensive    7   -2          4 0.5510249
#> 171 conservative extensive    7   -2          4 0.4461099
#> 172     grinding intensive    8   -2          2 0.7411800
#> 173    ballistic intensive    8   -2          2 0.5756390
#> 174 conservative intensive    8   -2          2 0.4705439
#> 175     grinding    normal    8   -2          3 0.7204611
#> 176    ballistic    normal    8   -2          3 0.5510249
#> 177 conservative    normal    8   -2          3 0.4461099
#> 178     grinding extensive    8   -2          4 0.7008691
#> 179    ballistic extensive    8   -2          4 0.5284295
#> 180 conservative extensive    8   -2          4 0.4240882
#> 181     grinding intensive    9   -2          2 0.7204611
#> 182    ballistic intensive    9   -2          2 0.5510249
#> 183 conservative intensive    9   -2          2 0.4461099
#> 184     grinding    normal    9   -2          3 0.7008691
#> 185    ballistic    normal    9   -2          3 0.5284295
#> 186 conservative    normal    9   -2          3 0.4240882
#> 187     grinding extensive    9   -2          4 0.6823144
#> 188    ballistic extensive    9   -2          4 0.5076142
#> 189 conservative extensive    9   -2          4 0.4041384
#> 190     grinding intensive   10   -2          2 0.7008691
#> 191    ballistic intensive   10   -2          2 0.5284295
#> 192 conservative intensive   10   -2          2 0.4240882
#> 193     grinding    normal   10   -2          3 0.6823144
#> 194    ballistic    normal   10   -2          3 0.5076142
#> 195 conservative    normal   10   -2          3 0.4041384
#> 196     grinding extensive   10   -2          4 0.6647168
#> 197    ballistic extensive   10   -2          4 0.4883766
#> 198 conservative extensive   10   -2          4 0.3859812
#> 199     grinding intensive   11   -2          2 0.6823144
#> 200    ballistic intensive   11   -2          2 0.5076142
#> 201 conservative intensive   11   -2          2 0.4041384
#> 202     grinding    normal   11   -2          3 0.6647168
#> 203    ballistic    normal   11   -2          3 0.4883766
#> 204 conservative    normal   11   -2          3 0.3859812
#> 205     grinding extensive   11   -2          4 0.6480041
#> 206    ballistic extensive   11   -2          4 0.4705439
#> 207 conservative extensive   11   -2          4 0.3693853
#> 208     grinding intensive   12   -2          2 0.6647168
#> 209    ballistic intensive   12   -2          2 0.4883766
#> 210 conservative intensive   12   -2          2 0.3859812
#> 211     grinding    normal   12   -2          3 0.6480041
#> 212    ballistic    normal   12   -2          3 0.4705439
#> 213 conservative    normal   12   -2          3 0.3693853
#> 214     grinding extensive   12   -2          4 0.6321113
#> 215    ballistic extensive   12   -2          4 0.4539677
#> 216 conservative extensive   12   -2          4 0.3541578
#> 217     grinding intensive    1   -1          1 0.9626492
#> 218    ballistic intensive    1   -1          1 0.8957363
#> 219 conservative intensive    1   -1          1 0.8375209
#> 220     grinding    normal    1   -1          2 0.9279881
#> 221    ballistic    normal    1   -1          2 0.8375209
#> 222 conservative    normal    1   -1          2 0.7631258
#> 223     grinding extensive    1   -1          3 0.8957363
#> 224    ballistic extensive    1   -1          3 0.7864108
#> 225 conservative extensive    1   -1          3 0.7008691
#> 226     grinding intensive    2   -1          1 0.9279881
#> 227    ballistic intensive    2   -1          1 0.8375209
#> 228 conservative intensive    2   -1          1 0.7631258
#> 229     grinding    normal    2   -1          2 0.8957363
#> 230    ballistic    normal    2   -1          2 0.7864108
#> 231 conservative    normal    2   -1          2 0.7008691
#> 232     grinding extensive    2   -1          3 0.8656510
#> 233    ballistic extensive    2   -1          3 0.7411800
#> 234 conservative extensive    2   -1          3 0.6480041
#> 235     grinding intensive    3   -1          1 0.8957363
#> 236    ballistic intensive    3   -1          1 0.7864108
#> 237 conservative intensive    3   -1          1 0.7008691
#> 238     grinding    normal    3   -1          2 0.8656510
#> 239    ballistic    normal    3   -1          2 0.7411800
#> 240 conservative    normal    3   -1          2 0.6480041
#> 241     grinding extensive    3   -1          3 0.8375209
#> 242    ballistic extensive    3   -1          3 0.7008691
#> 243 conservative extensive    3   -1          3 0.6025548
#> 244     grinding intensive    4   -1          1 0.8656510
#> 245    ballistic intensive    4   -1          1 0.7411800
#> 246 conservative intensive    4   -1          1 0.6480041
#> 247     grinding    normal    4   -1          2 0.8375209
#> 248    ballistic    normal    4   -1          2 0.7008691
#> 249 conservative    normal    4   -1          2 0.6025548
#> 250     grinding extensive    4   -1          3 0.8111616
#> 251    ballistic extensive    4   -1          3 0.6647168
#> 252 conservative extensive    4   -1          3 0.5630631
#> 253     grinding intensive    5   -1          1 0.8375209
#> 254    ballistic intensive    5   -1          1 0.7008691
#> 255 conservative intensive    5   -1          1 0.6025548
#> 256     grinding    normal    5   -1          2 0.8111616
#> 257    ballistic    normal    5   -1          2 0.6647168
#> 258 conservative    normal    5   -1          2 0.5630631
#> 259     grinding extensive    5   -1          3 0.7864108
#> 260    ballistic extensive    5   -1          3 0.6321113
#> 261 conservative extensive    5   -1          3 0.5284295
#> 262     grinding intensive    6   -1          1 0.8111616
#> 263    ballistic intensive    6   -1          1 0.6647168
#> 264 conservative intensive    6   -1          1 0.5630631
#> 265     grinding    normal    6   -1          2 0.7864108
#> 266    ballistic    normal    6   -1          2 0.6321113
#> 267 conservative    normal    6   -1          2 0.5284295
#> 268     grinding extensive    6   -1          3 0.7631258
#> 269    ballistic extensive    6   -1          3 0.6025548
#> 270 conservative extensive    6   -1          3 0.4978096
#> 271     grinding intensive    7   -1          1 0.7864108
#> 272    ballistic intensive    7   -1          1 0.6321113
#> 273 conservative intensive    7   -1          1 0.5284295
#> 274     grinding    normal    7   -1          2 0.7631258
#> 275    ballistic    normal    7   -1          2 0.6025548
#> 276 conservative    normal    7   -1          2 0.4978096
#> 277     grinding extensive    7   -1          3 0.7411800
#> 278    ballistic extensive    7   -1          3 0.5756390
#> 279 conservative extensive    7   -1          3 0.4705439
#> 280     grinding intensive    8   -1          1 0.7631258
#> 281    ballistic intensive    8   -1          1 0.6025548
#> 282 conservative intensive    8   -1          1 0.4978096
#> 283     grinding    normal    8   -1          2 0.7411800
#> 284    ballistic    normal    8   -1          2 0.5756390
#> 285 conservative    normal    8   -1          2 0.4705439
#> 286     grinding extensive    8   -1          3 0.7204611
#> 287    ballistic extensive    8   -1          3 0.5510249
#> 288 conservative extensive    8   -1          3 0.4461099
#> 289     grinding intensive    9   -1          1 0.7411800
#> 290    ballistic intensive    9   -1          1 0.5756390
#> 291 conservative intensive    9   -1          1 0.4705439
#> 292     grinding    normal    9   -1          2 0.7204611
#> 293    ballistic    normal    9   -1          2 0.5510249
#> 294 conservative    normal    9   -1          2 0.4461099
#> 295     grinding extensive    9   -1          3 0.7008691
#> 296    ballistic extensive    9   -1          3 0.5284295
#> 297 conservative extensive    9   -1          3 0.4240882
#> 298     grinding intensive   10   -1          1 0.7204611
#> 299    ballistic intensive   10   -1          1 0.5510249
#> 300 conservative intensive   10   -1          1 0.4461099
#> 301     grinding    normal   10   -1          2 0.7008691
#> 302    ballistic    normal   10   -1          2 0.5284295
#> 303 conservative    normal   10   -1          2 0.4240882
#> 304     grinding extensive   10   -1          3 0.6823144
#> 305    ballistic extensive   10   -1          3 0.5076142
#> 306 conservative extensive   10   -1          3 0.4041384
#> 307     grinding intensive   11   -1          1 0.7008691
#> 308    ballistic intensive   11   -1          1 0.5284295
#> 309 conservative intensive   11   -1          1 0.4240882
#> 310     grinding    normal   11   -1          2 0.6823144
#> 311    ballistic    normal   11   -1          2 0.5076142
#> 312 conservative    normal   11   -1          2 0.4041384
#> 313     grinding extensive   11   -1          3 0.6647168
#> 314    ballistic extensive   11   -1          3 0.4883766
#> 315 conservative extensive   11   -1          3 0.3859812
#> 316     grinding intensive   12   -1          1 0.6823144
#> 317    ballistic intensive   12   -1          1 0.5076142
#> 318 conservative intensive   12   -1          1 0.4041384
#> 319     grinding    normal   12   -1          2 0.6647168
#> 320    ballistic    normal   12   -1          2 0.4883766
#> 321 conservative    normal   12   -1          2 0.3859812
#> 322     grinding extensive   12   -1          3 0.6480041
#> 323    ballistic extensive   12   -1          3 0.4705439
#> 324 conservative extensive   12   -1          3 0.3693853
#> 325     grinding intensive    1    0          0 1.0000000
#> 326    ballistic intensive    1    0          0 0.9626492
#> 327 conservative intensive    1    0          0 0.9279881
#> 328     grinding    normal    1    0          1 0.9626492
#> 329    ballistic    normal    1    0          1 0.8957363
#> 330 conservative    normal    1    0          1 0.8375209
#> 331     grinding extensive    1    0          2 0.9279881
#> 332    ballistic extensive    1    0          2 0.8375209
#> 333 conservative extensive    1    0          2 0.7631258
#> 334     grinding intensive    2    0          0 0.9626492
#> 335    ballistic intensive    2    0          0 0.8957363
#> 336 conservative intensive    2    0          0 0.8375209
#> 337     grinding    normal    2    0          1 0.9279881
#> 338    ballistic    normal    2    0          1 0.8375209
#> 339 conservative    normal    2    0          1 0.7631258
#> 340     grinding extensive    2    0          2 0.8957363
#> 341    ballistic extensive    2    0          2 0.7864108
#> 342 conservative extensive    2    0          2 0.7008691
#> 343     grinding intensive    3    0          0 0.9279881
#> 344    ballistic intensive    3    0          0 0.8375209
#> 345 conservative intensive    3    0          0 0.7631258
#> 346     grinding    normal    3    0          1 0.8957363
#> 347    ballistic    normal    3    0          1 0.7864108
#> 348 conservative    normal    3    0          1 0.7008691
#> 349     grinding extensive    3    0          2 0.8656510
#> 350    ballistic extensive    3    0          2 0.7411800
#> 351 conservative extensive    3    0          2 0.6480041
#> 352     grinding intensive    4    0          0 0.8957363
#> 353    ballistic intensive    4    0          0 0.7864108
#> 354 conservative intensive    4    0          0 0.7008691
#> 355     grinding    normal    4    0          1 0.8656510
#> 356    ballistic    normal    4    0          1 0.7411800
#> 357 conservative    normal    4    0          1 0.6480041
#> 358     grinding extensive    4    0          2 0.8375209
#> 359    ballistic extensive    4    0          2 0.7008691
#> 360 conservative extensive    4    0          2 0.6025548
#> 361     grinding intensive    5    0          0 0.8656510
#> 362    ballistic intensive    5    0          0 0.7411800
#> 363 conservative intensive    5    0          0 0.6480041
#> 364     grinding    normal    5    0          1 0.8375209
#> 365    ballistic    normal    5    0          1 0.7008691
#> 366 conservative    normal    5    0          1 0.6025548
#> 367     grinding extensive    5    0          2 0.8111616
#> 368    ballistic extensive    5    0          2 0.6647168
#> 369 conservative extensive    5    0          2 0.5630631
#> 370     grinding intensive    6    0          0 0.8375209
#> 371    ballistic intensive    6    0          0 0.7008691
#> 372 conservative intensive    6    0          0 0.6025548
#> 373     grinding    normal    6    0          1 0.8111616
#> 374    ballistic    normal    6    0          1 0.6647168
#> 375 conservative    normal    6    0          1 0.5630631
#> 376     grinding extensive    6    0          2 0.7864108
#> 377    ballistic extensive    6    0          2 0.6321113
#> 378 conservative extensive    6    0          2 0.5284295
#> 379     grinding intensive    7    0          0 0.8111616
#> 380    ballistic intensive    7    0          0 0.6647168
#> 381 conservative intensive    7    0          0 0.5630631
#> 382     grinding    normal    7    0          1 0.7864108
#> 383    ballistic    normal    7    0          1 0.6321113
#> 384 conservative    normal    7    0          1 0.5284295
#> 385     grinding extensive    7    0          2 0.7631258
#> 386    ballistic extensive    7    0          2 0.6025548
#> 387 conservative extensive    7    0          2 0.4978096
#> 388     grinding intensive    8    0          0 0.7864108
#> 389    ballistic intensive    8    0          0 0.6321113
#> 390 conservative intensive    8    0          0 0.5284295
#> 391     grinding    normal    8    0          1 0.7631258
#> 392    ballistic    normal    8    0          1 0.6025548
#> 393 conservative    normal    8    0          1 0.4978096
#> 394     grinding extensive    8    0          2 0.7411800
#> 395    ballistic extensive    8    0          2 0.5756390
#> 396 conservative extensive    8    0          2 0.4705439
#> 397     grinding intensive    9    0          0 0.7631258
#> 398    ballistic intensive    9    0          0 0.6025548
#> 399 conservative intensive    9    0          0 0.4978096
#> 400     grinding    normal    9    0          1 0.7411800
#> 401    ballistic    normal    9    0          1 0.5756390
#> 402 conservative    normal    9    0          1 0.4705439
#> 403     grinding extensive    9    0          2 0.7204611
#> 404    ballistic extensive    9    0          2 0.5510249
#> 405 conservative extensive    9    0          2 0.4461099
#> 406     grinding intensive   10    0          0 0.7411800
#> 407    ballistic intensive   10    0          0 0.5756390
#> 408 conservative intensive   10    0          0 0.4705439
#> 409     grinding    normal   10    0          1 0.7204611
#> 410    ballistic    normal   10    0          1 0.5510249
#> 411 conservative    normal   10    0          1 0.4461099
#> 412     grinding extensive   10    0          2 0.7008691
#> 413    ballistic extensive   10    0          2 0.5284295
#> 414 conservative extensive   10    0          2 0.4240882
#> 415     grinding intensive   11    0          0 0.7204611
#> 416    ballistic intensive   11    0          0 0.5510249
#> 417 conservative intensive   11    0          0 0.4461099
#> 418     grinding    normal   11    0          1 0.7008691
#> 419    ballistic    normal   11    0          1 0.5284295
#> 420 conservative    normal   11    0          1 0.4240882
#> 421     grinding extensive   11    0          2 0.6823144
#> 422    ballistic extensive   11    0          2 0.5076142
#> 423 conservative extensive   11    0          2 0.4041384
#> 424     grinding intensive   12    0          0 0.7008691
#> 425    ballistic intensive   12    0          0 0.5284295
#> 426 conservative intensive   12    0          0 0.4240882
#> 427     grinding    normal   12    0          1 0.6823144
#> 428    ballistic    normal   12    0          1 0.5076142
#> 429 conservative    normal   12    0          1 0.4041384
#> 430     grinding extensive   12    0          2 0.6647168
#> 431    ballistic extensive   12    0          2 0.4883766
#> 432 conservative extensive   12    0          2 0.3859812
# ------------------------------------------
# Progression Deducted Intensity
progression_DI(10, step = seq(-3, 0, 1))
#> $adjustment
#> [1] -0.100 -0.075 -0.050 -0.025
#> 
#> $perc_1RM
#> [1] 0.6501875 0.6751875 0.7001875 0.7251875
#> 
progression_DI(10, step = seq(-3, 0, 1), volume = "extensive")
#> $adjustment
#> [1] -0.125 -0.100 -0.075 -0.050
#> 
#> $perc_1RM
#> [1] 0.6251875 0.6501875 0.6751875 0.7001875
#> 
progression_DI(5, step = seq(-3, 0, 1), type = "ballistic", step_increment = -0.05)
#> $adjustment
#> [1] -0.20 -0.15 -0.10 -0.05
#> 
#> $perc_1RM
#> [1] 0.5501875 0.6001875 0.6501875 0.7001875
#> 
progression_DI(
  5,
  step = seq(-3, 0, 1),
  type = "ballistic",
  step_increment = -0.05,
  volume_increment = -0.1
)
#> $adjustment
#> [1] -0.25 -0.20 -0.15 -0.10
#> 
#> $perc_1RM
#> [1] 0.5001875 0.5501875 0.6001875 0.6501875
#> 

# Generate progression table
generate_progression_table(progression_DI, type = "grinding", volume = "normal")
#>        type volume reps step adjustment  perc_1RM
#> 1  grinding normal    1   -3     -0.100 0.8677732
#> 2  grinding normal    2   -3     -0.100 0.8375586
#> 3  grinding normal    3   -3     -0.100 0.8091736
#> 4  grinding normal    4   -3     -0.100 0.7824568
#> 5  grinding normal    5   -3     -0.100 0.7572653
#> 6  grinding normal    6   -3     -0.100 0.7334722
#> 7  grinding normal    7   -3     -0.100 0.7109642
#> 8  grinding normal    8   -3     -0.100 0.6896399
#> 9  grinding normal    9   -3     -0.100 0.6694083
#> 10 grinding normal   10   -3     -0.100 0.6501875
#> 11 grinding normal   11   -3     -0.100 0.6319037
#> 12 grinding normal   12   -3     -0.100 0.6144899
#> 13 grinding normal    1   -2     -0.075 0.8927732
#> 14 grinding normal    2   -2     -0.075 0.8625586
#> 15 grinding normal    3   -2     -0.075 0.8341736
#> 16 grinding normal    4   -2     -0.075 0.8074568
#> 17 grinding normal    5   -2     -0.075 0.7822653
#> 18 grinding normal    6   -2     -0.075 0.7584722
#> 19 grinding normal    7   -2     -0.075 0.7359642
#> 20 grinding normal    8   -2     -0.075 0.7146399
#> 21 grinding normal    9   -2     -0.075 0.6944083
#> 22 grinding normal   10   -2     -0.075 0.6751875
#> 23 grinding normal   11   -2     -0.075 0.6569037
#> 24 grinding normal   12   -2     -0.075 0.6394899
#> 25 grinding normal    1   -1     -0.050 0.9177732
#> 26 grinding normal    2   -1     -0.050 0.8875586
#> 27 grinding normal    3   -1     -0.050 0.8591736
#> 28 grinding normal    4   -1     -0.050 0.8324568
#> 29 grinding normal    5   -1     -0.050 0.8072653
#> 30 grinding normal    6   -1     -0.050 0.7834722
#> 31 grinding normal    7   -1     -0.050 0.7609642
#> 32 grinding normal    8   -1     -0.050 0.7396399
#> 33 grinding normal    9   -1     -0.050 0.7194083
#> 34 grinding normal   10   -1     -0.050 0.7001875
#> 35 grinding normal   11   -1     -0.050 0.6819037
#> 36 grinding normal   12   -1     -0.050 0.6644899
#> 37 grinding normal    1    0     -0.025 0.9427732
#> 38 grinding normal    2    0     -0.025 0.9125586
#> 39 grinding normal    3    0     -0.025 0.8841736
#> 40 grinding normal    4    0     -0.025 0.8574568
#> 41 grinding normal    5    0     -0.025 0.8322653
#> 42 grinding normal    6    0     -0.025 0.8084722
#> 43 grinding normal    7    0     -0.025 0.7859642
#> 44 grinding normal    8    0     -0.025 0.7646399
#> 45 grinding normal    9    0     -0.025 0.7444083
#> 46 grinding normal   10    0     -0.025 0.7251875
#> 47 grinding normal   11    0     -0.025 0.7069037
#> 48 grinding normal   12    0     -0.025 0.6894899

# Use different reps-max model
generate_progression_table(
  progression_DI,
  type = "grinding",
  volume = "normal",
  max_perc_1RM_func = max_perc_1RM_linear,
  klin = 36
)
#>        type volume reps step adjustment  perc_1RM
#> 1  grinding normal    1   -3     -0.100 0.9000000
#> 2  grinding normal    2   -3     -0.100 0.8722222
#> 3  grinding normal    3   -3     -0.100 0.8444444
#> 4  grinding normal    4   -3     -0.100 0.8166667
#> 5  grinding normal    5   -3     -0.100 0.7888889
#> 6  grinding normal    6   -3     -0.100 0.7611111
#> 7  grinding normal    7   -3     -0.100 0.7333333
#> 8  grinding normal    8   -3     -0.100 0.7055556
#> 9  grinding normal    9   -3     -0.100 0.6777778
#> 10 grinding normal   10   -3     -0.100 0.6500000
#> 11 grinding normal   11   -3     -0.100 0.6222222
#> 12 grinding normal   12   -3     -0.100 0.5944444
#> 13 grinding normal    1   -2     -0.075 0.9250000
#> 14 grinding normal    2   -2     -0.075 0.8972222
#> 15 grinding normal    3   -2     -0.075 0.8694444
#> 16 grinding normal    4   -2     -0.075 0.8416667
#> 17 grinding normal    5   -2     -0.075 0.8138889
#> 18 grinding normal    6   -2     -0.075 0.7861111
#> 19 grinding normal    7   -2     -0.075 0.7583333
#> 20 grinding normal    8   -2     -0.075 0.7305556
#> 21 grinding normal    9   -2     -0.075 0.7027778
#> 22 grinding normal   10   -2     -0.075 0.6750000
#> 23 grinding normal   11   -2     -0.075 0.6472222
#> 24 grinding normal   12   -2     -0.075 0.6194444
#> 25 grinding normal    1   -1     -0.050 0.9500000
#> 26 grinding normal    2   -1     -0.050 0.9222222
#> 27 grinding normal    3   -1     -0.050 0.8944444
#> 28 grinding normal    4   -1     -0.050 0.8666667
#> 29 grinding normal    5   -1     -0.050 0.8388889
#> 30 grinding normal    6   -1     -0.050 0.8111111
#> 31 grinding normal    7   -1     -0.050 0.7833333
#> 32 grinding normal    8   -1     -0.050 0.7555556
#> 33 grinding normal    9   -1     -0.050 0.7277778
#> 34 grinding normal   10   -1     -0.050 0.7000000
#> 35 grinding normal   11   -1     -0.050 0.6722222
#> 36 grinding normal   12   -1     -0.050 0.6444444
#> 37 grinding normal    1    0     -0.025 0.9750000
#> 38 grinding normal    2    0     -0.025 0.9472222
#> 39 grinding normal    3    0     -0.025 0.9194444
#> 40 grinding normal    4    0     -0.025 0.8916667
#> 41 grinding normal    5    0     -0.025 0.8638889
#> 42 grinding normal    6    0     -0.025 0.8361111
#> 43 grinding normal    7    0     -0.025 0.8083333
#> 44 grinding normal    8    0     -0.025 0.7805556
#> 45 grinding normal    9    0     -0.025 0.7527778
#> 46 grinding normal   10    0     -0.025 0.7250000
#> 47 grinding normal   11    0     -0.025 0.6972222
#> 48 grinding normal   12    0     -0.025 0.6694444

# ------------------------------------------
# Progression RIR Constant
progression_RIR(10, step = seq(-3, 0, 1))
#> $adjustment
#> [1] 4 3 2 1
#> 
#> $perc_1RM
#> [1] 0.6820352 0.6978854 0.7144899 0.7319037
#> 
progression_RIR(10, step = seq(-3, 0, 1), volume = "extensive")
#> $adjustment
#> [1] 5 4 3 2
#> 
#> $perc_1RM
#> [1] 0.6668890 0.6820352 0.6978854 0.7144899
#> 
progression_RIR(5, step = seq(-3, 0, 1), type = "ballistic", step_increment = 2)
#> $adjustment
#> [1] 8 6 4 2
#> 
#> $perc_1RM
#> [1] 0.5359631 0.5771673 0.6252345 0.6820352
#> 
progression_RIR(
  5,
  step = seq(-3, 0, 1),
  type = "ballistic",
  step_increment = 3
)
#> $adjustment
#> [1] 12  9  6  3
#> 
#> $perc_1RM
#> [1] 0.4689992 0.5174912 0.5771673 0.6524008
#> 

# Generate progression table
generate_progression_table(progression_RIR, type = "grinding", volume = "normal")
#>        type volume reps step adjustment  perc_1RM
#> 1  grinding normal    1   -3          4 0.8572653
#> 2  grinding normal    2   -3          4 0.8334722
#> 3  grinding normal    3   -3          4 0.8109642
#> 4  grinding normal    4   -3          4 0.7896399
#> 5  grinding normal    5   -3          4 0.7694083
#> 6  grinding normal    6   -3          4 0.7501875
#> 7  grinding normal    7   -3          4 0.7319037
#> 8  grinding normal    8   -3          4 0.7144899
#> 9  grinding normal    9   -3          4 0.6978854
#> 10 grinding normal   10   -3          4 0.6820352
#> 11 grinding normal   11   -3          4 0.6668890
#> 12 grinding normal   12   -3          4 0.6524008
#> 13 grinding normal    1   -2          3 0.8824568
#> 14 grinding normal    2   -2          3 0.8572653
#> 15 grinding normal    3   -2          3 0.8334722
#> 16 grinding normal    4   -2          3 0.8109642
#> 17 grinding normal    5   -2          3 0.7896399
#> 18 grinding normal    6   -2          3 0.7694083
#> 19 grinding normal    7   -2          3 0.7501875
#> 20 grinding normal    8   -2          3 0.7319037
#> 21 grinding normal    9   -2          3 0.7144899
#> 22 grinding normal   10   -2          3 0.6978854
#> 23 grinding normal   11   -2          3 0.6820352
#> 24 grinding normal   12   -2          3 0.6668890
#> 25 grinding normal    1   -1          2 0.9091736
#> 26 grinding normal    2   -1          2 0.8824568
#> 27 grinding normal    3   -1          2 0.8572653
#> 28 grinding normal    4   -1          2 0.8334722
#> 29 grinding normal    5   -1          2 0.8109642
#> 30 grinding normal    6   -1          2 0.7896399
#> 31 grinding normal    7   -1          2 0.7694083
#> 32 grinding normal    8   -1          2 0.7501875
#> 33 grinding normal    9   -1          2 0.7319037
#> 34 grinding normal   10   -1          2 0.7144899
#> 35 grinding normal   11   -1          2 0.6978854
#> 36 grinding normal   12   -1          2 0.6820352
#> 37 grinding normal    1    0          1 0.9375586
#> 38 grinding normal    2    0          1 0.9091736
#> 39 grinding normal    3    0          1 0.8824568
#> 40 grinding normal    4    0          1 0.8572653
#> 41 grinding normal    5    0          1 0.8334722
#> 42 grinding normal    6    0          1 0.8109642
#> 43 grinding normal    7    0          1 0.7896399
#> 44 grinding normal    8    0          1 0.7694083
#> 45 grinding normal    9    0          1 0.7501875
#> 46 grinding normal   10    0          1 0.7319037
#> 47 grinding normal   11    0          1 0.7144899
#> 48 grinding normal   12    0          1 0.6978854

# Use different reps-max model
generate_progression_table(
  progression_RIR,
  type = "grinding",
  volume = "normal",
  max_perc_1RM_func = max_perc_1RM_linear,
  klin = 36
)
#>        type volume reps step adjustment  perc_1RM
#> 1  grinding normal    1   -3          4 0.8888889
#> 2  grinding normal    2   -3          4 0.8611111
#> 3  grinding normal    3   -3          4 0.8333333
#> 4  grinding normal    4   -3          4 0.8055556
#> 5  grinding normal    5   -3          4 0.7777778
#> 6  grinding normal    6   -3          4 0.7500000
#> 7  grinding normal    7   -3          4 0.7222222
#> 8  grinding normal    8   -3          4 0.6944444
#> 9  grinding normal    9   -3          4 0.6666667
#> 10 grinding normal   10   -3          4 0.6388889
#> 11 grinding normal   11   -3          4 0.6111111
#> 12 grinding normal   12   -3          4 0.5833333
#> 13 grinding normal    1   -2          3 0.9166667
#> 14 grinding normal    2   -2          3 0.8888889
#> 15 grinding normal    3   -2          3 0.8611111
#> 16 grinding normal    4   -2          3 0.8333333
#> 17 grinding normal    5   -2          3 0.8055556
#> 18 grinding normal    6   -2          3 0.7777778
#> 19 grinding normal    7   -2          3 0.7500000
#> 20 grinding normal    8   -2          3 0.7222222
#> 21 grinding normal    9   -2          3 0.6944444
#> 22 grinding normal   10   -2          3 0.6666667
#> 23 grinding normal   11   -2          3 0.6388889
#> 24 grinding normal   12   -2          3 0.6111111
#> 25 grinding normal    1   -1          2 0.9444444
#> 26 grinding normal    2   -1          2 0.9166667
#> 27 grinding normal    3   -1          2 0.8888889
#> 28 grinding normal    4   -1          2 0.8611111
#> 29 grinding normal    5   -1          2 0.8333333
#> 30 grinding normal    6   -1          2 0.8055556
#> 31 grinding normal    7   -1          2 0.7777778
#> 32 grinding normal    8   -1          2 0.7500000
#> 33 grinding normal    9   -1          2 0.7222222
#> 34 grinding normal   10   -1          2 0.6944444
#> 35 grinding normal   11   -1          2 0.6666667
#> 36 grinding normal   12   -1          2 0.6388889
#> 37 grinding normal    1    0          1 0.9722222
#> 38 grinding normal    2    0          1 0.9444444
#> 39 grinding normal    3    0          1 0.9166667
#> 40 grinding normal    4    0          1 0.8888889
#> 41 grinding normal    5    0          1 0.8611111
#> 42 grinding normal    6    0          1 0.8333333
#> 43 grinding normal    7    0          1 0.8055556
#> 44 grinding normal    8    0          1 0.7777778
#> 45 grinding normal    9    0          1 0.7500000
#> 46 grinding normal   10    0          1 0.7222222
#> 47 grinding normal   11    0          1 0.6944444
#> 48 grinding normal   12    0          1 0.6666667

# Plot progression table
plot_progression_table(progression_RIR)

plot_progression_table(progression_RIR, "adjustment")

# ------------------------------------------
# Progression RIR Increment
progression_RIR_increment(10, step = seq(-3, 0, 1))
#> $adjustment
#> [1] 8.090909 6.272727 4.454545 2.636364
#> 
#> $perc_1RM
#> [1] 0.6240533 0.6485581 0.6750661 0.7038333
#> 
progression_RIR_increment(10, step = seq(-3, 0, 1), volume = "extensive")
#> $adjustment
#> [1] 10.727273  8.909091  7.090909  5.272727
#> 
#> $perc_1RM
#> [1] 0.5916396 0.6136201 0.6372969 0.6628742
#> 
progression_RIR_increment(5, step = seq(-3, 0, 1), type = "ballistic")
#> $adjustment
#> [1] 7.2 5.4 3.6 1.8
#> 
#> $perc_1RM
#> [1] 0.5517181 0.5907931 0.6358249 0.6882881
#> 

# Generate progression table
generate_progression_table(progression_RIR_increment, type = "grinding", volume = "normal")
#>        type volume reps step adjustment  perc_1RM
#> 1  grinding normal    1   -3   4.000000 0.8572653
#> 2  grinding normal    2   -3   4.454545 0.8230884
#> 3  grinding normal    3   -3   4.909091 0.7915320
#> 4  grinding normal    4   -3   5.363636 0.7623060
#> 5  grinding normal    5   -3   5.818182 0.7351614
#> 6  grinding normal    6   -3   6.272727 0.7098835
#> 7  grinding normal    7   -3   6.727273 0.6862861
#> 8  grinding normal    8   -3   7.181818 0.6642071
#> 9  grinding normal    9   -3   7.636364 0.6435044
#> 10 grinding normal   10   -3   8.090909 0.6240533
#> 11 grinding normal   11   -3   8.545455 0.6057436
#> 12 grinding normal   12   -3   9.000000 0.5884776
#> 13 grinding normal    1   -2   3.000000 0.8824568
#> 14 grinding normal    2   -2   3.363636 0.8484577
#> 15 grinding normal    3   -2   3.727273 0.8169813
#> 16 grinding normal    4   -2   4.090909 0.7877568
#> 17 grinding normal    5   -2   4.454545 0.7605509
#> 18 grinding normal    6   -2   4.818182 0.7351614
#> 19 grinding normal    7   -2   5.181818 0.7114123
#> 20 grinding normal    8   -2   5.545455 0.6891497
#> 21 grinding normal    9   -2   5.909091 0.6682380
#> 22 grinding normal   10   -2   6.272727 0.6485581
#> 23 grinding normal   11   -2   6.636364 0.6300042
#> 24 grinding normal   12   -2   7.000000 0.6124824
#> 25 grinding normal    1   -1   2.000000 0.9091736
#> 26 grinding normal    2   -1   2.272727 0.8754407
#> 27 grinding normal    3   -1   2.545455 0.8441215
#> 28 grinding normal    4   -1   2.818182 0.8149657
#> 29 grinding normal    5   -1   3.090909 0.7877568
#> 30 grinding normal    6   -1   3.363636 0.7623060
#> 31 grinding normal    7   -1   3.636364 0.7384483
#> 32 grinding normal    8   -1   3.909091 0.7160386
#> 33 grinding normal    9   -1   4.181818 0.6949490
#> 34 grinding normal   10   -1   4.454545 0.6750661
#> 35 grinding normal   11   -1   4.727273 0.6562893
#> 36 grinding normal   12   -1   5.000000 0.6385288
#> 37 grinding normal    1    0   1.000000 0.9375586
#> 38 grinding normal    2    0   1.181818 0.9041963
#> 39 grinding normal    3    0   1.363636 0.8731267
#> 40 grinding normal    4    0   1.545455 0.8441215
#> 41 grinding normal    5    0   1.727273 0.8169813
#> 42 grinding normal    6    0   1.909091 0.7915320
#> 43 grinding normal    7    0   2.090909 0.7676204
#> 44 grinding normal    8    0   2.272727 0.7451111
#> 45 grinding normal    9    0   2.454545 0.7238842
#> 46 grinding normal   10    0   2.636364 0.7038333
#> 47 grinding normal   11    0   2.818182 0.6848633
#> 48 grinding normal   12    0   3.000000 0.6668890

# Use different reps-max model
generate_progression_table(
  progression_RIR_increment,
  type = "grinding",
  volume = "normal",
  max_perc_1RM_func = max_perc_1RM_linear,
  klin = 36
)
#>        type volume reps step adjustment  perc_1RM
#> 1  grinding normal    1   -3   4.000000 0.8888889
#> 2  grinding normal    2   -3   4.454545 0.8484848
#> 3  grinding normal    3   -3   4.909091 0.8080808
#> 4  grinding normal    4   -3   5.363636 0.7676768
#> 5  grinding normal    5   -3   5.818182 0.7272727
#> 6  grinding normal    6   -3   6.272727 0.6868687
#> 7  grinding normal    7   -3   6.727273 0.6464646
#> 8  grinding normal    8   -3   7.181818 0.6060606
#> 9  grinding normal    9   -3   7.636364 0.5656566
#> 10 grinding normal   10   -3   8.090909 0.5252525
#> 11 grinding normal   11   -3   8.545455 0.4848485
#> 12 grinding normal   12   -3   9.000000 0.4444444
#> 13 grinding normal    1   -2   3.000000 0.9166667
#> 14 grinding normal    2   -2   3.363636 0.8787879
#> 15 grinding normal    3   -2   3.727273 0.8409091
#> 16 grinding normal    4   -2   4.090909 0.8030303
#> 17 grinding normal    5   -2   4.454545 0.7651515
#> 18 grinding normal    6   -2   4.818182 0.7272727
#> 19 grinding normal    7   -2   5.181818 0.6893939
#> 20 grinding normal    8   -2   5.545455 0.6515152
#> 21 grinding normal    9   -2   5.909091 0.6136364
#> 22 grinding normal   10   -2   6.272727 0.5757576
#> 23 grinding normal   11   -2   6.636364 0.5378788
#> 24 grinding normal   12   -2   7.000000 0.5000000
#> 25 grinding normal    1   -1   2.000000 0.9444444
#> 26 grinding normal    2   -1   2.272727 0.9090909
#> 27 grinding normal    3   -1   2.545455 0.8737374
#> 28 grinding normal    4   -1   2.818182 0.8383838
#> 29 grinding normal    5   -1   3.090909 0.8030303
#> 30 grinding normal    6   -1   3.363636 0.7676768
#> 31 grinding normal    7   -1   3.636364 0.7323232
#> 32 grinding normal    8   -1   3.909091 0.6969697
#> 33 grinding normal    9   -1   4.181818 0.6616162
#> 34 grinding normal   10   -1   4.454545 0.6262626
#> 35 grinding normal   11   -1   4.727273 0.5909091
#> 36 grinding normal   12   -1   5.000000 0.5555556
#> 37 grinding normal    1    0   1.000000 0.9722222
#> 38 grinding normal    2    0   1.181818 0.9393939
#> 39 grinding normal    3    0   1.363636 0.9065657
#> 40 grinding normal    4    0   1.545455 0.8737374
#> 41 grinding normal    5    0   1.727273 0.8409091
#> 42 grinding normal    6    0   1.909091 0.8080808
#> 43 grinding normal    7    0   2.090909 0.7752525
#> 44 grinding normal    8    0   2.272727 0.7424242
#> 45 grinding normal    9    0   2.454545 0.7095960
#> 46 grinding normal   10    0   2.636364 0.6767677
#> 47 grinding normal   11    0   2.818182 0.6439394
#> 48 grinding normal   12    0   3.000000 0.6111111
# ------------------------------------------
# Progression %MR Step Const
progression_perc_MR(10, step = seq(-3, 0, 1))
#> $adjustment
#> [1] 0.5 0.6 0.7 0.8
#> 
#> $perc_1RM
#> [1] 0.6002401 0.6430868 0.6776379 0.7060900
#> 
progression_perc_MR(10, step = seq(-3, 0, 1), volume = "extensive")
#> $adjustment
#> [1] 0.3 0.4 0.5 0.6
#> 
#> $perc_1RM
#> [1] 0.4739336 0.5457026 0.6002401 0.6430868
#> 
progression_perc_MR(5, step = seq(-3, 0, 1), type = "ballistic", step_increment = -0.2)
#> $adjustment
#> [1] 0.2 0.4 0.6 0.8
#> 
#> $perc_1RM
#> [1] 0.3752345 0.5457026 0.6430868 0.7060900
#> 
progression_perc_MR(
  5,
  step = seq(-3, 0, 1),
  type = "ballistic",
  step_increment = -0.15,
  volume_increment = -0.25
)
#> $adjustment
#> [1] 0.30 0.45 0.60 0.75
#> 
#> $perc_1RM
#> [1] 0.4739336 0.5747126 0.6430868 0.6925208
#> 

# Generate progression table
generate_progression_table(progression_perc_MR, type = "grinding", volume = "normal")
#>        type volume reps step adjustment  perc_1RM
#> 1  grinding normal    1   -3        0.5 0.9375586
#> 2  grinding normal    2   -3        0.5 0.8824568
#> 3  grinding normal    3   -3        0.5 0.8334722
#> 4  grinding normal    4   -3        0.5 0.7896399
#> 5  grinding normal    5   -3        0.5 0.7501875
#> 6  grinding normal    6   -3        0.5 0.7144899
#> 7  grinding normal    7   -3        0.5 0.6820352
#> 8  grinding normal    8   -3        0.5 0.6524008
#> 9  grinding normal    9   -3        0.5 0.6252345
#> 10 grinding normal   10   -3        0.5 0.6002401
#> 11 grinding normal   11   -3        0.5 0.5771673
#> 12 grinding normal   12   -3        0.5 0.5558026
#> 13 grinding normal    1   -2        0.6 0.9474183
#> 14 grinding normal    2   -2        0.6 0.9000900
#> 15 grinding normal    3   -2        0.6 0.8572653
#> 16 grinding normal    4   -2        0.6 0.8183306
#> 17 grinding normal    5   -2        0.6 0.7827789
#> 18 grinding normal    6   -2        0.6 0.7501875
#> 19 grinding normal    7   -2        0.6 0.7202017
#> 20 grinding normal    8   -2        0.6 0.6925208
#> 21 grinding normal    9   -2        0.6 0.6668890
#> 22 grinding normal   10   -2        0.6 0.6430868
#> 23 grinding normal   11   -2        0.6 0.6209252
#> 24 grinding normal   12   -2        0.6 0.6002401
#> 25 grinding normal    1   -1        0.7 0.9545888
#> 26 grinding normal    2   -1        0.7 0.9131229
#> 27 grinding normal    3   -1        0.7 0.8751094
#> 28 grinding normal    4   -1        0.7 0.8401344
#> 29 grinding normal    5   -1        0.7 0.8078477
#> 30 grinding normal    6   -1        0.7 0.7779507
#> 31 grinding normal    7   -1        0.7 0.7501875
#> 32 grinding normal    8   -1        0.7 0.7243377
#> 33 grinding normal    9   -1        0.7 0.7002101
#> 34 grinding normal   10   -1        0.7 0.6776379
#> 35 grinding normal   11   -1        0.7 0.6564757
#> 36 grinding normal   12   -1        0.7 0.6365951
#> 37 grinding normal    1    0        0.8 0.9600384
#> 38 grinding normal    2    0        0.8 0.9231479
#> 39 grinding normal    3    0        0.8 0.8889877
#> 40 grinding normal    4    0        0.8 0.8572653
#> 41 grinding normal    5    0        0.8 0.8277289
#> 42 grinding normal    6    0        0.8 0.8001600
#> 43 grinding normal    7    0        0.8 0.7743684
#> 44 grinding normal    8    0        0.8 0.7501875
#> 45 grinding normal    9    0        0.8 0.7274711
#> 46 grinding normal   10    0        0.8 0.7060900
#> 47 grinding normal   11    0        0.8 0.6859299
#> 48 grinding normal   12    0        0.8 0.6668890

# Use different reps-max model
generate_progression_table(
  progression_perc_MR,
  type = "grinding",
  volume = "normal",
  max_perc_1RM_func = max_perc_1RM_linear,
  klin = 36
)
#>        type volume reps step adjustment  perc_1RM
#> 1  grinding normal    1   -3        0.5 0.9722222
#> 2  grinding normal    2   -3        0.5 0.9166667
#> 3  grinding normal    3   -3        0.5 0.8611111
#> 4  grinding normal    4   -3        0.5 0.8055556
#> 5  grinding normal    5   -3        0.5 0.7500000
#> 6  grinding normal    6   -3        0.5 0.6944444
#> 7  grinding normal    7   -3        0.5 0.6388889
#> 8  grinding normal    8   -3        0.5 0.5833333
#> 9  grinding normal    9   -3        0.5 0.5277778
#> 10 grinding normal   10   -3        0.5 0.4722222
#> 11 grinding normal   11   -3        0.5 0.4166667
#> 12 grinding normal   12   -3        0.5 0.3611111
#> 13 grinding normal    1   -2        0.6 0.9814815
#> 14 grinding normal    2   -2        0.6 0.9351852
#> 15 grinding normal    3   -2        0.6 0.8888889
#> 16 grinding normal    4   -2        0.6 0.8425926
#> 17 grinding normal    5   -2        0.6 0.7962963
#> 18 grinding normal    6   -2        0.6 0.7500000
#> 19 grinding normal    7   -2        0.6 0.7037037
#> 20 grinding normal    8   -2        0.6 0.6574074
#> 21 grinding normal    9   -2        0.6 0.6111111
#> 22 grinding normal   10   -2        0.6 0.5648148
#> 23 grinding normal   11   -2        0.6 0.5185185
#> 24 grinding normal   12   -2        0.6 0.4722222
#> 25 grinding normal    1   -1        0.7 0.9880952
#> 26 grinding normal    2   -1        0.7 0.9484127
#> 27 grinding normal    3   -1        0.7 0.9087302
#> 28 grinding normal    4   -1        0.7 0.8690476
#> 29 grinding normal    5   -1        0.7 0.8293651
#> 30 grinding normal    6   -1        0.7 0.7896825
#> 31 grinding normal    7   -1        0.7 0.7500000
#> 32 grinding normal    8   -1        0.7 0.7103175
#> 33 grinding normal    9   -1        0.7 0.6706349
#> 34 grinding normal   10   -1        0.7 0.6309524
#> 35 grinding normal   11   -1        0.7 0.5912698
#> 36 grinding normal   12   -1        0.7 0.5515873
#> 37 grinding normal    1    0        0.8 0.9930556
#> 38 grinding normal    2    0        0.8 0.9583333
#> 39 grinding normal    3    0        0.8 0.9236111
#> 40 grinding normal    4    0        0.8 0.8888889
#> 41 grinding normal    5    0        0.8 0.8541667
#> 42 grinding normal    6    0        0.8 0.8194444
#> 43 grinding normal    7    0        0.8 0.7847222
#> 44 grinding normal    8    0        0.8 0.7500000
#> 45 grinding normal    9    0        0.8 0.7152778
#> 46 grinding normal   10    0        0.8 0.6805556
#> 47 grinding normal   11    0        0.8 0.6458333
#> 48 grinding normal   12    0        0.8 0.6111111

# ------------------------------------------
# Progression %MR Step Variable
progression_perc_MR_variable(10, step = seq(-3, 0, 1))
#> $adjustment
#> [1] 0.4818182 0.5818182 0.6818182 0.7818182
#> 
#> $perc_1RM
#> [1] 0.5913199 0.6359932 0.6718624 0.7012966
#> 
progression_perc_MR_variable(10, step = seq(-3, 0, 1), volume = "extensive")
#> $adjustment
#> [1] 0.2818182 0.3818182 0.4818182 0.5818182
#> 
#> $perc_1RM
#> [1] 0.4583765 0.5341473 0.5913199 0.6359932
#> 
progression_perc_MR_variable(5, step = seq(-3, 0, 1), type = "ballistic")
#> $adjustment
#> [1] 0.4363636 0.5363636 0.6363636 0.7363636
#> 
#> $perc_1RM
#> [1] 0.5671748 0.6169612 0.6564757 0.6885998
#> 
# Generate progression table
generate_progression_table(progression_perc_MR_variable, type = "grinding", volume = "normal")
#>        type volume reps step adjustment  perc_1RM
#> 1  grinding normal    1   -3  0.4000000 0.9231479
#> 2  grinding normal    2   -3  0.4090909 0.8599931
#> 3  grinding normal    3   -3  0.4181818 0.8071733
#> 4  grinding normal    4   -3  0.4272727 0.7623435
#> 5  grinding normal    5   -3  0.4363636 0.7238181
#> 6  grinding normal    6   -3  0.4454545 0.6903548
#> 7  grinding normal    7   -3  0.4545455 0.6610172
#> 8  grinding normal    8   -3  0.4636364 0.6350867
#> 9  grinding normal    9   -3  0.4727273 0.6120023
#> 10 grinding normal   10   -3  0.4818182 0.5913199
#> 11 grinding normal   11   -3  0.4909091 0.5726830
#> 12 grinding normal   12   -3  0.5000000 0.5558026
#> 13 grinding normal    1   -2  0.5000000 0.9375586
#> 14 grinding normal    2   -2  0.5090909 0.8843129
#> 15 grinding normal    3   -2  0.5181818 0.8383709
#> 16 grinding normal    4   -2  0.5272727 0.7983263
#> 17 grinding normal    5   -2  0.5363636 0.7631119
#> 18 grinding normal    6   -2  0.5454545 0.7319037
#> 19 grinding normal    7   -2  0.5545455 0.7040547
#> 20 grinding normal    8   -2  0.5636364 0.6790502
#> 21 grinding normal    9   -2  0.5727273 0.6564757
#> 22 grinding normal   10   -2  0.5818182 0.6359932
#> 23 grinding normal   11   -2  0.5909091 0.6173250
#> 24 grinding normal   12   -2  0.6000000 0.6002401
#> 25 grinding normal    1   -1  0.6000000 0.9474183
#> 26 grinding normal    2   -1  0.6090909 0.9014342
#> 27 grinding normal    3   -1  0.6181818 0.8608794
#> 28 grinding normal    4   -1  0.6272727 0.8248458
#> 29 grinding normal    5   -1  0.6363636 0.7926173
#> 30 grinding normal    6   -1  0.6454545 0.7636215
#> 31 grinding normal    7   -1  0.6545455 0.7373952
#> 32 grinding normal    8   -1  0.6636364 0.7135596
#> 33 grinding normal    9   -1  0.6727273 0.6918021
#> 34 grinding normal   10   -1  0.6818182 0.6718624
#> 35 grinding normal   11   -1  0.6909091 0.6535217
#> 36 grinding normal   12   -1  0.7000000 0.6365951
#> 37 grinding normal    1    0  0.7000000 0.9545888
#> 38 grinding normal    2    0  0.7090909 0.9141411
#> 39 grinding normal    3    0  0.7181818 0.8778851
#> 40 grinding normal    4    0  0.7272727 0.8452014
#> 41 grinding normal    5    0  0.7363636 0.8155868
#> 42 grinding normal    6    0  0.7454545 0.7886284
#> 43 grinding normal    7    0  0.7545455 0.7639841
#> 44 grinding normal    8    0  0.7636364 0.7413684
#> 45 grinding normal    9    0  0.7727273 0.7205405
#> 46 grinding normal   10    0  0.7818182 0.7012966
#> 47 grinding normal   11    0  0.7909091 0.6834626
#> 48 grinding normal   12    0  0.8000000 0.6668890

# Use different reps-max model
generate_progression_table(
  progression_perc_MR_variable,
  type = "grinding",
  volume = "normal",
  max_perc_1RM_func = max_perc_1RM_linear,
  klin = 36
)
#>        type volume reps step adjustment  perc_1RM
#> 1  grinding normal    1   -3  0.4000000 0.9583333
#> 2  grinding normal    2   -3  0.4090909 0.8919753
#> 3  grinding normal    3   -3  0.4181818 0.8285024
#> 4  grinding normal    4   -3  0.4272727 0.7677305
#> 5  grinding normal    5   -3  0.4363636 0.7094907
#> 6  grinding normal    6   -3  0.4454545 0.6536281
#> 7  grinding normal    7   -3  0.4545455 0.6000000
#> 8  grinding normal    8   -3  0.4636364 0.5484749
#> 9  grinding normal    9   -3  0.4727273 0.4989316
#> 10 grinding normal   10   -3  0.4818182 0.4512579
#> 11 grinding normal   11   -3  0.4909091 0.4053498
#> 12 grinding normal   12   -3  0.5000000 0.3611111
#> 13 grinding normal    1   -2  0.5000000 0.9722222
#> 14 grinding normal    2   -2  0.5090909 0.9186508
#> 15 grinding normal    3   -2  0.5181818 0.8669591
#> 16 grinding normal    4   -2  0.5272727 0.8170498
#> 17 grinding normal    5   -2  0.5363636 0.7688324
#> 18 grinding normal    6   -2  0.5454545 0.7222222
#> 19 grinding normal    7   -2  0.5545455 0.6771403
#> 20 grinding normal    8   -2  0.5636364 0.6335125
#> 21 grinding normal    9   -2  0.5727273 0.5912698
#> 22 grinding normal   10   -2  0.5818182 0.5503472
#> 23 grinding normal   11   -2  0.5909091 0.5106838
#> 24 grinding normal   12   -2  0.6000000 0.4722222
#> 25 grinding normal    1   -1  0.6000000 0.9814815
#> 26 grinding normal    2   -1  0.6090909 0.9365672
#> 27 grinding normal    3   -1  0.6181818 0.8929739
#> 28 grinding normal    4   -1  0.6272727 0.8506441
#> 29 grinding normal    5   -1  0.6363636 0.8095238
#> 30 grinding normal    6   -1  0.6454545 0.7695618
#> 31 grinding normal    7   -1  0.6545455 0.7307099
#> 32 grinding normal    8   -1  0.6636364 0.6929224
#> 33 grinding normal    9   -1  0.6727273 0.6561562
#> 34 grinding normal   10   -1  0.6818182 0.6203704
#> 35 grinding normal   11   -1  0.6909091 0.5855263
#> 36 grinding normal   12   -1  0.7000000 0.5515873
#> 37 grinding normal    1    0  0.7000000 0.9880952
#> 38 grinding normal    2    0  0.7090909 0.9494302
#> 39 grinding normal    3    0  0.7181818 0.9117440
#> 40 grinding normal    4    0  0.7272727 0.8750000
#> 41 grinding normal    5    0  0.7363636 0.8391632
#> 42 grinding normal    6    0  0.7454545 0.8042005
#> 43 grinding normal    7    0  0.7545455 0.7700803
#> 44 grinding normal    8    0  0.7636364 0.7367725
#> 45 grinding normal    9    0  0.7727273 0.7042484
#> 46 grinding normal   10    0  0.7818182 0.6724806
#> 47 grinding normal   11    0  0.7909091 0.6414432
#> 48 grinding normal   12    0  0.8000000 0.6111111
# ------------------------------------------
# Progression Perc Drop
progression_perc_drop(10, step = seq(-3, 0, 1))
#> $adjustment
#> [1] -0.18181818 -0.13636364 -0.09090909 -0.04545455
#> 
#> $perc_1RM
#> [1] 0.5683694 0.6138239 0.6592785 0.7047330
#> 
progression_perc_drop(10, step = seq(-3, 0, 1), volume = "extensive")
#> $adjustment
#> [1] -0.22727273 -0.18181818 -0.13636364 -0.09090909
#> 
#> $perc_1RM
#> [1] 0.5229148 0.5683694 0.6138239 0.6592785
#> 
progression_perc_drop(5, step = seq(-3, 0, 1), type = "ballistic")
#> $adjustment
#> [1] -0.170 -0.125 -0.080 -0.035
#> 
#> $perc_1RM
#> [1] 0.5801875 0.6251875 0.6701875 0.7151875
#> 

# Generate progression table
generate_progression_table(progression_perc_drop, type = "grinding", volume = "normal")
#>        type volume reps step  adjustment  perc_1RM
#> 1  grinding normal    1   -3 -0.10000000 0.8677732
#> 2  grinding normal    2   -3 -0.10909091 0.8284677
#> 3  grinding normal    3   -3 -0.11818182 0.7909917
#> 4  grinding normal    4   -3 -0.12727273 0.7551840
#> 5  grinding normal    5   -3 -0.13636364 0.7209017
#> 6  grinding normal    6   -3 -0.14545455 0.6880177
#> 7  grinding normal    7   -3 -0.15454545 0.6564188
#> 8  grinding normal    8   -3 -0.16363636 0.6260036
#> 9  grinding normal    9   -3 -0.17272727 0.5966811
#> 10 grinding normal   10   -3 -0.18181818 0.5683694
#> 11 grinding normal   11   -3 -0.19090909 0.5409946
#> 12 grinding normal   12   -3 -0.20000000 0.5144899
#> 13 grinding normal    1   -2 -0.07500000 0.8927732
#> 14 grinding normal    2   -2 -0.08181818 0.8557404
#> 15 grinding normal    3   -2 -0.08863636 0.8205372
#> 16 grinding normal    4   -2 -0.09545455 0.7870022
#> 17 grinding normal    5   -2 -0.10227273 0.7549926
#> 18 grinding normal    6   -2 -0.10909091 0.7243813
#> 19 grinding normal    7   -2 -0.11590909 0.6950551
#> 20 grinding normal    8   -2 -0.12272727 0.6669127
#> 21 grinding normal    9   -2 -0.12954545 0.6398629
#> 22 grinding normal   10   -2 -0.13636364 0.6138239
#> 23 grinding normal   11   -2 -0.14318182 0.5887219
#> 24 grinding normal   12   -2 -0.15000000 0.5644899
#> 25 grinding normal    1   -1 -0.05000000 0.9177732
#> 26 grinding normal    2   -1 -0.05454545 0.8830131
#> 27 grinding normal    3   -1 -0.05909091 0.8500827
#> 28 grinding normal    4   -1 -0.06363636 0.8188204
#> 29 grinding normal    5   -1 -0.06818182 0.7890835
#> 30 grinding normal    6   -1 -0.07272727 0.7607450
#> 31 grinding normal    7   -1 -0.07727273 0.7336915
#> 32 grinding normal    8   -1 -0.08181818 0.7078217
#> 33 grinding normal    9   -1 -0.08636364 0.6830447
#> 34 grinding normal   10   -1 -0.09090909 0.6592785
#> 35 grinding normal   11   -1 -0.09545455 0.6364491
#> 36 grinding normal   12   -1 -0.10000000 0.6144899
#> 37 grinding normal    1    0 -0.02500000 0.9427732
#> 38 grinding normal    2    0 -0.02727273 0.9102859
#> 39 grinding normal    3    0 -0.02954545 0.8796281
#> 40 grinding normal    4    0 -0.03181818 0.8506386
#> 41 grinding normal    5    0 -0.03409091 0.8231744
#> 42 grinding normal    6    0 -0.03636364 0.7971086
#> 43 grinding normal    7    0 -0.03863636 0.7723279
#> 44 grinding normal    8    0 -0.04090909 0.7487308
#> 45 grinding normal    9    0 -0.04318182 0.7262265
#> 46 grinding normal   10    0 -0.04545455 0.7047330
#> 47 grinding normal   11    0 -0.04772727 0.6841764
#> 48 grinding normal   12    0 -0.05000000 0.6644899

# Use different reps-max model
generate_progression_table(
  progression_perc_drop,
  type = "grinding",
  volume = "normal",
  max_perc_1RM_func = max_perc_1RM_linear,
  klin = 36
)
#>        type volume reps step  adjustment  perc_1RM
#> 1  grinding normal    1   -3 -0.10000000 0.9000000
#> 2  grinding normal    2   -3 -0.10909091 0.8631313
#> 3  grinding normal    3   -3 -0.11818182 0.8262626
#> 4  grinding normal    4   -3 -0.12727273 0.7893939
#> 5  grinding normal    5   -3 -0.13636364 0.7525253
#> 6  grinding normal    6   -3 -0.14545455 0.7156566
#> 7  grinding normal    7   -3 -0.15454545 0.6787879
#> 8  grinding normal    8   -3 -0.16363636 0.6419192
#> 9  grinding normal    9   -3 -0.17272727 0.6050505
#> 10 grinding normal   10   -3 -0.18181818 0.5681818
#> 11 grinding normal   11   -3 -0.19090909 0.5313131
#> 12 grinding normal   12   -3 -0.20000000 0.4944444
#> 13 grinding normal    1   -2 -0.07500000 0.9250000
#> 14 grinding normal    2   -2 -0.08181818 0.8904040
#> 15 grinding normal    3   -2 -0.08863636 0.8558081
#> 16 grinding normal    4   -2 -0.09545455 0.8212121
#> 17 grinding normal    5   -2 -0.10227273 0.7866162
#> 18 grinding normal    6   -2 -0.10909091 0.7520202
#> 19 grinding normal    7   -2 -0.11590909 0.7174242
#> 20 grinding normal    8   -2 -0.12272727 0.6828283
#> 21 grinding normal    9   -2 -0.12954545 0.6482323
#> 22 grinding normal   10   -2 -0.13636364 0.6136364
#> 23 grinding normal   11   -2 -0.14318182 0.5790404
#> 24 grinding normal   12   -2 -0.15000000 0.5444444
#> 25 grinding normal    1   -1 -0.05000000 0.9500000
#> 26 grinding normal    2   -1 -0.05454545 0.9176768
#> 27 grinding normal    3   -1 -0.05909091 0.8853535
#> 28 grinding normal    4   -1 -0.06363636 0.8530303
#> 29 grinding normal    5   -1 -0.06818182 0.8207071
#> 30 grinding normal    6   -1 -0.07272727 0.7883838
#> 31 grinding normal    7   -1 -0.07727273 0.7560606
#> 32 grinding normal    8   -1 -0.08181818 0.7237374
#> 33 grinding normal    9   -1 -0.08636364 0.6914141
#> 34 grinding normal   10   -1 -0.09090909 0.6590909
#> 35 grinding normal   11   -1 -0.09545455 0.6267677
#> 36 grinding normal   12   -1 -0.10000000 0.5944444
#> 37 grinding normal    1    0 -0.02500000 0.9750000
#> 38 grinding normal    2    0 -0.02727273 0.9449495
#> 39 grinding normal    3    0 -0.02954545 0.9148990
#> 40 grinding normal    4    0 -0.03181818 0.8848485
#> 41 grinding normal    5    0 -0.03409091 0.8547980
#> 42 grinding normal    6    0 -0.03636364 0.8247475
#> 43 grinding normal    7    0 -0.03863636 0.7946970
#> 44 grinding normal    8    0 -0.04090909 0.7646465
#> 45 grinding normal    9    0 -0.04318182 0.7345960
#> 46 grinding normal   10    0 -0.04545455 0.7045455
#> 47 grinding normal   11    0 -0.04772727 0.6744949
#> 48 grinding normal   12    0 -0.05000000 0.6444444
# ------------------------------------------
# Progression Relative Intensity
progression_rel_int(10, step = seq(-3, 0, 1))
#> $adjustment
#> [1] 0.775 0.825 0.875 0.925
#> 
#> $perc_1RM
#> [1] 0.5813953 0.6189047 0.6564141 0.6939235
#> 
progression_rel_int(10, step = seq(-3, 0, 1), volume = "extensive")
#> $adjustment
#> [1] 0.70 0.75 0.80 0.85
#> 
#> $perc_1RM
#> [1] 0.5251313 0.5626407 0.6001500 0.6376594
#> 
progression_rel_int(5, step = seq(-3, 0, 1), type = "ballistic")
#> $adjustment
#> [1] 0.775 0.825 0.875 0.925
#> 
#> $perc_1RM
#> [1] 0.5813953 0.6189047 0.6564141 0.6939235
#> 

# Generate progression table
generate_progression_table(progression_rel_int, type = "grinding", volume = "normal")
#>        type volume reps step adjustment  perc_1RM
#> 1  grinding normal    1   -3      0.775 0.7500242
#> 2  grinding normal    2   -3      0.775 0.7266079
#> 3  grinding normal    3   -3      0.775 0.7046095
#> 4  grinding normal    4   -3      0.775 0.6839040
#> 5  grinding normal    5   -3      0.775 0.6643806
#> 6  grinding normal    6   -3      0.775 0.6459410
#> 7  grinding normal    7   -3      0.775 0.6284973
#> 8  grinding normal    8   -3      0.775 0.6119709
#> 9  grinding normal    9   -3      0.775 0.5962915
#> 10 grinding normal   10   -3      0.775 0.5813953
#> 11 grinding normal   11   -3      0.775 0.5672254
#> 12 grinding normal   12   -3      0.775 0.5537296
#> 13 grinding normal    1   -2      0.825 0.7984129
#> 14 grinding normal    2   -2      0.825 0.7734858
#> 15 grinding normal    3   -2      0.825 0.7500682
#> 16 grinding normal    4   -2      0.825 0.7280268
#> 17 grinding normal    5   -2      0.825 0.7072439
#> 18 grinding normal    6   -2      0.825 0.6876146
#> 19 grinding normal    7   -2      0.825 0.6690455
#> 20 grinding normal    8   -2      0.825 0.6514529
#> 21 grinding normal    9   -2      0.825 0.6347619
#> 22 grinding normal   10   -2      0.825 0.6189047
#> 23 grinding normal   11   -2      0.825 0.6038205
#> 24 grinding normal   12   -2      0.825 0.5894541
#> 25 grinding normal    1   -1      0.875 0.8468015
#> 26 grinding normal    2   -1      0.875 0.8203638
#> 27 grinding normal    3   -1      0.875 0.7955269
#> 28 grinding normal    4   -1      0.875 0.7721497
#> 29 grinding normal    5   -1      0.875 0.7501072
#> 30 grinding normal    6   -1      0.875 0.7292882
#> 31 grinding normal    7   -1      0.875 0.7095937
#> 32 grinding normal    8   -1      0.875 0.6909349
#> 33 grinding normal    9   -1      0.875 0.6732323
#> 34 grinding normal   10   -1      0.875 0.6564141
#> 35 grinding normal   11   -1      0.875 0.6404157
#> 36 grinding normal   12   -1      0.875 0.6251786
#> 37 grinding normal    1    0      0.925 0.8951902
#> 38 grinding normal    2    0      0.925 0.8672417
#> 39 grinding normal    3    0      0.925 0.8409855
#> 40 grinding normal    4    0      0.925 0.8162725
#> 41 grinding normal    5    0      0.925 0.7929704
#> 42 grinding normal    6    0      0.925 0.7709618
#> 43 grinding normal    7    0      0.925 0.7501419
#> 44 grinding normal    8    0      0.925 0.7304169
#> 45 grinding normal    9    0      0.925 0.7117027
#> 46 grinding normal   10    0      0.925 0.6939235
#> 47 grinding normal   11    0      0.925 0.6770109
#> 48 grinding normal   12    0      0.925 0.6609031
generate_progression_table(progression_rel_int, step_increment = -0.1, volume_increment = 0.15)
#>             type    volume reps step adjustment  perc_1RM
#> 1       grinding intensive    1   -3       0.70 0.6774412
#> 2      ballistic intensive    1   -3       0.70 0.6562910
#> 3   conservative intensive    1   -3       0.70 0.6364215
#> 4       grinding    normal    1   -3       0.85 0.8226072
#> 5      ballistic    normal    1   -3       0.85 0.7969248
#> 6   conservative    normal    1   -3       0.85 0.7727975
#> 7       grinding extensive    1   -3       1.00 0.9677732
#> 8      ballistic extensive    1   -3       1.00 0.9375586
#> 9   conservative extensive    1   -3       1.00 0.9091736
#> 10      grinding intensive    2   -3       0.70 0.6562910
#> 11     ballistic intensive    2   -3       0.70 0.6177197
#> 12  conservative intensive    2   -3       0.70 0.5834306
#> 13      grinding    normal    2   -3       0.85 0.7969248
#> 14     ballistic    normal    2   -3       0.85 0.7500882
#> 15  conservative    normal    2   -3       0.85 0.7084514
#> 16      grinding extensive    2   -3       1.00 0.9375586
#> 17     ballistic extensive    2   -3       1.00 0.8824568
#> 18  conservative extensive    2   -3       1.00 0.8334722
#> 19      grinding intensive    3   -3       0.70 0.6364215
#> 20     ballistic intensive    3   -3       0.70 0.5834306
#> 21  conservative intensive    3   -3       0.70 0.5385858
#> 22      grinding    normal    3   -3       0.85 0.7727975
#> 23     ballistic    normal    3   -3       0.85 0.7084514
#> 24  conservative    normal    3   -3       0.85 0.6539971
#> 25      grinding extensive    3   -3       1.00 0.9091736
#> 26     ballistic extensive    3   -3       1.00 0.8334722
#> 27  conservative extensive    3   -3       1.00 0.7694083
#> 28      grinding intensive    4   -3       0.70 0.6177197
#> 29     ballistic intensive    4   -3       0.70 0.5527479
#> 30  conservative intensive    4   -3       0.70 0.5001429
#> 31      grinding    normal    4   -3       0.85 0.7500882
#> 32     ballistic    normal    4   -3       0.85 0.6711939
#> 33  conservative    normal    4   -3       0.85 0.6073164
#> 34      grinding extensive    4   -3       1.00 0.8824568
#> 35     ballistic extensive    4   -3       1.00 0.7896399
#> 36  conservative extensive    4   -3       1.00 0.7144899
#> 37      grinding intensive    5   -3       0.70 0.6000857
#> 38     ballistic intensive    5   -3       0.70 0.5251313
#> 39  conservative intensive    5   -3       0.70 0.4668223
#> 40      grinding    normal    5   -3       0.85 0.7286755
#> 41     ballistic    normal    5   -3       0.85 0.6376594
#> 42  conservative    normal    5   -3       0.85 0.5668556
#> 43      grinding extensive    5   -3       1.00 0.8572653
#> 44     ballistic extensive    5   -3       1.00 0.7501875
#> 45  conservative extensive    5   -3       1.00 0.6668890
#> 46      grinding intensive    6   -3       0.70 0.5834306
#> 47     ballistic intensive    6   -3       0.70 0.5001429
#> 48  conservative intensive    6   -3       0.70 0.4376641
#> 49      grinding    normal    6   -3       0.85 0.7084514
#> 50     ballistic    normal    6   -3       0.85 0.6073164
#> 51  conservative    normal    6   -3       0.85 0.5314493
#> 52      grinding extensive    6   -3       1.00 0.8334722
#> 53     ballistic extensive    6   -3       1.00 0.7144899
#> 54  conservative extensive    6   -3       1.00 0.6252345
#> 55      grinding intensive    7   -3       0.70 0.5676750
#> 56     ballistic intensive    7   -3       0.70 0.4774246
#> 57  conservative intensive    7   -3       0.70 0.4119343
#> 58      grinding    normal    7   -3       0.85 0.6893196
#> 59     ballistic    normal    7   -3       0.85 0.5797299
#> 60  conservative    normal    7   -3       0.85 0.5002060
#> 61      grinding extensive    7   -3       1.00 0.8109642
#> 62     ballistic extensive    7   -3       1.00 0.6820352
#> 63  conservative extensive    7   -3       1.00 0.5884776
#> 64      grinding intensive    8   -3       0.70 0.5527479
#> 65     ballistic intensive    8   -3       0.70 0.4566806
#> 66  conservative intensive    8   -3       0.70 0.3890618
#> 67      grinding    normal    8   -3       0.85 0.6711939
#> 68     ballistic    normal    8   -3       0.85 0.5545407
#> 69  conservative    normal    8   -3       0.85 0.4724322
#> 70      grinding extensive    8   -3       1.00 0.7896399
#> 71     ballistic extensive    8   -3       1.00 0.6524008
#> 72  conservative extensive    8   -3       1.00 0.5558026
#> 73      grinding intensive    9   -3       0.70 0.5385858
#> 74     ballistic intensive    9   -3       0.70 0.4376641
#> 75  conservative intensive    9   -3       0.70 0.3685957
#> 76      grinding    normal    9   -3       0.85 0.6539971
#> 77     ballistic    normal    9   -3       0.85 0.5314493
#> 78  conservative    normal    9   -3       0.85 0.4475804
#> 79      grinding extensive    9   -3       1.00 0.7694083
#> 80     ballistic extensive    9   -3       1.00 0.6252345
#> 81  conservative extensive    9   -3       1.00 0.5265652
#> 82      grinding intensive   10   -3       0.70 0.5251313
#> 83     ballistic intensive   10   -3       0.70 0.4201681
#> 84  conservative intensive   10   -3       0.70 0.3501751
#> 85      grinding    normal   10   -3       0.85 0.6376594
#> 86     ballistic    normal   10   -3       0.85 0.5102041
#> 87  conservative    normal   10   -3       0.85 0.4252126
#> 88      grinding extensive   10   -3       1.00 0.7501875
#> 89     ballistic extensive   10   -3       1.00 0.6002401
#> 90  conservative extensive   10   -3       1.00 0.5002501
#> 91      grinding intensive   11   -3       0.70 0.5123326
#> 92     ballistic intensive   11   -3       0.70 0.4040171
#> 93  conservative intensive   11   -3       0.70 0.3335080
#> 94      grinding    normal   11   -3       0.85 0.6221181
#> 95     ballistic    normal   11   -3       0.85 0.4905922
#> 96  conservative    normal   11   -3       0.85 0.4049740
#> 97      grinding extensive   11   -3       1.00 0.7319037
#> 98     ballistic extensive   11   -3       1.00 0.5771673
#> 99  conservative extensive   11   -3       1.00 0.4764400
#> 100     grinding intensive   12   -3       0.70 0.5001429
#> 101    ballistic intensive   12   -3       0.70 0.3890618
#> 102 conservative intensive   12   -3       0.70 0.3183555
#> 103     grinding    normal   12   -3       0.85 0.6073164
#> 104    ballistic    normal   12   -3       0.85 0.4724322
#> 105 conservative    normal   12   -3       0.85 0.3865745
#> 106     grinding extensive   12   -3       1.00 0.7144899
#> 107    ballistic extensive   12   -3       1.00 0.5558026
#> 108 conservative extensive   12   -3       1.00 0.4547935
#> 109     grinding intensive    1   -2       0.80 0.7742185
#> 110    ballistic intensive    1   -2       0.80 0.7500469
#> 111 conservative intensive    1   -2       0.80 0.7273388
#> 112     grinding    normal    1   -2       0.95 0.9193845
#> 113    ballistic    normal    1   -2       0.95 0.8906807
#> 114 conservative    normal    1   -2       0.95 0.8637149
#> 115     grinding extensive    1   -2       1.10 1.0645505
#> 116    ballistic extensive    1   -2       1.10 1.0313145
#> 117 conservative extensive    1   -2       1.10 1.0000909
#> 118     grinding intensive    2   -2       0.80 0.7500469
#> 119    ballistic intensive    2   -2       0.80 0.7059654
#> 120 conservative intensive    2   -2       0.80 0.6667778
#> 121     grinding    normal    2   -2       0.95 0.8906807
#> 122    ballistic    normal    2   -2       0.95 0.8383339
#> 123 conservative    normal    2   -2       0.95 0.7917986
#> 124     grinding extensive    2   -2       1.10 1.0313145
#> 125    ballistic extensive    2   -2       1.10 0.9707024
#> 126 conservative extensive    2   -2       1.10 0.9168195
#> 127     grinding intensive    3   -2       0.80 0.7273388
#> 128    ballistic intensive    3   -2       0.80 0.6667778
#> 129 conservative intensive    3   -2       0.80 0.6155267
#> 130     grinding    normal    3   -2       0.95 0.8637149
#> 131    ballistic    normal    3   -2       0.95 0.7917986
#> 132 conservative    normal    3   -2       0.95 0.7309379
#> 133     grinding extensive    3   -2       1.10 1.0000909
#> 134    ballistic extensive    3   -2       1.10 0.9168195
#> 135 conservative extensive    3   -2       1.10 0.8463492
#> 136     grinding intensive    4   -2       0.80 0.7059654
#> 137    ballistic intensive    4   -2       0.80 0.6317119
#> 138 conservative intensive    4   -2       0.80 0.5715919
#> 139     grinding    normal    4   -2       0.95 0.8383339
#> 140    ballistic    normal    4   -2       0.95 0.7501579
#> 141 conservative    normal    4   -2       0.95 0.6787654
#> 142     grinding extensive    4   -2       1.10 0.9707024
#> 143    ballistic extensive    4   -2       1.10 0.8686039
#> 144 conservative extensive    4   -2       1.10 0.7859388
#> 145     grinding intensive    5   -2       0.80 0.6858123
#> 146    ballistic intensive    5   -2       0.80 0.6001500
#> 147 conservative intensive    5   -2       0.80 0.5335112
#> 148     grinding    normal    5   -2       0.95 0.8144021
#> 149    ballistic    normal    5   -2       0.95 0.7126782
#> 150 conservative    normal    5   -2       0.95 0.6335445
#> 151     grinding extensive    5   -2       1.10 0.9429919
#> 152    ballistic extensive    5   -2       1.10 0.8252063
#> 153 conservative extensive    5   -2       1.10 0.7335779
#> 154     grinding intensive    6   -2       0.80 0.6667778
#> 155    ballistic intensive    6   -2       0.80 0.5715919
#> 156 conservative intensive    6   -2       0.80 0.5001876
#> 157     grinding    normal    6   -2       0.95 0.7917986
#> 158    ballistic    normal    6   -2       0.95 0.6787654
#> 159 conservative    normal    6   -2       0.95 0.5939727
#> 160     grinding extensive    6   -2       1.10 0.9168195
#> 161    ballistic extensive    6   -2       1.10 0.7859388
#> 162 conservative extensive    6   -2       1.10 0.6877579
#> 163     grinding intensive    7   -2       0.80 0.6487714
#> 164    ballistic intensive    7   -2       0.80 0.5456282
#> 165 conservative intensive    7   -2       0.80 0.4707821
#> 166     grinding    normal    7   -2       0.95 0.7704160
#> 167    ballistic    normal    7   -2       0.95 0.6479334
#> 168 conservative    normal    7   -2       0.95 0.5590537
#> 169     grinding extensive    7   -2       1.10 0.8920607
#> 170    ballistic extensive    7   -2       1.10 0.7502387
#> 171 conservative extensive    7   -2       1.10 0.6473254
#> 172     grinding intensive    8   -2       0.80 0.6317119
#> 173    ballistic intensive    8   -2       0.80 0.5219207
#> 174 conservative intensive    8   -2       0.80 0.4446421
#> 175     grinding    normal    8   -2       0.95 0.7501579
#> 176    ballistic    normal    8   -2       0.95 0.6197808
#> 177 conservative    normal    8   -2       0.95 0.5280124
#> 178     grinding extensive    8   -2       1.10 0.8686039
#> 179    ballistic extensive    8   -2       1.10 0.7176409
#> 180 conservative extensive    8   -2       1.10 0.6113828
#> 181     grinding intensive    9   -2       0.80 0.6155267
#> 182    ballistic intensive    9   -2       0.80 0.5001876
#> 183 conservative intensive    9   -2       0.80 0.4212522
#> 184     grinding    normal    9   -2       0.95 0.7309379
#> 185    ballistic    normal    9   -2       0.95 0.5939727
#> 186 conservative    normal    9   -2       0.95 0.5002370
#> 187     grinding extensive    9   -2       1.10 0.8463492
#> 188    ballistic extensive    9   -2       1.10 0.6877579
#> 189 conservative extensive    9   -2       1.10 0.5792217
#> 190     grinding intensive   10   -2       0.80 0.6001500
#> 191    ballistic intensive   10   -2       0.80 0.4801921
#> 192 conservative intensive   10   -2       0.80 0.4002001
#> 193     grinding    normal   10   -2       0.95 0.7126782
#> 194    ballistic    normal   10   -2       0.95 0.5702281
#> 195 conservative    normal   10   -2       0.95 0.4752376
#> 196     grinding extensive   10   -2       1.10 0.8252063
#> 197    ballistic extensive   10   -2       1.10 0.6602641
#> 198 conservative extensive   10   -2       1.10 0.5502751
#> 199     grinding intensive   11   -2       0.80 0.5855229
#> 200    ballistic intensive   11   -2       0.80 0.4617338
#> 201 conservative intensive   11   -2       0.80 0.3811520
#> 202     grinding    normal   11   -2       0.95 0.6953085
#> 203    ballistic    normal   11   -2       0.95 0.5483089
#> 204 conservative    normal   11   -2       0.95 0.4526180
#> 205     grinding extensive   11   -2       1.10 0.8050940
#> 206    ballistic extensive   11   -2       1.10 0.6348840
#> 207 conservative extensive   11   -2       1.10 0.5240840
#> 208     grinding intensive   12   -2       0.80 0.5715919
#> 209    ballistic intensive   12   -2       0.80 0.4446421
#> 210 conservative intensive   12   -2       0.80 0.3638348
#> 211     grinding    normal   12   -2       0.95 0.6787654
#> 212    ballistic    normal   12   -2       0.95 0.5280124
#> 213 conservative    normal   12   -2       0.95 0.4320538
#> 214     grinding extensive   12   -2       1.10 0.7859388
#> 215    ballistic extensive   12   -2       1.10 0.6113828
#> 216 conservative extensive   12   -2       1.10 0.5002729
#> 217     grinding intensive    1   -1       0.90 0.8709958
#> 218    ballistic intensive    1   -1       0.90 0.8438027
#> 219 conservative intensive    1   -1       0.90 0.8182562
#> 220     grinding    normal    1   -1       1.05 1.0161618
#> 221    ballistic    normal    1   -1       1.05 0.9844365
#> 222 conservative    normal    1   -1       1.05 0.9546322
#> 223     grinding extensive    1   -1       1.20 1.1613278
#> 224    ballistic extensive    1   -1       1.20 1.1250703
#> 225 conservative extensive    1   -1       1.20 1.0910083
#> 226     grinding intensive    2   -1       0.90 0.8438027
#> 227    ballistic intensive    2   -1       0.90 0.7942111
#> 228 conservative intensive    2   -1       0.90 0.7501250
#> 229     grinding    normal    2   -1       1.05 0.9844365
#> 230    ballistic    normal    2   -1       1.05 0.9265796
#> 231 conservative    normal    2   -1       1.05 0.8751459
#> 232     grinding extensive    2   -1       1.20 1.1250703
#> 233    ballistic extensive    2   -1       1.20 1.0589481
#> 234 conservative extensive    2   -1       1.20 1.0001667
#> 235     grinding intensive    3   -1       0.90 0.8182562
#> 236    ballistic intensive    3   -1       0.90 0.7501250
#> 237 conservative intensive    3   -1       0.90 0.6924675
#> 238     grinding    normal    3   -1       1.05 0.9546322
#> 239    ballistic    normal    3   -1       1.05 0.8751459
#> 240 conservative    normal    3   -1       1.05 0.8078787
#> 241     grinding extensive    3   -1       1.20 1.0910083
#> 242    ballistic extensive    3   -1       1.20 1.0001667
#> 243 conservative extensive    3   -1       1.20 0.9232900
#> 244     grinding intensive    4   -1       0.90 0.7942111
#> 245    ballistic intensive    4   -1       0.90 0.7106759
#> 246 conservative intensive    4   -1       0.90 0.6430409
#> 247     grinding    normal    4   -1       1.05 0.9265796
#> 248    ballistic    normal    4   -1       1.05 0.8291219
#> 249 conservative    normal    4   -1       1.05 0.7502143
#> 250     grinding extensive    4   -1       1.20 1.0589481
#> 251    ballistic extensive    4   -1       1.20 0.9475679
#> 252 conservative extensive    4   -1       1.20 0.8573878
#> 253     grinding intensive    5   -1       0.90 0.7715388
#> 254    ballistic intensive    5   -1       0.90 0.6751688
#> 255 conservative intensive    5   -1       0.90 0.6002001
#> 256     grinding    normal    5   -1       1.05 0.9001286
#> 257    ballistic    normal    5   -1       1.05 0.7876969
#> 258 conservative    normal    5   -1       1.05 0.7002334
#> 259     grinding extensive    5   -1       1.20 1.0287184
#> 260    ballistic extensive    5   -1       1.20 0.9002251
#> 261 conservative extensive    5   -1       1.20 0.8002668
#> 262     grinding intensive    6   -1       0.90 0.7501250
#> 263    ballistic intensive    6   -1       0.90 0.6430409
#> 264 conservative intensive    6   -1       0.90 0.5627110
#> 265     grinding    normal    6   -1       1.05 0.8751459
#> 266    ballistic    normal    6   -1       1.05 0.7502143
#> 267 conservative    normal    6   -1       1.05 0.6564962
#> 268     grinding extensive    6   -1       1.20 1.0001667
#> 269    ballistic extensive    6   -1       1.20 0.8573878
#> 270 conservative extensive    6   -1       1.20 0.7502814
#> 271     grinding intensive    7   -1       0.90 0.7298678
#> 272    ballistic intensive    7   -1       0.90 0.6138317
#> 273 conservative intensive    7   -1       0.90 0.5296298
#> 274     grinding    normal    7   -1       1.05 0.8515124
#> 275    ballistic    normal    7   -1       1.05 0.7161370
#> 276 conservative    normal    7   -1       1.05 0.6179015
#> 277     grinding extensive    7   -1       1.20 0.9731571
#> 278    ballistic extensive    7   -1       1.20 0.8184422
#> 279 conservative extensive    7   -1       1.20 0.7061731
#> 280     grinding intensive    8   -1       0.90 0.7106759
#> 281    ballistic intensive    8   -1       0.90 0.5871608
#> 282 conservative intensive    8   -1       0.90 0.5002223
#> 283     grinding    normal    8   -1       1.05 0.8291219
#> 284    ballistic    normal    8   -1       1.05 0.6850209
#> 285 conservative    normal    8   -1       1.05 0.5835927
#> 286     grinding extensive    8   -1       1.20 0.9475679
#> 287    ballistic extensive    8   -1       1.20 0.7828810
#> 288 conservative extensive    8   -1       1.20 0.6669631
#> 289     grinding intensive    9   -1       0.90 0.6924675
#> 290    ballistic intensive    9   -1       0.90 0.5627110
#> 291 conservative intensive    9   -1       0.90 0.4739087
#> 292     grinding    normal    9   -1       1.05 0.8078787
#> 293    ballistic    normal    9   -1       1.05 0.6564962
#> 294 conservative    normal    9   -1       1.05 0.5528935
#> 295     grinding extensive    9   -1       1.20 0.9232900
#> 296    ballistic extensive    9   -1       1.20 0.7502814
#> 297 conservative extensive    9   -1       1.20 0.6318783
#> 298     grinding intensive   10   -1       0.90 0.6751688
#> 299    ballistic intensive   10   -1       0.90 0.5402161
#> 300 conservative intensive   10   -1       0.90 0.4502251
#> 301     grinding    normal   10   -1       1.05 0.7876969
#> 302    ballistic    normal   10   -1       1.05 0.6302521
#> 303 conservative    normal   10   -1       1.05 0.5252626
#> 304     grinding extensive   10   -1       1.20 0.9002251
#> 305    ballistic extensive   10   -1       1.20 0.7202881
#> 306 conservative extensive   10   -1       1.20 0.6003002
#> 307     grinding intensive   11   -1       0.90 0.6587133
#> 308    ballistic intensive   11   -1       0.90 0.5194505
#> 309 conservative intensive   11   -1       0.90 0.4287960
#> 310     grinding    normal   11   -1       1.05 0.7684989
#> 311    ballistic    normal   11   -1       1.05 0.6060256
#> 312 conservative    normal   11   -1       1.05 0.5002620
#> 313     grinding extensive   11   -1       1.20 0.8782844
#> 314    ballistic extensive   11   -1       1.20 0.6926007
#> 315 conservative extensive   11   -1       1.20 0.5717280
#> 316     grinding intensive   12   -1       0.90 0.6430409
#> 317    ballistic intensive   12   -1       0.90 0.5002223
#> 318 conservative intensive   12   -1       0.90 0.4093142
#> 319     grinding    normal   12   -1       1.05 0.7502143
#> 320    ballistic    normal   12   -1       1.05 0.5835927
#> 321 conservative    normal   12   -1       1.05 0.4775332
#> 322     grinding extensive   12   -1       1.20 0.8573878
#> 323    ballistic extensive   12   -1       1.20 0.6669631
#> 324 conservative extensive   12   -1       1.20 0.5457522
#> 325     grinding intensive    1    0       1.00 0.9677732
#> 326    ballistic intensive    1    0       1.00 0.9375586
#> 327 conservative intensive    1    0       1.00 0.9091736
#> 328     grinding    normal    1    0       1.15 1.1129391
#> 329    ballistic    normal    1    0       1.15 1.0781924
#> 330 conservative    normal    1    0       1.15 1.0455496
#> 331     grinding extensive    1    0       1.30 1.2581051
#> 332    ballistic extensive    1    0       1.30 1.2188262
#> 333 conservative extensive    1    0       1.30 1.1819256
#> 334     grinding intensive    2    0       1.00 0.9375586
#> 335    ballistic intensive    2    0       1.00 0.8824568
#> 336 conservative intensive    2    0       1.00 0.8334722
#> 337     grinding    normal    2    0       1.15 1.0781924
#> 338    ballistic    normal    2    0       1.15 1.0148253
#> 339 conservative    normal    2    0       1.15 0.9584931
#> 340     grinding extensive    2    0       1.30 1.2188262
#> 341    ballistic extensive    2    0       1.30 1.1471938
#> 342 conservative extensive    2    0       1.30 1.0835139
#> 343     grinding intensive    3    0       1.00 0.9091736
#> 344    ballistic intensive    3    0       1.00 0.8334722
#> 345 conservative intensive    3    0       1.00 0.7694083
#> 346     grinding    normal    3    0       1.15 1.0455496
#> 347    ballistic    normal    3    0       1.15 0.9584931
#> 348 conservative    normal    3    0       1.15 0.8848196
#> 349     grinding extensive    3    0       1.30 1.1819256
#> 350    ballistic extensive    3    0       1.30 1.0835139
#> 351 conservative extensive    3    0       1.30 1.0002308
#> 352     grinding intensive    4    0       1.00 0.8824568
#> 353    ballistic intensive    4    0       1.00 0.7896399
#> 354 conservative intensive    4    0       1.00 0.7144899
#> 355     grinding    normal    4    0       1.15 1.0148253
#> 356    ballistic    normal    4    0       1.15 0.9080859
#> 357 conservative    normal    4    0       1.15 0.8216633
#> 358     grinding extensive    4    0       1.30 1.1471938
#> 359    ballistic extensive    4    0       1.30 1.0265319
#> 360 conservative extensive    4    0       1.30 0.9288368
#> 361     grinding intensive    5    0       1.00 0.8572653
#> 362    ballistic intensive    5    0       1.00 0.7501875
#> 363 conservative intensive    5    0       1.00 0.6668890
#> 364     grinding    normal    5    0       1.15 0.9858551
#> 365    ballistic    normal    5    0       1.15 0.8627157
#> 366 conservative    normal    5    0       1.15 0.7669223
#> 367     grinding extensive    5    0       1.30 1.1144449
#> 368    ballistic extensive    5    0       1.30 0.9752438
#> 369 conservative extensive    5    0       1.30 0.8669557
#> 370     grinding intensive    6    0       1.00 0.8334722
#> 371    ballistic intensive    6    0       1.00 0.7144899
#> 372 conservative intensive    6    0       1.00 0.6252345
#> 373     grinding    normal    6    0       1.15 0.9584931
#> 374    ballistic    normal    6    0       1.15 0.8216633
#> 375 conservative    normal    6    0       1.15 0.7190196
#> 376     grinding extensive    6    0       1.30 1.0835139
#> 377    ballistic extensive    6    0       1.30 0.9288368
#> 378 conservative extensive    6    0       1.30 0.8128048
#> 379     grinding intensive    7    0       1.00 0.8109642
#> 380    ballistic intensive    7    0       1.00 0.6820352
#> 381 conservative intensive    7    0       1.00 0.5884776
#> 382     grinding    normal    7    0       1.15 0.9326089
#> 383    ballistic    normal    7    0       1.15 0.7843405
#> 384 conservative    normal    7    0       1.15 0.6767492
#> 385     grinding extensive    7    0       1.30 1.0542535
#> 386    ballistic extensive    7    0       1.30 0.8866458
#> 387 conservative extensive    7    0       1.30 0.7650209
#> 388     grinding intensive    8    0       1.00 0.7896399
#> 389    ballistic intensive    8    0       1.00 0.6524008
#> 390 conservative intensive    8    0       1.00 0.5558026
#> 391     grinding    normal    8    0       1.15 0.9080859
#> 392    ballistic    normal    8    0       1.15 0.7502610
#> 393 conservative    normal    8    0       1.15 0.6391730
#> 394     grinding extensive    8    0       1.30 1.0265319
#> 395    ballistic extensive    8    0       1.30 0.8481211
#> 396 conservative extensive    8    0       1.30 0.7225434
#> 397     grinding intensive    9    0       1.00 0.7694083
#> 398    ballistic intensive    9    0       1.00 0.6252345
#> 399 conservative intensive    9    0       1.00 0.5265652
#> 400     grinding    normal    9    0       1.15 0.8848196
#> 401    ballistic    normal    9    0       1.15 0.7190196
#> 402 conservative    normal    9    0       1.15 0.6055500
#> 403     grinding extensive    9    0       1.30 1.0002308
#> 404    ballistic extensive    9    0       1.30 0.8128048
#> 405 conservative extensive    9    0       1.30 0.6845348
#> 406     grinding intensive   10    0       1.00 0.7501875
#> 407    ballistic intensive   10    0       1.00 0.6002401
#> 408 conservative intensive   10    0       1.00 0.5002501
#> 409     grinding    normal   10    0       1.15 0.8627157
#> 410    ballistic    normal   10    0       1.15 0.6902761
#> 411 conservative    normal   10    0       1.15 0.5752876
#> 412     grinding extensive   10    0       1.30 0.9752438
#> 413    ballistic extensive   10    0       1.30 0.7803121
#> 414 conservative extensive   10    0       1.30 0.6503252
#> 415     grinding intensive   11    0       1.00 0.7319037
#> 416    ballistic intensive   11    0       1.00 0.5771673
#> 417 conservative intensive   11    0       1.00 0.4764400
#> 418     grinding    normal   11    0       1.15 0.8416892
#> 419    ballistic    normal   11    0       1.15 0.6637424
#> 420 conservative    normal   11    0       1.15 0.5479060
#> 421     grinding extensive   11    0       1.30 0.9514748
#> 422    ballistic extensive   11    0       1.30 0.7503174
#> 423 conservative extensive   11    0       1.30 0.6193721
#> 424     grinding intensive   12    0       1.00 0.7144899
#> 425    ballistic intensive   12    0       1.00 0.5558026
#> 426 conservative intensive   12    0       1.00 0.4547935
#> 427     grinding    normal   12    0       1.15 0.8216633
#> 428    ballistic    normal   12    0       1.15 0.6391730
#> 429 conservative    normal   12    0       1.15 0.5230126
#> 430     grinding extensive   12    0       1.30 0.9288368
#> 431    ballistic extensive   12    0       1.30 0.7225434
#> 432 conservative extensive   12    0       1.30 0.5912316

# Use different reps-max model
generate_progression_table(
  progression_rel_int,
  type = "grinding",
  volume = "normal",
  max_perc_1RM_func = max_perc_1RM_linear,
  klin = 36
)
#>        type volume reps step adjustment  perc_1RM
#> 1  grinding normal    1   -3      0.775 0.7750000
#> 2  grinding normal    2   -3      0.775 0.7534722
#> 3  grinding normal    3   -3      0.775 0.7319444
#> 4  grinding normal    4   -3      0.775 0.7104167
#> 5  grinding normal    5   -3      0.775 0.6888889
#> 6  grinding normal    6   -3      0.775 0.6673611
#> 7  grinding normal    7   -3      0.775 0.6458333
#> 8  grinding normal    8   -3      0.775 0.6243056
#> 9  grinding normal    9   -3      0.775 0.6027778
#> 10 grinding normal   10   -3      0.775 0.5812500
#> 11 grinding normal   11   -3      0.775 0.5597222
#> 12 grinding normal   12   -3      0.775 0.5381944
#> 13 grinding normal    1   -2      0.825 0.8250000
#> 14 grinding normal    2   -2      0.825 0.8020833
#> 15 grinding normal    3   -2      0.825 0.7791667
#> 16 grinding normal    4   -2      0.825 0.7562500
#> 17 grinding normal    5   -2      0.825 0.7333333
#> 18 grinding normal    6   -2      0.825 0.7104167
#> 19 grinding normal    7   -2      0.825 0.6875000
#> 20 grinding normal    8   -2      0.825 0.6645833
#> 21 grinding normal    9   -2      0.825 0.6416667
#> 22 grinding normal   10   -2      0.825 0.6187500
#> 23 grinding normal   11   -2      0.825 0.5958333
#> 24 grinding normal   12   -2      0.825 0.5729167
#> 25 grinding normal    1   -1      0.875 0.8750000
#> 26 grinding normal    2   -1      0.875 0.8506944
#> 27 grinding normal    3   -1      0.875 0.8263889
#> 28 grinding normal    4   -1      0.875 0.8020833
#> 29 grinding normal    5   -1      0.875 0.7777778
#> 30 grinding normal    6   -1      0.875 0.7534722
#> 31 grinding normal    7   -1      0.875 0.7291667
#> 32 grinding normal    8   -1      0.875 0.7048611
#> 33 grinding normal    9   -1      0.875 0.6805556
#> 34 grinding normal   10   -1      0.875 0.6562500
#> 35 grinding normal   11   -1      0.875 0.6319444
#> 36 grinding normal   12   -1      0.875 0.6076389
#> 37 grinding normal    1    0      0.925 0.9250000
#> 38 grinding normal    2    0      0.925 0.8993056
#> 39 grinding normal    3    0      0.925 0.8736111
#> 40 grinding normal    4    0      0.925 0.8479167
#> 41 grinding normal    5    0      0.925 0.8222222
#> 42 grinding normal    6    0      0.925 0.7965278
#> 43 grinding normal    7    0      0.925 0.7708333
#> 44 grinding normal    8    0      0.925 0.7451389
#> 45 grinding normal    9    0      0.925 0.7194444
#> 46 grinding normal   10    0      0.925 0.6937500
#> 47 grinding normal   11    0      0.925 0.6680556
#> 48 grinding normal   12    0      0.925 0.6423611
```
