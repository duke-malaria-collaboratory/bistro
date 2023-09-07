test_that("match_exact works", {
  bm_profs <- tibble::tibble(
    SampleName = c("A", "A", "A", "B", "B", "C"),
    Marker = c("m1", "m1", "m2", "m1", "m2", NA),
    Allele = c(1:5, NA),
    Height = c(100, rep(1000, 5))
  )
  hu_profs <- tibble::tibble(
    SampleName = c("a", "a", "a", "b", "b"),
    Marker = c("m1", "m1", "m2", "m1", "m2"),
    Allele = c(2, 1, 3, 1, 3)
  )

  expect_equal(
    match_exact(bm_profs, hu_profs) |>
      dplyr::pull(match),
    c("yes", "no", "no")
  )

  expect_message(expect_equal(
    match_exact(bm_profs, hu_profs, peak_thresh = 200) |>
      dplyr::pull(match),
    c("no", "no", "no")
  ))

  expect_equal(
    match_exact(
      bm_profs |>
        dplyr::slice_head(n = 1),
      hu_profs |>
        dplyr::group_by(SampleName) |>
        dplyr::slice_head(n = 1) |>
        dplyr::mutate(Allele = 1),
      rm_twins = FALSE
    ) |>
      dplyr::pull(match),
    c("yes", "yes")
  )
})
