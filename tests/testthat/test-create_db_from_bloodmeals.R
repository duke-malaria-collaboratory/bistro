test_that("create_db_from_bloodmeals works", {
  expect_no_error(create_db_from_bloodmeals(
    bloodmeal_profiles,
    "ESX17", 0, c("AMEL")
  ))
  expect_equal(create_db_from_bloodmeals(
    bloodmeal_profiles |>
      dplyr::group_by(SampleName, Marker) |>
      dplyr::slice_head(n = 2),
    "ESX17", 0, c("AMEL")
  ) |>
    nrow(), 32)
})
