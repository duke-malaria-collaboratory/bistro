#' Create human profile database from bloodmeal profiles
#'
#' @inheritParams bistro
#'
#' @return Human database created from complete single-source bloodmeals.
#'  Complete is defined as the number of markers in the kit minus the
#'   number of markers in `rm_markers`.
#' @export
#'
#' @examples
#' \dontrun{
#' # load example data
#' path_to_data <- paste0(
#'   "https://raw.githubusercontent.com/duke-malaria-collaboratory/",
#'   "bistro_validation/main/data/provedit/provedit_samples_mass200thresh.csv"
#' )
#' samples <- readr::read_csv(path_to_data)
#' create_db_from_bloodmeals(samples, kit = "identifiler", peak_thresh = 200)
#' }
#'
create_db_from_bloodmeals <- function(bloodmeal_profiles,
                                      kit,
                                      peak_thresh,
                                      rm_markers = c("AMEL")) {
  check_pkg_version("tidyr", utils::packageVersion("tidyr"), "1.3.0")
  n_markers_in_kit <- check_create_db_input(
    bloodmeal_profiles,
    kit,
    peak_thresh,
    rm_markers
  )
  bloodmeal_profiles |>
    filter_peaks(peak_thresh = peak_thresh) |>
    rm_markers(markers = rm_markers) |>
    dplyr::group_by(SampleName) |>
    dplyr::mutate(n_markers = dplyr::n_distinct(Marker)) |>
    dplyr::group_by(SampleName, Marker) |>
    dplyr::mutate(n_alleles = dplyr::n_distinct(Allele)) |>
    dplyr::ungroup() |>
    dplyr::filter(n_markers == n_markers_in_kit) |>
    dplyr::group_by(SampleName) |>
    dplyr::filter(all(n_alleles <= 2)) |>
    dplyr::ungroup() |>
    dplyr::select(SampleName, Marker, Allele) |>
    dplyr::mutate(SampleName = paste0("H", as.numeric(factor(SampleName)))) |>
    dplyr::arrange(Marker, Allele) |>
    dplyr::group_by(SampleName) |>
    dplyr::summarize(
      all_alleles =
        stringr::str_c(paste0(Marker, "__", Allele),
          collapse = ";"
        )
    ) |>
    dplyr::group_by(all_alleles) |>
    dplyr::summarize() |>
    dplyr::mutate(SampleName = paste0("H", dplyr::row_number()), .before = 1) |>
    tidyr::separate_longer_delim(all_alleles, delim = ";") |>
    tidyr::separate(all_alleles, sep = "__", into = c("Marker", "Allele"))
}
