#' Vertical Planning Functions
#'
#' Functions for creating vertical planning (progressions)
#'
#' @param reps Numeric vector indicating reps prescription
#' @param reps_change Change in \code{reps} across progression steps
#' @param step Numeric vector indicating progression steps (i.e. -3, -2, -1, 0)
#'
#' @return Data frame with \code{reps}, \code{index}, and \code{step} columns
#'
#' @name vertical_planning_functions
#' @examples
#' # Generic vertical planning function
#' # ----------------------------------
#'
#' # Constant
#' vertical_planning(reps = c(3, 2, 1), step = c(-3, -2, -1, 0))
#'
#' # Linear
#' vertical_planning(reps = c(5, 5, 5, 5, 5), reps_change = c(0, -1, -2))
#'
#' # Reverse Linear
#' vertical_planning(reps = c(5, 5, 5, 5, 5), reps_change = c(0, 1, 2))
#'
#' # Block
#' vertical_planning(reps = c(5, 5, 5, 5, 5), step = c(-2, -1, 0, -3))
#'
#' # Block variant
#' vertical_planning(reps = c(5, 5, 5, 5, 5), step = c(-2, -1, -3, 0))
#'
#' # Undulating
#' vertical_planning(reps = c(12, 10, 8), reps_change = c(0, -4, -2, -6))
#'
#' # Undulating + Block variant
#' vertical_planning(
#'   reps = c(12, 10, 8),
#'   reps_change = c(0, -4, -2, -6),
#'   step = c(-2, -1, -3, 0)
#' )
#'
#' # Rep accumulation
#' # If used with `scheme_generic()` (or any other `scheme_`) it will provide wrong set and rep scheme.
#' # Use `scheme_rep_acc()` instead, or apply `.vertical_rep_accumulation.post()`
#' # function AFTER generating the scheme
#' vertical_planning(
#'   reps = c(10, 8, 6),
#'   reps_change = c(-3, -2, -1, 0),
#'   step = c(0, 0, 0, 0)
#' )
#'
#'
NULL

#' @describeIn vertical_planning_functions Generic Vertical Planning
#' @export
vertical_planning <- function(reps, reps_change = NULL, step = NULL) {
  if (is.null(reps_change) & is.null(step)) {
    stop("Please define either 'reps_change' or 'step' parameters", call. = FALSE)
  }

  if (is.null(reps_change)) {
    reps_change <- rep(0, length(step))
  }

  if (is.null(step)) {
    step <- seq(-length(reps_change) + 1, 0)
  }

  if (length(reps_change) != length(step)) {
    stop("'reps_change' and 'step' parameters lengths differ")
  }

  df <- expand.grid(
    reps = reps,
    index = seq_along(reps_change)
  )

  df$reps <- df$reps + reps_change[df$index]
  df$step <- step[df$index]

  df
}

#' @describeIn vertical_planning_functions Constants Vertical Planning
#' @param n_steps Number of progression steps. Default is 4
#' @export
#' @examples
#'
#' # Constant
#' # ----------------------------------
#' vertical_constant(c(5, 5, 5), 4)
#' vertical_constant(c(3, 2, 1), 2)
#'
#' plot_vertical(vertical_constant)
vertical_constant <- function(reps, n_steps = 4) {
  vertical_planning(reps = reps, reps_change = rep(0, n_steps))
}

#' @describeIn vertical_planning_functions Linear Vertical Planning
#' @export
#' @examples
#'
#' # Linear
#' # ----------------------------------
#' vertical_linear(c(10, 8, 6), c(0, -2, -4))
#' vertical_linear(c(5, 5, 5), c(0, -1, -2, -3))
#'
#' plot_vertical(vertical_linear)
vertical_linear <- function(reps,
                            reps_change = c(0, -1, -2, -3)) {
  vertical_planning(reps = reps, reps_change = reps_change)
}

#' @describeIn vertical_planning_functions Reverse Linear Vertical Planning
#' @export
#' @examples
#'
#' # Reverse Linear
#' # ----------------------------------
#' vertical_linear_reverse(c(6, 4, 2), c(0, 1, 2))
#' vertical_linear_reverse(c(5, 5, 5))
#'
#' plot_vertical(vertical_linear_reverse)
vertical_linear_reverse <- function(reps,
                                    reps_change = c(0, 1, 2, 3)) {
  vertical_planning(reps = reps, reps_change = reps_change)
}


