test_that("calc_log10_lrs works", {
  bloodmeal_profiles_sub <- bloodmeal_profiles |>
    rm_dups() |>
    filter_peaks(200) |>
    suppressMessages()

  bm_profs <- bloodmeal_profiles_sub |>
    dplyr::filter(SampleName %in% c("evid2", "evid3"))
  hu_profs <- human_profiles |>
    dplyr::filter(SampleName %in% c("P1"))

  expect_snapshot(
    calc_one_log10_lr(
      bloodmeal_profiles_sub,
      "evid1",
      human_profiles,
      "00-JP0001-14_20142342311_NO-3241",
      pop_allele_freqs = pop_allele_freqs,
      kit = "ESX17",
      peak_thresh = 200,
      seed = 1
    )
  )

  expect_snapshot(
    calc_one_log10_lr(
      bloodmeal_profiles_sub,
      "evid2",
      human_profiles,
      "00-JP0001-14_20142342311_NO-3241",
      pop_allele_freqs = pop_allele_freqs,
      kit = "ESX17",
      peak_thresh = 200,
      seed = 1
    )
  )

  expect_snapshot(
    calc_one_log10_lr(
      bloodmeal_profiles_sub,
      "evid4",
      human_profiles,
      "00-JP0001-14_20142342311_NO-3241",
      pop_allele_freqs = pop_allele_freqs,
      kit = "ESX17",
      peak_thresh = 200,
      seed = 1
    )
  )

  expect_snapshot(
    calc_one_log10_lr(
      bloodmeal_profiles_sub,
      "evid2",
      human_profiles,
      "P1",
      pop_allele_freqs = pop_allele_freqs,
      kit = "ESX17",
      peak_thresh = 200,
      seed = 1
    )
  )

  expect_snapshot(
    calc_one_log10_lr(
      bloodmeal_profiles_sub,
      "evid1",
      human_profiles,
      "00-JP0001-14_20142342311_NO-3241",
      pop_allele_freqs = pop_allele_freqs,
      kit = "ESX17",
      peak_thresh = 200,
      time_limit = 0.00000001
    )
  )

  expect_snapshot(
    calc_log10_lrs(
      bm_profs,
      hu_profs,
      pop_allele_freqs = pop_allele_freqs,
      kit = "ESX17",
      peak_thresh = 200,
      seed = 1,
      check_inputs = FALSE
    )
  )

  suppressMessages(expect_no_error(calc_log10_lrs(
    bm_profs,
    hu_profs,
    pop_allele_freqs = pop_allele_freqs,
    kit = "ESX17",
    peak_thresh = 200,
    # seed = 1,
    check_inputs = TRUE
  )))


})
