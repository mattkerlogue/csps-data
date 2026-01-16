# CSPS data extraction and processing
# 04.02 process organisation data
# ======

# setup ------

source("R/utils/text_to_uid.R")
source("R/utils/extract_response_category.R")
source("R/utils/hash_time.R")

raw_tbl_org_data <- arrow::read_parquet(
  "proc/04-extract_data/04_02-raw_tbl_org_data_692a26db.parquet"
)

qs_regex <- readr::read_csv(
  "proc/csps_questions_ref.csv",
  show_col_types = FALSE
)

measures_lookup <- readr::read_csv(
  "proc/csps_measures_lookup.csv",
  show_col_types = FALSE
)

org_regex <- readr::read_csv(
  "proc/csps_org_regex.csv",
  show_col_types = FALSE
)

# match questions and organisations ------

# questions
raw_unq_qm <- raw_tbl_org_data |>
  dplyr::distinct(question_measure) |>
  dplyr::mutate(
    qm_text = stringr::str_squish(tolower(question_measure)),
    uid_qm_txt = purrr::map_chr(
      .x = qm_text,
      .f = ~ text_to_uid(.x, qs_regex$regex, qs_regex$uid_qm_txt)
    ),
    uid_qm_num = purrr::map_chr(
      .x = qm_text,
      .f = ~ text_to_uid(.x, qs_regex$regex, qs_regex$uid_qm_num)
    )
  )

raw_unq_org <- raw_tbl_org_data |>
  dplyr::distinct(organisation) |>
  dplyr::mutate(
    uid_org_txt = purrr::map_chr(
      .x = stringr::str_squish(tolower(organisation)),
      .f = ~ text_to_uid(.x, org_regex$regex, org_regex$uid_org_txt)
    )
  )

tbl_org_data_proc <- raw_tbl_org_data |>
  dplyr::left_join(raw_unq_qm, by = "question_measure") |>
  dplyr::mutate(
    year = obj_year,
    measure = dplyr::if_else(is.na(uid_qm_num), qm_text, NA_character_)
  ) |>
  dplyr::rows_patch(
    measures_lookup |>
      dplyr::add_count(year, measure) |>
      dplyr::filter(n == 1) |>
      dplyr::select(-n),
    by = c("year", "measure"),
    unmatched = "ignore"
  ) |>
  dplyr::left_join(raw_unq_org, by = "organisation")

tbl_resp_cat <- tbl_org_data_proc |>
  dplyr::distinct(qm_text, uid_qm_num, uid_qm_txt) |>
  dplyr::mutate(
    response_category = purrr::pmap_chr(
      .l = list(
        qm_text = qm_text,
        uid_qm_txt = uid_qm_txt,
        uid_qm_num = uid_qm_num
      ),
      .f = extract_response_cat
    )
  )

tbl_org_data_out <- tbl_org_data_proc |>
  dplyr::left_join(
    tbl_resp_cat,
    by = c("qm_text", "uid_qm_num", "uid_qm_txt")
  ) |>
  dplyr::select(
    data_type = obj_data,
    year,
    uid_org_txt,
    uid_qm_num,
    uid_qm_txt,
    response_category,
    value
  ) |>
  dplyr::arrange(year, uid_org_txt, uid_qm_num, response_category)

hash_time()

# single CSV is 12MB
readr::write_excel_csv(
  tbl_org_data_out,
  file.path(
    "data",
    "02-organisations",
    paste0(
      "csps_organisations_2009-2024_",
      .csps_hash_time$hash_short,
      ".csv"
    )
  ),
  na = ""
)

# parquet file is ~470KB
arrow::write_parquet(
  tbl_org_data_out,
  file.path(
    "data",
    "02-organisations",
    paste0(
      "csps_organisations_2009-2024_",
      .csps_hash_time$hash_short,
      ".parquet"
    )
  )
)

# write by year csv files
tbl_org_data_out |>
  dplyr::group_by(year) |>
  dplyr::group_walk(
    .f = ~ readr::write_excel_csv(
      .x,
      file.path(
        "data",
        "02-organisations",
        "by_year",
        paste0(
          "csps_organisations_",
          .y$year,
          "_",
          .csps_hash_time$hash_short,
          ".csv"
        )
      ),
      na = ""
    )
  )
