#' Identify similarity matches between STR profiles from bloodmeals and a human
#' database
#'
#' Match STR profiles between bloodmeals and humans based on threshold of most
#' similar human-human pair. Twins are not included when computing the
#' threshold. Note that bloodmeal peak height threshold is optional here because
#' it is only used for filtering. Also note that if `rm_twins = FALSE`, then a
#' match to a twin will result in multiple rows returned for that bloodmeal.
#'
#' @inheritParams bistro
#' @param return_similarities A boolean indicating whether or not to return
#'   human-human and bloodmeal-human. Default: FALSE
#'
#' @return Dataframe with three columns:
#' - `bloodmeal_id`: bloodmeal ID
#' - `human_id`: human ID of match (or NA)
#' - `match`: whether or not a match was identified (yes or no)
#' - `similarity`: similarity value if a match as found
#'
#'   If `return_similarities = TRUE`, then a named list of length 4 is returned:
#' - `matches`: the dataframe described above
#' - `max_hu_hu_similarity`: maximum human-human similarity
#'  (the threshold used for matching)
#' - `hu_hu_similarities`: all human-human similarity values,
#'   `bm_hu_similarities`: all bloodmeal-human similarities for profiles that
#'   have identical alleles at at least one marker
#' @export
#'
#' @examples
#' match_similarity(bloodmeal_profiles, human_profiles)
match_similarity <- function(bloodmeal_profiles, human_profiles,
                             bloodmeal_ids = NULL, human_ids = NULL,
                             peak_thresh = NULL, rm_twins = TRUE, rm_markers = NULL,
                             return_similarities = FALSE) {
  if (is.null(peak_thresh)) {
    check_colnames(bloodmeal_profiles, c("SampleName", "Marker", "Allele"))
  } else {
    check_colnames(
      bloodmeal_profiles,
      c("SampleName", "Marker", "Allele", "Height")
    )
  }
  check_colnames(human_profiles, c("SampleName", "Marker", "Allele"))
  check_ids(bloodmeal_ids, "bloodmeal_ids")
  check_ids(human_ids, "human_ids")
  check_is_bool(rm_twins, "rm_twins")
  check_ids(rm_markers, "rm_markers")
  check_is_bool(return_similarities, "return_similarities")

  bloodmeal_profiles <- prep_bloodmeal_profiles(
    bloodmeal_profiles,
    bloodmeal_ids,
    peak_thresh,
    rm_markers = rm_markers
  )

  all_bm_ids <- unique(bloodmeal_profiles$SampleName)

  bloodmeal_profiles <- bloodmeal_profiles |>
    tidyr::drop_na()

  human_profiles <- prep_human_profiles(
    human_profiles,
    human_ids,
    rm_twins,
    rm_markers = rm_markers
  ) |>
    tidyr::drop_na()

  message("Calculating human-human similarities")
  hu_similarities <- get_human_similarity(human_profiles)

  max_similarity <- hu_similarities |>
    dplyr::filter(similarity != 1) |> # remove twins
    dplyr::select(similarity) |>
    dplyr::slice_max(similarity, with_ties = FALSE) |>
    dplyr::pull(similarity)
  message("Maximum similarity between people: ", max_similarity)

  message("Calculating bloodmeal-human similarities")
  bm_hu_similarities <- get_bloodmeal_human_similarity(
    bloodmeal_profiles,
    human_profiles
  )

  message("Identifying matches")
  bm_ids <- bloodmeal_profiles |>
    dplyr::select(SampleName) |>
    dplyr::rename(bloodmeal_id = SampleName) |>
    dplyr::distinct(bloodmeal_id)

  matches <- bm_hu_similarities |>
    dplyr::group_by(bloodmeal_id, similarity) |>
    dplyr::summarize(
      match = ifelse(dplyr::n() == 1 & any(similarity > max_similarity),
        "yes", "no"
      ),
      human_id = ifelse(dplyr::n() == 1 & any(similarity > max_similarity),
        unique(human_id), NA
      )
    ) |>
    dplyr::ungroup() |>
    dplyr::select(bloodmeal_id, human_id, match, similarity) |>
    dplyr::full_join(bm_ids) |>
    dplyr::mutate(match = ifelse(is.na(match), "no", match)) |>
    suppressMessages()

  dropped <- all_bm_ids[!all_bm_ids %in% unique(matches$bloodmeal_id)]

  if (length(dropped) > 0) {
    matches <- matches |>
      dplyr::bind_rows(
        tibble::tibble(
          bloodmeal_id = dropped,
          human_id = NA,
          match = "no"
        )
      )
  }

  if (return_similarities) {
    matches <- list(
      matches = matches,
      max_hu_hu_similarity = max_similarity,
      hu_hu_similarities = hu_similarities,
      bm_hu_similarities = bm_hu_similarities
    )
  }

  return(matches)
}


