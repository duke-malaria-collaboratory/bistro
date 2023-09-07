test_that("get_similarities works", {
  bm_profs <- tibble::tibble(
    SampleName = c("A", "A", "A", "B", "B", "C"),
    Marker = c("m1", "m1", "m2", "m1", "m2", NA),
    Allele = c(1:5, NA),
    Height = c(100, rep(1000, 5))
  )
  hu_profs <- tibble::tibble(
    SampleName = c("a", "a", "a", "b", "b"),
    Marker = c("m1", "m1", "m2", "m1", "m2"),
    Allele = c(2, 1, 3, 1, 3)
  )

  expect_equal(
    get_human_similarities(hu_profs) |> dplyr::pull(similarity),
    0.5
  )

  expect_equal(
    suppressMessages(get_human_similarities(human_profiles) |>
      dplyr::pull(similarity)),
    c(0.117647058823529, 0, 0.0588235294117647)
  )

  expect_equal(
    get_bloodmeal_human_similarities(
      bm_profs,
      hu_profs
    ) |>
      dplyr::pull(similarity),
    1
  )

  expect_equal(
    get_bloodmeal_human_similarities(
      bloodmeal_profiles,
      human_profiles
    ) |>
      dplyr::pull(similarity),
    c(0.294117647058824, 0.0588235294117647)
  )

  expect_snapshot(match_similarity(bm_profs, hu_profs))

  expect_snapshot(match_similarity(
    bloodmeal_profiles,
    human_profiles
  ))

  expect_snapshot(
    match_similarity(bloodmeal_profiles,
      human_profiles,
      return_similarities = TRUE
    )
  )

  expect_snapshot(match_similarity(bloodmeal_profiles,
    human_profiles,
    peak_thresh = 200
  ))
})
