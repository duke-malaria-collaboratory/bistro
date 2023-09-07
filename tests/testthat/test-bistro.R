test_that("bistro works", {
  bm_evid1 <- bloodmeal_profiles |>
    dplyr::filter(SampleName == "evid1")
  hu_p1 <- human_profiles |>
    dplyr::filter(SampleName == "P1")

  expect_snapshot(
    bistro(
      bm_evid1,
      hu_p1,
      pop_allele_freqs = pop_allele_freqs,
      kit = "ESX17",
      peak_thresh = 200
    )
  )

  expect_snapshot(bistro(
    bm_evid1,
    hu_p1,
    calc_allele_freqs = TRUE,
    kit = "ESX17",
    peak_thresh = 200
  ))

  expect_error(
    bistro(
      bloodmeal_profiles,
      human_profiles,
      kit = "ESX17",
      peak_thresh = 200
    ),
    "If `calc_allele_freqs = FALSE`, then `pop_allele_freqs` is required."
  )
})