#' Get pairwise human STR profile similarities
#'
#' @inheritParams bistro
#'
#' @return Dataframe with three columns:
#' - hu1: human ID 1
#' - hu2: human ID 2
#' - similarity: similarity value (# exact locus matches / # loci)
#' @keywords internal
get_human_similarity <- function(human_profiles) {
  human_profiles <- human_profiles |>
    tidyr::drop_na()
  str_hu1_by_marker <- human_profiles |>
    dplyr::group_by(SampleName, Marker) |>
    dplyr::summarize(alleles = stringr::str_c(sort(Allele), collapse = ";")) |>
    dplyr::ungroup() |>
    dplyr::rename(human1 = SampleName) |>
    suppressMessages()
  str_hu2_by_marker <- human_profiles |>
    dplyr::group_by(SampleName, Marker) |>
    dplyr::summarize(alleles = stringr::str_c(sort(Allele), collapse = ";")) |>
    dplyr::ungroup() |>
    dplyr::rename(human2 = SampleName) |>
    suppressMessages()
  n_markers <- dplyr::n_distinct(str_hu1_by_marker$Marker)

  hu_samps <- unique(str_hu1_by_marker$human1)
  n_hu_tot <- length(hu_samps)

  hu_similarity <- lapply(1:n_hu_tot, function(hu1_n) {
    hu1 <- hu_samps[hu1_n]
    hu_prof <- str_hu1_by_marker |>
      dplyr::filter(human1 == hu1)
    lapply(1:n_hu_tot, function(hu2_n) {
      if (hu1_n < hu2_n) {
        hu2 <- hu_samps[hu2_n]
        hu_prof |>
          dplyr::full_join(str_hu2_by_marker |>
            dplyr::filter(human2 == hu2)) |>
          dplyr::summarize(
            similarity = sum(!is.na(human1) & !is.na(human2)) / n_markers,
            hu1 = unique(human1[!is.na(human1)]),
            hu2 = unique(human2[!is.na(human2)])
          )
      }
    }) |>
      dplyr::bind_rows()
  }) |>
    dplyr::bind_rows() |>
    suppressMessages() |>
    dplyr::select(hu1, hu2, similarity)

  return(hu_similarity)
}

#' Identify matches between bloodmeal and human STR profiles
#'  based on similarity values
#'
#' @inheritParams bistro
#'
#' @return dataframe with two columns:
#' - bloodmeal_id: bloodmeal ID
#' - human_id: human ID of match, or "No match" if no match
#' @keywords internal
get_bloodmeal_human_similarity <- function(bloodmeal_profiles,
                                           human_profiles) {
  bloodmeal_profiles <- bloodmeal_profiles |>
    tidyr::drop_na()
  human_profiles <- human_profiles |>
    tidyr::drop_na()

  bm_samps <- bloodmeal_profiles |>
    dplyr::filter(!is.na(Marker)) |>
    dplyr::pull(SampleName) |>
    unique()

  str_hu_by_marker <- human_profiles |>
    dplyr::group_by(SampleName, Marker) |>
    dplyr::summarize(alleles = stringr::str_c(sort(Allele), collapse = ";")) |>
    dplyr::ungroup() |>
    dplyr::rename(human_id = SampleName) |>
    suppressMessages()
  str_bm_by_marker <- bloodmeal_profiles |>
    dplyr::group_by(SampleName, Marker) |>
    dplyr::summarize(alleles = stringr::str_c(sort(Allele), collapse = ";")) |>
    dplyr::ungroup() |>
    dplyr::rename(bloodmeal_id = SampleName) |>
    suppressMessages()

  n_markers <- dplyr::n_distinct(str_hu_by_marker$Marker)
  hu_samps <- unique(str_hu_by_marker$human_id)

  similarities <- lapply(bm_samps, function(m_id) {
    str_bm_by_marker_sub <- str_bm_by_marker |>
      dplyr::filter(bloodmeal_id == m_id)
    lapply(hu_samps, function(h_id) {
      str_bm_by_marker_sub |>
        dplyr::left_join(str_hu_by_marker |>
          dplyr::filter(human_id %in% h_id)) |>
        dplyr::group_by(bloodmeal_id) |>
        dplyr::reframe(
          similarity = sum(!is.na(human_id)) / n_markers,
          human_id = unique(human_id[!is.na(human_id)])
        )
    }) |>
      dplyr::bind_rows() |>
      dplyr::slice_max(similarity)
  }) |>
    dplyr::bind_rows() |>
    suppressMessages()

  return(similarities)
}
