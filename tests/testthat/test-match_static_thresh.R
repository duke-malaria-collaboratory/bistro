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

  expect_true(nrow(dplyr::bind_rows(
    bistro_output$lrs,
    bistro_output$lrs |>
      dplyr::mutate(human_id = "P2", log10_lr = -10)
  ) |>
    match_static_thresh(10)) == 1)

  expect_true(bistro_output$lrs |>
    dplyr::mutate(log10_lr = Inf) |>
    match_static_thresh(10) |>
    dplyr::pull(match) == "no")
})
