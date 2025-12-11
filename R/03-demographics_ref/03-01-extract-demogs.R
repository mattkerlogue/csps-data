# CSPS data extraction and processing
# 03.01 extract demographics
# ======
# This script works through files in raw-data folder and scrapes files for
# the labels of demographic questions and categories.

# setup ------
source("R/00_data_files.R")
source("R/extract_helpers.R")

# 2013 to 2019 demographics ------
# 2013 to 2019 follow a similar format, published in Excel

dm_2013 <- extract_excel_dem_rows(
  csps_data_files$csps2013$demographics.x,
  sheet = "Scores",
  rows = 1:2,
  start_col = 3
)

dm_2014 <- extract_excel_dem_rows(
  csps_data_files$csps2014$demographics.x,
  sheet = "2014",
  rows = 1:2,
  start_col = 3
)

dm_2015 <- extract_excel_dem_rows(
  csps_data_files$csps2015$demographics.x,
  sheet = "2015",
  rows = 1:2,
  start_col = 3
)

dm_2016 <- extract_excel_dem_rows(
  csps_data_files$csps2016$demographics.x,
  sheet = "2016",
  rows = 1:2,
  start_col = 3
)

dm_2017 <- extract_excel_dem_rows(
  csps_data_files$csps2017$demographics.x,
  sheet = "2017",
  rows = 1:2,
  start_col = 3,
  # 2017 is missing a column header for detailed sexual orientation results
  insert = list(
    col = 182,
    row = 1,
    text = "Sexual identity - Detailed [J07]"
  )
)

dm_2018 <- extract_excel_dem_rows(
  csps_data_files$csps2018$demographics.x,
  sheet = "2018",
  rows = 1:2,
  start_col = 3
)

dm_2019 <- extract_excel_dem_rows(
  csps_data_files$csps2019$demographics.x,
  sheet = "2019",
  rows = 1:2,
  start_col = 3
)

# 2020 to 2024 demographics ------
# Following updates to government statistical service guidance on publishing
# spreadsheets from 2020 onwards the format of the demographics files changed,
# including a switch to using ODS files.

dm_2020 <- extract_ods_dem_cols(
  csps_data_files$csps2020$demographics.o,
  sheet = "Benchmarks",
  cols = 1:2,
  skip = 4
)

dm_2021 <- extract_ods_dem_cols(
  csps_data_files$csps2021$demographics.o,
  sheet = "Benchmarks",
  cols = 1:2,
  skip = 4
)

dm_2022 <- extract_ods_dem_cols(
  csps_data_files$csps2022$demographics.o,
  sheet = "Benchmarks",
  cols = 1:2,
  skip = 4
)

dm_2023 <- extract_ods_dem_cols(
  csps_data_files$csps2023$demographics.o,
  sheet = "Benchmarks",
  cols = 1:2,
  skip = 5
)

dm_2024 <- extract_ods_dem_cols(
  csps_data_files$csps2024$demographics.o,
  sheet = "Table_1",
  cols = 1:2,
  skip = 5
)

# create and output files for regex development ------

raw_tbl_dems <- tibble::tibble(
  obj = ls(pattern = "^dm_", envir = .GlobalEnv)
) |>
  dplyr::mutate(
    year = as.integer(gsub("\\D", "", obj, perl = TRUE)),
    dems = purrr::map(.x = obj, .f = ~ get(.x))
  ) |>
  tidyr::unnest(dems)

readr::write_excel_csv(
  raw_tbl_dems,
  "proc/03-demographics_ref/03_01-raw_tbl_dems.csv",
  na = ""
)

unq_demographic_qs <- raw_tbl_dems |>
  dplyr::mutate(demographic = stringr::str_squish(demographic)) |>
  dplyr::distinct(demographic) |>
  dplyr::arrange(demographic)

readr::write_excel_csv(
  unq_demographic_qs,
  "proc/03-demographics_ref/03_01-unq_demographic_qs.csv",
  na = ""
)

readr::write_excel_csv(
  unq_demographic_qs |>
    dplyr::mutate(uid_txt = NA_character_, regex = NA_character_),
  "proc/03-demographics_ref/03_01-unq_demographic_qs_regex.csv",
  na = ""
)

unq_categories <- raw_tbl_dems |>
  dplyr::mutate(
    category = gsub("\\(n.*\\)", "", category),
    category = stringr::str_squish(category)
  ) |>
  dplyr::distinct(category) |>
  dplyr::arrange(category)

readr::write_excel_csv(
  unq_categories,
  "proc/03-demographics_ref/03_01-unq_categories.csv",
  na = ""
)

readr::write_excel_csv(
  unq_categories |>
    dplyr::mutate(uid_txt = NA_character_, regex = NA_character_),
  "proc/03-demographics_ref/03_01-unq_categories_regex.csv",
  na = ""
)
