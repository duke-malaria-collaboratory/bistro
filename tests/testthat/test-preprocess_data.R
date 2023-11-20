test_that("prep_bloodmeal_profiles works", {
  expect_warning(expect_error(
    prep_bloodmeal_profiles(
      bloodmeal_profiles %>% dplyr::filter(Height < 200),
      peak_thresh = 200
    ),
    "All bloodmeal peak heights below threshold of 200."
  ))

  expect_snapshot(prep_bloodmeal_profiles(
    bloodmeal_profiles,
    bloodmeal_ids = "evid1",
    peak_thresh = 200
  ))
})

test_that("prep_human_profiles works", {
  expect_snapshot(prep_human_profiles(human_profiles, rm_markers = "amel"))

  expect_snapshot(prep_human_profiles(human_profiles, human_ids = "P1"))
})

test_that("rm_markers works", {
  expect_equal(
    nrow(rm_markers(bloodmeal_profiles, c("amel")) |>
      dplyr::filter(Marker == "AMEL")),
    0
  )

  expect_equal(
    nrow(rm_markers(bloodmeal_profiles, NULL)),
    nrow(bloodmeal_profiles)
  )
})

test_that("rm_dups works", {
  expect_no_message(rm_dups(tibble::tibble(test = 1:2)))

  expect_warning(
    rm_dups(tibble::tibble(test = rep(1, 2))),
    "Detected and removed 1 duplicate rows."
  )
})

test_that("rm_twins works", {
  expect_snapshot(rm_twins(
    dplyr::bind_rows(
      human_profiles,
      human_profiles |>
        dplyr::filter(SampleName == "P1") |>
        dplyr::mutate(SampleName = "Pdup")
    )
  ))
})

test_that("subset_ids works", {
  expect_equal(subset_ids("a", c("a", "b"), "ids"), "a")
  expect_error(
    expect_warning(
      subset_ids("c", c("a", "b"), "ids"),
      "Removing 1 ids not found in the dataset: c"
    ),
    "None of the provided ids are present in the dataset."
  )
})
