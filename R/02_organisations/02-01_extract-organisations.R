# load df_list
source("R/00_data_files.R")
source("R/variable_extract_helpers.R")

# 2009-13 organisations ----

org_2009 <- extract_csv_org_cols(
  csps_data_files$csps2009$organisations.c
)

org_2010 <- extract_csv_org_cols(
  csps_data_files$csps2010$organisations.c
)

org_2011 <- extract_csv_org_cols(
  csps_data_files$csps2011$organisations.c
)

org_2012 <- extract_csv_org_cols(
  csps_data_files$csps2012$organisations.c
)

org_2013 <- extract_csv_org_cols(
  csps_data_files$csps2013$organisations.c
)

org_2014 <- extract_csv_org_cols(
  csps_data_files$csps2014$organisations.c
)

org_2015 <- extract_csv_org_cols(
  csps_data_files$csps2015$organisations.c
)

# 2016-19 organisations ----
# organisation code also included in csv file

org_2016 <- extract_csv_org_cols(
  csps_data_files$csps2016$organisations.c,
  cols = 3,
  col_names = c("group", "organisation", "org_code")
)

org_2017 <- extract_csv_org_cols(
  csps_data_files$csps2017$organisations.c,
  cols = 3,
  col_names = c("group", "organisation", "org_code")
)

org_2018 <- extract_csv_org_cols(
  csps_data_files$csps2018$organisations.c,
  cols = 3,
  col_names = c("group", "organisation", "org_code")
)

org_2019 <- extract_csv_org_cols(
  csps_data_files$csps2019$organisations.c,
  cols = 3,
  col_names = c("group", "organisation", "org_code")
)

# 2020 organisations ----
# organisation data published only as ODS file

org_2020 <- extract_ods_org_cols(
  csps_data_files$csps2020$organisations.o,
  sheet = "Table_1",
  cols = 3,
  col_names = c("group", "org_code", "organisation")
)

# 2021-24 organisations ----
# organisation data included within benchmarks ODS file

org_2021 <- extract_ods_org_cols(
  path = csps_data_files$csps2021$benchmarks.o,
  sheet = "Table_3",
  cols = 3,
  skip = 5,
  col_names = c("org_code", "organisation", "group")
)

org_2022 <- extract_ods_org_cols(
  path = csps_data_files$csps2022$benchmarks.o,
  sheet = "Table_3",
  cols = 3,
  skip = 6,
  col_names = c("org_code", "organisation", "group")
)

org_2023 <- extract_ods_org_cols(
  path = csps_data_files$csps2023$benchmarks.o,
  sheet = "Table_3",
  cols = 3,
  skip = 6,
  col_names = c("org_code", "organisation", "group")
)

org_2024 <- extract_ods_org_cols(
  path = csps_data_files$csps2024$benchmarks.o,
  sheet = "Table_3",
  cols = 3,
  skip = 6,
  col_names = c("org_code", "organisation", "group")
)

# merged data ----

raw_tbl_orgs <- tibble::tibble(
  obj = ls(pattern = "^org", envir = .GlobalEnv)
) |>
  dplyr::mutate(
    year = as.integer(gsub("org_(\\d+)", "\\1", obj)),
    data = purrr::map(.x = obj, .f = ~ get(.x))
  ) |>
  tidyr::unnest(cols = data) |>
  tidyr::drop_na(organisation)

readr::write_excel_csv(
  raw_tbl_orgs,
  "proc/02_organisations/02_01-raw_tbl_orgs.csv",
  na = ""
)

tbl_unq_groups <- raw_tbl_orgs |>
  dplyr::summarise(
    year_from = min(year),
    year_to = max(year),
    .by = group
  ) |>
  tidyr::drop_na(group) |>
  dplyr::arrange(group)

readr::write_excel_csv(
  tbl_unq_group,
  "proc/02_organisations/02_01-tbl_unq_groups.csv",
  na = ""
)

readr::write_excel_csv(
  tbl_unq_grp |>
    dplyr::mutate(
      regex = NA_character_,
      uid_txt = NA_character_
    ),
  "proc/02_organisations/02_01-tbl_unq_grp_regex.csv",
  na = ""
)

tbl_unq_orgs <- raw_tbl_orgs |>
  dplyr::summarise(
    year_from = min(year),
    year_to = max(year),
    .by = organisation
  ) |>
  dplyr::arrange(organisation) |>
  dplyr::left_join(
    raw_tbl_orgs |>
      dplyr::distinct(organisation, org_code) |>
      tidyr::drop_na() |>
      dplyr::summarise(
        org_codes = paste(org_code, collapse = ", "),
        .by = organisation
      ),
    by = "organisation"
  ) |>
  dplyr::left_join(
    raw_tbl_orgs |>
      dplyr::distinct(organisation, group) |>
      tidyr::drop_na() |>
      dplyr::summarise(
        groups = paste(group, collapse = ", "),
        .by = organisation
      ),
    by = "organisation"
  )

readr::write_excel_csv(
  tbl_unq_orgs,
  "proc/02_organisations/02_01-tbl_unq_orgs.csv",
  na = ""
)

readr::write_excel_csv(
  tbl_unq_orgs |>
    dplyr::mutate(
      regex = NA_character_,
      uid_txt = NA_character_
    ),
  "proc/02_organisations/02_01-tbl_unq_orgs_regex.csv",
  na = ""
)
