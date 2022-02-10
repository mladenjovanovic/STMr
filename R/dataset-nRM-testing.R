#' Repetition maximum testing of 12 athletes
#'
#' A dataset containing repetition maximum testing for 12 athletes
#'     using 70, 80, and 90% of 1RM
#'
#' @format A data frame with 36 rows and 6 variables:
#' \describe{
#'   \item{Athlete}{Name of the athlete; ID}
#'   \item{1RM}{Maximum weight the athlete can lift correctly for a single rep}
#'   \item{Goal %1RM}{%1RM we want to use for testing; 70, 80, or 90%}
#'   \item{Weight}{Weight that is estimated to be lifted, but rounded to closes 2.5}
#'   \item{Observed %1RM}{Recalculated %1RM after rounding the weight}
#'   \item{nRM}{Number of maximum repetitions performed}
#' }
"nRM_testing"
