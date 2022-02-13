#' Reps to failure testing of 12 athletes
#'
#' A dataset containing reps to failure testing for 12 athletes
#'     using 70, 80, and 90% of 1RM
#'
#' @format A data frame with 36 rows and 6 variables:
#' \describe{
#'   \item{Athlete}{Name of the athlete; ID}
#'   \item{1RM}{Maximum weight the athlete can lift correctly for a single rep}
#'   \item{Target %1RM}{%1RM we want to use for testing; 70, 80, or 90%}
#'   \item{Target Weight}{Estimated weight to be lifted}
#'   \item{Real Weight}{Weight that is estimated to be lifted, but rounded to closest 2.5}
#'   \item{Real %1RM}{Recalculated %1RM after rounding the weight}
#'   \item{nRM}{Reps-to-failure (RTF), or the number of maximum repetitions (nRM) performed}
#' }
"RTF_testing"
