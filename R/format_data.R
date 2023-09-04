#' Format population allele frequencies
#'
#' @description Format population allele frequencies for input into the euroformix `contLikSearch()` function.
#'
#' @inheritParams bistro
#'
#' @return A list of allele frequencies for the population in the format required for input into the euroformix `contLikSearch()` function
format_allele_freqs <- function(pop_allele_freqs){

  allele_names <- pop_allele_freqs$Allele
  marker_names <- names(pop_allele_freqs)[names(pop_allele_freqs) != 'Allele']
  names(marker_names) <- marker_names
  alleles_list <- lapply(marker_names, function(m){
    freqs <- pop_allele_freqs[[m]]
    names(freqs) <- allele_names
    freqs[!is.na(freqs)]
  })

  return(alleles_list)

}

#' Format human STR profiles
#'
#' @description Format human STR profiles for input into the euroformix `contLikSearch()` function.
#'
#' @inheritParams bistro
#'
#' @return A list of lists including the alleles for each sample in the format required for input into the euroformix `contLikSearch()` function
format_human_profiles <- function(human_profiles){

  hu_formatted <- human_profiles |>
    dplyr::arrange(SampleName, Marker, Allele) |>
    dplyr::group_by(SampleName, Marker) |>
    dplyr::mutate(index = dplyr::row_number()) |>
    tidyr::pivot_wider(names_from = index, values_from = Allele, names_prefix = "Allele") |>
    dplyr::select(SampleName, Marker, Allele1, Allele2) |>
      data.frame() |>
      euroformix::sample_tableToList()

  return(hu_formatted)

}


#' Format bloodmeal STR profiles
#'
#' @description Format bloodmeal STR profiles for input into the euroformix `contLikSearch()` function.
#'
#' @inheritParams bistro
#'
#' @return A list of lists including the alleles for each sample in the format required for input into the euroformix `contLikSearch()` function.
format_bloodmeal_profiles <- function(bloodmeal_profiles){

  bm_formatted <- bloodmeal_profiles |>
    dplyr::group_by(SampleName) |>
    dplyr::mutate(peaks = dplyr::n_distinct(Allele, na.rm = TRUE)) |>
    dplyr::filter(peaks != 0) |>
    dplyr::select(-peaks) |>
    dplyr::arrange(Allele) |>
    dplyr::group_by(SampleName, Marker) |>
    dplyr::mutate(index = dplyr::row_number()) |>
    tidyr::pivot_wider(names_from = index, values_from = c(Allele, Height), names_sep = "") |>
      data.frame() |>
      euroformix::sample_tableToList()

  return(bm_formatted)

}
