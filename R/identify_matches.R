#' Identify matches between a bloodmeal and human references
#'
#' @param log10_lrs output from [calc_log10_lrs()]
#'
#' @return tibble with matches for bloodmeal-human pairs including bloodmeal_id,
#'   locus_count (number of STR loci used for matching), est_noc
#'   (estimated number of contributors), match, human_id (if match), log10_lr
#'   (log10 likelihood ratio), notes
#' @inheritParams calc_one_log10_lr
#' @keywords internal
identify_one_match_set <- function(log10_lrs, bloodmeal_id) {
  bm_id <- bloodmeal_id
  log10_lrs <- log10_lrs |>
    dplyr::filter(bloodmeal_id == bm_id)

  est_noc <- unique(log10_lrs$est_noc)
  locus_count <- unique(log10_lrs$locus_count)
  notes <- stringr::str_c(unique(log10_lrs$notes), collapse = ";")

  matches <- tibble::tibble(
    bloodmeal_id = bloodmeal_id,
    locus_count = locus_count,
    est_noc = est_noc,
    match = "no",
    human_id = NA,
    log10_lr = NA,
    notes = notes,
    thresh_low = NA
  )

  if (all(is.na(log10_lrs$log10_lr) | is.infinite(log10_lrs$log10_lr))) {
    matches_thresh <- matches |>
      dplyr::mutate(notes = ifelse(is.na(notes),
        "all log10LRs NA or Inf",
        paste0("all log10LRs NA or Inf", ";", notes)
      ))
  } else if (max(log10_lrs$log10_lr[!is.infinite(log10_lrs$log10_lr)]) < 1.5 &&
    is.na(notes)) {
    matches_thresh <- matches |>
      dplyr::mutate(notes = "all log10LRs < 1.5")
  } else {
    # matches can only have log10_lrs > 1
    log10_lrs <- log10_lrs |>
      dplyr::filter(log10_lr > 1 & !is.infinite(log10_lr))

    thresh <- floor(max(log10_lrs$log10_lr) * 2) / 2

    mht <- NULL

    # screen thresholds
    while (TRUE) {
      matches_thresh <- log10_lrs |>
        dplyr::filter(log10_lr >= thresh) |>
        dplyr::mutate(
          notes = ifelse(
            dplyr::n() > est_noc,
            "> min NOC matches",
            "passed all filters"
          ),
          match = ifelse(notes == "passed all filters", "yes", "no"),
          human_id = ifelse(notes == "> min NOC matches", NA, human_id),
          log10_lr = ifelse(notes == "> min NOC matches", NA, log10_lr),
          thresh_low = thresh
        ) |>
        dplyr::select(
          bloodmeal_id,
          locus_count,
          est_noc,
          match,
          human_id,
          log10_lr,
          notes,
          thresh_low
        ) |>
        dplyr::distinct() # do we need this?

      matches <- matches |>
        dplyr::bind_rows(matches_thresh)

      thresh <- thresh - 0.5

      mlt <- matches_thresh |>
        dplyr::arrange(human_id) |>
        dplyr::pull(human_id)

      if ((identical(mht, mlt) &&
        nrow(matches_thresh) == est_noc) ||
        matches_thresh$notes[1] == "> min NOC matches" ||
        thresh == 0.5) {
        break
      }

      mht <- mlt
    }

    if (nrow(matches_thresh) < est_noc ||
      matches_thresh$notes[1] == "> min NOC matches" ||
      matches_thresh$thresh_low[1] == 1) {
      # are 1st and last both required above?
      temp <- matches |>
        dplyr::filter(notes != "> min NOC matches") |>
        dplyr::group_by(thresh_low) |>
        dplyr::mutate(
          n_samps = dplyr::n_distinct(human_id),
          human_id = stringr::str_c(human_id, collapse = ","),
          log10_lr = stringr::str_c(log10_lr, collapse = ",")
        ) |>
        dplyr::ungroup() |>
        dplyr::distinct() |>
        dplyr::arrange(thresh_low) |>
        dplyr::mutate(next_same = human_id == dplyr::lead(human_id) &
          notes == dplyr::lead(notes)) |>
        dplyr::filter(next_same) |>
        dplyr::filter(n_samps == suppressWarnings(max(n_samps))) |>
        dplyr::slice_max(thresh_low) |>
        tidyr::separate_longer_delim(c(human_id, log10_lr), delim = ",") |>
        dplyr::mutate(log10_lr = as.numeric(log10_lr)) |>
        dplyr::select(-c(next_same, n_samps))

      if (nrow(temp) > 0) {
        matches_thresh <- temp
      }
    }
  }

  return(matches_thresh)
}

#' Identify matches for multiple bloodmeal-human pairs
#'
#' @param log10_lrs Output from [calc_log10_lrs()]
#' @inheritParams bistro
#'
#' @return A tibble with the same output as for [bistro()].
#'
#' @export
#' @keywords internal
identify_matches <- function(log10_lrs, bloodmeal_ids = NULL) {
  if (is.null(bloodmeal_ids)) {
    bloodmeal_ids <- unique(log10_lrs$bloodmeal_id)
  }

  lapply(bloodmeal_ids, function(bm_id) {
    identify_one_match_set(log10_lrs, bm_id)
  }) |> dplyr::bind_rows()
}
