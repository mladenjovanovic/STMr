#' @describeIn generic_progression_table %MR Step generic table
#' @export
#' @examples
#' percMR_step_generic(10, step = seq(-3, 0, 1))
#' percMR_step_generic(5, step = seq(-3, 0, 1), type = "ballistic")
percMR_step_generic <- function(reps,
                                step = 0,
                                rep_start = 0,
                                rep_step = 0,
                                inc_start = 1,
                                inc_step = ((2 - 1) / 11),
                                adjustment = 0,
                                func_max_perc_1RM = get_max_perc_1RM_percMR,
                                ...) {
  rep_percMR <- rep_start + (reps - 1) * rep_step
  step_percMR <- step * (inc_start + (reps - 1) * inc_step)

  adjustment <- 1 - (rep_percMR + step_percMR + adjustment)
  perc_1RM <- func_max_perc_1RM(
    max_reps = reps,
    adjustment = adjustment,
    ...
  )

  return(list(
    adjustment = adjustment,
    perc_1RM = perc_1RM
  ))
}


#' @describeIn progression_table %MR Step Variable progression table
#' @export
#' @examples
#' percMR_step_var(10, step = seq(-3, 0, 1))
#' percMR_step_var(10, step = seq(-3, 0, 1), volume = "extensive")
#' percMR_step_var(5, step = seq(-3, 0, 1), type = "ballistic")
#'
#' # Generate progression table
#' generate_progression_table(percMR_step_var)
#'
#' # Plot progression table
#' plot_progression_table(percMR_step_var)
#' plot_progression_table(percMR_step_var, "adjustment")
percMR_step_var <- function(reps,
                            step = 0,
                            volume = "normal",
                            type = "grinding",
                            adjustment = 0,
                            func_max_perc_1RM = get_max_perc_1RM_percMR,
                            ...) {
  params <- data.frame(
    volume = c("intensive", "normal", "extensive", "intensive", "normal", "extensive"),
    type = c("grinding", "grinding", "grinding", "ballistic", "ballistic", "ballistic"),
    rep_start = c(0, 0.3, 0.5, 0, 0.3, 0.5),
    rep_step = c(0, -(0.1 / 11), -(0.1 / 11), 0, -(0.1 / 11), -(0.1 / 11)),
    inc_start = c(-0.4 / 3, -0.3 / 3, -0.3 / 3, -0.4 / 3, -0.3 / 3, -0.3 / 3),
    inc_step = c((0.7 - 0.6) / (11 * 3), (0.5 - 0.5) / (11 * 3), (0.3 - 0.3) / (11 * 3), (0.7 - 0.6) / (11 * 3), (0.5 - 0.5) / (11 * 3), (0.3 - 0.3) / (11 * 3))
  )

  params <- params[params$volume == volume, ]
  params <- params[params$type == type, ]

  percMR_step_generic(
    reps = reps,
    step = step,
    rep_start = params$rep_start[1],
    rep_step = params$rep_step[1],
    inc_start = params$inc_start[1],
    inc_step = params$inc_step[1],
    adjustment = adjustment,
    func_max_perc_1RM = func_max_perc_1RM,
    type = type,
    ...
  )
}

#' @describeIn progression_table %MR Step Constant progression table
#' @export
#' @examples
#' percMR_step_const(10, step = seq(-3, 0, 1))
#' percMR_step_const(10, step = seq(-3, 0, 1), volume = "extensive")
#' percMR_step_const(5, step = seq(-3, 0, 1), type = "ballistic")
#'
#' # Generate progression table
#' generate_progression_table(percMR_step_const)
#'
#' # Plot progression table
#' plot_progression_table(percMR_step_const)
#' plot_progression_table(percMR_step_const, "adjustment")
percMR_step_const <- function(reps,
                              step = 0,
                              volume = "normal",
                              type = "grinding",
                              adjustment = 0,
                              func_max_perc_1RM = get_max_perc_1RM_percMR,
                              ...) {
  params <- data.frame(
    volume = c("intensive", "normal", "extensive", "intensive", "normal", "extensive"),
    type = c("grinding", "grinding", "grinding", "ballistic", "ballistic", "ballistic"),
    rep_start = c(0, 0.2, 0.4, 0, 0.2, 0.4),
    rep_step = c(0, 0, 0, 0, 0, 0),
    inc_start = c(-0.1, -0.1, -0.1, -0.1, -0.1, -0.1),
    inc_step = c(0, 0, 0, 0, 0, 0)
  )

  params <- params[params$volume == volume, ]
  params <- params[params$type == type, ]

  percMR_step_generic(
    reps = reps,
    step = step,
    rep_start = params$rep_start[1],
    rep_step = params$rep_step[1],
    inc_start = params$inc_start[1],
    inc_step = params$inc_step[1],
    adjustment = adjustment,
    func_max_perc_1RM = func_max_perc_1RM,
    type = type,
    ...
  )
}
