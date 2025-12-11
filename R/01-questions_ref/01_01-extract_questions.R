# 01-01.  Question & metrics metadata processing
#         > Extract question wordings
# =========================================================================

# setup -------------------------------------------------------------------

# load df_list
source("R/00_data_files.R")
source("R/variable_extract_helpers.R")

# get questions -----------------------------------------------------------

## 2009-2013 benchmarks ----

cli::cli_progress_step("2009-2013 benchmarks")

# 2009-2013 benchmark scores are only available in a single 2013 publication
qs_2013_bm <- extract_csv_col1(
  csps_data_files$csps2013$benchmarks.c,
  locale = readr::locale(encoding = "latin1")
)

## 2009-2012 organisations ----

cli::cli_progress_step("2009-2012 organisation scores")

# 2009-2012 only organisation scores are published
qs_2009_org <- extract_csv_header(csps_data_files$csps2009$organisations.c)
qs_2009_org <- qs_2009_org[c(-1, -2)]
qs_2010_org <- extract_csv_header(csps_data_files$csps2010$organisations.c)
qs_2010_org <- qs_2010_org[c(-1, -2)]
qs_2011_org <- extract_csv_header(csps_data_files$csps2011$organisations.c)
qs_2011_org <- qs_2011_org[c(-1, -2)]
qs_2012_org <- extract_csv_header(csps_data_files$csps2012$organisations.c)
qs_2012_org <- qs_2012_org[c(-1, -2)]

## 2013 additional scores ----

cli::cli_progress_step("2013 additional scores")

# organisations
qs_2013_org <- extract_csv_header(csps_data_files$csps2013$organisations.c)
qs_2013_org <- qs_2013_org[c(-1, -2)]

# demographics
qs_2013_dem <- extract_csv_col1(csps_data_files$csps2013$demographics.c)

# scs 2009 to 2013 trend
qs_2013_scs <- extract_csv_col1(csps_data_files$csps2013$scs.c)

## 2014 scores ----

cli::cli_progress_step("2014 scores")

# benchmarks
qs_2014_bm <- extract_csv_col1(csps_data_files$csps2014$benchmarks.c)

# organisation scores
qs_2014_org <- extract_csv_header(csps_data_files$csps2014$organisations.c)
qs_2014_org <- qs_2014_org[c(-1, -2)]

# demographics
qs_2014_dem <- extract_csv_col1(csps_data_files$csps2014$demographics.c)
qs_2014_dem <- qs_2014_dem[4:122]

## 2015 scores ----

cli::cli_progress_step("2015 scores")

# benchmarks
qs_2015_bm <- extract_csv_col1(csps_data_files$csps2015$benchmarks.c)

# organisations
qs_2015_org <- extract_csv_header(csps_data_files$csps2015$organisations.c)
qs_2015_org <- qs_2015_org[c(-1, -2)]

# demographics
qs_2015_dem <- extract_csv_col1(csps_data_files$csps2015$demographics.c)
qs_2015_dem <- qs_2015_dem[4:132]

## 2016 scores ----

cli::cli_progress_step("2016 scores")

# benchmarks
qs_2016_bm <- extract_csv_col2(csps_data_files$csps2016$benchmarks.c)

# organisations
qs_2016_org <- extract_csv_header(csps_data_files$csps2016$organisations.c)
qs_2016_org <- qs_2016_org[c(-1, -2, -3)]

# demographics
qs_2016_dem <- extract_csv_col1(csps_data_files$csps2016$demographics.c)
qs_2016_dem <- qs_2016_dem[c(3, 5:127)]

cli::cli_progress_update(3)

## 2017 scores ----

cli::cli_progress_step("2017 scores")

# benchmarks
qs_2017_bm <- extract_csv_col2(csps_data_files$csps2017$benchmarks.c)

# organisations
qs_2017_org <- extract_csv_header(csps_data_files$csps2017$organisations.c)
qs_2017_org <- qs_2017_org[c(-1, -2, -3)]

