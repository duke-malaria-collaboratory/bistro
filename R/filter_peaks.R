#' Filter peak heights that are under threshold
#'
#' @inheritParams bistro
#'
#' @return Filtered dataframe, error if all peak heights under threshold
#' @keywords internal
filter_peaks <- function(bloodmeal_profiles, threshT){

  if(!is.numeric(bloodmeal_profiles$Height)){
    warning("Converting Height column to numeric.")
    bloodmeal_profiles <- bloodmeal_profiles |>
      dplyr::mutate(Height = as.numeric(Height))
  }

  if(nrow(bloodmeal_profiles) == 0){
    message("No peak heights provided")
  }else{
  n_over_thresh <- sum(bloodmeal_profiles$Height >= threshT, na.rm = TRUE)
  if(n_over_thresh == 0){
    warning("All peak heights are under the threshold of ", threshT)
    bloodmeal_profiles <- bloodmeal_profiles |>
      dplyr::filter(Height >= threshT)
  }
  n_under_thresh <- sum(bloodmeal_profiles$Height < threshT, na.rm = TRUE)
  if(n_under_thresh > 0){
    bm_pre <- unique(bloodmeal_profiles$SampleName)
    message("Removing ", n_under_thresh, " peaks under the threshold of ", threshT, " RFU.")
    bloodmeal_profiles <- bloodmeal_profiles |>
      dplyr::filter(Height >= threshT)
    bm_post <- unique(bloodmeal_profiles$SampleName)
    length_diff <- length(bm_pre) - length(bm_post)
    if(length_diff != 0){
      message("For ", length_diff,"/", length(bm_pre), " bloodmeal ids, all peaks are below the threshold")
    }
  }
  }
  return(bloodmeal_profiles)
}


