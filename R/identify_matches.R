#' Identify matches between a bloodmeal and human references
#'
#' @param log10LRs output from [calc_log10LRs()]
#'
#' @return tibble with matches for bloodmeal-human pairs including bloodmeal_id, bloodmeal_locus_count (number of STR loci used for matching), est_noc (estimated number of contributors), match, human_id (if match), log10LR (log10 likelihood ratio), note
#' @inheritParams calc_one_log10LR
#' @keywords internal
identify_one_match_set <- function(log10LRs, bloodmeal_id){

  bm_id <- bloodmeal_id
  log10LRs <- log10LRs |>
    dplyr::filter(bloodmeal_id == bm_id)

  est_noc <- unique(log10LRs$est_noc)
  bloodmeal_locus_count <- unique(log10LRs$bloodmeal_locus_count)
  notes <- stringr::str_c(unique(log10LRs$note), collapse = ";")

  matches <- tibble::tibble(bloodmeal_id = bloodmeal_id,
                    est_noc = est_noc,
                    bloodmeal_locus_count = bloodmeal_locus_count,
                    match = "no",
                    human_id = NA,
                    log10LR = NA,
                    note = notes,
                    thresh_low = NA)

  if(all(is.na(log10LRs$log10LR))){
    matches_thresh <- matches
  }else if(max(log10LRs$log10LR[!is.infinite(log10LRs$log10LR)]) < 1.5 & is.na(notes)){
    matches_thresh <- matches |>
      dplyr::mutate(note = "all log10LR < 1.5")
  } else {

    # matches can only have log10LRs > 1
    log10LRs <- log10LRs |>
      dplyr::filter(log10LR > 1 & !is.infinite(log10LR))

    thresh = floor(max(log10LRs$log10LR)*2)/2

    mht <- NULL

    # screen thresholds
    while(TRUE){
      matches_thresh <- log10LRs |>
        dplyr::filter(log10LR >= thresh) |>
        dplyr::mutate(note = ifelse(dplyr::n() > est_noc, '> min NOC matches', 'passed all filters'),
               match = ifelse(note == 'passed all filters', 'yes', 'no'),
               human_id = ifelse(note == '> min NOC matches', NA, human_id),
               log10LR = ifelse(note == '> min NOC matches', NA, log10LR),
               thresh_low = thresh) |>
        dplyr::select(bloodmeal_id, est_noc, bloodmeal_locus_count, match, human_id, log10LR, note, thresh_low) |>
        dplyr::distinct() # do we need this?

      matches <- matches |>
        dplyr::bind_rows(matches_thresh)

      thresh <- thresh - 0.5

      # if(thresh == 0.5) break

      mlt <- matches_thresh |>
        dplyr::arrange(human_id) |>
        dplyr::pull(human_id)

      if((identical(mht, mlt) & nrow(matches_thresh) == est_noc) | matches_thresh$note[1] == '> min NOC matches' | thresh == 0.5) { # & !all(is.na(mlt))) {
        break
      }

      mht <- mlt

    }

      if(nrow(matches_thresh) < est_noc | matches_thresh$note[1] == '> min NOC matches' | matches_thresh$thresh_low[1] == 1){ # are 1st and last both required?
      temp <- matches |>
        dplyr::filter(note != '> min NOC matches') |>
        dplyr::group_by(thresh_low) |>
        dplyr::mutate(n_samps = dplyr::n_distinct(human_id),
                      human_id = stringr::str_c(human_id, collapse = ","),
                      log10LR = stringr::str_c(log10LR, collapse = ",")) |>
        dplyr::ungroup() |>
        dplyr::distinct() |>
        dplyr::arrange(thresh_low) |>
        dplyr::mutate(next_same = human_id == dplyr::lead(human_id) & note == dplyr::lead(note)) |>
        dplyr::filter(next_same) |>
        dplyr::filter(n_samps == suppressWarnings(max(n_samps))) |>
        dplyr::slice_max(thresh_low) |>
        tidyr::separate_longer_delim(c(human_id, log10LR), delim = ",") |>
        dplyr::mutate(log10LR = as.numeric(log10LR)) |>
        dplyr::select(-c(next_same, n_samps))

      if(nrow(temp) > 0){
        matches_thresh <- temp
      }

    }

  }

  return(matches_thresh)

}

#' Identify matches for multiple bloodmeal-human pairs
#'
#' @param log10LRs Output from [calc_log10LRs()]
#' @inheritParams bistro
#'
#' @return A tibble with the same output as for [bistro()].
#'
#' @export
#' @keywords internal
identify_matches <- function(log10LRs, bloodmeal_ids = NULL){

  if(is.null(bloodmeal_ids)) bloodmeal_ids <- unique(log10LRs$bloodmeal_id)

  lapply(bloodmeal_ids, function(bm_id){
    identify_one_match_set(log10LRs, bm_id)
  }) |> dplyr::bind_rows()
}

