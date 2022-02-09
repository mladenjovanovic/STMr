check_method <- function(method) {
  if (any(!(method %in% c("RIR", "DI", "RelInt", "%MR")))) {
    stop("Please provide valid method. Options are 'RIR', 'DI', 'RelInt', and '%MR'", call. = FALSE)
  }
}

check_model <- function(model) {
  if (any(!(model %in% c("epley", "modified epley", "linear")))) {
    stop("Please provide valid model. Options are 'epley', 'modified epley', and 'linear'", call. = FALSE)
  }
}

check_volume <- function(volume) {
  if (any(!(volume %in% c("intensive", "normal", "extensive")))) {
    stop("Please provide valid volume. Options are 'intensive', 'normal', and 'extensive'", call. = FALSE)
  }
}

check_type <- function(type) {
  if (any(!(type %in% c("grinding", "ballistic")))) {
    stop("Please provide valid type. Options are 'grinding' and 'ballistic'", call. = FALSE)
  }
}

get_mfactor <- function(type) {
  check_type(type)

  ifelse(
    type == "grinding",
    1,
    ifelse(
      type == "ballistic",
      2,
      NA
    )
  )
}