# demographics
qs_2017_dem <- extract_excel_col(csps_data_files$csps2017$demographics.x)
qs_2017_dem <- qs_2017_dem[3:128]

## 2018 scores ----

cli::cli_progress_step("2018 scores")

# benchmarks
qs_2018_bm <- extract_csv_col2(csps_data_files$csps2018$benchmarks.c)

# mean scores
qs_2018_mean <- extract_csv_col2(csps_data_files$csps2018$means.c)

# organisations
qs_2018_org <- extract_csv_header(csps_data_files$csps2018$organisations.c)
qs_2018_org <- qs_2018_org[c(-1, -2, -3)]

# demographics
qs_2018_dem <- extract_excel_col(csps_data_files$csps2018$demographics.x)
qs_2018_dem <- qs_2018_dem[3:129]

## 2019 scores ----

cli::cli_progress_step("2019 scores")

# benchmark
qs_2019_bm <- extract_csv_col2(csps_data_files$csps2019$benchmarks.c)

# mean scores
qs_2019_mean <- extract_csv_col2(csps_data_files$csps2019$means.c)

# organisations
qs_2019_org <- extract_csv_header(csps_data_files$csps2019$organisations.c)
qs_2019_org <- qs_2019_org[c(-1, -2, -3)]

# demographics
qs_2019_dem <- extract_excel_col(csps_data_files$csps2019$demographics.x)
qs_2019_dem <- qs_2019_dem[3:133]

## 2020 scores ----

cli::cli_progress_step("2020 scores")

# benchmarks
qs_2020_bm <- extract_csv_col2(csps_data_files$csps2020$benchmarks.c)

# mean scores
qs_2020_mean <- extract_csv_col2(csps_data_files$csps2020$means.c)

# organisations
## in 2020 organisation scores were only published as an ODS file with the
## headline measures and individual question scores supplied in separate tabs
xqs_2020_org1 <- extract_ods_row(
  csps_data_files$csps2020$organisations.o,
  sheet = "Table_1",
  row = 0
)

xqs_2020_org2 <- extract_ods_row(
  csps_data_files$csps2020$organisations.o,
  sheet = "Table_2",
  row = 0
)

qs_2020_org <- c(xqs_2020_org1[4:16], xqs_2020_org2[4:85])

# demographics
qs_2020_dem <- extract_ods_row(
  csps_data_files$csps2020$demographics.o,
  sheet = "Benchmarks",
  row = 4
)
qs_2020_dem <- qs_2020_dem[3:146]

## 2021 scores ----
# note: from 2021 onwards all files are published as ODS files

cli::cli_progress_step("2021 scores")

# benchmarks
qs_2021_bm <- extract_ods_cols(
  csps_data_files$csps2021$benchmarks.o,
  sheet = "Table_1",
  start_col = 1,
  cols = 2,
  row_to_names = 4
)

# mean scores
qs_2021_mean <- extract_ods_cols(
  csps_data_files$csps2021$benchmarks.o,
  sheet = "Table_2",
  start_col = 1,
  cols = 2,
  row_to_names = 4
)

# organisations
## from 2021 the organisation scores are included within the benchmarks ODS file
qs_2021_org <- extract_ods_row(
  csps_data_files$csps2021$benchmarks.o,
  sheet = "Table_3",
  row = 4
)
qs_2021_org <- qs_2021_org[5:130]

# demographics
qs_2021_dem <- extract_ods_row(
  csps_data_files$csps2021$demographics.o,
  sheet = "Benchmarks",
  row = 4
)
qs_2021_dem <- qs_2021_dem[4:147]

## 2022 scores ----

cli::cli_progress_step("2022 scores")

# benchmarks
qs_2022_bm <- extract_ods_cols(
  csps_data_files$csps2022$benchmarks.o,
  sheet = "Table_1",
  start_col = 1,
  cols = 2,
  row_to_names = 5
)

