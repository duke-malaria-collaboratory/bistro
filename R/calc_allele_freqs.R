#' Calculate allele frequencies
#'
#' @description Calculate allele frequencies for a (generally human) population.
#'
#' @param check_inputs A boolean indicating whether or not to check the
#'  inputs to the function. Default: TRUE
#' @inheritParams bistro
#'
#' @return A tibble where the first column is the STR allele and the following
#'   columns are the frequency of that allele for different markers. Alleles
#'   that do not exist for a given marker are coded as NA.
#'
#' @export
#' @examples
#' calc_allele_freqs(human_profiles)
calc_allele_freqs <- function(human_profiles,
                              rm_markers = NULL,
                              check_inputs = TRUE) {
  check_is_bool(check_inputs)
  if (check_inputs) {
    check_colnames(human_profiles, c("SampleName", "Marker", "Allele"))
    check_present(rm_markers, human_profiles, "Marker")
  }

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
