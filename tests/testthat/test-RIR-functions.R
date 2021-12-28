check_get_max_perc1RM_RIR_functions <- function(max_perc1RM_func, ...) {
  reps <- seq(1, 50, length.out = 100)

  # Ballistic version of the max-reps table should be equal to double reps grinding
  expect_equal(
    max_perc1RM_func(reps * 2, adjustment = 0, type = "grinding", ...),
    max_perc1RM_func(reps, adjustment = 0, type = "ballistic", ...)
  )

  expect_equal(
    max_perc1RM_func(reps, adjustment = 0, type = "grinding", ...),
    max_perc1RM_func(reps / 2, adjustment = 0, type = "ballistic", ...)
  )

  # Ballistic version of the max-reps table should be equal to double reps grinding
  # In this case that is achieved by using RIR of same number as number of reps
  expect_equal(
    max_perc1RM_func(reps, adjustment = reps, type = "grinding", ...),
    max_perc1RM_func(reps, adjustment = 0, type = "ballistic", ...)
  )

  # When using RIR, double reps should be equal to using RIR of number of reps
  # For example, 10RM (10 reps at 0RIR) is equal to 5 reps with 5RIR
  # Grinding
  expect_equal(
    max_perc1RM_func(reps, adjustment = reps, type = "grinding", ...),
    max_perc1RM_func(reps * 2, adjustment = 0, type = "grinding", ...)
  )

  # Ballistic
  expect_equal(
    max_perc1RM_func(reps, adjustment = reps, type = "ballistic", ...),
    max_perc1RM_func(reps * 2, adjustment = 0, type = "ballistic", ...)
  )
}

# Function to check max reps
check_get_max_reps_RIR_functions <- function(max_reps_func, ...) {
  test_data <- expand.grid(
    perc_1RM = seq(0.3, 1, length.out = 20),
    adjustment = seq(0, 10, length.out = 20)
  )

  # Maximum number of reps at given %1RM should be double for the
  # Grinding variants
  expect_equal(
    max_reps_func(test_data$perc_1RM, adjustment = 0, type = "grinding", ...),
    2 * max_reps_func(test_data$perc_1RM, adjustment = 0, type = "ballistic", ...)
  )

  expect_equal(
    max_reps_func(test_data$perc_1RM, adjustment = test_data$adjustment, type = "grinding", ...),
    2 * max_reps_func(test_data$perc_1RM, adjustment = 1 / 2 * test_data$adjustment, type = "ballistic", ...)
  )

  # When using the RIR method, the adjustment used in the function should be equal to
  # deducting it from the results
  expect_equal(
    max_reps_func(test_data$perc_1RM, adjustment = test_data$adjustment, type = "grinding", ...),
    max_reps_func(test_data$perc_1RM, adjustment = 0, type = "grinding", ...) - test_data$adjustment
  )

  expect_equal(
    max_reps_func(test_data$perc_1RM, adjustment = test_data$adjustment, type = "ballistic", ...),
    max_reps_func(test_data$perc_1RM, adjustment = 0, type = "ballistic", ...) - test_data$adjustment
  )
}

# Function to check 1RM predictions
check_get_predicted_1RM_RIR_functions <- function(predicted_1RM_func, ...) {
  test_data <- expand.grid(
    weight = seq(100, 200, length.out = 10),
    reps = seq(1, 10),
    adjustment = seq(0, 10)
  )

  # Predicted 1RM using the ballistic should same as grinding, but using the double reps
  expect_equal(
    predicted_1RM_func(weight = test_data$weight, reps = test_data$reps * 2, adjustment = 0, type = "grinding"),
    predicted_1RM_func(weight = test_data$weight, reps = test_data$reps, adjustment = 0, type = "ballistic")
  )

  # Predicted 1RM using the reps + RIR (as total reps) and RIR as parameter should be same
  expect_equal(
    predicted_1RM_func(weight = test_data$weight, reps = test_data$reps + test_data$adjustment, adjustment = 0, type = "grinding"),
    predicted_1RM_func(weight = test_data$weight, reps = test_data$reps, adjustment = test_data$adjustment, type = "grinding")
  )

  expect_equal(
    predicted_1RM_func(weight = test_data$weight, reps = test_data$reps + test_data$adjustment, adjustment = 0, type = "ballistic"),
    predicted_1RM_func(weight = test_data$weight, reps = test_data$reps, adjustment = test_data$adjustment, type = "ballistic")
  )
}

# ================================================================
# Prediction of %1RM from number of reps
test_that("get_max_perc_1RM() function predicts %1RM correctly", {
  check_get_max_perc1RM_RIR_functions(get_max_perc_1RM)
})

