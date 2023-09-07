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
#' @param peak_thresh Allele peak height threshold in RFUs. All peaks under this
#'   threshold will be filtered out. If prior filtering was performed, this
#'   number should be equal to or greater than that number. Also used for
#'   `threshT` argument in [euroformix::contLikSearch()].
#' @param pop_allele_freqs Data frame where the first column is the STR allele
#'   and the following columns are the frequency of that allele for different
#'   markers. Alleles that do not exist for a given marker are coded as NA. If
#'   NULL and `calc_allele_freqs = TRUE`, then population allele frequencies
#'   will be calculated from `human_profiles`.
#' @param calc_allele_freqs A boolean indicating whether or not to calculate
#'   allele frequencies from `human_profiles`. If FALSE, a `pop_allele_freqs`
#'   input is required. Default: FALSE
#' @param bloodmeal_ids Vector of bloodmeal ids from the SampleName column in
#'   `bloodmeal_profiles` for which to compute log10_lrs. If NULL, all ids in
#'   the input dataframe will be used. Default: NULL
#' @param human_ids Vector of human ids from the SampleName column in
#'   `human_profiles` for which to compute log10_lrs. If NULL, all ids in the
#'   input dataframe will be used. Default: NULL
#' @param rm_twins A boolean indicating whether or not to remove likely twins
#'   (identical STR profiles) from the human database prior to identifying
#'   matches. Default: TRUE
#' @param model_degrad A boolean indicating whether or not to model peak
#'   degradation. Used for `modelDegrad` argument in
#'   [euroformix::contLikSearch()]. Default: TRUE
#' @param model_bw_stutt A boolean indicating whether or not to model peak
#'   backward stutter. Used for `modelBWstutt` argument in
#'   [euroformix::contLikSearch()]. Default: FALSE
#' @param model_fw_stutt A boolean indicating whether or not to model peak
#'   forward stutter. Used for `modelFWstutt` argument in
#'   [euroformix::contLikSearch()]. Default: FALSE
#' @param difftol Tolerance for difference in log likelihoods across 2
#'   iterations. [euroformix::contLikSearch()] argument. Default: 1
#' @param threads Number of threads to use when calculating log10_lrs.
#'   [euroformix::contLikSearch()] argument. Default: 4
#' @param seed Seed when calculating log10_lrs. [euroformix::contLikSearch()]
#'   argument. Default: 1
#' @param time_limit Time limit in minutes to run the
#'   [euroformix::contLikSearch()] function on 1 bloodmeal-human pair. Default:
#'   3
#' @param return_lrs A boolean indicating whether or not to return log10LRs for
#'   all bloodmeal-human pairs. Default: FALSE
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
#'   If `return_lrs = TRUE`, then a named list of length 2 is returned:
#' * matches - the tibble described above
#' * lrs - log10LRs for each bloodmeal-human pair including some
#' of the columns described above and an additional column:
#'  `efm_noc`, which is the number of contributors used as input
#'   into euroformix, which is `min(est_noc, 3)`.
#'
#' @export
#'
#' @examples
#' bistro(bloodmeal_profiles, human_profiles,
#'   pop_allele_freqs = pop_allele_freqs,
#'   kit = "ESX17", peak_thresh = 200
#' )
bistro <-
  function(bloodmeal_profiles,
           human_profiles,
           kit,
           peak_thresh,
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
           time_limit = 3,
           return_lrs = FALSE) {
    check_bistro_inputs(
      bloodmeal_profiles,
      human_profiles,
      kit,
      peak_thresh,
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

    if (calc_allele_freqs) {
      pop_allele_freqs <- calc_allele_freqs(human_profiles)
    }

    message("Formatting bloodmeal profiles")
    bloodmeal_profiles <- prep_bloodmeal_profiles(
      bloodmeal_profiles,
      peak_thresh,
      bloodmeal_ids
    )

    message("Formatting human profiles")
    human_profiles <- prep_human_profiles(
      human_profiles,
      human_ids,
      rm_twins
    )

    message("Calculating log10LRs")

    log10_lrs <-
      calc_log10_lrs(
        bloodmeal_profiles,
        human_profiles,
        pop_allele_freqs,
        kit,
        peak_thresh,
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

    if(return_lrs){
      matches <- list(matches = matches,
                      lrs = log10_lrs)
    }

    return(matches)
  }
