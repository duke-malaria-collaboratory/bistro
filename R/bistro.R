#' Identify human contributors to a bloodmeal using STR profiles
#'
#' @description Identifies matches between bloodmeal STR profiles and a database
#'   of human STR profiles. The [euroformix::contLikSearch()] function is used
#'   to calculate log10 likelihood ratios (log10_lrs) that are then used to
#'   identify human contributors to each bloodmeal. For more details than are
#'   present here, see `vignette('bistro')`.
#'
#' @param bloodmeal_profiles Tibble with alleles for all bloodmeals in reference
#'   database including 4 columns: SampleName, Marker, Allele, Height. Height
#'   must be numeric or coercible to numeric.
#' @param human_profiles Tibble with alleles for all humans in reference
#'   database including three columns: SampleName, Marker, Allele.
#' @param kit STR kit name from euroformix. To see a list of all kits embedded
#'   in euroformix use [euroformix::getKit()]. If your kit is not included, see
#'   vignette("bistro") for details on how to include your own kit.
#' @param peak_threshold Allele peak height threshold
#' in RFUs. All peaks under this
#'   threshold will be filtered out. If prior filtering was performed, this
#'   number should be equal to or greater than that number.
#'   Also used for `threshT` argument in [euroformix::contLikSearch()].
#' @param pop_allele_freqs Data frame where the first column is the STR allele
#'   and the following columns are the frequency of that allele for different
#'   markers. Alleles that do not exist for a given marker are coded as NA. If
#'   NULL and `calc_allele_freqs = TRUE`, then population allele frequencies
#'   will be calculated from `human_profiles`.
#' @param calc_allele_freqs A boolean indicating whether or not to calculate
#'   allele frequencies from `human_profiles`. If FALSE, a `pop_allele_freqs`
#'   input is required. Default: FALSE
#' @param bloodmeal_ids Vector of bloodmeal ids from the
#'  SampleName column in
#'   `bloodmeal_profiles` for which to compute log10_lrs.
#'    If NULL, all ids in the
#'   input dataframe will be used. Default: NULL
#' @param human_ids Vector of human ids from the SampleName column in
#'   `human_profiles` for which to compute log10_lrs. If NULL, all ids in the
#'   input dataframe will be used. Default: NULL
#' @param rm_twins A boolean indicating whether or not to remove likely twins
#'   from the human database (identical STR profiles). Default: TRUE
#' @param model_degrad A boolean indicating whether or not to model peak
#'   degradation.
#'   Used for `modelDegrad` argument in [euroformix::contLikSearch()].
#'  Default: TRUE
#' @param model_bw_stutt A boolean indicating whether or not to model peak
#'   backward stutter.
#'   Used for `modelBWstutt` argument in [euroformix::contLikSearch()].
#'   Default: FALSE
#' @param model_fw_stutt A boolean indicating whether or
#'  not to model peak forward stutter.
#'   Used for `modelFWstutt` argument in [euroformix::contLikSearch()].
#'  Default: FALSE
#' @param difftol Tolerance for difference in log likelihoods across 2
#'   iterations. [euroformix::contLikSearch()] argument. Default: 1
#' @param threads Number of threads to use when calculating log10_lrs.
#'   [euroformix::contLikSearch()] argument. Default: 4
#' @param seed Seed when calculating log10_lrs. [euroformix::contLikSearch()]
#'   argument. Default: 1
#' @param time_limit Time limit in minutes to run the
#'   [euroformix::contLikSearch()] function on 1 bloodmeal-human pair. Default:
#'   3
#'
#' @return Tibble with matches for bloodmeal-human pairs including the columns
#'   listed below. Note that if multiple matches are found for a bloodmeal,
#'   these are included as separate rows.
#'
#' * `bloodmeal_id`: bloodmeal id
#' * `locus_count`: number of loci successfully typed in the bloodmeal
#' * `est_noc`: estimated number of contributors to the bloodmeal
#' * `match`: whether a match was identified for a given bloodmeal (yes or no)
#' * `human_id`: If match, human id (NA otherwise)
#' * `log10_lr`: If match, log10 likelihood ratio (NA otherwise)
#' * `notes`: Why the bloodmeal does or doesn't have a match
#'
#'
#' @export
#'
#' @examples
#' bistro(bloodmeal_profiles, human_profiles,
#'   pop_allele_freqs = pop_allele_freqs,
#'   kit = "ESX17", peak_threshold = 200
#' )
bistro <-
  function(bloodmeal_profiles,
           human_profiles,
           kit,
           peak_threshold,
           pop_allele_freqs = NULL,
           calc_allele_freqs = FALSE,
           bloodmeal_ids = NULL,
           human_ids = NULL,
           rm_twins = TRUE,
           model_degrad = TRUE,
           model_bw_stutt = FALSE,
           model_fw_stutt = FALSE,
           difftol = 1,
           threads = 4,
           seed = 1,
           time_limit = 3) {
    check_bistro_inputs(
      bloodmeal_profiles,
      human_profiles,
      kit,
      peak_threshold,
      pop_allele_freqs,
      calc_allele_freqs,
      bloodmeal_ids,
      human_ids,
      rm_twins,
      model_degrad,
      model_bw_stutt,
      model_fw_stutt,
      difftol,
      threads,
      seed,
      time_limit
    )

    if (rm_twins) {
      human_profiles <- rm_twins(human_profiles)
    }

    if (calc_allele_freqs) {
      pop_allele_freqs <- calc_allele_freqs(human_profiles)
    }

    message("Formatting bloodmeal profiles")

    if (is.null(bloodmeal_ids)) {
      bloodmeal_ids <- unique(bloodmeal_profiles$SampleName)
    } else {
      bloodmeal_ids <-
        subset_ids(bloodmeal_ids, bloodmeal_profiles$SampleName)
    }

    bloodmeal_profiles <- bloodmeal_profiles |>
      dplyr::filter(SampleName %in% bloodmeal_ids)

    if (sum(bloodmeal_profiles$Height >= peak_threshold, na.rm = TRUE) == 0) {
      stop("All bloodmeal peak heights below threshold.")
    }

    bloodmeal_profiles <- bloodmeal_profiles |>
      rm_dups() |>
      filter_peaks(peak_threshold)

    message("Formatting human profiles")

    if (is.null(human_ids)) {
      human_ids <- unique(human_profiles$SampleName)
    } else {
      human_ids <- subset_ids(human_ids, human_profiles$SampleName)
    }

    human_profiles <- human_profiles |>
      dplyr::filter(SampleName %in% human_ids) |>
      rm_dups()

    message("Calculating log10LRs")

    log10_lrs <-
      calc_log10_lrs(
        bloodmeal_profiles,
        human_profiles,
        pop_allele_freqs,
        kit,
        peak_threshold,
        bloodmeal_ids,
        human_ids,
        model_degrad,
        model_bw_stutt,
        model_fw_stutt,
        difftol,
        threads,
        seed,
        time_limit
      )

    message("Identifying matches")

    matches <- identify_matches(log10_lrs, bloodmeal_ids)

    return(matches)
  }