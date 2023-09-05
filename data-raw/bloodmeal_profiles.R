## code to prepare `bloodmeal_profiles` dataset
library(dplyr, warn.conflicts = FALSE)
library(readr)
library(tidyr)
library(stringr)
library(usethis)

full_profile <- read_delim("data-raw/stain.txt") |>
  select(-ADO, -UD1, -`...17`) |>
  mutate(
    across(starts_with("Allele"), as.character),
    across(starts_with("Height"), as.character)
  ) |>
  pivot_longer(
    cols = c(starts_with("Allele"), starts_with("Height")),
    names_to = "names",
    values_to = "value"
  ) |>
  drop_na() |>
  filter(str_detect(names, "Allele")) |>
  mutate(index = substr(names, 8, 8)) |>
  select(-names) |>
  rename(Allele = value) |>
  left_join(read_delim("data-raw/stain.txt") |>
    select(-ADO, -UD1, -`...17`) |>
    mutate(
      across(starts_with("Allele"), as.character),
      across(starts_with("Height"), as.character)
    ) |>
    pivot_longer(
      cols = c(starts_with("Allele"), starts_with("Height")),
      names_to = "names", values_to = "value"
    ) |>
    drop_na() |>
    filter(str_detect(names, "Height")) |>
    mutate(index = substr(names, 8, 8)) |>
    select(-names) |>
    rename(Height = value)) |>
  select(-index) |>
  rename(SampleName = `Sample Name`) |>
  arrange(SampleName, Marker, Allele) |>
  mutate(Height = as.numeric(Height))

partial_profile_1 <- full_profile |>
  filter(Marker == "D1S1656") |>
  mutate(SampleName = "evid2")

partial_profile_2 <- full_profile |>
  filter(Allele %in% c("9", "16.3", "20", "9", "29.2", "6", "13")) |>
  mutate(SampleName = "evid3")

no_profile <- full_profile |>
  slice_head(n = 1) |>
  mutate(
    Marker = NA,
    Allele = NA,
    Height = NA
  ) |>
  mutate(SampleName = "evid4")

bloodmeal_profiles <- bind_rows(
  full_profile,
  partial_profile_1,
  partial_profile_2,
  no_profile
)

write_csv(bloodmeal_profiles, file = "data-raw/bloodmeal_profiles.csv")

use_data(bloodmeal_profiles, overwrite = TRUE)
