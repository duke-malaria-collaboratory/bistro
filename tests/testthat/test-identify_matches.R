test_that("identify_matches works", {

  bloodmeal_profiles_sub <- bloodmeal_profiles |>
    rm_dups() |>
    filter_peaks(200) |>
    suppressMessages()

  lrs <- suppressMessages(calc_log10LRs(bloodmeal_profiles_sub, human_profiles, pop_allele_freqs = pop_allele_freqs, kit = "ESX17", threshT = 200))

  expect_snapshot(identify_one_match_set(lrs, "evid1"))

  expect_snapshot(identify_one_match_set(lrs, "evid2"))

  expect_snapshot(lrs |> dplyr::filter(human_id == 'P1') |> identify_one_match_set("evid1"))

  expect_snapshot(lrs |> dplyr::filter(bloodmeal_id == 'evid1') |> dplyr::mutate(log10LR = c(1.55, 1.1, 1.2)) |> identify_one_match_set('evid1'))

  expect_snapshot(identify_matches(lrs))

})
