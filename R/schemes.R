#' Set and Rep Schemes
#'
#' @param reps Numeric vector indicating reps prescription
#' @param adjustment Numeric vector indicating adjustments. Forwarded to \code{progression_table}.
#' @param vertical_planning Vertical planning function. Default is \code{\link{vertical_constant}}
#' @param vertical_planning_control Arguments forwarded to the \code{\link{vertical_planning}} function
#' @param progression_table Progression table function. Default is \code{\link{progression_perc_drop}}
#' @param progression_table_control Arguments forwarded to the \code{\link{progression_table}} function
#' @return Data frame with the following columns: \code{reps}, \code{index}, \code{step},
#'     \code{adjustment}, and \code{perc_1RM}.
#'
#' @name set_and_reps_schemes
NULL


#' @describeIn set_and_reps_schemes Generic set and rep scheme.
#'     \code{scheme_generic} is called in all other set and rep schemes - only the default parameters
#'     differ to make easier and quicker schemes writing and groupings
#'
#' @export
#' @examples
#' scheme_generic(
#'   reps = c(8, 6, 4, 8, 6, 4),
#'   # Adjusting using lower %1RM (RIR Increment method used)
#'   adjustment = c(4, 2, 0, 6, 4, 2),
#'   vertical_planning = vertical_linear,
#'   vertical_planning_control = list(reps_change = c(0, -2, -4)),
#'   progression_table = progression_RIR_increment,
#'   progression_table_control = list(volume = "extensive")
#' )
scheme_generic <- function(reps,
                           adjustment,
                           vertical_planning,
                           vertical_planning_control = list(),
                           progression_table,
                           progression_table_control = list()) {

  # Just to make sure the lengths are the same
  .tmp <- data.frame(
    reps = reps,
    adjustment = adjustment
  )

  progression <- do.call(vertical_planning, c(list(reps = .tmp$reps), vertical_planning_control))

  # Find reps based on the returned set_id
  # This is needed for vertical_accumulate_set() and
  #   vertical_accumulate_set_reverse() functions
  .reps <- .tmp$reps[progression$set_id]
  .adjustment <- .tmp$adjustment[progression$set_id]

  loads <- do.call(
    progression_table,
    c(
      list(
        reps = .reps,
        step = progression$step,
        adjustment = .adjustment
      ),
      progression_table_control
    )
  )

  # Constructor
  new_STMr_scheme(
    index = progression$index,
    step = progression$step,
    set = progression$set,
    reps = .reps,
    adjustment = .adjustment,
    perc_1RM = loads$perc_1RM
  )
}

#' @describeIn set_and_reps_schemes Wave set and rep scheme
#' @export
#' @examples
#'
#' # Wave set and rep schemes
#' # --------------------------
#' scheme_wave()
#'
#' scheme_wave(
#'   reps = c(8, 6, 4, 8, 6, 4),
#'   # Second wave with higher intensity
#'   adjustment = c(-0.25, -0.15, 0.05, -0.2, -0.1, 0),
#'   vertical_planning = vertical_block,
#'   progression_table = progression_perc_drop,
#'   progression_table_control = list(type = "ballistic")
#' )
#'
#' # Adjusted second wave
#' # and using 3 steps progression
#' scheme_wave(
#'   reps = c(8, 6, 4, 8, 6, 4),
#'   # Adjusting using lower %1RM (progression_perc_drop method used)
#'   adjustment = c(0, 0, 0, -0.1, -0.1, -0.1),
#'   vertical_planning = vertical_linear,
#'   vertical_planning_control = list(reps_change = c(0, -2, -4)),
#'   progression_table = progression_perc_drop,
#'   progression_table_control = list(volume = "extensive")
#' )
#'
#' # Adjusted using RIR inc
#' # This time we adjust first wave as well, first two sets easier
#' scheme <- scheme_wave(
#'   reps = c(8, 6, 4, 8, 6, 4),
#'   # Adjusting using lower %1RM (RIR Increment method used)
#'   adjustment = c(4, 2, 0, 6, 4, 2),
#'   vertical_planning = vertical_linear,
#'   vertical_planning_control = list(reps_change = c(0, -2, -4)),
#'   progression_table = progression_RIR_increment,
#'   progression_table_control = list(volume = "extensive")
#' )
#' plot(scheme)
scheme_wave <- function(reps = c(10, 8, 6),
                        adjustment = -rev((seq_along(reps) - 1) * 5) / 100,
                        vertical_planning = vertical_constant,
                        vertical_planning_control = list(),
                        progression_table = progression_perc_drop,
                        progression_table_control = list(volume = "normal")) {
  scheme_generic(
    reps = reps,
    adjustment = adjustment,
    vertical_planning = vertical_planning,
    vertical_planning_control = vertical_planning_control,
    progression_table = progression_table,
    progression_table_control = progression_table_control
  )
}

