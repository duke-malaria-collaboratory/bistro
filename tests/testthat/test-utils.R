test_that("ignore_unused_imports works", {

  expect_no_error(ignore_unused_imports())

})


test_that("rm_dups works", {

  expect_no_message(rm_dups(tibble::tibble(test=1:2)))

  expect_warning(rm_dups(tibble::tibble(test=rep(1,2))),
               "Detected and removed 1 duplicate rows.")

})

test_that("rm_twins works", {
  expect_snapshot(rm_twins(dplyr::bind_rows(human_profiles, human_profiles |> dplyr::filter(SampleName == 'P1') |> dplyr::mutate(SampleName = 'Pdup'))))
})

test_that("subset_ids works", {
  expect_equal(subset_ids('a', c('a', 'b'), 'ids'), 'a')
  expect_error(expect_warning(subset_ids('c', c('a', 'b'), 'ids'),
                              "Removing 1 ids not found in the dataset: c"),
               "None of the provided ids are present in the dataset.")
})

