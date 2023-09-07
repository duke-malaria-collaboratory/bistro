#' Preprocess bloodmeal profiles
#'
#' Removes duplicates and peaks below threshold, subsets ids
#'
#' @inheritParams bistro
#'
#' @return Dataframe with preprocessed bloodmeal profiles
#' @export
#' @keywords internal
prep_bloodmeal_profiles <- function(bloodmeal_profiles,
                                    bloodmeal_ids = NULL,
                                    peak_thresh = NULL) {
  if (is.null(bloodmeal_ids)) {
    bloodmeal_ids <- unique(bloodmeal_profiles$SampleName)
  } else {
    bloodmeal_ids <-
      subset_ids(bloodmeal_ids, bloodmeal_profiles$SampleName)
  }

  bloodmeal_profiles <- bloodmeal_profiles |>
    dplyr::filter(SampleName %in% bloodmeal_ids) |>
    rm_dups()

  if (!is.null(peak_thresh)) {
    check_heights(bloodmeal_profiles$Height, peak_thresh)
    bloodmeal_profiles <- bloodmeal_profiles |>
      filter_peaks(peak_thresh)
  }

  return(bloodmeal_profiles)
}

#' Preprocess human profiles
#'
#' Removes duplicates and optionally twins, subsets ids
#'
#' @inheritParams bistro
#'
#' @return Dataframe with preprocessed human profiles
#' @export
#' @keywords internal
prep_human_profiles <- function(human_profiles,
                                human_ids = NULL,
                                rm_twins = TRUE) {
  if (rm_twins) {
    human_profiles <- rm_twins(human_profiles)
  }

  if (is.null(human_ids)) {
    human_ids <- unique(human_profiles$SampleName)
  } else {
    human_ids <- subset_ids(human_ids, human_profiles$SampleName)
  }

  human_profiles <- human_profiles |>
    dplyr::filter(SampleName %in% human_ids) |>
    rm_dups()

  return(human_profiles)
}

#' Remove duplicate rows with warning
#'
#' @param df Dataframe from which to remove duplicate rows
#'
#' @return Un-duplicated dataframe
#' @export
#' @keywords internal
rm_dups <- function(df) {
  n_orig <- nrow(df)
  if (n_orig != dplyr::n_distinct(df)) {
    df <- df |>
      dplyr::distinct()
    warning(paste0(
      "Detected and removed ",
      n_orig - nrow(df),
      " duplicate rows."
    ))
  }
  return(df)
}

#' Remove identical STR profiles
#'
#' @inheritParams bistro
#'
#' @return Data frame with twins removed
#' @export
#' @keywords internal
rm_twins <- function(human_profiles) {
  not_twins <- human_profiles |>
    dplyr::arrange(Marker, Allele) |>
    dplyr::group_by(SampleName) |>
    dplyr::summarize(all_alleles = stringr::str_c(paste0(Marker, Allele),
      collapse = ";"
    )) |>
    dplyr::group_by(all_alleles) |>
    dplyr::mutate(n = dplyr::n()) |>
    dplyr::filter(n == 1) |>
    dplyr::pull(SampleName)

  n_ident_profs <-
    dplyr::n_distinct(human_profiles$SampleName) - length(not_twins)

  if (n_ident_profs > 0) {
    message(
      paste0(
        "Identified ",
        n_ident_profs,
        " people whose profiles appear more than once",
        " (likely identical twins). These are being removed."
      )
    )
    human_profiles <- human_profiles |>
      dplyr::filter(SampleName %in% not_twins)
  }

  return(human_profiles)
}

#' Subset to ids present in the dataset
#'
#' @param ids ids to check if in vec
#' @param vec vector of ids
#' @param vec_name name of vector
#'
#' @return list of IDs that are present
#' @keywords internal
subset_ids <- function(ids, vec, vec_name) {
  id_absent <- setdiff(ids, vec)
  if (length(id_absent) > 0) {
    warning(
      "Removing ",
      length(id_absent),
      " ",
      vec_name,
      " not found in the dataset: ",
      id_absent
    )
  }
  ids <- intersect(ids, vec)
  if (length(ids) == 0) {
    stop("None of the provided ", vec_name, " are present in the dataset.")
  }
  return(ids)
}