#' @describeIn set_and_reps_schemes Plateau set and rep scheme
#' @export
#' @examples
#'
#' # Plateau set and rep schemes
#' # --------------------------
#' scheme_plateau()
#'
#' scheme <- scheme_plateau(
#'   reps = c(3, 3, 3),
#'   progression_table_control = list(type = "ballistic")
#' )
#' plot(scheme)
scheme_plateau <- function(reps = c(5, 5, 5),
                           vertical_planning = vertical_constant,
                           vertical_planning_control = list(),
                           progression_table = progression_perc_drop,
                           progression_table_control = list(volume = "normal")) {
  scheme_generic(
    reps = reps,
    # No adjustment with plateau
    adjustment = 0,
    vertical_planning = vertical_planning,
    vertical_planning_control = vertical_planning_control,
    progression_table = progression_table,
    progression_table_control = progression_table_control
  )
}


#' @describeIn set_and_reps_schemes Step set and rep scheme
#' @export
#' @examples
#'
#' # Step set and rep schemes
#' # --------------------------
#' scheme_step()
#'
#' scheme <- scheme_step(
#'   reps = c(2, 2, 2),
#'   adjustment = c(-0.1, -0.05, 0),
#'   vertical_planning = vertical_linear_reverse,
#'   progression_table_control = list(type = "ballistic")
#' )
#' plot(scheme)
scheme_step <- function(reps = c(5, 5, 5),
                        adjustment = -rev((seq_along(reps) - 1) * 10) / 100,
                        vertical_planning = vertical_constant,
                        vertical_planning_control = list(),
                        progression_table = progression_perc_drop,
                        progression_table_control = list(volume = "intensive")) {
  scheme_generic(
    reps = reps,
    adjustment = adjustment,
    vertical_planning = vertical_planning,
    vertical_planning_control = vertical_planning_control,
    progression_table = progression_table,
    progression_table_control = progression_table_control
  )
}

#' @describeIn set_and_reps_schemes Reverse Step set and rep scheme
#' @export
#' @examples
#'
#' # Reverse Step set and rep schemes
#' #- -------------------------
#' scheme <- scheme_step_reverse()
#' plot(scheme)
scheme_step_reverse <- function(reps = c(5, 5, 5),
                                adjustment = -((seq_along(reps) - 1) * 10) / 100,
                                vertical_planning = vertical_constant,
                                vertical_planning_control = list(),
                                progression_table = progression_perc_drop,
                                progression_table_control = list(volume = "intensive")) {
  scheme_generic(
    reps = reps,
    adjustment = adjustment,
    vertical_planning = vertical_planning,
    vertical_planning_control = vertical_planning_control,
    progression_table = progression_table,
    progression_table_control = progression_table_control
  )
}

#' @describeIn set_and_reps_schemes Descending Wave set and rep scheme
#' @export
#' @examples
#'
#' # Descending Wave set and rep schemes
#' # --------------------------
#' scheme <- scheme_wave_descending()
#' plot(scheme)
scheme_wave_descending <- function(reps = c(6, 8, 10),
                                   adjustment = -rev((seq_along(reps) - 1) * 5) / 100,
                                   vertical_planning = vertical_constant,
                                   vertical_planning_control = list(),
                                   progression_table = progression_perc_drop,
                                   progression_table_control = list(volume = "normal")) {
  scheme_generic(
    reps = reps,
    adjustment = adjustment,
    vertical_planning = vertical_planning,
    vertical_planning_control = vertical_planning_control,
    progression_table = progression_table,
    progression_table_control = progression_table_control
  )
}

