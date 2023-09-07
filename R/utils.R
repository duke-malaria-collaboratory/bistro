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
    "locus_count"
  )
)

# import euroformix (required to get kit)
#' @import euroformix

# no notes for codetools
ignore_unused_imports <- function() {
  codetools::checkUsage
}
