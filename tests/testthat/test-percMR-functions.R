check_get_max_perc1RM_percMR_functions <- function(max_perc1RM_func, ...) {
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

  #
  expect_equal(
    max_perc1RM_func(test_data$reps, adjustment = test_data$adjustment, type = "grinding", ...),
    max_perc1RM_func(test_data$reps / test_data$adjustment, adjustment = 1, type = "grinding", ...)
  )

  expect_equal(
    max_perc1RM_func(test_data$reps, adjustment = test_data$adjustment, type = "ballistic", ...),
    max_perc1RM_func(test_data$reps / test_data$adjustment, adjustment = 1, type = "ballistic", ...)
  )
}

check_get_max_reps_percMR_functions <- function(max_reps_func, ...) {
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
    max_reps_func(test_data$perc_1RM, adjustment = 1, type = "grinding", ...) * test_data$adjustment,
    max_reps_func(test_data$perc_1RM, adjustment = test_data$adjustment, type = "grinding", ...)
  )

  expect_equal(
    max_reps_func(test_data$perc_1RM, adjustment = 1, type = "ballistic", ...) * test_data$adjustment,
    max_reps_func(test_data$perc_1RM, adjustment = test_data$adjustment, type = "ballistic", ...)
  )
}



# ================================================================
# Prediction of %1RM from number of reps
test_that("get_max_perc_1RM_percMR() function predicts %1RM correctly", {
  check_get_max_perc1RM_percMR_functions(get_max_perc_1RM_percMR)
})

test_that("get_max_perc_1RM_k_percMR() function predicts %1RM correctly", {
  check_get_max_perc1RM_percMR_functions(get_max_perc_1RM_k_percMR)
  check_get_max_perc1RM_percMR_functions(get_max_perc_1RM_k_percMR, k = 0.0333)
  check_get_max_perc1RM_percMR_functions(get_max_perc_1RM_k_percMR, k = 0.6666)
  check_get_max_perc1RM_percMR_functions(get_max_perc_1RM_k_percMR, k = 0.2222)
})

test_that("get_max_perc_1RM_kmod_percMR() function predicts %1RM correctly", {
  check_get_max_perc1RM_percMR_functions(get_max_perc_1RM_kmod_percMR)
  check_get_max_perc1RM_percMR_functions(get_max_perc_1RM_kmod_percMR, kmod = 0.0353)
  check_get_max_perc1RM_percMR_functions(get_max_perc_1RM_kmod_percMR, kmod = 0.0242)
  check_get_max_perc1RM_percMR_functions(get_max_perc_1RM_kmod_percMR, kmod = 0.0656)
})

test_that("get_max_perc_1RM_klin_percMR() function predicts %1RM correctly", {
  check_get_max_perc1RM_percMR_functions(get_max_perc_1RM_klin_percMR)
  check_get_max_perc1RM_percMR_functions(get_max_perc_1RM_klin_percMR, klin = 33)
  check_get_max_perc1RM_percMR_functions(get_max_perc_1RM_klin_percMR, klin = 50)
  check_get_max_perc1RM_percMR_functions(get_max_perc_1RM_klin_percMR, klin = 10)
})

# ================================================================
# Prediction of reps from %1RM
test_that("get_max_reps_percMR() function predicts reps correctly", {
  check_get_max_reps_percMR_functions(get_max_reps_percMR)
})
