test_that("filter_peaks works", {

  expect_warning(expect_warning(filter_peaks(tibble::tibble(SampleName='samp', Height = '1'), 200),
                 "Converting Height column to numeric."),
               "All peak heights are under the threshold of 200")

  expect_message(expect_message(expect_equal(filter_peaks(tibble::tibble(SampleName=c('samp1','samp2'), Height = c(100,300)), 200) %>% dplyr::pull(Height), 300),
               "Removing 1 peaks under the threshold of 200 RFU."),
               "For 1/2 bloodmeal ids, all peaks are below the threshold")

  expect_message(filter_peaks(tibble::tibble(SampleName='samp', Height=numeric())),
                 "No peak heights provided")

})
