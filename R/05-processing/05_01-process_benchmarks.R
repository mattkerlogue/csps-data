# CSPS data extraction and processing
# 04.01 process benchmark data
# ======

# setup ------

source("R/utils/text_to_uid.R")
source("R/utils/extract_response_category.R")
source("R/utils/hash_time.R")

raw_tbl_bm_data <- arrow::read_parquet(
  "proc/04-extract_data/04_01-raw_tbl_bm_data_692a26db.parquet"
)

qs_regex <- readr::read_csv(
  "proc/csps_questions_ref.csv",
  show_col_types = FALSE
)

# question regex matching ------

# get unique set of question text, match to ids and extract responses
raw_unq_qm <- raw_tbl_bm_data |>
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
    ),
    response_category = purrr::pmap_chr(
      .l = list(
        qm_text = qm_text,
        uid_qm_txt = uid_qm_txt,
        uid_qm_num = uid_qm_num
      ),
      .f = extract_response_cat
    )
  )

# match back to main table
tbl_bm_data_proc <- raw_tbl_bm_data |>
  dplyr::left_join(raw_unq_qm, by = "question_measure")

# output datasets ------

# get the very latest values
tbl_bm_latest_values <- tbl_bm_data_proc |>
  dplyr::filter(
    obj_year == max(obj_year),
    .by = c(obj_data, year, uid_qm_num, response_category)
  ) |>
  dplyr::select(
    data_type = obj_data,
    year,
    uid_qm_num,
    uid_qm_txt,
    response_category,
    value
  ) |>
  dplyr::arrange(data_type, year, uid_qm_num, response_category)

# get historical variation
tbl_bm_historic <- tbl_bm_data_proc |>
  dplyr::arrange(obj_data, uid_qm_num, response_category, year, -obj_year) |>
  dplyr::mutate(value_round = round(value, 0)) |>
  dplyr::distinct(
    obj_data,
    uid_qm_num,
    response_category,
    year,
    value_round,
    .keep_all = TRUE
  ) |>
  dplyr::add_count(obj_data, uid_qm_num, response_category, year) |>
  dplyr::filter(n > 1) |>
  dplyr::filter(
    obj_year != max(obj_year),
    .by = c(obj_data, uid_qm_num, response_category, year)
  ) |>
  dplyr::select(
    src_year = obj_year,
    data_type = obj_data,
    uid_qm_num,
    uid_qm_txt,
    year,
    response_category,
    value
  ) |>
  dplyr::arrange(data_type, uid_qm_num, year, response_category, value)

hash_time()

# write latest values
readr::write_excel_csv(
  tbl_bm_latest_values,
  file.path(
    "data",
    "01-benchmarks",
    paste0(
      "csps_benchmarks_2009-2024_",
      .csps_hash_time$hash_short,
      ".csv"
    )
  ),
  na = ""
)

# write historic variations
readr::write_excel_csv(
  tbl_bm_historic,
  file.path(
    "data",
    "01-benchmarks",
    paste0(
      "csps_benchmarks_2009-2024_historic_",
      .csps_hash_time$hash_short,
      ".csv"
    )
  ),
  na = ""
)

# parquet files for completeness

arrow::write_parquet(
  tbl_bm_latest_values,
  file.path(
    "data",
    "01-benchmarks",
    paste0(
      "csps_benchmarks_2009-2024_",
      .csps_hash_time$hash_short,
      ".parquet"
    )
  )
)

arrow::write_parquet(
  tbl_bm_historic,
  file.path(
    "data",
    "01-benchmarks",
    paste0(
      "csps_benchmarks_2009-2024_historic_",
      .csps_hash_time$hash_short,
      ".parquet"
    )
  )
)
