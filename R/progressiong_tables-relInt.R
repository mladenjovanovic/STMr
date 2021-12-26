#' @describeIn generic_progression_table Relative Intensity generic table
#' @export
#' @examples
#' relInt_generic(10, step = seq(-3, 0, 1))
#' relInt_generic(5, step = seq(-3, 0, 1), type = "ballistic")
relInt_generic <- function(reps,
                                step = 0,
                                rep_start = 0,
                                rep_step = 0,
                                inc_start = 1,
                                inc_step = ((2 - 1) / 11),
                                adjustment = 0,
                                func_max_perc_1RM = get_max_perc_1RM_relInt,
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


#' @describeIn progression_table Relative Intensity progression table
#' @export
#' @examples
#' relInt(10, step = seq(-3, 0, 1))
#' relInt(10, step = seq(-3, 0, 1), volume = "extensive")
#' relInt(5, step = seq(-3, 0, 1), type = "ballistic")
#'
#' # Generate progression table
#' generate_progression_table(relInt)
#'
#' # Plot progression table
#' plot_progression_table(relInt)
#' plot_progression_table(relInt, "adjustment")
relInt <- function(reps,
                        step = 0,
                        volume = "normal",
                        type = "grinding",
                        adjustment = 0,
                        func_max_perc_1RM = get_max_perc_1RM_relInt,
                        ...) {


  params <- data.frame(
    volume = c("intensive", "normal", "extensive", "intensive", "normal", "extensive"),
    type = c("grinding", "grinding", "grinding", "ballistic", "ballistic", "ballistic"),
    rep_start = c(0, 0.075, 0.15, 0, 0.075, 0.15),
    rep_step = c(0, 0, 0, 0, 0, 0),
    inc_start = c(-0.05, -0.05, -0.05, -0.05, -0.05, -0.05),
    inc_step = c(0, 0, 0, 0, 0, 0)
  )

  params <- params[params$volume == volume, ]
  params <- params[params$type == type, ]

  relInt_generic(
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
