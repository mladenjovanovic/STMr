# ===================================================
# Reps In Reserve
# ===================================================

check_RIR_adjustment <- function(model = "epley", ...) {
  params <- expand.grid(
    reps = seq(1, 50, length.out = 20),
    adjustment = seq(0, 10, length.out = 20),
    mfactor = seq(1, 3, length.out = 20)
  )

  perc_1RM <- get_perc_1RM(params$reps, "RIR", model, adjustment = params$adjustment, mfactor = params$mfactor, ...)

  # Expect that these are reversible
  expect_equal(
    get_reps(perc_1RM, "RIR", model, adjustment = params$adjustment, mfactor = params$mfactor, ...),
    params$reps
  )
}

# ----------------------------------------------------
test_that("RIR rep adjustment works for Epley model", {
  check_RIR_adjustment("epley")
  for (k in seq(0.01, 0.08, length.out = 50)) {
    check_RIR_adjustment("epley", k)
  }
})

test_that("RIR rep adjustment works for Modified Epley model", {
  check_RIR_adjustment("modified epley")
  for (kmod in seq(0.01, 0.08, length.out = 50)) {
    check_RIR_adjustment("modified epley", kmod)
  }
})

test_that("RIR rep adjustment works for Linear model", {
  check_RIR_adjustment("linear")
  for (klin in seq(20, 40, length.out = 50)) {
    check_RIR_adjustment("linear", klin)
  }
})

# ===================================================
# Deducted Intensity
# ===================================================

check_DI_adjustment <- function(model = "epley", ...) {
  params <- expand.grid(
    reps = seq(1, 50, length.out = 20),
    adjustment = seq(0, 0.5, length.out = 20),
    mfactor = seq(1, 3, length.out = 20)
  )

  perc_1RM <- get_perc_1RM(params$reps, "DI", model, adjustment = params$adjustment, mfactor = params$mfactor, ...)

  # Expect that these are reversible
  expect_equal(
    get_reps(perc_1RM, "DI", model, adjustment = params$adjustment, mfactor = params$mfactor, ...),
    params$reps
  )
}

# ----------------------------------------------------
test_that("DI rep adjustment works for Epley model", {
  check_DI_adjustment("epley")
  for (k in seq(0.01, 0.08, length.out = 50)) {
    check_DI_adjustment("epley", k)
  }
})

test_that("DI rep adjustment works for Modified Epley model", {
  check_DI_adjustment("modified epley")
  for (kmod in seq(0.01, 0.08, length.out = 50)) {
    check_DI_adjustment("modified epley", kmod)
  }
})

test_that("DI rep adjustment works for Linear model", {
  check_DI_adjustment("linear")
  for (klin in seq(20, 40, length.out = 50)) {
    check_DI_adjustment("linear", klin)
  }
})

# ===================================================
# Relative Intensity
# ===================================================

check_RI_adjustment <- function(model = "epley", ...) {
  params <- expand.grid(
    reps = seq(1, 50, length.out = 20),
    adjustment = seq(1, 0.5, length.out = 20),
    mfactor = seq(1, 3, length.out = 20)
  )

  perc_1RM <- get_perc_1RM(params$reps, "RelInt", model, adjustment = params$adjustment, mfactor = params$mfactor, ...)

  # Expect that these are reversible
  expect_equal(
    get_reps(perc_1RM, "RelInt", model, adjustment = params$adjustment, mfactor = params$mfactor, ...),
    params$reps
  )
}

# ----------------------------------------------------
test_that("RI rep adjustment works for Epley model", {
  check_RI_adjustment("epley")
  for (k in seq(0.01, 0.08, length.out = 50)) {
    check_RI_adjustment("epley", k)
  }
})

test_that("RI rep adjustment works for Modified Epley model", {
  check_RI_adjustment("modified epley")
  for (kmod in seq(0.01, 0.08, length.out = 50)) {
    check_RI_adjustment("modified epley", kmod)
  }
})

test_that("RI rep adjustment works for Linear model", {
  check_RI_adjustment("linear")
  for (klin in seq(20, 40, length.out = 50)) {
    check_RI_adjustment("linear", klin)
  }
})

# ===================================================
# % Max Reps
# ===================================================

check_perc_MR_adjustment <- function(model = "epley", ...) {
  params <- expand.grid(
    reps = seq(1, 50, length.out = 20),
    adjustment = seq(1, 0.5, length.out = 20),
    mfactor = seq(1, 3, length.out = 20)
  )

  perc_1RM <- get_perc_1RM(params$reps, "%MR", model, adjustment = params$adjustment, mfactor = params$mfactor, ...)

  # Expect that these are reversible
  expect_equal(
    get_reps(perc_1RM, "%MR", model, adjustment = params$adjustment, mfactor = params$mfactor, ...),
    params$reps
  )
}

# ----------------------------------------------------
test_that("%MR rep adjustment works for Epley model", {
  check_perc_MR_adjustment("epley")
  for (k in seq(0.01, 0.08, length.out = 50)) {
    check_perc_MR_adjustment("epley", k)
  }
})

test_that("%MR rep adjustment works for Modified Epley model", {
  check_perc_MR_adjustment("modified epley")
  for (kmod in seq(0.01, 0.08, length.out = 50)) {
    check_perc_MR_adjustment("modified epley", kmod)
  }
})

test_that("%MR rep adjustment works for Linear model", {
  check_perc_MR_adjustment("linear")
  for (klin in seq(20, 40, length.out = 50)) {
    check_perc_MR_adjustment("linear", klin)
  }
})