#' @describeIn vertical_planning_functions Block Vertical Planning
#' @export
#' @examples
#'
#' # Block
#' # ----------------------------------
#' vertical_block(c(6, 4, 2))
#'
#' plot_vertical(vertical_block)
vertical_block <- function(reps,
                           step = c(-2, -1, 0, -3)) {
  vertical_planning(reps = reps, step = step)
}

#' @describeIn vertical_planning_functions Block Variant Vertical Planning
#' @export
#' @examples
#'
#' # Block Variant
#' # ----------------------------------
#' vertical_block_variant(c(6, 4, 2))
#'
#' plot_vertical(vertical_block_variant)
vertical_block_variant <- function(reps,
                                   step = c(-2, -1, -3, 0)) {
  vertical_planning(reps = reps, step = step)
}


#' @describeIn vertical_planning_functions Rep Accumulation Vertical Planning
#' @export
#' @examples
#'
#' # Rep Accumulation
#' # ----------------------------------
#' # If used with `scheme_generic()` (or any other `scheme_`) it will provide wrong set and rep scheme.
#' # Use `scheme_rep_acc()` instead, or apply `.vertical_rep_accumulation.post()`
#' # function AFTER generating the scheme
#' vertical_rep_accumulation(c(10, 8, 6))
#'
#' plot_vertical(vertical_rep_accumulation)
vertical_rep_accumulation <- function(reps,
                                      reps_change = c(-3, -2, -1, 0),
                                      step = c(0, 0, 0, 0)) {
  vertical_planning(reps = reps, reps_change = reps_change, step = step)
}


#' @describeIn vertical_planning_functions Set Accumulation Vertical Planning
#' @param accumulate_set Which set (position in \code{reps}) to accumulate
#' @param set_increment How many sets to increase each step? Default is 1
#' @param sequence Should the sequence of accumulated sets be repeated, or
#'     individual sets?
#' @export
#' @examples
#'
#' # Set Accumulation
#' # ----------------------------------
#' # Default is accumulation of the last set
#' vertical_set_accumulation(c(3, 2, 1))
#'
#' # We can have whole sequence being repeated
#' vertical_set_accumulation(c(3, 2, 1), accumulate_set = 1:3)
#'
#' # Or we can have accumulation of the individual sets
#' vertical_set_accumulation(c(3, 2, 1), accumulate_set = 1:3, sequence = FALSE)
#'
#' # We can also have two or more sequences
#' vertical_set_accumulation(c(10, 8, 6, 4, 2, 1), accumulate_set = c(1:2, 5:6))
#'
#' # And also repeat the individual sets
#' vertical_set_accumulation(
#'   c(10, 8, 6, 4, 2, 1),
#'   accumulate_set = c(1:2, 5:6),
#'   sequence = FALSE
#' )
#' plot_vertical(vertical_set_accumulation)
vertical_set_accumulation <- function(reps,
                                      step = c(-2, -2, -2, -2),
                                      accumulate_set = length(reps),
                                      set_increment = 1,
                                      sequence = TRUE) {


  # +++++++++++++++++++++++++++++++++++++++++++
  # Code chunk for dealing with R CMD check note
  index <- NULL
  set_index <- NULL
  .accumulate <- NULL
  .repeat <- NULL
  .group <- NULL
  .id <- NULL
  # +++++++++++++++++++++++++++++++++++++++++++

  if (any(accumulate_set > length(reps))) {
    stop("Set index in `accumulate_set` cannot be bigger than number of sets", call. = FALSE)
  }

  # Sort
  accumulate_set <- accumulate_set[order(accumulate_set)]

  # Get the initial vertical plan
  vp <- vertical_planning(reps = reps, step = step)

  # Get the set index
  vp <- vp %>%
    dplyr::group_by(index) %>%
    dplyr::mutate(set_index = seq_along(reps)) %>%
    dplyr::ungroup()

  if (sequence == TRUE) {
    vp <- vp %>%
      dplyr::group_by(index) %>%
      dplyr::mutate(
        .accumulate = set_index %in% accumulate_set,
        .repeat = ifelse(.accumulate, (set_increment * (index - 1)) + 1, 1),
        .group = mark_sequences(.accumulate)
      ) %>%
      tidyr::uncount(.repeat, .id = ".id") %>%
      dplyr::arrange(.group, .id) %>%
      dplyr::mutate(set_index = seq_along(reps)) %>%
      dplyr::ungroup() %>%
      dplyr::arrange(index, set_index)
  } else {
    vp <- vp %>%
      dplyr::group_by(index) %>%
      dplyr::mutate(
        .accumulate = set_index %in% accumulate_set,
        .repeat = ifelse(.accumulate, (set_increment * (index - 1)) + 1, 1)
      ) %>%
      tidyr::uncount(.repeat) %>%
      dplyr::mutate(set_index = seq_along(reps)) %>%
      dplyr::ungroup() %>%
      dplyr::arrange(index, set_index)
  }

  dplyr::select(vp, reps, index, step) %>%
    data.frame()
}

