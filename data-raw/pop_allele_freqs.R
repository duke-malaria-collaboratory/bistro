## code to prepare `pop_allele_freqs` dataset
library(readr)
library(usethis)

pop_allele_freqs <- read_csv("data-raw/ESX17_Norway.csv")

write_csv(pop_allele_freqs, file = "data-raw/pop_allele_freqs.csv")

use_data(pop_allele_freqs, overwrite = TRUE)
