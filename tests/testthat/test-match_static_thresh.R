test_that("match_static_thresh works", {
  bm_evid1 <- bloodmeal_profiles |>
    dplyr::filter(SampleName == "evid1")
  hu_p1 <- human_profiles |>
    dplyr::filter(SampleName == "P1")
  bistro_output <- bistro(bm_evid1, hu_p1,
    pop_allele_freqs = pop_allele_freqs,
    kit = "ESX17", peak_thresh = 200,
    return_lrs = TRUE
  ) |>
    suppressMessages()
  expect_snapshot(match_static_thresh(bistro_output$lrs, 10))
})