#' @describeIn vertical_planning_functions Set Accumulation Reverse Vertical Planning
#' @param accumulate_set Which set (position in \code{reps}) to accumulate
#' @param set_increment How many sets to increase each step? Default is 1
#' @param sequence Should the sequence of accumulated sets be repeated, or
#'     individual sets?
#' @export
#' @examples
#'
#' # Reverse Set Accumulation
#' # ----------------------------------
#' # Default is accumulation of the last set
#' vertical_set_accumulation_reverse(c(3, 2, 1))
#'
#' # We can have whole sequence being repeated
#' vertical_set_accumulation_reverse(c(3, 2, 1), accumulate_set = 1:3)
#'
#' # Or we can have accumulation of the individual sets
#' vertical_set_accumulation_reverse(c(3, 2, 1), accumulate_set = 1:3, sequence = FALSE)
#'
#' # We can also have two or more sequences
#' vertical_set_accumulation_reverse(c(10, 8, 6, 4, 2, 1), accumulate_set = c(1:2, 5:6))
#'
#' # And also repeat the individual sets
#' vertical_set_accumulation_reverse(
#'   c(10, 8, 6, 4, 2, 1),
#'   accumulate_set = c(1:2, 5:6),
#'   sequence = FALSE
#' )
#'
#' plot_vertical(vertical_set_accumulation_reverse)
vertical_set_accumulation_reverse <- function(reps,
                                              step = c(-3, -2, -1, 0),
                                              accumulate_set = length(reps),
                                              set_increment = 1,
                                              sequence = TRUE) {

  # +++++++++++++++++++++++++++++++++++++++++++
  # Code chunk for dealing with R CMD check note
  index <- NULL
  set_index <- NULL
  .accumulate <- NULL
  .repeat <- NULL
  .group <- NULL
  .id <- NULL
  # +++++++++++++++++++++++++++++++++++++++++++

  if (any(accumulate_set > length(reps))) {
    stop("Set index in `accumulate_set` cannot be bigger than number of sets", call. = FALSE)
  }

  # Sort
  accumulate_set <- accumulate_set[order(accumulate_set)]

  # Get the initial vertical plan
  vp <- vertical_planning(reps = reps, step = step)

  max_step_index <- max(vp$index)

  # Get the set index
  vp <- vp %>%
    dplyr::group_by(index) %>%
    dplyr::mutate(set_index = seq_along(reps)) %>%
    dplyr::ungroup()

  if (sequence == TRUE) {
    vp <- vp %>%
      dplyr::group_by(index) %>%
      dplyr::mutate(
        .accumulate = set_index %in% accumulate_set,
        .repeat = ifelse(.accumulate, max_step_index - (set_increment * (index - 1)), 1),
        .group = mark_sequences(.accumulate)
      ) %>%
      tidyr::uncount(.repeat, .id = ".id") %>%
      dplyr::arrange(.group, .id) %>%
      dplyr::mutate(set_index = seq_along(reps)) %>%
      dplyr::ungroup() %>%
      dplyr::arrange(index, set_index)
  } else {
    vp <- vp %>%
      dplyr::group_by(index) %>%
      dplyr::mutate(
        .accumulate = set_index %in% accumulate_set,
        .repeat = ifelse(.accumulate, max_step_index - (set_increment * (index - 1)), 1)
      ) %>%
      tidyr::uncount(.repeat) %>%
      dplyr::mutate(set_index = seq_along(reps)) %>%
      dplyr::ungroup() %>%
      dplyr::arrange(index, set_index)
  }

  dplyr::select(vp, reps, index, step) %>%
    data.frame()
}

#' @describeIn vertical_planning_functions Undulating Vertical Planning
#' @export
#' @examples
#'
#' # Undulating
#' # ----------------------------------
#' vertical_undulating(c(8, 6, 4))
vertical_undulating <- function(reps,
                                reps_change = c(0, -2, -1, -3)) {
  vertical_planning(reps = reps, reps_change = reps_change)
}

