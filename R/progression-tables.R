#' Generic progression table
#'
#' Generic progression tables allow for custom progressions using
#'    \code{rep_start}, \code{rep_step}, \code{inc_start}, and
#'    \code{inc_step} parameters. For more information check the
#'    'Strength Training Manual' Chapter 6.
#'
#' @param reps Number of reps
#' @param step Progression step. Default is 0. Use negative numbers (i.e., -1, -2)
#' @param rep_start Used to define intensive, normal, and extensive progression.
#'      \code{rep_start} defines the adjustment for the first rep
#' @param rep_step Used to define intensive, normal, and extensive progression.
#'      \code{rep_step} defines the adjustment as rep number increases
#' @param inc_start Defines the progression for \code{step} for single rep
#' @param inc_step Defines the progression for \code{step} for rep increase
#'     For example, lower reps can have bigger jumps than high reps.
#' @param adjustment Additional adjustment. Default is 0.
#' @param func_max_perc_1RM What max rep table should be used?
#'     Default is \code{\link{get_max_perc_1RM}}
#' @param ... Forwarded to \code{func_max_perc_1RM}. Used to differentiate between
#'     'grinding' and 'ballistic' max reps schemes.
#'
#' @return List with two elements: \code{adjustment} and \code{perc_1RM}
#' @name generic_progression_table
NULL


