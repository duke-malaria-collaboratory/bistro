test_that("check_bistro_input works", {
  expect_no_error(check_bistro_inputs(
    bloodmeal_profiles, human_profiles,
    "ESX17", 1, NULL, TRUE
  ))
})

test_that("check_is_bool works", {
  expect_no_error(check_is_bool(TRUE, "v1"))
  expect_error(
    check_is_bool(1, "v1"),
    "v1 must be a logical"
  )
})

test_that("check_is_numeric works", {
  expect_no_error(check_is_numeric(1, "v1"))
  expect_no_error(check_is_numeric(-1, "v1"))
  expect_no_error(check_is_numeric(1, "v1", pos = TRUE))
  expect_error(
    check_is_numeric(0, "v1", pos = TRUE),
    "v1 must be greater than zero, but is 0."
  )
  expect_error(
    check_is_numeric("a", "v1"),
    "v1 must be numeric, but is character."
  )
})

test_that("check_kit works", {
  expect_error(
    check_kit("nokit"),
    "Kit nokit does not exist in euroformix."
  )
  expect_no_error(expect_equal(
    colnames(check_kit("ESX17")),
    c(
      "Panel",
      "Short.Name",
      "Full.Name",
      "Marker",
      "Allele",
      "Size",
      "Size.Min",
      "Size.Max",
      "Virtual",
      "Color",
      "Repeat",
      "Marker.Min",
      "Marker.Max",
      "Offset",
      "Gender.Marker"
    )
  ))
})

test_that("check_calc_allele_freqs works", {
  expect_no_error(check_calc_allele_freqs(NULL))
  expect_no_error(check_calc_allele_freqs(TRUE))
  expect_error(
    check_calc_allele_freqs(1),
    "`calc_allele_freqs` must be NULL or a logical"
  )
})

test_that("check_if_allele_freqs works", {
  expect_no_warning(check_if_allele_freqs(pop_allele_freqs, TRUE))
  expect_message(
    check_if_allele_freqs(pop_allele_freqs, FALSE, euroformix::getKit("ESX17")),
    "1/17 markers in kit but not in pop_allele_freqs: AMEL"
  )
  expect_error(
    check_if_allele_freqs(NULL, FALSE),
    "If `calc_allele_freqs = FALSE`, then `pop_allele_freqs` is required."
  )
})

test_that("check_ids works", {
  expect_no_error(check_ids(NULL, "v1"))
  expect_no_error(check_ids(1, "v1"))
  expect_no_error(check_ids(1:2, "v1"))
  expect_no_error(check_ids("a", "v1"))
  expect_error(
    check_ids(tibble::tibble(test = numeric()), "v1"),
    "v1 must be NULL or a vector but is: tbl_dftbldata.frame"
  )
})

test_that("check_colnames works", {
  expect_no_error(check_colnames(tibble::tibble(test = 1), "test"))

  expect_error(
    check_colnames(tibble::tibble(test = 1), "test1"),
    "Not all expected column names are present. Missing: test1"
  )
})

test_that("check_peak_thresh works", {
  expect_no_error(check_peak_thresh(1))

  expect_error(
    check_peak_thresh(-1),
    "thresT must be \u2265 0, but is -1"
  )

  expect_error(
    check_peak_thresh("test"),
    "thresT must be numeric, but is character"
  )
})

test_that("check_setdiff_markers works", {
  expect_message(
    expect_message(
      check_setdiff_markers(1:3, c(1, 4), "m1", "m2"),
      "2/3 markers in m1 but not in m2: 2,3"
    ),
    "1/2 markers in m2 but not in m1: 4"
  )
})

test_that("check_heights works", {
  expect_no_error(check_heights(1:10, 5))
  expect_error(
    check_heights(1:10, 15),
    "All bloodmeal peak heights below threshold of 15."
  )
  expect_error(check_heights(NA, 15))
})