#' @describeIn vertical_planning_functions Undulating Vertical Planning
#' @export
#' @examples
#'
#' # Reverse Undulating
#' # ----------------------------------
#' vertical_undulating_reverse(c(8, 6, 4))
vertical_undulating_reverse <- function(reps,
                                        reps_change = c(0, 2, 1, 3)) {
  vertical_planning(reps = reps, reps_change = reps_change)
}

#' @describeIn vertical_planning_functions Block Undulating Vertical Planning
#' @export
#' @examples
#'
#' # Block Undulating
#' # ----------------------------------
#' # This is a combination of Block Variant (undulation in the steps) and
#' # Undulating (undulation in reps)
#' vertical_block_undulating(c(8, 6, 4))
vertical_block_undulating <- function(reps,
                                      reps_change = c(0, -2, -1, -3),
                                      step = c(-2, -1, -3, 0)) {
  vertical_planning(reps = reps, reps_change = reps_change, step = step)
}

#' @describeIn vertical_planning_functions Volume-Intensity Vertical Planning
#' @export
#' @examples
#'
#' # Volume-Intensity
#' # ----------------------------------
#' vertical_volume_intensity(c(6, 6, 6))
vertical_volume_intensity <- function(reps,
                                      reps_change = c(0, 0, -3, -3)) {
  vertical_planning(reps = reps, reps_change = reps_change)
}


#' @describeIn vertical_planning_functions Rep Accumulation Vertical Planning POST treatment
#' This functions is to be applied AFTER scheme is generated. Other options is to use
#' \code{\link{scheme_rep_acc}} function, that is flexible enough to generate most options,
#' except for the \code{\link{scheme_ladder}} and \code{\link{scheme_light_heavy}}
#'
#' @param scheme Scheme generated by `scheme_` functions
#' @param rep_decrement Rep decrements across progression step
#' @param remove_reps Should < 1 reps be removed?
#'
#' @export
#' @examples
#'
#' # Rep Accumulation
#' # --------------------------
#' scheme_rep_acc()
#'
#' # Generate Wave scheme with rep accumulation vertical progression
#' # This functions doesn't allow you to use different vertical planning
#' # options
#' scheme <- scheme_rep_acc(reps = c(10, 8, 6), adjustment = c(-0.1, -0.05, 0))
#' plot(scheme)
#'
#' # Other options is to use `.vertical_rep_accumulation.post()` and
#' # apply it after
#' # The default vertical progression is `vertical_const()`
#' scheme <- scheme_wave(reps = c(10, 8, 6), adjustment = c(-0.1, -0.05, 0))
#'
#' .vertical_rep_accumulation.post(scheme)
#'
#' # We can also create "undulating" rep decrements
#' .vertical_rep_accumulation.post(
#'   scheme,
#'   rep_decrement = c(-3, -1, -2, 0)
#' )
#'
#' # `scheme_rep_acc` will not allow you to generate `scheme_ladder()`
#' # and `scheme_scheme_light_heavy()`
#' # You must use `.vertical_rep_accumulation.post()` to do so
#' scheme <- scheme_ladder()
#' scheme <- .vertical_rep_accumulation.post(scheme)
#' plot(scheme)
#'
#' # Please note that reps < 1 are removed. If you do not want this,
#' # use `remove_reps = FALSE` parameter
#' .vertical_rep_accumulation.post(scheme, remove_reps = FALSE)
.vertical_rep_accumulation.post <- function(scheme,
                                            rep_decrement = c(-3, -2, -1, 0),
                                            remove_reps = TRUE) {
  max_step <- max(scheme$step)
  max_index <- max(scheme$index)
  indexes <- seq(max_index - length(rep_decrement) + 1, max_index)

  index_step <- data.frame(index = indexes, step = max_step, rep_decrement = rep_decrement)

  selected_step_df <- scheme[scheme$step == max_step, ]

  df <- tidyr::expand_grid(
    index_step,
    data.frame(
      reps = selected_step_df$reps,
      adjustment = selected_step_df$adjustment,
      perc_1RM = selected_step_df$perc_1RM
    )
  )

  df <- data.frame(
    reps = df$reps + df$rep_decrement,
    index = df$index,
    step = df$step,
    adjustment = df$adjustment,
    perc_1RM = df$perc_1RM
  )

  # Remove reps < 1
  if (remove_reps == TRUE) {
    df <- df[df$reps >= 1, ]
  }

  # Call the constructor
  new_STMr_scheme(
    reps = df$reps,
    index = df$index,
    step = df$step,
    adjustment = df$adjustment,
    perc_1RM = df$perc_1RM
  )
}
