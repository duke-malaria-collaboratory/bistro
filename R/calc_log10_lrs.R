#' Calculate log10_lr for one bloodmeal-human pair
#'
#' @param bloodmeal_id Bloodmeal id from the `SampleName` column in
#'   `bloodmeal_profiles` for which to compute the log10_lr
#' @param human_id Human id from the `SampleName` column in `human_profiles` for
#'   which to compute the log10_lr
#'
#' @return tibble with log10_lr for bloodmeal-human pair including bloodmeal_id,
#'   human_id, locus_count (number of STR loci used for matching),
#'   est_noc (estimated number of contributors), efm_noc (number of contributors
#'   used in euroformix), log10_lr (log10 likelihood ratio), notes
#' @inheritParams bistro
#'
#' @keywords internal
calc_one_log10_lr <-
  function(bloodmeal_profiles,
           bloodmeal_id,
           human_profiles,
           human_id,
           pop_allele_freqs,
           kit,
           peak_threshold,
           model_degrad = TRUE,
           model_bw_stutt = FALSE,
           model_fw_stutt = FALSE,
           difftol = 1,
           threads = 4,
           seed = 1,
           time_limit = 3) {
    bloodmeal_profile <- bloodmeal_profiles |>
      dplyr::filter(SampleName == bloodmeal_id)

    human_profile <- human_profiles |>
      dplyr::filter(SampleName == human_id)

    locus_count <-
      dplyr::n_distinct(bloodmeal_profile$Marker, na.rm = TRUE)
    est_noc <-
      ifelse(locus_count == 0, 0, ceiling(max(table(
        bloodmeal_profile$Marker
      ) / 2)))
    efm_noc <- min(est_noc, 3)

    output_df <- tibble::tibble(
      bloodmeal_id = bloodmeal_id,
      human_id = human_id,
      locus_count = locus_count,
      est_noc = est_noc,
      efm_noc = efm_noc,
      log10_lr = NA,
      notes = NA
    )

    if (nrow(bloodmeal_profile) == 0) {
      output_df$notes <- "no peaks above threshold"
    } else if (nrow(
      dplyr::inner_join(
        bloodmeal_profile |> dplyr::select(-SampleName),
        human_profile |> dplyr::select(-SampleName),
        by = dplyr::join_by(Marker, Allele)
      )
    ) == 0) {
      output_df$notes <- "no shared alleles"
    } else {
      bloodmeal_profile_list <-
        format_bloodmeal_profiles(bloodmeal_profile)
      human_profile_list <- format_human_profiles(human_profile)
      pop_allele_freqs_list <- format_allele_freqs(pop_allele_freqs)

      efm_out <- tryCatch(
        expr = {
          R.utils::withTimeout(
            {
              output <- euroformix::contLikSearch(
                NOC = efm_noc,
                modelDegrad = model_degrad,
                modelBWstutt = model_bw_stutt,
                modelFWstutt = model_fw_stutt,
                samples = bloodmeal_profile_list,
                popFreq = pop_allele_freqs_list,
                refData = human_profile_list,
                condOrder = 0,
                knownRefPOI = 1,
                prC = 0.05,
                threshT = peak_threshold,
                lambda = 0.01,
                kit = kit,
                nDone = 2,
                seed = seed,
                difftol = difftol,
                maxThreads = threads,
                verbose = FALSE
              )
              output$outtable[3]
            },
            timeout = 60 * time_limit,
            elapsed = 60 * time_limit
          )
        },
        error = function(err) {
          return(err)
        }
      )

      if (is.numeric(efm_out)) {
        output_df$log10_lr <- efm_out
      } else if (class(efm_out)[1] == "simpleError") {
        output_df$notes <- "euroformix error"
      } else if (class(efm_out)[1] == "TimeoutException") {
        output_df$notes <- "timed out"
      }
    }

    return(output_df)
  }

#' Calculate log10_lrs for multiple bloodmeal-human pairs
#'
#' @inheritParams bistro
#'
#' @return A tibble with the same output as for [bistro()], except there is no
#'   match column and every bloodmeal-human pair with the calculated log10_lr is
#'   included. The only additional column is `efm_noc` which is the number of
#'   contributors used for [euroformix::contLikSearch()]. This has a maximum
#'   value of 3.
#'
#' @export
#' @keywords internal
calc_log10_lrs <-
  function(bloodmeal_profiles,
           human_profiles,
           pop_allele_freqs,
           kit,
           peak_threshold,
           bloodmeal_ids = NULL,
           human_ids = NULL,
           model_degrad = TRUE,
           model_bw_stutt = FALSE,
           model_fw_stutt = FALSE,
           difftol = 1,
           threads = 4,
           seed = 1,
           time_limit = 3) {
    if (is.null(bloodmeal_ids)) {
      bloodmeal_ids <- unique(bloodmeal_profiles$SampleName)
    }
    if (is.null(human_ids)) {
      human_ids <- unique(human_profiles$SampleName)
    }

    n_bm_tot <- length(bloodmeal_ids)
    message("# bloodmeal ids: ", n_bm_tot)
    n_hu_tot <- length(human_ids)
    message("# human ids: ", n_hu_tot)

    n_bm <- 0

    lapply(bloodmeal_ids, function(bm_id) {
      n_bm <<- n_bm + 1
      message("Bloodmeal id ", n_bm, "/", n_bm_tot)
      n_hu <- 0
      lapply(human_ids, function(hu_id) {
        n_hu <<- n_hu + 1
        message("Human id ", n_hu, "/", n_hu_tot)
        calc_one_log10_lr(
          bloodmeal_profiles,
          bm_id,
          human_profiles,
          hu_id,
          pop_allele_freqs = pop_allele_freqs,
          kit = kit,
          peak_threshold = peak_threshold,
          model_degrad = model_degrad,
          model_bw_stutt = model_bw_stutt,
          model_fw_stutt = model_fw_stutt,
          difftol = difftol,
          threads = threads,
          seed = seed,
          time_limit = time_limit
        )
      }) |>
        dplyr::bind_rows()
    }) |>
      dplyr::bind_rows()
  }
