% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calc_allele_freqs.R
\name{calc_allele_freqs}
\alias{calc_allele_freqs}
\title{Calculate allele frequencies}
\usage{
calc_allele_freqs(human_profiles, rm_markers = NULL, check_inputs = TRUE)
}
\arguments{
\item{human_profiles}{Tibble or data frame with alleles for all humans in
reference database including three columns: SampleName, Marker, Allele.}

\item{rm_markers}{A vector indicating what markers should be removed prior to
calculating log10LRs. NULL to include all markers. By default, for the
bistro function AMEL is removed as it is not standard to include it in LR
calculations.}

\item{check_inputs}{A boolean indicating whether or not to check the
inputs to the function. Default: TRUE}
}
\value{
A tibble where the first column is the STR allele and the following
columns are the frequency of that allele for different markers. Alleles
that do not exist for a given marker are coded as NA.
}
\description{
Calculate allele frequencies for a (generally human) population.
}
\examples{
calc_allele_freqs(human_profiles)
}
