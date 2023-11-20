# global variables
utils::globalVariables(
  c(
    "Marker",
    "Allele",
    "allele_count",
    "locus_n",
    "freq",
    "SampleName",
    "Height",
    "peaks",
    "index",
    "Allele1",
    "Allele2",
    "all_alleles",
    "n",
    "log10_lr",
    "notes",
    "human_id",
    "thresh_low",
    "next_same",
    "n_samps",
    "bloodmeal_id",
    "human1",
    "human2",
    "hu1",
    "hu2",
    "similarity",
    "profile",
    "alleles",
    "est_noc",
    "locus_count",
    "n_markers",
    "n_alleles"
  )
)

# import euroformix (required to get kit)
#' @import euroformix

# no notes for codetools
ignore_unused_imports <- function() {
  codetools::checkUsage
}

#' Check package version
#'
#' @param pkg package to test
#' @param curr_version current package version
#' @param version required package version
#'
#' @return nothing or error if package version too old
#'
#' @keywords internal
check_pkg_version <- function(pkg, curr_version, version) {
  vers <- utils::compareVersion(as.character(curr_version), version)
  if (vers == -1) {
    stop(
      "The ", pkg, " package is version ", curr_version, " but must be >= ",
      version, ". Please update the package to use this function."
    )
  }
}