#' @describeIn generic_progression_table RIR Increment generic table
#' @export
#' @examples
#' RIR_increment_generic(10, step = seq(-3, 0, 1))
#' RIR_increment_generic(5, step = seq(-3, 0, 1), type = "ballistic")
RIR_increment_generic <- function(reps,
                                  step = 0,
                                  rep_start = 2,
                                  rep_step = ((6 - 2) / 11),
                                  inc_start = 1,
                                  inc_step = ((2 - 1) / 11),
                                  adjustment = 0,
                                  func_max_perc_1RM = get_max_perc_1RM,
                                  ...) {
  rep_RIR <- rep_start + (reps - 1) * rep_step
  step_RIR <- -1 * step * (inc_start + (reps - 1) * inc_step)

  adjustment <- rep_RIR + step_RIR + adjustment
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

#' @describeIn generic_progression_table Percent Drop generic table
#' @export
#' @examples
#' perc_drop_generic(10, step = seq(-3, 0, 1))
#' perc_drop_generic(5, step = seq(-3, 0, 1), type = "ballistic")
perc_drop_generic <- function(reps,
                              step = 0,
                              rep_start = -0.05,
                              rep_step = ((-0.1 - -0.05) / 11),
                              inc_start = -0.025,
                              inc_step = ((-0.05 - -0.025) / 11),
                              adjustment = 0,
                              func_max_perc_1RM = get_max_perc_1RM,
                              ...) {
  rep_perc_drop <- rep_start + (reps - 1) * rep_step
  step_perc_drop <- -1 * step * (inc_start + (reps - 1) * inc_step)

  perc_1RM <- func_max_perc_1RM(
    max_reps = reps,
    adjustment = 0,
    ...
  )

  adjustment <- rep_perc_drop + step_perc_drop + adjustment

  return(list(
    adjustment = adjustment,
    perc_1RM = perc_1RM + adjustment
  ))
}


#' Progression table
#'
#' Progression table explained in the 'Strength Training Manual' Chapter 6.
#'
#' @param reps Number of reps
#' @param step Progression step. Default is 0. Use negative numbers (i.e., -1, -2)
#' @param volume Character string: 'intensive', 'normal' (Default), or 'extensive'
#' @param type Type of max rep table. Options are grinding (Default) and ballistic.
#' @param adjustment Additional adjustment. Default is 0.
#' @param func_max_perc_1RM What max rep table should be used?
#'     Default is \code{\link{get_max_perc_1RM}}
#' @return List with two elements: \code{adjustment} and \code{perc_1RM}
#' @name progression_table
NULL


#' @describeIn progression_table RIR Increment progression table. This is the original
#'     progression table from the Strength Training Manual
#' @export
#' @examples
#' RIR_increment(10, step = seq(-3, 0, 1))
#' RIR_increment(10, step = seq(-3, 0, 1), volume = "extensive")
#' RIR_increment(5, step = seq(-3, 0, 1), type = "ballistic")
#'
#' # Generate progression table
#' generate_progression_table(RIR_increment)
#'
#' # Plot progression table
#' plot_progression_table(RIR_increment)
#' plot_progression_table(RIR_increment, "adjustment")
RIR_increment <- function(reps,
                          step = 0,
                          volume = "normal",
                          type = "grinding",
                          adjustment = 0,
                          func_max_perc_1RM = get_max_perc_1RM) {
  params <- data.frame(
    volume = c("intensive", "normal", "extensive", "intensive", "normal", "extensive"),
    type = c("grinding", "grinding", "grinding", "ballistic", "ballistic", "ballistic"),
    rep_start = c(0, 1, 2, 0, 1, 2),
    rep_step = c(0, ((3 - 1) / 11), ((6 - 2) / 11), 0, 0.2, 0.4),
    inc_start = c(1, 1, 1, 1, 1, 1),
    inc_step = c(((2 - 1) / 11), ((2 - 1) / 11), ((2 - 1) / 11), 0.2, 0.2, 0.2)
  )

  params <- params[params$volume == volume, ]
  params <- params[params$type == type, ]

  RIR_increment_generic(
    reps = reps,
    step = step,
    rep_start = params$rep_start[1],
    rep_step = params$rep_step[1],
    inc_start = params$inc_start[1],
    inc_step = params$inc_step[1],
    adjustment = adjustment,
    func_max_perc_1RM = func_max_perc_1RM,
    type = type
  )
}

#' @describeIn progression_table Fixed 2 RIR Increment progression table. This variant have fixed RIR
#'     increment across reps from phases to phases (2RIR) and 2RIR difference between extensive, normal, and
#'     intensive schemes
#' @export
#' @examples
#' RIR_increment_fixed_2(10, step = seq(-3, 0, 1))
#' RIR_increment_fixed_2(10, step = seq(-3, 0, 1), volume = "extensive")
#' RIR_increment_fixed_2(5, step = seq(-3, 0, 1), type = "ballistic")
#'
#' # Generate progression table
#' generate_progression_table(RIR_increment_fixed_2)
#'
#' # Plot progression table
#' plot_progression_table(RIR_increment_fixed_2)
#' plot_progression_table(RIR_increment_fixed_2, "adjustment")
RIR_increment_fixed_2 <- function(reps,
                          step = 0,
                          volume = "normal",
                          type = "grinding",
                          adjustment = 0,
                          func_max_perc_1RM = get_max_perc_1RM) {
  params <- data.frame(
    volume = c("intensive", "normal", "extensive", "intensive", "normal", "extensive"),
    type = c("grinding", "grinding", "grinding", "ballistic", "ballistic", "ballistic"),
    rep_start = c(0, 2, 4, 0, 2, 4),
    rep_step = c(0, 0, 0, 0, 0, 0),
    inc_start = c(2, 2, 2, 2, 2, 2),
    inc_step = c(0, 0, 0, 0, 0, 0)
  )

  params <- params[params$volume == volume, ]
  params <- params[params$type == type, ]

  RIR_increment_generic(
    reps = reps,
    step = step,
    rep_start = params$rep_start[1],
    rep_step = params$rep_step[1],
    inc_start = params$inc_start[1],
    inc_step = params$inc_step[1],
    adjustment = adjustment,
    func_max_perc_1RM = func_max_perc_1RM,
    type = type
  )
}

#' @describeIn progression_table Fixed 4 RIR Increment progression table. This variant have fixed RIR
#'     increment across reps from phases to phases (4RIR) and 4RIR difference between extensive, normal, and
#'     intensive schemes
#' @export
#' @examples
#' RIR_increment_fixed_4(10, step = seq(-3, 0, 1))
#' RIR_increment_fixed_4(10, step = seq(-3, 0, 1), volume = "extensive")
#' RIR_increment_fixed_4(5, step = seq(-3, 0, 1), type = "ballistic")
#'
#' # Generate progression table
#' generate_progression_table(RIR_increment_fixed_4)
#'
#' # Plot progression table
#' plot_progression_table(RIR_increment_fixed_4)
#' plot_progression_table(RIR_increment_fixed_4, "adjustment")
RIR_increment_fixed_4 <- function(reps,
                                  step = 0,
                                  volume = "normal",
                                  type = "grinding",
                                  adjustment = 0,
                                  func_max_perc_1RM = get_max_perc_1RM) {
  params <- data.frame(
    volume = c("intensive", "normal", "extensive", "intensive", "normal", "extensive"),
    type = c("grinding", "grinding", "grinding", "ballistic", "ballistic", "ballistic"),
    rep_start = c(0, 4, 8, 0, 4, 8),
    rep_step = c(0, 0, 0, 0, 0, 0),
    inc_start = c(4, 4, 4, 4, 4, 4),
    inc_step = c(0, 0, 0, 0, 0, 0)
  )

  params <- params[params$volume == volume, ]
  params <- params[params$type == type, ]

  RIR_increment_generic(
    reps = reps,
    step = step,
    rep_start = params$rep_start[1],
    rep_step = params$rep_step[1],
    inc_start = params$inc_start[1],
    inc_step = params$inc_step[1],
    adjustment = adjustment,
    func_max_perc_1RM = func_max_perc_1RM,
    type = type
  )
}

#' @describeIn progression_table Percent Drop progression table. This is the original
#'     progression table from the Strength Training Manual
#' @export
#' @examples
#' perc_drop(10, step = seq(-3, 0, 1))
#' perc_drop(10, step = seq(-3, 0, 1), volume = "extensive")
#' perc_drop(5, step = seq(-3, 0, 1), type = "ballistic")
#'
#' # Generate progression table
#' generate_progression_table(perc_drop)
#'
#' # Plot progression table
#' plot_progression_table(perc_drop)
#' plot_progression_table(perc_drop, "adjustment")
perc_drop <- function(reps,
                      step = 0,
                      volume = "normal",
                      type = "grinding",
                      adjustment = 0,
                      func_max_perc_1RM = get_max_perc_1RM) {
  params <- data.frame(
    volume = c("intensive", "normal", "extensive", "intensive", "normal", "extensive"),
    type = c("grinding", "grinding", "grinding", "ballistic", "ballistic", "ballistic"),
    rep_start = c(0, -0.025, -0.05, 0, -0.025, -0.05),
    rep_step = c(0, ((-0.05 - -0.025) / 11), ((-0.1 - -0.05) / 11), 0, -0.0025, -0.005),
    inc_start = c(-0.025, -0.025, -0.025, -0.025, -0.025, -0.025),
    inc_step = c(((-0.05 - -0.025) / 11), ((-0.05 - -0.025) / 11), ((-0.05 - -0.025) / 11), -0.005, -0.005, -0.005)
  )

  params <- params[params$volume == volume, ]
  params <- params[params$type == type, ]

  perc_drop_generic(
    reps = reps,
    step = step,
    rep_start = params$rep_start[1],
    rep_step = params$rep_step[1],
    inc_start = params$inc_start[1],
    inc_step = params$inc_step[1],
    adjustment = adjustment,
    func_max_perc_1RM = func_max_perc_1RM,
    type = type
  )
}

#' @describeIn progression_table 5% Fixed Percent Drop progression table. This variant have fixed percent
#'     drops across reps from phases to phases (5%) and 5% difference between extensive, normal, and
#'     intensive schemes
#' @export
#' @examples
#' perc_drop_fixed_5(10, step = seq(-3, 0, 1))
#' perc_drop_fixed_5(10, step = seq(-3, 0, 1), volume = "extensive")
#' perc_drop_fixed_5(5, step = seq(-3, 0, 1), type = "ballistic")
#'
#' # Generate progression table
#' generate_progression_table(perc_drop_fixed_5)
#'
#' # Plot progression table
#' plot_progression_table(perc_drop_fixed_5)
#' plot_progression_table(perc_drop_fixed_5, "adjustment")
perc_drop_fixed_5 <- function(reps,
                      step = 0,
                      volume = "normal",
                      type = "grinding",
                      adjustment = 0,
                      func_max_perc_1RM = get_max_perc_1RM) {
  params <- data.frame(
    volume = c("intensive", "normal", "extensive", "intensive", "normal", "extensive"),
    type = c("grinding", "grinding", "grinding", "ballistic", "ballistic", "ballistic"),
    rep_start = c(0, -0.05, -0.01, 0, -0.05, -0.1),
    rep_step = c(0, 0, 0, 0, 0, 0),
    inc_start = c(-0.05, -0.05, -0.05, -0.05, -0.05, -0.05),
    inc_step = c(0, 0, 0, 0, 0, 0)
  )

  params <- params[params$volume == volume, ]
  params <- params[params$type == type, ]

  perc_drop_generic(
    reps = reps,
    step = step,
    rep_start = params$rep_start[1],
    rep_step = params$rep_step[1],
    inc_start = params$inc_start[1],
    inc_step = params$inc_step[1],
    adjustment = adjustment,
    func_max_perc_1RM = func_max_perc_1RM,
    type = type
  )
}

#' @describeIn progression_table 2.5% Fixed Percent Drop progression table. This variant have fixed percent
#'     drops across reps from phases to phases (2.5%) and 2.5% difference between extensive, normal, and
#'     intensive schemes
#' @export
#' @examples
#' perc_drop_fixed_25(10, step = seq(-3, 0, 1))
#' perc_drop_fixed_25(10, step = seq(-3, 0, 1), volume = "extensive")
#' perc_drop_fixed_25(5, step = seq(-3, 0, 1), type = "ballistic")
#'
#' # Generate progression table
#' generate_progression_table(perc_drop_fixed_25)
#'
#' # Plot progression table
#' plot_progression_table(perc_drop_fixed_25)
#' plot_progression_table(perc_drop_fixed_25, "adjustment")
perc_drop_fixed_25 <- function(reps,
                              step = 0,
                              volume = "normal",
                              type = "grinding",
                              adjustment = 0,
                              func_max_perc_1RM = get_max_perc_1RM) {
  params <- data.frame(
    volume = c("intensive", "normal", "extensive", "intensive", "normal", "extensive"),
    type = c("grinding", "grinding", "grinding", "ballistic", "ballistic", "ballistic"),
    rep_start = c(0, -0.025, -0.05, 0, -0.025, -0.05),
    rep_step = c(0, 0, 0, 0, 0, 0),
    inc_start = c(-0.025, -0.025, -0.025, -0.025, -0.025, -0.025),
    inc_step = c(0, 0, 0, 0, 0, 0)
  )

  params <- params[params$volume == volume, ]
  params <- params[params$type == type, ]

  perc_drop_generic(
    reps = reps,
    step = step,
    rep_start = params$rep_start[1],
    rep_step = params$rep_step[1],
    inc_start = params$inc_start[1],
    inc_step = params$inc_step[1],
    adjustment = adjustment,
    func_max_perc_1RM = func_max_perc_1RM,
    type = type
  )
}


#' @describeIn progression_table Generates progression tables
#' @param progression_table Progression table function to use. Default is
#'     \code{\link{RIR_increment}}
#' @param ... Forwarded to \code{progression_table} for using different rep max function
#' @export
#' @examples
#' generate_progression_table()
#'
#' generate_progression_table(type = "grinding", volume = "normal")
#'
#' generate_progression_table(
#'   reps = 1:5,
#'   step = seq(-5, 0, 1),
#'   type = "grinding",
#'   volume = "normal"
#' )
generate_progression_table <- function(progression_table = RIR_increment,
                                       type = c("grinding", "ballistic"),
                                       volume = c("intensive", "normal", "extensive"),
                                       reps = 1:12,
                                       step = seq(-3, 0, 1),
                                       ...) {
  params <- expand.grid(
    type = type,
    volume = volume,
    reps = reps,
    step = step,
    stringsAsFactors = FALSE
  )

  val_adj <- numeric(nrow(params))
  val_perc <- numeric(nrow(params))

  for (i in seq_len(nrow(params))) {
    val <- progression_table(
      reps = params$reps[i],
      step = params$step[i],
      volume = params$volume[i],
      type = params$type[i],
      ...
    )
    val_adj[i] <- val$adjustment
    val_perc[i] <- val$perc_1RM
  }

    data.frame(
      params,
      adjustment = val_adj,
      perc_1RM = val_perc)
}
