## code to prepare `human_profiles` dataset
library(dplyr, warn.conflicts = FALSE)
library(readr)
library(tidyr)
library(usethis)

human_profiles <- read_delim("data-raw/databaseESX17.txt") |>
  bind_rows(read_csv("data-raw/refs.csv") |>
    rename(
      `Allele 1` = Allele1,
      `Allele 2` = Allele2,
      `Sample Name` = SampleName
    )) |>
  pivot_longer(
    cols = starts_with("Allele"),
    names_to = "name",
    values_to = "Allele"
  ) |>
  select(-name) |>
  rename(SampleName = `Sample Name`) |>
  arrange(SampleName, Marker, Allele) |>
  distinct() |>
  filter(SampleName %in% c(
    "00-JP0001-14_20142342311_NO-3241",
    "P1", "P2"
  ))

write_csv(human_profiles, file = "data-raw/human_profiles.csv")

use_data(human_profiles, overwrite = TRUE)
