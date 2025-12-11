source("R/00_data_files.R")
source("R/data_extract_helpers.R")

df_2013_csbm <- long_csv(
  csps_data_files$csps2013$benchmarks.c,
  type = list(type = "benchmark_csv"),
  cols = 1:6,
  locale = readr::locale(encoding = "latin1"),
  na = c("", "NA", "n/a")
)

df_2014_csbm <- long_csv(
  csps_data_files$csps2014$benchmarks.c,
  type = list(type = "benchmark_csv"),
  na = c("", "NA", "n/a")
)

df_2015_csbm <- long_csv(
  csps_data_files$csps2015$benchmarks.c,
  type = list(type = "benchmark_csv"),
  na = c("", "NA", "n/a")
)

df_2016_csbm <- long_csv(
  csps_data_files$csps2016$benchmarks.c,
  type = list(type = "benchmark_csv"),
  values_convert = "scale_100",
  cols = 2:10,
  na = c("", "NA", "n/a")
)

df_2017_csbm <- long_csv(
  csps_data_files$csps2017$benchmarks.c,
  type = list(type = "benchmark_csv"),
  values_convert = "scale_100",
  cols = 2:11,
  na = c("", "NA", "n/a")
)

df_2018_csbm <- long_csv(
  csps_data_files$csps2018$benchmarks.c,
  type = list(type = "benchmark_csv"),
  values_convert = "scale_100",
  cols = 2:12,
  na = c("", "NA", "n/a")
)

df_2018_mean <- long_csv(
  csps_data_files$csps2018$means.c,
  type = list(type = "benchmark_csv"),
  values_convert = "scale_100",
  cols = 2:12,
  na = c("", "NA", "n/a")
)

df_2019_csbm <- long_csv(
  csps_data_files$csps2019$benchmarks.c,
  type = list(type = "benchmark_csv"),
  values_convert = "scale_100",
  cols = 2:13,
  na = c("", "NA", "n/a")
)

df_2019_mean <- long_csv(
  csps_data_files$csps2019$means.c,
  type = list(type = "benchmark_csv"),
  values_convert = "scale_100",
  cols = 2:12,
  na = c("", "NA", "n/a")
)

df_2020_csbm <- long_csv(
  csps_data_files$csps2020$benchmarks.c,
  type = list(type = "benchmark_csv"),
  values_convert = "scale_100",
  cols = c(2, 4:15),
  na = c("", "NA", "n/a")
)

df_2020_mean <- long_csv(
  csps_data_files$csps2020$means.c,
  type = list(type = "benchmark_csv"),
  values_convert = "scale_100",
  cols = c(2, 4:15),
  na = c("", "NA", "n/a")
)

df_2021_csbm <- extract_benchmark_ods(
  csps_data_files$csps2021$benchmarks.o,
  sheet = "Table_1",
  cols = c(2, 5:17),
  skip = 4,
  na = c("", "NA", "n/a", "[z]")
)

df_2021_mean <- extract_benchmark_ods(
  csps_data_files$csps2021$benchmarks.o,
  sheet = "Table_2",
  cols = c(2, 5:17),
  skip = 4,
  na = c("", "NA", "n/a", "[z]")
)

df_2022_csbm <- extract_benchmark_ods(
  csps_data_files$csps2022$benchmarks.o,
  sheet = "Table_1",
  cols = c(2, 5:18),
  skip = 5,
  na = c("", "NA", "n/a", "[z]")
)

df_2022_mean <- extract_benchmark_ods(
  csps_data_files$csps2022$benchmarks.o,
  sheet = "Table_2",
  cols = c(2, 5:18),
  skip = 5,
  na = c("", "NA", "n/a", "[z]")
)

df_2023_csbm <- extract_benchmark_ods(
  csps_data_files$csps2023$benchmarks.o,
  sheet = "Table_1",
  cols = c(2, 5:19),
  skip = 4,
  na = c("", "NA", "n/a", "[z]")
)

df_2023_mean <- extract_benchmark_ods(
  csps_data_files$csps2023$benchmarks.o,
  sheet = "Table_2",
  cols = c(2, 5:19),
  skip = 4,
  na = c("", "NA", "n/a", "[z]")
)

df_2024_csbm <- extract_benchmark_ods(
  csps_data_files$csps2024$benchmarks.o,
  sheet = "Table_1",
  cols = c(2, 5:20),
  skip = 4,
  na = c("", "NA", "n/a", "[z]")
)

df_2024_mean <- extract_benchmark_ods(
  csps_data_files$csps2024$benchmarks.o,
  sheet = "Table_2",
  cols = c(2, 5:20),
  skip = 4,
  na = c("", "NA", "n/a", "[z]")
)

raw_tbl_bm_data <- tibble::tibble(
  obj = ls(pattern = "^df_\\d{4}_(csbm|mean)$", envir = .GlobalEnv)
) |>
  dplyr::mutate(
    obj_data = dplyr::if_else(grepl("_csbm$", obj), "benchmark", "mean"),
    obj_year = as.integer(gsub("df_(\\d+)_.*", "\\1", obj)),
    data = purrr::map(.x = obj, .f = ~ get(.x))
  ) |>
  tidyr::unnest(data)

# readr::write_excel_csv(
#   raw_tbl_bm,
#   "proc/04-extract_data/04_01-raw_tbl_bm_data.csv",
#   na = ""
# )

arrow::write_parquet(
  raw_tbl_bm_data,
  "proc/04-extract_data/04_01-raw_tbl_bm_data.parquet"
)
