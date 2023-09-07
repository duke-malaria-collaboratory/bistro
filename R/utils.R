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
    "n_samps"
  )
)

# import euroformix (required to get kit)
#' @import euroformix

# no notes for codetools
ignore_unused_imports <- function() {
  codetools::checkUsage
}
