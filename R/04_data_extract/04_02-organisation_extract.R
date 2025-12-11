source("R/00_data_files.R")
source("R/data_extract_helpers.R")

df_2009_org <- long_csv(
  csps_data_files$csps2009$organisations.c,
  type = list(
    type = "organisation_csv",
    org_cols = 1:2,
    org_headers = c("dept_group", "organisation")
  ),
  na = c("", "NA", "n/a")
)

df_2010_org <- long_csv(
  csps_data_files$csps2010$organisations.c,
  type = list(
    type = "organisation_csv",
    org_cols = 1:2,
    org_headers = c("dept_group", "organisation")
  ),
  na = c("", "NA", "n/a")
)

df_2011_org <- long_csv(
  csps_data_files$csps2011$organisations.c,
  type = list(
    type = "organisation_csv",
    org_cols = 1:2,
    org_headers = c("dept_group", "organisation")
  ),
  values_convert = "scale_100",
  na = c("", "NA", "n/a")
)

df_2012_org <- long_csv(
  csps_data_files$csps2012$organisations.c,
  type = list(
    type = "organisation_csv",
    org_cols = 1:2,
    org_headers = c("dept_group", "organisation")
  ),
  na = c("", "NA", "n/a")
)

df_2013_org <- long_csv(
  csps_data_files$csps2013$organisations.c,
  type = list(
    type = "organisation_csv",
    org_cols = 1:2,
    org_headers = c("dept_group", "organisation")
  ),
  na = c("", "NA", "n/a")
)

df_2014_org <- long_csv(
  csps_data_files$csps2014$organisations.c,
  type = list(
    type = "organisation_csv",
    org_cols = 1:2,
    org_headers = c("dept_group", "organisation")
  ),
  na = c("", "NA", "n/a")
)

df_2015_org <- long_csv(
  csps_data_files$csps2015$organisations.c,
  type = list(
    type = "organisation_csv",
    org_cols = 1:2,
    org_headers = c("dept_group", "organisation")
  ),
  na = c("", "NA", "n/a"),
  cols = 1:92,
  locale = readr::locale(encoding = "latin1")
)

df_2016_org <- long_csv(
  csps_data_files$csps2016$organisations.c,
  type = list(
    type = "organisation_csv",
    org_cols = 1:3,
    org_headers = c("dept_group", "organisation", "org_code")
  ),
  na = c("", "NA", "n/a", ".")
)

df_2017_org <- long_csv(
  csps_data_files$csps2017$organisations.c,
  type = list(
    type = "organisation_csv",
    org_cols = 1:3,
    org_headers = c("dept_group", "organisation", "org_code")
  ),
  na = c("", "NA", "n/a", "n<10")
)

df_2018_org <- long_csv(
  csps_data_files$csps2018$organisations.c,
  type = list(
    type = "organisation_csv",
    org_cols = 1:3,
    org_headers = c("dept_group", "organisation", "org_code")
  ),
  na = c("", "NA", "n/a")
)

df_2019_org <- long_csv(
  csps_data_files$csps2019$organisations.c,
  type = list(
    type = "organisation_csv",
    org_cols = 1:3,
    org_headers = c("dept_group", "organisation", "org_code")
  ),
  na = c("", "NA", "n/a")
)

xdf_2020_org_1 <- extract_organisation_ods(
  csps_data_files$csps2020$organisations.o,
  sheet = "Table_1",
  org_cols = 1:3,
  org_headers = c("dept_group", "org_code", "organisation"),
  value_convert = "scale_100",
  na = c("", "NA", "n/a")
)

xdf_2020_org_2 <- extract_organisation_ods(
  csps_data_files$csps2020$organisations.o,
  sheet = "Table_2",
  org_cols = 1:3,
  org_headers = c("dept_group", "org_code", "organisation"),
  value_convert = "scale_100",
  na = c("", "NA", "n/a")
)

df_2020_org <- dplyr::bind_rows(xdf_2020_org_1, xdf_2020_org_2)

df_2021_org <- extract_organisation_ods(
  csps_data_files$csps2021$benchmarks.o,
  sheet = "Table_3",
  skip = 4,
  cols = -4,
  org_cols = 1:3,
  org_headers = c("org_code", "organisation", "dept_group"),
  na = c("", "NA", "n/a")
)

df_2022_org <- extract_organisation_ods(
  csps_data_files$csps2022$benchmarks.o,
  sheet = "Table_3",
  skip = 5,
  cols = -4,
  org_cols = 1:3,
  org_headers = c("org_code", "organisation", "dept_group"),
  na = c("", "NA", "n/a")
)

df_2023_org <- extract_organisation_ods(
  csps_data_files$csps2023$benchmarks.o,
  sheet = "Table_3",
  skip = 5,
  cols = -4,
  org_cols = 1:3,
  org_headers = c("org_code", "organisation", "dept_group"),
  na = c("", "NA", "n/a", "[c]")
)

df_2024_org <- extract_organisation_ods(
  csps_data_files$csps2024$benchmarks.o,
  sheet = "Table_3",
  skip = 5,
  cols = -4,
  org_cols = 1:3,
  org_headers = c("org_code", "organisation", "dept_group"),
  na = c("", "NA", "n/a", "[c]")
)

raw_tbl_org_data <- tibble::tibble(
  obj = ls(pattern = "^df_(\\d{4})_org$", envir = .GlobalEnv)
) |>
  dplyr::mutate(
    obj_data = "organisation",
    obj_year = as.integer(gsub("df_(\\d{4})_.*", "\\1", obj)),
    data = purrr::map(.x = obj, .f = ~ get(.x))
  ) |>
  tidyr::unnest(data) |>
  dplyr::relocate(org_code, .after = organisation)

# csv file is ~24MB in size, parquet is < 1MB
# readr::write_excel_csv(
#   raw_tbl_org,
#   "proc/04_extract/04_02-raw_tbl_org_data.csv",
#   na = ""
# )

arrow::write_parquet(
  raw_tbl_org_data,
  "proc/04_extract/04_02-raw_tbl_org_data.parquet"
)
