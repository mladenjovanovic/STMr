# Color set
color_black <- "#000000"
color_blue <- "#5DA5DA"
color_red <- "#F15854"
color_grey <- "#4D4D4D"
color_green <- "#60BD68"
color_orange <- "#FAA43A"
color_pink <- "#F17CB0"
color_purple <- "#B276B2"
color_yellow <- "#DECF3F"

# Rounding
mround <- function(x, accuracy, f = round) {
  f(x / accuracy) * accuracy
}

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
  if (any(!(type %in% c("grinding", "ballistic", "conservative")))) {
    stop("Please provide valid type. Options are 'grinding', 'ballistic' and 'conservative'", call. = FALSE)
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
      ifelse(
        type == "conservative",
        3,
        NA
      )
    )
  )
}

check_weighting <- function(weighted) {
  if (any(!(weighted %in% c("none", "reps", "load", "eRIR", "reps x load", "reps x eRIR", "load x eRIR", "reps x load x eRIR")))) {
    stop("Please provide valid weighting type. Options are 'none', 'reps', 'load', 'eRIR', 'reps x load', 'reps x eRIR', 'load x eRIR', and 'reps x load x eRIR'", call. = FALSE)
  }
}

get_weighting <- function(weighted, reps, load, eRIR, normalize = FALSE) {
  # +++++++++++++++++++++++++++++++++++++++++++
  # Code chunk for dealing with R CMD check note
  weight <- NULL
  # +++++++++++++++++++++++++++++++++++++++++++

  df <- data.frame(
    weighted = weighted,
    # Since we are weighting smaller reps more heavily, we can use 1/reps
    reps = 1 / reps,
    load = load,
    normalize = normalize,
    # eRIR needs to be incremented by 1, since there can be 0 ratings
    # and that can cause problems for weighting in the non-linear regression
    # For example, when all sets are taken to failure, eRIR is equal 0
    # Since we want to weight sets close to failure heavier, we are going
    # to use 1/(eRIR + 1)
    eRIR = 1 / (eRIR + 1)
  ) %>%
    dplyr::mutate(
      weight = dplyr::case_when(
        weighted == "none" ~ 1,
        weighted == "reps" ~ reps,
        weighted == "load" ~ load,
        weighted == "eRIR" ~ eRIR,
        weighted == "reps x load" ~ reps * load,
        weighted == "reps x eRIR" ~ reps * eRIR,
        weighted == "load x eRIR" ~ load * eRIR,
        weighted == "reps x load x eRIR" ~ reps * load * eRIR
      ),
      weight = ifelse(normalize == TRUE, weight / min(weight), weight)
    )

  df$weight
}

# Function to normalize/standardize
range01 <- function(x, .min = min(x), .max = max(x)) {
  res <- (x - .min) / (.max - .min)

  res <- ifelse(is.na(res), 1, res)

  res
}

# Function to mark and group sequences of TRUE values
mark_sequences <- function(x) {
  group <- x
  group_index <- 1

  group[1] <- 1

  if (length(x) < 2) {
    return(group)
  }

  for (i in seq(2, length(x))) {
    if ((x[i] & x[i - 1]) == FALSE) {
      group_index <- group_index + 1
    }
    group[i] <- group_index
  }

  group
}

# Function to mark and index steps
mark_index <- function(x) {
  group <- x
  group_index <- 1

  group[1] <- 1

  if (length(x) < 2) {
    return(group)
  }

  for (i in seq(2, length(x))) {
    if ((x[i] != x[i - 1])) {
      group_index <- group_index + 1
    }
    group[i] <- group_index
  }

  group
}
