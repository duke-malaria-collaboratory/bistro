#' Check bistro inputs
#'
#' @inheritParams bistro
#'
#' @return Error or nothing
#' @keywords internal
check_bistro_inputs <- function(bloodmeal_profiles, human_profiles, kit, threshT, pop_allele_freqs = NULL, calc_allele_freqs = FALSE, bloodmeal_ids = NULL, human_ids = NULL, rm_twins = TRUE, modelDegrad = TRUE, modelBWstutt = FALSE, modelFWstutt = FALSE, difftol = 1, threads = 4, seed = 1, time_limit = 3){

  check_colnames(bloodmeal_profiles, c('SampleName', 'Marker', 'Allele', 'Height'))
  check_colnames(human_profiles, c('SampleName', 'Marker', 'Allele'))
  check_ids(bloodmeal_ids, 'bloodmeal_ids')
  check_ids(human_ids, 'human_ids')

  kit_df <- check_kit(kit)

  check_setdiff_markers(toupper(unique(human_profiles$Marker)), toupper(unique(kit_df$Marker)), 'bloodmeal_profiles', 'kit')
  check_setdiff_markers(toupper(unique(human_profiles$Marker)), toupper(unique(kit_df$Marker)), 'human_profiles', 'kit')

  check_calc_allele_freqs(calc_allele_freqs)
  check_if_allele_freqs(pop_allele_freqs, calc_allele_freqs, kit_df)

  check_threshT(threshT)
  check_is_bool(rm_twins, 'rm_twins')
  check_is_bool(modelDegrad, 'modelDegrad')
  check_is_bool(modelBWstutt, 'modelBWstutt')
  check_is_bool(modelFWstutt, 'modelFWstutt')
  check_is_numeric(difftol, 'difftol', pos = TRUE)
  check_is_numeric(threads, 'threads', pos = TRUE)
  check_is_numeric(seed, 'seed')
  check_is_numeric(time_limit, 'time_limit', pos = TRUE)

}

#' Check is boolean
#'
#' @param vec vector to check
#' @param vec_name vector name
#'
#' @return Error or nothing
#' @keywords internal
check_is_bool <- function(vec, vec_name){
  if(!is.logical(vec)){
    stop(vec_name, " must be a logical (TRUE or FALSE), but is ", class(vec), '.')
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
check_is_numeric <- function(vec, vec_name, pos = FALSE){
  if(!is.numeric(vec)){
    stop(vec_name, " must be numeric, but is ", class(vec), '.')
  }else if(vec <= 0 & pos == TRUE){
    stop(vec_name, " must be greater than zero, but is ", vec, '.')
  }
}

#' Check calc_allele_freqs
#'
#' @inheritParams bistro
#'
#' @return Error or nothing
#' @keywords internal
check_calc_allele_freqs <- function(calc_allele_freqs){
  if(!is.null(calc_allele_freqs) & !is.logical(calc_allele_freqs)){
    stop("`calc_allele_freqs` must be NULL or a logical (TRUE or FALSE), but is ", class(calc_allele_freqs), '.')
  }
}

#' Check kit
#'
#' @inheritParams bistro
#'
#' @return Error if kit doesn't exist, dataframe of kit otherwise
#' @keywords internal
check_kit <- function(kit){
  kit_df <- euroformix::getKit(kit)
  if(all(is.na(kit_df))){
    stop('Kit ', kit, " does not exist in euroformix. Use `euroformix::getKit(kit)` for a list of preexisting kits in euroformix and `vignette('bistro')` for how to include a custom kit.")
  }else{
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
check_if_allele_freqs <- function(pop_allele_freqs, calc_allele_freqs, kit_df){
  if(!calc_allele_freqs & is.null(pop_allele_freqs)){
    stop("If `calc_allele_freqs = FALSE`, then `pop_allele_freqs` is required.")
  }else if(!is.null(pop_allele_freqs) & calc_allele_freqs == FALSE){
    check_colnames(pop_allele_freqs, c('Allele'))
    check_setdiff_markers(toupper(names(pop_allele_freqs)[!names(pop_allele_freqs) == 'Allele']), toupper(unique(kit_df$Marker)), 'pop_allele_freqs', 'kit')
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
check_setdiff_markers <- function(markers1, markers2, markers1_name, markers2_name){
  in_markers1_only <- setdiff(toupper(markers1), toupper(markers2))
  n_in_markers1_only <- length(in_markers1_only)
  in_markers2_only <- setdiff(toupper(markers2), toupper(markers1))
  n_in_markers2_only <- length(in_markers2_only)
  if(n_in_markers1_only > 0){
    warning(n_in_markers1_only, '/', length(markers1),  ' markers in ', markers1_name, ' but not in ', markers2_name, ': ', paste0(in_markers1_only, collapse = ','), '\n')
  }
  if(n_in_markers2_only > 0){
    warning(n_in_markers2_only, '/', length(markers2),  ' markers in ', markers2_name, ' but not in ', markers1_name, ': ', paste0(in_markers2_only, collapse = ','), '\n')
  }
}

#' Check input ids
#'
#' @param vec vector to check
#' @param vec_name vector name
#'
#' @return Error or nothing
#' @keywords internal
check_ids <- function(vec, vec_name){
  if(!is.null(vec) & !is.vector(vec)){
    stop(vec_name, ' must be NULL or a vector but is: ', class(vec))
  }
}

#' Check column names
#'
#' @param df Dataframe to check
#' @param expected_colnames Column names required to be resent
#'
#' @return Nothing or error
#' @keywords internal
check_colnames <- function(df, expected_colnames){
  # check if expected columns are present

  missing_colnames <- expected_colnames[!expected_colnames %in% names(df)]
  if(length(missing_colnames) > 0){
    stop(paste0("Not all expected column names are present. Missing: ", paste0(missing_colnames, collapse = ', ')))
  }
}

#' Check threshT
#'
#' @inheritParams bistro
#'
#' @return Error or nothing
#' @keywords internal
check_threshT <- function(threshT){
  if(!is.numeric(threshT)) stop("thresT must be numeric, but is ", class(threshT))
  if(threshT < 0) stop("thresT must be \u2265 0, but is ", threshT)
}