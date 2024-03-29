% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/match_similarity.R
\name{match_similarity}
\alias{match_similarity}
\title{Identify similarity matches between STR profiles from bloodmeals and a human
database}
\usage{
match_similarity(
  bloodmeal_profiles,
  human_profiles,
  bloodmeal_ids = NULL,
  human_ids = NULL,
  peak_thresh = NULL,
  rm_twins = TRUE,
  rm_markers = NULL,
  return_similarities = FALSE
)
}
\arguments{
\item{bloodmeal_profiles}{Tibble or data frame with alleles for all
bloodmeals in reference database including 4 columns: SampleName, Marker,
Allele, Height. Height must be numeric or coercible to numeric.}

\item{human_profiles}{Tibble or data frame with alleles for all humans in
reference database including three columns: SampleName, Marker, Allele.}

\item{bloodmeal_ids}{Vector of bloodmeal ids from the SampleName column in
\code{bloodmeal_profiles} for which to compute log10_lrs. If NULL, all ids in
the input dataframe will be used. Default: NULL}

\item{human_ids}{Vector of human ids from the SampleName column in
\code{human_profiles} for which to compute log10_lrs. If NULL, all ids in the
input dataframe will be used. Default: NULL}

\item{peak_thresh}{Allele peak height threshold in RFUs. All peaks under this
threshold will be filtered out. If prior filtering was performed, this
number should be equal to or greater than that number. Also used for
\code{threshT} argument in \code{\link[euroformix:contLikSearch]{euroformix::contLikSearch()}}.}

\item{rm_twins}{A boolean indicating whether or not to remove likely twins
(identical STR profiles) from the human database prior to identifying
matches. Default: TRUE}

\item{rm_markers}{A vector indicating what markers should be removed prior to
calculating log10LRs. NULL to include all markers. By default, for the
bistro function AMEL is removed as it is not standard to include it in LR
calculations.}

\item{return_similarities}{A boolean indicating whether or not to return
human-human and bloodmeal-human. Default: FALSE}
}
\value{
Dataframe with three columns:
\itemize{
\item \code{bloodmeal_id}: bloodmeal ID
\item \code{human_id}: human ID of match (or NA)
\item \code{match}: whether or not a match was identified (yes or no)
\item \code{similarity}: similarity value if a match as found

If \code{return_similarities = TRUE}, then a named list of length 4 is returned:
\item \code{matches}: the dataframe described above
\item \code{max_hu_hu_similarity}: maximum human-human similarity
(the threshold used for matching)
\item \code{hu_hu_similarities}: all human-human similarity values,
\code{bm_hu_similarities}: all bloodmeal-human similarities for profiles that
have identical alleles at at least one marker
}
}
\description{
Match STR profiles between bloodmeals and humans based on threshold of most
similar human-human pair. Twins are not included when computing the
threshold. Note that bloodmeal peak height threshold is optional here because
it is only used for filtering. Also note that if \code{rm_twins = FALSE}, then a
match to a twin will result in multiple rows returned for that bloodmeal.
}
\examples{
match_similarity(bloodmeal_profiles, human_profiles)
}
