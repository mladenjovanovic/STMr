check_get_max_perc1RM_relInt_functions <- function(max_perc1RM_func, ...) {
  reps <- seq(1, 50, length.out = 100)

  test_data <- expand.grid(
    reps = seq(1, 50, length.out = 20),
    adjustment = seq(1, 0.1, length.out = 20)
  )

  # Ballistic version of the max-reps table should be equal to double reps grinding
  expect_equal(
    max_perc1RM_func(reps * 2, adjustment = 1, type = "grinding", ...),
    max_perc1RM_func(reps, adjustment = 1, type = "ballistic", ...)
  )

  expect_equal(
    max_perc1RM_func(reps, adjustment = 1, type = "grinding", ...),
    max_perc1RM_func(reps / 2, adjustment = 1, type = "ballistic", ...)
  )

  # Estimated %1RM with adjustment provided, should be the same as
  # estimated %1RM without adjustment, but mutliplied by adjustment
  expect_equal(
    max_perc1RM_func(test_data$reps, adjustment = test_data$adjustment, type = "grinding", ...),
    max_perc1RM_func(test_data$reps, adjustment = 1, type = "grinding", ...) * test_data$adjustment
  )

  expect_equal(
    max_perc1RM_func(test_data$reps, adjustment = test_data$adjustment, type = "ballistic", ...),
    max_perc1RM_func(test_data$reps, adjustment = 1, type = "ballistic", ...) * test_data$adjustment
  )
}

check_get_max_reps_relInt_functions <- function(max_reps_func, ...) {
  test_data <- expand.grid(
    perc_1RM = seq(0.3, 1, length.out = 20),
    adjustment = seq(0, 1, length.out = 20)
  )

  # Maximum number of reps at given %1RM should be double for the
  # Grinding variants
  expect_equal(
    max_reps_func(test_data$perc_1RM, adjustment = 1, type = "grinding", ...),
    2 * max_reps_func(test_data$perc_1RM, adjustment = 1, type = "ballistic", ...)
  )

  expect_equal(
    max_reps_func(test_data$perc_1RM / test_data$adjustment, adjustment = 1, type = "grinding", ...),
    max_reps_func(test_data$perc_1RM, adjustment = test_data$adjustment, type = "grinding", ...)
  )

  expect_equal(
    max_reps_func(test_data$perc_1RM / test_data$adjustment, adjustment = 1, type = "ballistic", ...),
    max_reps_func(test_data$perc_1RM, adjustment = test_data$adjustment, type = "ballistic", ...)
  )
}




# ================================================================
# Prediction of %1RM from number of reps
test_that("get_max_perc_1RM_relint() function predicts %1RM correctly", {
  check_get_max_perc1RM_relInt_functions(get_max_perc_1RM_relInt)
})

test_that("get_max_perc_1RM_k_relInt() function predicts %1RM correctly", {
  check_get_max_perc1RM_relInt_functions(get_max_perc_1RM_k_relInt)
  check_get_max_perc1RM_relInt_functions(get_max_perc_1RM_k_relInt, k = 0.0333)
  check_get_max_perc1RM_relInt_functions(get_max_perc_1RM_k_relInt, k = 0.0666)
  check_get_max_perc1RM_relInt_functions(get_max_perc_1RM_k_relInt, k = 0.0222)
})

test_that("get_max_perc_1RM_kmod_relInt() function predicts %1RM correctly", {
  check_get_max_perc1RM_relInt_functions(get_max_perc_1RM_kmod_relInt)
  check_get_max_perc1RM_relInt_functions(get_max_perc_1RM_kmod_relInt, kmod = 0.353)
  check_get_max_perc1RM_relInt_functions(get_max_perc_1RM_kmod_relInt, kmod = 0.242)
  check_get_max_perc1RM_relInt_functions(get_max_perc_1RM_kmod_relInt, kmod = 0.656)
})

test_that("get_max_perc_1RM_klin_relInt() function predicts %1RM correctly", {
  check_get_max_perc1RM_relInt_functions(get_max_perc_1RM_klin_relInt)
  check_get_max_perc1RM_relInt_functions(get_max_perc_1RM_klin_relInt, klin = 33)
  check_get_max_perc1RM_relInt_functions(get_max_perc_1RM_klin_relInt, klin = 55)
  check_get_max_perc1RM_relInt_functions(get_max_perc_1RM_klin_relInt, klin = 10)
})


# ================================================================
# Prediction of reps from %1RM
test_that("get_max_reps_relInt() function predicts reps correctly", {
  check_get_max_reps_relInt_functions(get_max_reps_relInt)
})
