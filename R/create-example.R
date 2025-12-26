#' Create Example
#'
#' This function create simple example using \code{progression_table}
#' @param progression_table Progression table function
#' @param reps Numeric vector. Default is \code{c(3, 5, 10)}
#' @param volume Character vector. Default is \code{c("intensive", "normal", "extensive")}
#' @param type Character vector. Type of max rep table. Options are grinding (Default), ballistic,
#'     and conservative
#' @param ... Extra arguments forwarded to \code{progression_table}
#' @return Data frame with the following structure
#'   \describe{
#'     \item{type}{Type of the set and rep scheme}
#'     \item{reps}{Number of reps performed}
#'     \item{volume}{Volume type of the set and rep scheme}
#'     \item{Step 1}{First progression step %1RM}
#'     \item{Step 2}{Second progression step %1RM}
#'     \item{Step 3}{Third progression step %1RM}
#'     \item{Step 4}{Fourth progression step %1RM}
#'     \item{Step 2-1 Diff}{Difference in %1RM between second and first progression step}
#'     \item{Step 3-2 Diff}{Difference in %1RM between third and second progression step}
#'     \item{Step 4-3 Diff}{Difference in %1RM between fourth and third progression step}
#'   }
#'
#' @export
#' @examples
#' create_example(progression_RIR)
#'
#' # Create example using specific reps-max table and k value
#' create_example(
#'   progression_RIR,
#'   max_perc_1RM_func = max_perc_1RM_modified_epley,
#'   kmod = 0.0388
#' )
create_example <- function(progression_table,
                           reps = c(3, 5, 10),
                           volume = c("intensive", "normal", "extensive"),
                           type = c("grinding", "ballistic"),
                           ...) {

  # +++++++++++++++++++++++++++++++++++++++++++
  # Code chunk for dealing with R CMD check note
  step <- NULL
  `%1RM` <- NULL
  `Step 1` <- NULL
  `Step 2` <- NULL
  `Step 3` <- NULL
  `Step 4` <- NULL
  # +++++++++++++++++++++++++++++++++++++++++++

  # Perform checks
  check_volume(volume)
  check_type(type)

  example_data <- tidyr::expand_grid(
    type = type,
    reps = reps,
    volume = volume,
    step = c(-3, -2, -1, 0)
  ) %>%
    # dplyr::rowwise() %>%
    dplyr::mutate(
      `%1RM` = 100 * progression_table(reps = reps, step = step, volume = volume, type = type, ...)$perc_1RM
    ) %>%
    # dplyr::ungroup() %>%
    dplyr::mutate(
      step = paste0("Step ", length(unique(step)) + step)
    )

  example_data_wide <- tidyr::pivot_wider(example_data, id_cols = c(type, reps, volume), names_from = step, values_from = `%1RM`) %>%
    dplyr::mutate(
      `Step 2-1 Diff` = `Step 2` - `Step 1`,
      `Step 3-2 Diff` = `Step 3` - `Step 2`,
      `Step 4-3 Diff` = `Step 4` - `Step 3`
    )

  example_data_wide
}
