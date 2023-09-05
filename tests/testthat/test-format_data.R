test_that("format_allele_freqs works", {
  allele_freqs_sub <- pop_allele_freqs |>
    dplyr::select(Allele, D3S1358, TH01) |>
    dplyr::filter(!is.na(D3S1358) | !is.na(TH01))
  expect_snapshot(format_allele_freqs(allele_freqs_sub))
})

test_that("format_human_profiles works", {
  hu_profs_sub <- human_profiles |> dplyr::filter(SampleName == "P1")
  expect_snapshot(format_human_profiles(hu_profs_sub))
})

test_that("format_bloodmeal_profiles works", {
  expect_message(
    expect_message(
      expect_equal(
        format_bloodmeal_profiles(filter_peaks(bloodmeal_profiles, 3000)),
        list(evid1 = list(D2S441 = list(
          adata = c("10", "14"), hdata = c(3362, 3693)
        )))
      ),
      "Removing 66 peaks under the threshold of 3000 RFU."
    ),
    "For 3/4 bloodmeal ids, all peaks are below the threshold"
  )
})
