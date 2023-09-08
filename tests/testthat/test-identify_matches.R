test_that("identify_matches works", {
  bloodmeal_profiles_sub <- bloodmeal_profiles |>
    rm_dups() |>
    filter_peaks(200) |>
    suppressMessages()

  lrs <-
    suppressMessages(
      calc_log10_lrs(
        bloodmeal_profiles_sub,
        human_profiles,
        pop_allele_freqs = pop_allele_freqs,
        kit = "ESX17",
        peak_thresh = 200
      )
    )

  expect_no_error(identify_one_match_set(
    lrs |>
      dplyr::slice_head(n = 3) |>
      dplyr::mutate(log10_lr = c(1, NA, Inf)),
    "evid1"
  ))

  expect_snapshot(identify_one_match_set(lrs, "evid1"))

  expect_snapshot(identify_one_match_set(lrs, "evid2"))

  lrs |>
    dplyr::filter(human_id == "P1") |>
    identify_one_match_set("evid1") |>
    expect_snapshot()

  expect_snapshot(
    lrs |>
      dplyr::filter(bloodmeal_id == "evid1") |>
      dplyr::mutate(log10_lr = c(1.55, 1.1, 1.2)) |>
      identify_one_match_set("evid1")
  )

  expect_snapshot(identify_matches(lrs))

  expect_equal(
    lrs |>
      dplyr::mutate(log10_lr = Inf) |>
      identify_matches() |>
      dplyr::pull(notes),
    c(
      "all log10LRs NA or Inf",
      "all log10LRs NA or Inf;no shared alleles;euroformix error",
      "all log10LRs NA or Inf"
    )
  )
})
