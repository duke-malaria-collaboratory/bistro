#' Match bloodmeals and humans based on log10LR static threshold
#'
#' @param thresh log10LR threshold for matching.
#' All bloodmeal-human pairs with
#'   a log10LR ≥ thresh will be considered a match.
#' @inheritParams identify_matches
#'
#' @return Dataframe including columns similar to the `bistro()` output.
#' @export
#'
#' @examples
#' bistro_output <- bistro(bloodmeal_profiles, human_profiles,
#'   pop_allele_freqs = pop_allele_freqs,
#'   kit = "ESX17", peak_thresh = 200, return_lrs = TRUE
#' )
#' match_static_thresh(bistro_output$lrs, 10)
match_static_thresh <- function(log10_lrs, thresh) {
  check_colnames(
    log10_lrs,
    c(
      "bloodmeal_id", "human_id",
      "locus_count", "est_noc", "efm_noc",
      "log10_lr", "notes"
    )
  )
  check_is_numeric(thresh, pos = TRUE)

  bm_info <- log10_lrs |>
    dplyr::select(bloodmeal_id, locus_count, est_noc) |>
    dplyr::distinct()

  matches <- log10_lrs |>
    dplyr::filter(log10_lr >= thresh &
      !is.infinite(log10_lr)) |>
    dplyr::mutate(match = "yes") |>
    dplyr::select(
      bloodmeal_id,
      locus_count,
      est_noc,
      match,
      human_id,
      log10_lr
    )

  # add in bloodmeals that were dropped
  matches <- bm_info |>
    dplyr::left_join(matches,
      by = dplyr::join_by(
        bloodmeal_id,
        locus_count,
        est_noc
      )
    ) |>
    dplyr::mutate(match = ifelse(is.na(match), "no", match))

  return(matches)
}
