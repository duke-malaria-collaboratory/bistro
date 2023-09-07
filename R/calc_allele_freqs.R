#' Calculate allele frequencies
#'
#' @description Calculate allele frequencies for a (generally human) population.
#'
#' @inheritParams bistro
#'
#' @return A tibble where the first column is the STR allele and the following
#'   columns are the frequency of that allele for different markers. Alleles
#'   that do not exist for a given marker are coded as NA.
#'
#' @export
#' @keywords internal
calc_allele_freqs <- function(human_profiles, rm_markers = NULL) {
  # check if expected columns are present
  check_colnames(human_profiles, c("SampleName", "Marker", "Allele"))
  check_ids(rm_markers, "rm_markers")

  if (!is.null(rm_markers)) {
    human_profiles <- human_profiles |>
      dplyr::filter(!Marker %in% rm_markers)
  }

  # remove duplicates if necessary
  human_profiles <- rm_dups(human_profiles)

  # Calculate human population allele frequencies
  allele_freqs <- human_profiles |>
    dplyr::group_by(Marker, Allele) |>
    dplyr::mutate(allele_count = dplyr::n()) |>
    dplyr::group_by(Marker) |>
    dplyr::mutate(locus_n = dplyr::n()) |>
    dplyr::ungroup() |>
    dplyr::mutate(freq = allele_count / locus_n) |>
    dplyr::select(Marker, Allele, freq) |>
    dplyr::distinct() |>
    tidyr::pivot_wider(names_from = "Marker", values_from = freq)

  return(allele_freqs)
}
