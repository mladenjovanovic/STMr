#' Strength Training Log
#'
#' A dataset containing strength training log for a single athlete. Strength training program
#'     involves doing two strength training sessions, over 12 week (4 phases of 3 weeks each).
#'     Session A involves linear wave-loading pattern starting with 2x12/10/8 reps and reaching 2x8/6/4 reps.
#'     Session B involves constant wave-loading pattern using 2x3/2/1. This dataset contains \code{weight}
#'     being used, as well as estimated reps-in-reserve (eRIR), which represent subjective rating
#'     of the proximity to failure
#'
#' @format A data frame with 144 rows and 8 variables:
#' \describe{
#'   \item{phase}{Phase index number. Numeric from 1 to 4}
#'   \item{week}{Week index number (within phase). Numeric from 1 to 3}
#'   \item{day}{Day (total) index number. Numeric from 1 to 3}
#'   \item{session}{Name of the session. Can be "Session A" or "Session B"}
#'   \item{set}{Set index number. Numeric from 1 to 6}
#'   \item{weight}{Weight in kg being used}
#'   \item{reps}{Number of reps being done}
#'   \item{eRIR}{Estimated reps-in-reserve}
#' }
"strength_training_log"
