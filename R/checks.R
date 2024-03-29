#' Check bistro inputs
#'
#' @inheritParams bistro
#'
#' @return Error or nothing
#' @keywords internal
check_bistro_inputs <-
  function(bloodmeal_profiles,
           human_profiles,
           kit,
           peak_thresh,
           pop_allele_freqs,
           calc_allele_freqs,
           bloodmeal_ids,
           human_ids,
           rm_twins,
           rm_markers,
           model_degrad,
           model_bw_stutt,
           model_fw_stutt,
           difftol,
           threads,
           seed,
           time_limit,
           return_lrs) {
    check_colnames(
      bloodmeal_profiles,
      c("SampleName", "Marker", "Allele", "Height")
    )
    check_colnames(human_profiles, c("SampleName", "Marker", "Allele"))
    check_present(bloodmeal_ids, bloodmeal_profiles, "SampleName")
    check_present(human_ids, human_profiles, "SampleName")
    check_present(rm_markers, human_profiles, "Marker")
    check_present(rm_markers, bloodmeal_profiles, "Marker")

    kit_df <- check_kit(kit)

    bm_prof_markers <- bloodmeal_profiles$Marker |>
      unique() |>
      toupper()
    hu_prof_markers <- human_profiles$Marker |>
      unique() |>
      toupper()
    kit_markers <- kit_df$Marker |>
      unique() |>
      toupper()

    if (!is.null(rm_markers)) {
      rm_markers <- toupper(rm_markers)
      bm_prof_markers <- bm_prof_markers[!bm_prof_markers %in% rm_markers]
      hu_prof_markers <- hu_prof_markers[!hu_prof_markers %in% rm_markers]
      kit_markers <- kit_markers[!kit_markers %in% rm_markers]
    }

    check_setdiff_markers(
      bm_prof_markers,
      kit_markers,
      "bloodmeal_profiles",
      "kit"
    )
    check_setdiff_markers(
      hu_prof_markers,
      kit_markers,
      "human_profiles",
      "kit"
    )

    check_calc_allele_freqs(calc_allele_freqs)
    check_if_allele_freqs(pop_allele_freqs, calc_allele_freqs, kit_df)

    check_peak_thresh(peak_thresh)
    check_is_bool(rm_twins)
    check_is_bool(model_degrad)
    check_is_bool(model_bw_stutt)
    check_is_bool(model_fw_stutt)
    check_is_bool(return_lrs)
    check_is_numeric(difftol, pos = TRUE)
    check_is_numeric(threads, pos = TRUE)
    if (!is.null(seed)) {
      check_is_numeric(seed)
    }
    check_is_numeric(time_limit, pos = TRUE)
  }

#' Check is boolean
#'
#' @param vec vector to check
#' @param vec_name vector name
#'
#' @return Error or nothing
#' @keywords internal
check_is_bool <- function(vec) {
  if (!is.logical(vec)) {
    stop(
      deparse(substitute(vec)),
      " must be a logical (TRUE or FALSE), but is ",
      class(vec),
      "."
    )
  }
}

#' Check is numeric
#'
#' @param vec vector to check
#' @param vec_name vector name
#' @param pos whether the number must be positive
#'
#' @return Error or nothing
#' @keywords internal
check_is_numeric <- function(vec, pos = FALSE) {
  if (!is.numeric(vec)) {
    stop(deparse(substitute(vec)), " must be numeric, but is ", class(vec), ".")
  } else if (vec <= 0 && pos == TRUE) {
    stop(deparse(substitute(vec)), " must be greater than zero, but is ", vec, ".")
  }
}

#' Check calc_allele_freqs
#'
#' @inheritParams bistro
#'
#' @return Error or nothing
#' @keywords internal
check_calc_allele_freqs <- function(calc_allele_freqs) {
  if (!is.null(calc_allele_freqs) && !is.logical(calc_allele_freqs)) {
    stop(
      "`calc_allele_freqs` must be NULL or a logical (TRUE or FALSE), but is ",
      class(calc_allele_freqs),
      "."
    )
  }
}

#' Check kit
#'
#' @inheritParams bistro
#'
#' @return Error if kit doesn't exist, dataframe of kit otherwise
#' @keywords internal
check_kit <- function(kit) {
  kit_df <- euroformix::getKit(kit)
  if (all(is.na(kit_df))) {
    stop(
      "Kit ",
      kit,
      " does not exist in euroformix. Use `euroformix::getKit(kit)` ",
      "for a list of preexisting kits in euroformix and ",
      "`vignette('bistro')` for how to include a custom kit."
    )
  } else {
    return(kit_df)
  }
}

#' Check calc_if_allele_freqs
#'
#' @param kit_df Kit dataframe from [euroformix::getKit()]
#' @inheritParams bistro
#'
#' @return Error or nothing
#' @keywords internal
check_if_allele_freqs <-
  function(pop_allele_freqs,
           calc_allele_freqs,
           kit_df) {
    if (!calc_allele_freqs && is.null(pop_allele_freqs)) {
      stop(
        "If `calc_allele_freqs = FALSE`, ",
        "then `pop_allele_freqs` is required."
      )
    } else if (!is.null(pop_allele_freqs) &&
      calc_allele_freqs == FALSE) {
      check_colnames(pop_allele_freqs, c("Allele"))

      pop_freq_markers <-
        toupper(names(pop_allele_freqs)[!names(pop_allele_freqs) == "Allele"])
      kit_markers <- toupper(unique(kit_df$Marker))
      check_setdiff_markers(
        pop_freq_markers,
        kit_markers,
        "pop_allele_freqs",
        "kit"
      )
    }
  }