#' @describeIn set_and_reps_schemes Light-Heavy set and rep scheme
#'     Please note that the \code{adjustment} column in the output
#'     will be wrong, hence set to \code{NA}
#' @export
#' @examples
#'
#' # Light-Heavy set and rep schemes
#' # --------------------------
#' scheme <- scheme_light_heavy()
#' plot(scheme)
scheme_light_heavy <- function(reps = c(10, 5, 10, 5),
                               adjustment = c(-0.1, 0)[(seq_along(reps) %% 2) + 1],
                               vertical_planning = vertical_constant,
                               vertical_planning_control = list(),
                               progression_table = progression_perc_drop,
                               progression_table_control = list(volume = "normal")) {
  df_max <- scheme_generic(
    reps = rep(max(reps), length(reps)),
    adjustment = adjustment,
    vertical_planning = vertical_planning,
    vertical_planning_control = vertical_planning_control,
    progression_table = progression_table,
    progression_table_control = progression_table_control
  )

  df_reps <- scheme_generic(
    reps = reps,
    adjustment = adjustment,
    vertical_planning = vertical_planning,
    vertical_planning_control = vertical_planning_control,
    progression_table = progression_table,
    progression_table_control = progression_table_control
  )

  df_max$reps <- df_reps$reps
  df_max$adjustment <- NA

  df_max
}


#' @describeIn set_and_reps_schemes Pyramid set and rep scheme
#' @export
#' @examples
#'
#' # Pyramid set and rep schemes
#' # --------------------------
#' scheme <- scheme_pyramid()
#' plot(scheme)
scheme_pyramid <- function(reps = c(12, 10, 8, 10, 12),
                           adjustment = 0,
                           vertical_planning = vertical_constant,
                           vertical_planning_control = list(),
                           progression_table = progression_perc_drop,
                           progression_table_control = list(volume = "extensive")) {
  scheme_generic(
    reps = reps,
    adjustment = adjustment,
    vertical_planning = vertical_planning,
    vertical_planning_control = vertical_planning_control,
    progression_table = progression_table,
    progression_table_control = progression_table_control
  )
}


#' @describeIn set_and_reps_schemes Reverse Pyramid set and rep scheme
#' @export
#' @examples
#'
#' # Reverse Pyramid set and rep schemes
#' # --------------------------
#' scheme <- scheme_pyramid_reverse()
#' plot(scheme)
scheme_pyramid_reverse <- function(reps = c(8, 10, 12, 10, 8),
                                   adjustment = 0,
                                   vertical_planning = vertical_constant,
                                   vertical_planning_control = list(),
                                   progression_table = progression_perc_drop,
                                   progression_table_control = list(volume = "extensive")) {
  scheme_generic(
    reps = reps,
    adjustment = adjustment,
    vertical_planning = vertical_planning,
    vertical_planning_control = vertical_planning_control,
    progression_table = progression_table,
    progression_table_control = progression_table_control
  )
}

#' @describeIn set_and_reps_schemes Rep Accumulation set and rep scheme
#' @export
#' @examples
#'
#' # Rep Accumulation set and rep schemes
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
#' scheme <- scheme_ladder()
#' scheme <- .vertical_rep_accumulation.post(scheme, remove_reps = FALSE)
#' plot(scheme)
scheme_rep_acc <- function(reps = c(10, 10, 10),
                           adjustment = 0,
                           vertical_planning_control = list(step = rep(0, 4)),
                           progression_table = progression_perc_drop,
                           progression_table_control = list(volume = "normal")) {
  scheme_df <- scheme_generic(
    reps = reps,
    adjustment = adjustment,
    vertical_planning = vertical_planning,
    vertical_planning_control = vertical_planning_control,
    progression_table = progression_table,
    progression_table_control = progression_table_control
  )

  scheme_df$reps <- scheme_df$reps - (max(scheme_df$index) - scheme_df$index)

  scheme_df
}

#' @describeIn set_and_reps_schemes Ladder set and rep scheme
#'     Please note that the \code{adjustment} column in the output
#'     will be wrong, hence set to \code{NA}
#' @export
#' @examples
#'
#' # Ladder set and rep schemes
#' # --------------------------
#' scheme <- scheme_ladder()
#' plot(scheme)
scheme_ladder <- function(reps = c(3, 5, 10),
                          adjustment = 0,
                          vertical_planning = vertical_constant,
                          vertical_planning_control = list(),
                          progression_table = progression_perc_drop,
                          progression_table_control = list(volume = "normal")) {
  df_max <- scheme_generic(
    reps = rep(max(reps), length(reps)),
    adjustment = adjustment,
    vertical_planning = vertical_planning,
    vertical_planning_control = vertical_planning_control,
    progression_table = progression_table,
    progression_table_control = progression_table_control
  )

  df_reps <- scheme_generic(
    reps = reps,
    adjustment = adjustment,
    vertical_planning = vertical_planning,
    vertical_planning_control = vertical_planning_control,
    progression_table = progression_table,
    progression_table_control = progression_table_control
  )

  df_max$reps <- df_reps$reps
  df_max$adjustment <- NA
  df_max
}
