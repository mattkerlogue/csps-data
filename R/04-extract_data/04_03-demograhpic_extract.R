# CSPS data extraction and processing
# 03.02 extract demographic data
# ======
# This script works through files in raw-data folder and extracts data for the
# demographic scores.

# setup ---

source("R/00_data_files.R")
source("R/data_extract_helpers.R")

# 2013 to 2019 files ------
# From 2013 to 2019 demographic results were published in a similar format
# Excel file

df_2013_dem <- extract_demographic_data(
  csps_data_files$csps2013$demographics.x,
  sheet = "Scores",
  data_structure = list(
    data_zone = list(col_start = 3, row_start = 4),
    demographics = list(
      orientation = "landscape",
      start_index = 3,
      demographic_loc = 1,
      category_loc = 2
    ),
    measures = list(orientation = "portrait", start_index = 4, measure_loc = 1)
  ),
  value_convert = "scale_100"
)

df_2014_dem <- extract_demographic_data(
  csps_data_files$csps2014$demographics.x,
  sheet = "2014",
  data_structure = list(
    data_zone = list(col_start = 3, row_start = 4),
    demographics = list(
      orientation = "landscape",
      start_index = 3,
      demographic_loc = 1,
      category_loc = 2
    ),
    measures = list(orientation = "portrait", start_index = 4, measure_loc = 1)
  ),
  value_convert = "scale_100"
)

df_2015_dem <- extract_demographic_data(
  csps_data_files$csps2015$demographics.x,
  sheet = "2015",
  data_structure = list(
    data_zone = list(col_start = 3, row_start = 4),
    demographics = list(
      orientation = "landscape",
      start_index = 3,
      demographic_loc = 1,
      category_loc = 2
    ),
    measures = list(orientation = "portrait", start_index = 4, measure_loc = 1)
  ),
  value_convert = "scale_100"
)

df_2016_dem <- extract_demographic_data(
  csps_data_files$csps2016$demographics.x,
  sheet = "2016",
  data_structure = list(
    data_zone = list(col_start = 3, row_start = 4),
    demographics = list(
      orientation = "landscape",
      start_index = 3,
      demographic_loc = 1,
      category_loc = 2
    ),
    measures = list(orientation = "portrait", start_index = 4, measure_loc = 1)
  ),
  value_convert = "scale_100"
)

df_2017_dem <- extract_demographic_data(
  csps_data_files$csps2017$demographics.x,
  sheet = "2017",
  data_structure = list(
    data_zone = list(col_start = 3, row_start = 4),
    demographics = list(
      orientation = "landscape",
      start_index = 3,
      demographic_loc = 1,
      category_loc = 2
    ),
    measures = list(orientation = "portrait", start_index = 4, measure_loc = 1)
  ),
  # 2017 is missing a column header for detailed sexual orientation results
  insert = list(
    col = 182,
    row = 1,
    text = "Sexual identity - Detailed [J07]"
  ),
  value_convert = "scale_100"
)

df_2018_dem <- extract_demographic_data(
  csps_data_files$csps2018$demographics.x,
  sheet = "2018",
  data_structure = list(
    data_zone = list(col_start = 3, row_start = 4),
    demographics = list(
      orientation = "landscape",
      start_index = 3,
      demographic_loc = 1,
      category_loc = 2
    ),
    measures = list(orientation = "portrait", start_index = 4, measure_loc = 1)
  ),
  value_convert = "scale_100"
)

df_2019_dem <- extract_demographic_data(
  csps_data_files$csps2019$demographics.x,
  sheet = "2019",
  data_structure = list(
    data_zone = list(col_start = 3, row_start = 4),
    demographics = list(
      orientation = "landscape",
      start_index = 3,
      demographic_loc = 1,
      category_loc = 2
    ),
    measures = list(orientation = "portrait", start_index = 4, measure_loc = 1)
  ),
  value_convert = "scale_100"
)

# 2020 to 2024 files ------
# From 2020 onwards demographic scores are published as ODS files with a
# revised structure and format compared to the Excel files

df_2020_dem <- extract_demographic_data(
  csps_data_files$csps2020$demographics.o,
  sheet = "Benchmarks",
  data_structure = list(na = c("", "NA", "[z]", "[c]")),
  skip = 4
)

df_2021_dem <- extract_demographic_data(
  csps_data_files$csps2021$demographics.o,
  sheet = "Benchmarks",
  data_structure = list(drop_cols = 3, na = c("", "NA", "[z]", "[c]")),
  skip = 4
)

df_2022_dem <- extract_demographic_data(
  csps_data_files$csps2022$demographics.o,
  sheet = "Benchmarks",
  data_structure = list(drop_cols = 3, na = c("", "NA", "[z]", "[c]")),
  skip = 4
)

df_2023_dem <- extract_demographic_data(
  csps_data_files$csps2023$demographics.o,
  sheet = "Benchmarks",
  data_structure = list(drop_cols = 3, na = c("", "NA", "[z]", "[c]")),
  skip = 5
)

df_2024_dem <- extract_demographic_data(
  csps_data_files$csps2024$demographics.o,
  sheet = "Table_1",
  data_structure = list(drop_cols = 3, na = c("", "NA", "[z]", "[c]")),
  skip = 5
)

# combine data and extract

raw_tbl_dem_data <- tibble::tibble(
  obj = ls(pattern = "^df_\\d{4}_dem$", envir = .GlobalEnv)
) |>
  dplyr::mutate(
    obj_data = "demographic",
    obj_year = as.integer(gsub("df_(\\d{4})_dem", "\\1", obj)),
    data = purrr::map(.x = obj, .f = ~ get(.x))
  ) |>
  tidyr::unnest(data)

# combined csv is ~49 MB
# readr::write_excel_csv(
#   raw_tbl_dem_data,
#   "proc/04-extract_data/04_03-raw_tbl_dem_data.csv",
#   na = ""
# )
#
# can use group_walk to produce individual files but collectively still ~49MB
# raw_tbl_dem_data |>
#   dplyr::group_by(obj) |>
#   dplyr::group_walk(
#     .f = ~ readr::write_excel_csv(
#       .x,
#       file.path(
#         "proc",
#         "04-extract_data",
#         "04_03-demographics_raw",
#         paste0("", .y$obj, ".csv")
#       ),
#       na = ""
#     )
#   )

# parquet file is ~ 1.1MB
arrow::write_parquet(
  raw_tbl_dem_data,
  "proc/04-extract_data/04_03-raw_tbl_dem_data.parquet"
)