test_that("get_max_perc_1RM_k() predicts %1RM correctly", {
  check_get_max_perc1RM_RIR_functions(get_max_perc_1RM_k)
  check_get_max_perc1RM_RIR_functions(get_max_perc_1RM_k, k = 0.0333)
  check_get_max_perc1RM_RIR_functions(get_max_perc_1RM_k, k = 0.0666)
  check_get_max_perc1RM_RIR_functions(get_max_perc_1RM_k, k = 0.0222)
})

test_that("get_max_perc_1RM_kmod() predicts %1RM correctly", {
  check_get_max_perc1RM_RIR_functions(get_max_perc_1RM_kmod)
  check_get_max_perc1RM_RIR_functions(get_max_perc_1RM_kmod, kmod = 0.0353)
  check_get_max_perc1RM_RIR_functions(get_max_perc_1RM_kmod, kmod = 0.0242)
  check_get_max_perc1RM_RIR_functions(get_max_perc_1RM_kmod, kmod = 0.0656)
})

test_that("get_max_perc_1RM_klin() predicts %1RM correctly", {
  check_get_max_perc1RM_RIR_functions(get_max_perc_1RM_klin)
  check_get_max_perc1RM_RIR_functions(get_max_perc_1RM_klin, klin = 33)
  check_get_max_perc1RM_RIR_functions(get_max_perc_1RM_klin, klin = 50)
  check_get_max_perc1RM_RIR_functions(get_max_perc_1RM_klin, klin = 10)
})

# ================================================================
# Prediction of reps from %1RM
test_that("get_max_reps() function predicts reps correctly", {
  check_get_max_reps_RIR_functions(get_max_reps)
})

test_that("get_max_reps_k() function predicts reps correctly", {
  check_get_max_reps_RIR_functions(get_max_reps_k)
  check_get_max_reps_RIR_functions(get_max_reps_k, k = 0.0333)
  check_get_max_reps_RIR_functions(get_max_reps_k, k = 0.0666)
  check_get_max_reps_RIR_functions(get_max_reps_k, k = 0.0222)
})

test_that("get_max_reps_kmod() function predicts reps correctly", {
  check_get_max_reps_RIR_functions(get_max_reps_kmod)
  check_get_max_reps_RIR_functions(get_max_reps_kmod, kmod = 0.0353)
  check_get_max_reps_RIR_functions(get_max_reps_kmod, kmod = 0.0242)
  check_get_max_reps_RIR_functions(get_max_reps_kmod, kmod = 0.0656)
})

test_that("get_max_reps_klin() function predicts reps correctly", {
  check_get_max_reps_RIR_functions(get_max_reps_klin)
  check_get_max_reps_RIR_functions(get_max_reps_klin, klin = 33)
  check_get_max_reps_RIR_functions(get_max_reps_klin, klin = 50)
  check_get_max_reps_RIR_functions(get_max_reps_klin, klin = 10)
})

# ================================================================
# Prediction of 1RM
test_that("get_predicted_1RM() function predicts 1RM correctly", {
  check_get_predicted_1RM_RIR_functions(get_predicted_1RM)
})

test_that("get_predicted_1RM_k() function predicts 1RM correctly", {
  check_get_predicted_1RM_RIR_functions(get_predicted_1RM_k)
  check_get_predicted_1RM_RIR_functions(get_predicted_1RM_k, k = 0.0333)
  check_get_predicted_1RM_RIR_functions(get_predicted_1RM_k, k = 0.0666)
  check_get_predicted_1RM_RIR_functions(get_predicted_1RM_k, k = 0.0222)
})

test_that("get_predicted_1RM_kmod() function predicts 1RM correctly", {
  check_get_predicted_1RM_RIR_functions(get_predicted_1RM_kmod)
  check_get_predicted_1RM_RIR_functions(get_predicted_1RM_kmod, kmod = 0.0353)
  check_get_predicted_1RM_RIR_functions(get_predicted_1RM_kmod, kmod = 0.0242)
  check_get_predicted_1RM_RIR_functions(get_predicted_1RM_kmod, kmod = 0.0656)
})

test_that("get_predicted_1RM_klin() function predicts 1RM correctly", {
  check_get_predicted_1RM_RIR_functions(get_predicted_1RM_klin)
  check_get_predicted_1RM_RIR_functions(get_predicted_1RM_klin, klin = 33)
  check_get_predicted_1RM_RIR_functions(get_predicted_1RM_klin, klin = 50)
  check_get_predicted_1RM_RIR_functions(get_predicted_1RM_klin, klin = 10)
})