#' Check what markers are present
#'
#' @param markers1 first vector to check
#' @param markers2 second vector to check
#' @param markers1_name first vector name
#' @param markers2_name second vector name
#'
#' @return Error or nothing
#' @keywords internal
check_setdiff_markers <-
  function(markers1,
           markers2,
           markers1_name,
           markers2_name) {
    in_markers1_only <- setdiff(toupper(markers1), toupper(markers2))
    in_markers1_only <- in_markers1_only[!is.na(in_markers1_only)]
    n_in_markers1_only <- length(in_markers1_only)
    in_markers2_only <-
      setdiff(toupper(markers2), toupper(markers1))
    in_markers2_only <- in_markers2_only[!is.na(in_markers2_only)]
    n_in_markers2_only <- length(in_markers2_only)
    if (n_in_markers1_only > 0) {
      message(
        n_in_markers1_only,
        "/",
        length(markers1),
        " markers in ",
        markers1_name,
        " but not in ",
        markers2_name,
        ": ",
        paste0(in_markers1_only, collapse = ",")
      )
    }
    if (n_in_markers2_only > 0) {
      message(
        n_in_markers2_only,
        "/",
        length(markers2),
        " markers in ",
        markers2_name,
        " but not in ",
        markers1_name,
        ": ",
        paste0(in_markers2_only, collapse = ",")
      )
    }
  }

#' Check input ids
#'
#' @param vec vector to check
#' @param vec_name vector name
#'
#' @return Error or nothing
#' @keywords internal
check_ids <- function(vec) {
  if (!is.null(vec) && !is.vector(vec)) {
    stop(deparse(substitute(vec)), " must be NULL or a vector but is: ", class(vec))
  }
}

#' Check column names
#'
#' @param df Dataframe to check
#' @param expected_colnames Column names required to be resent
#'
#' @return Nothing or error
#' @keywords internal
check_colnames <- function(df, expected_colnames) {
  # check if expected columns are present

  missing_colnames <-
    expected_colnames[!expected_colnames %in% names(df)]
  if (length(missing_colnames) > 0) {
    stop(paste0(
      "Not all expected column names are present in ", deparse(substitute(df)), ". Missing: ",
      paste0(missing_colnames, collapse = ", ")
    ))
  }
}

#' Check peak_thresh
#'
#' @inheritParams bistro
#'
#' @return Error or nothing
#' @keywords internal
check_peak_thresh <- function(peak_thresh) {
  if (!is.numeric(peak_thresh)) {
    stop("thresT must be numeric, but is ", class(peak_thresh))
  }
  if (peak_thresh < 0) {
    stop("thresT must be \u2265 0, but is ", peak_thresh)
  }
}

#' Check peak_thresh
#'
#' @param heights vector of peak heights
#' @inheritParams bistro
#'
#' @return Error or nothing
#' @keywords internal
check_heights <- function(heights, peak_thresh) {
  if (sum(heights >= peak_thresh, na.rm = TRUE) == 0) {
    stop("All bloodmeal peak heights below threshold of ", peak_thresh, ".")
  }
}

#' Check input to `create_db_from_bloodmeals()``
#'
#' @inheritParams bistro
#'
#' @return number of alleles in a complete profile
#'
#' @keywords internal
check_create_db_input <- function(bloodmeal_profiles,
                                  kit,
                                  peak_thresh,
                                  rm_markers) {
  check_colnames(
    bloodmeal_profiles,
    c("SampleName", "Marker", "Allele")
  )
  check_present(rm_markers, bloodmeal_profiles, "Marker")
  check_peak_thresh(peak_thresh)
  kit_df <- check_kit(kit)
  kit_markers <- kit_df$Marker |>
    unique() |>
    toupper()
  bm_prof_markers <- bloodmeal_profiles$Marker |>
    unique() |>
    toupper()
  if (!is.null(rm_markers)) {
    rm_markers <- toupper(rm_markers)
    bm_prof_markers <- bm_prof_markers[!bm_prof_markers %in% rm_markers]
    kit_markers <- kit_markers[!kit_markers %in% rm_markers]
  }
  check_setdiff_markers(
    bm_prof_markers,
    kit_markers,
    "bloodmeal_profiles",
    "kit"
  )
  length(kit_markers)
}

#' Check if input markers to remove are present in the dataset
#'
#' @param df Data frame to check against
#' @inheritParams bistro
#'
#' @return Warning or nothing
#' @keywords internal
check_present <- function(to_rm, df, col) {
  check_ids(to_rm)
  not_present <- setdiff(toupper(to_rm), toupper(unlist(df[, col])))
  if (length(not_present) > 0) {
    warning(
      "These are not present in ", deparse(substitute(df)), "[,", deparse(substitute(col)), "]: ",
      not_present
    )
  }
}
