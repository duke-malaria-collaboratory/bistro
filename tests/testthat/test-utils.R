test_that("ignore_unused_imports works", {
  expect_no_error(ignore_unused_imports())
})

test_that("check_pkg_version works", {
  expect_no_error(check_pkg_version('tidyr', '1.1.2', '1.1.1'))
  expect_no_error(check_pkg_version('tidyr', '1.1.1', '1.1.1'))
  expect_error(check_pkg_version('tidyr', '1.1.1', '1.1.2'),
               "The tidyr package is version 1.1.1 but must be >= 1.1.2. Please update the package to use this function.")
})
