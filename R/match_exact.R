#' Identify exact matches between bloodmeal and human STR profiles
#'
#' Match exact STR profiles between bloodmeals and humans.
#' Note that bloodmeal peak height threshold is optional here because
#' it is only used for filtering.
#' Also note that if `rm_twins = FALSE`, then a match to a twin
#' will result in multiple rows returned for that bloodmeal.
#'
#' @inheritParams bistro
#'
#' @return Dataframe with three columns:
#' - `bloodmeal_id`: bloodmeal ID
#' - `human_id`: human ID of match (or NA)
#' - `match`: whether or not a match was identified (yes or no)
#' @export
#'
#' @examples
#' match_exact(bloodmeal_profiles, human_profiles)
match_exact <- function(bloodmeal_profiles,
                        human_profiles,
                        bloodmeal_ids = NULL,
                        human_ids = NULL,
                        peak_thresh = NULL,
                        rm_twins = TRUE,
                        rm_markers = NULL) {
  if (is.null(peak_thresh)) {
    check_colnames(bloodmeal_profiles, c("SampleName", "Marker", "Allele"))
  } else {
    check_colnames(
      bloodmeal_profiles,
      c("SampleName", "Marker", "Allele", "Height")
    )
  }
  check_colnames(human_profiles, c("SampleName", "Marker", "Allele"))
  check_present(bloodmeal_ids, bloodmeal_profiles, "SampleName")
  check_present(human_ids, human_profiles, "SampleName")
  check_is_bool(rm_twins)
  check_present(rm_markers, bloodmeal_profiles, "SampleName")
  check_present(rm_markers, human_profiles, "SampleName")

  bloodmeal_profiles <- prep_bloodmeal_profiles(
    bloodmeal_profiles,
    bloodmeal_ids,
    peak_thresh,
    rm_markers = NULL,
    check_heights = FALSE,
    check_inputs = FALSE
  )

  human_profiles <- prep_human_profiles(
    human_profiles,
    human_ids,
    rm_twins,
    rm_markers = NULL,
    check_inputs = FALSE
  )

  # human profiles
  humans_short <- human_profiles |>
    dplyr::arrange(as.numeric(Allele)) |>
    dplyr::group_by(SampleName, Marker) |>
    dplyr::summarise(Allele = stringr::str_c(Allele, collapse = ",")) |>
    dplyr::ungroup() |>
    dplyr::arrange(Marker) |>
    dplyr::group_by(SampleName) |>
    dplyr::summarise(profile = stringr::str_c(Allele, collapse = "_")) |>
    dplyr::ungroup() |>
    dplyr::group_by(profile) |>
    dplyr::rename(human_id = SampleName) |>
    suppressWarnings() |>
    suppressMessages()

  # bloodmeal profiles
  bloodmeals_short <- bloodmeal_profiles |>
    dplyr::select(SampleName, Marker, Allele) |>
    dplyr::distinct() |>
    tidyr::drop_na(Marker) |>
    tidyr::complete(SampleName, Marker) |>
    dplyr::arrange(as.numeric(Allele)) |>
    dplyr::group_by(SampleName, Marker) |>
    dplyr::mutate(Allele = ifelse(is.na(Allele), "NA", Allele)) |>
    dplyr::summarise(alleles = stringr::str_c(Allele, collapse = ",")) |>
    dplyr::ungroup() |>
    dplyr::arrange(Marker) |>
    dplyr::group_by(SampleName) |>
    dplyr::summarise(profile = stringr::str_c(alleles, collapse = "_")) |>
    dplyr::rename(bloodmeal_id = SampleName) |>
    suppressWarnings() |>
    suppressMessages()

  # find exact matches
  matches_exact <- bloodmeals_short |>
    dplyr::left_join(humans_short, by = "profile") |>
    dplyr::select(-profile) |>
    dplyr::mutate(match = ifelse(is.na(human_id), "no", "yes"))

  # add in bloodmeals that were dropped
  bm_samps <- unique(bloodmeal_profiles$SampleName)
  dropped <- bm_samps[!bm_samps %in% matches_exact$bloodmeal_id]

  if (length(dropped) > 0) {
    matches_exact <- matches_exact |>
      dplyr::bind_rows(
        tibble::tibble(
          bloodmeal_id = dropped,
          human_id = NA,
          match = "no"
        )
      )
  }

  return(matches_exact)
}
