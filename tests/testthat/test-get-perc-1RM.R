# ===================================================
# Reps In Reserve
# ===================================================

check_RIR_adjustment <- function(model = "epley", ...) {
  reps <- seq(1, 50, length.out = 100)

  # Ballistic version of the max-reps table should be equal to double reps grinding
  expect_equal(
    get_perc_1RM(reps * 2, "RIR", model, adjustment = 0, mfactor = 1, ...),
    get_perc_1RM(reps, "RIR", model, adjustment = 0, mfactor = 2, ...)
  )

  expect_equal(
    get_perc_1RM(reps, "RIR", model, adjustment = 0, mfactor = 1, ...),
    get_perc_1RM(reps / 2, "RIR", model, adjustment = 0, mfactor = 2, ...)
  )

  # Ballistic version of the max-reps table should be equal to double reps grinding
  # In this case that is achieved by using RIR of same number as number of reps
  expect_equal(
    get_perc_1RM(reps, "RIR", model, adjustment = reps, mfactor = 1, ...),
    get_perc_1RM(reps, "RIR", model, adjustment = 0, mfactor = 2, ...)
  )

  # When using RIR, double reps should be equal to using RIR of number of reps
  # For example, 10RM (10 reps at 0RIR) is equal to 5 reps with 5RIR
  # Grinding
  expect_equal(
    get_perc_1RM(reps, "RIR", model, adjustment = reps, mfactor = 1, ...),
    get_perc_1RM(reps * 2, "RIR", model, adjustment = 0, mfactor = 1, ...)
  )

  # Ballistic
  expect_equal(
    get_perc_1RM(reps, "RIR", model, adjustment = reps, mfactor = 2, ...),
    get_perc_1RM(reps * 2, "RIR", model, adjustment = 0, mfactor = 2, ...)
  )
}

# ----------------------------------------------------

test_that("RIR adjustment works for Epley model", {
  check_RIR_adjustment("epley")
  for (k in seq(0.01, 0.08, length.out = 50)) {
    check_RIR_adjustment("epley", k)
  }
})

test_that("RIR adjustment works for Modified Epley model", {
  check_RIR_adjustment("modified epley")
  for (kmod in seq(0.01, 0.08, length.out = 50)) {
    check_RIR_adjustment("modified epley", kmod)
  }
})

test_that("RIR adjustment works for Linear model", {
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
    adjustment = seq(0, -0.5, length.out = 20),
    mfactor = seq(1, 3, length.out = 20)
  )

  # DI is simply deducting intensity
  expect_equal(
    get_perc_1RM(params$reps, "DI", model, params$adjustment, mfactor = params$mfactor, ...),
    get_perc_1RM(params$reps, "DI", model, adjustment = 0, mfactor = params$mfactor, ...) + params$adjustment
  )
}

# ----------------------------------------------------

test_that("DI adjustment works for Epley model", {
  check_DI_adjustment("epley")
  for (k in seq(0.01, 0.08, length.out = 50)) {
    check_DI_adjustment("epley", k)
  }
})

test_that("DI adjustment works for Modified Epley model", {
  check_DI_adjustment("modified epley")
  for (kmod in seq(0.01, 0.08, length.out = 50)) {
    check_DI_adjustment("modified epley", kmod)
  }
})

test_that("DI adjustment works for Linear model", {
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

  # RI is simply relative intensity
  expect_equal(
    get_perc_1RM(params$reps, "RelInt", model, params$adjustment, mfactor = params$mfactor, ...),
    get_perc_1RM(params$reps, "RelInt", model, adjustment = 1, mfactor = params$mfactor, ...) * params$adjustment
  )
}

# ----------------------------------------------------

test_that("RI adjustment works for Epley model", {
  check_RI_adjustment("epley")
  for (k in seq(0.01, 0.08, length.out = 50)) {
    check_RI_adjustment("epley", k)
  }
})

test_that("RI adjustment works for Modified Epley model", {
  check_RI_adjustment("modified epley")
  for (kmod in seq(0.01, 0.08, length.out = 50)) {
    check_RI_adjustment("modified epley", kmod)
  }
})

test_that("RI adjustment works for Linear model", {
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
    adjustment = seq(1, 0.2, length.out = 20),
    mfactor = seq(1, 3, length.out = 20)
  )

  # Should be the same as adjusting the reps
  expect_equal(
    get_perc_1RM(params$reps, "%MR", model, params$adjustment, mfactor = params$mfactor, ...),
    get_perc_1RM(params$reps / params$adjustment, "%MR", model, adjustment = 1, mfactor = params$mfactor, ...)
  )
}


# ----------------------------------------------------

test_that("%MR adjustment works for Epley model", {
  check_perc_MR_adjustment("epley")
  for (k in seq(0.01, 0.08, length.out = 50)) {
    check_perc_MR_adjustment("epley", k)
  }
})

test_that("%MR adjustment works for Modified Epley model", {
  check_perc_MR_adjustment("modified epley")
  for (kmod in seq(0.01, 0.08, length.out = 50)) {
    check_perc_MR_adjustment("modified epley", kmod)
  }
})

test_that("%MR adjustment works for Linear model", {
  check_perc_MR_adjustment("linear")
  for (klin in seq(20, 40, length.out = 50)) {
    check_perc_MR_adjustment("linear", klin)
  }
})