# mean scores
qs_2022_mean <- extract_ods_cols(
  csps_data_files$csps2022$benchmarks.o,
  sheet = "Table_2",
  start_col = 1,
  cols = 2,
  row_to_names = 5
)

# organisations
qs_2022_org <- extract_ods_row(
  csps_data_files$csps2022$benchmarks.o,
  sheet = "Table_3",
  row = 5
)
qs_2022_org <- qs_2022_org[5:120]

# demographics
qs_2022_dem <- extract_ods_row(
  csps_data_files$csps2022$demographics.o,
  sheet = "Benchmarks",
  row = 4
)
qs_2022_dem <- qs_2022_dem[4:180]

## 2023 scores ----

cli::cli_progress_step("2023 scores")

# benchmarks
qs_2023_bm <- extract_ods_cols(
  csps_data_files$csps2023$benchmarks.o,
  sheet = "Table_1",
  start_col = 1,
  cols = 2,
  row_to_names = 4
)

# mean scores
qs_2023_mean <- extract_ods_cols(
  csps_data_files$csps2023$benchmarks.o,
  sheet = "Table_2",
  start_col = 1,
  cols = 2,
  row_to_names = 4
)

# organisations
qs_2023_org <- extract_ods_row(
  csps_data_files$csps2023$benchmarks.o,
  sheet = "Table_3",
  row = 5
)
qs_2023_org <- qs_2023_org[5:123]

# demographics
qs_2023_dem <- extract_ods_row(
  csps_data_files$csps2023$demographics.o,
  sheet = "Benchmarks",
  row = 5
)
qs_2023_dem <- qs_2023_dem[5:183]

## 2024 scores ----

cli::cli_progress_step("2024 scores")

# benchmarks
qs_2024_bm <- extract_ods_cols(
  csps_data_files$csps2024$benchmarks.o,
  sheet = "Table_1",
  start_col = 1,
  cols = 2,
  row_to_names = 4
)

# mean scores
qs_2024_mean <- extract_ods_cols(
  csps_data_files$csps2024$benchmarks.o,
  sheet = "Table_2",
  start_col = 1,
  cols = 2,
  row_to_names = 4
)

# organisations
qs_2024_org <- extract_ods_row(
  csps_data_files$csps2024$benchmarks.o,
  sheet = "Table_3",
  row = 5
)
qs_2024_org <- qs_2024_org[5:125]

# demographics
qs_2024_dem <- extract_ods_row(
  csps_data_files$csps2024$demographics.o,
  sheet = "Table_1",
  row = 5
)
qs_2024_dem <- qs_2024_dem[4:185]

# get unified data --------------------------------------------------------

cli::cli_progress_step("Merge data")

# function to extract question labels from objects
get_values <- function(x, class) {
  if (class == "character") {
    return(tibble::tibble(raw_measure = NA_character_, raw_label = get(x)))
  } else if (class == "tbl_df") {
    df <- get(x)
    return(df |> dplyr::select(raw_measure = Measure, raw_label = Label))
  } else {
    return(NULL)
  }
}

## raw table ---
raw_tbl_qs <- tibble::tibble(
  obj = ls(pattern = "^qs_", envir = .GlobalEnv)
) |>
  dplyr::mutate(
    obj_class = purrr::map_chr(.x = obj, .f = ~ class(get(.x))[1]),
    obj_labels = purrr::map2(
      .x = obj,
      .y = obj_class,
      .f = ~ get_values(.x, .y)
    )
  ) |>
  tidyr::unnest(obj_labels) |>
  dplyr::mutate(
    # handle windows encoding errors
    across(c(raw_measure, raw_label), ~ iconv(.x, "UTF-8", "UTF-8", ""))
  ) |>
  dplyr::filter(!is.na(raw_label) & raw_label != "")

cli::cli_progress_step("Write merged data to disk")

readr::write_excel_csv(
  raw_tbl_qs,
  "proc/01-questions_ref/01_01-raw_tbl_qs.csv",
  na = ""
)

cli::cli_progress_done()
