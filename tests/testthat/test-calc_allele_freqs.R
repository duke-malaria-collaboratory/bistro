test_that("calc_allele_freqs works", {
  expect_error(
    calc_allele_freqs(data.frame(name = 1)),
    "Not all expected column names are present. Missing:"
  )

  hu_prof_sub <-
    human_profiles |> dplyr::filter(Marker %in% c("AMEL", "D10S1248"))
  expect_snapshot(calc_allele_freqs(hu_prof_sub))

  expect_snapshot(calc_allele_freqs(hu_prof_sub, rm_markers = c("AMEL")))
})
