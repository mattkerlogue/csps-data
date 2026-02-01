# CSPS data extraction and processing
# 04.03 process demographic data
# ======

# setup ------

source("R/utils/text_to_uid.R")
source("R/utils/extract_response_category.R")
source("R/utils/hash_time.R")

raw_tbl_dem_data <- arrow::read_parquet(
  "proc/04-extract_data/04_03-raw_tbl_dem_data_df950add.parquet"
)

qs_regex <- readr::read_csv(
  "proc/csps_questions_ref.csv",
  show_col_types = FALSE
)

measures_lookup <- readr::read_csv(
  "proc/csps_measures_lookup.csv",
  show_col_types = FALSE
)

demq_regex <- readr::read_csv(
  "proc/csps_demogqs_regex.csv",
  show_col_types = FALSE
)

demcat_regex <- readr::read_csv(
  "proc/csps_demcat_regex.csv",
  show_col_types = FALSE
)

demcat_lookup <- readr::read_csv(
  "proc/csps_demcat_lookup.csv",
  show_col_types = FALSE
)

demcat_ref <- readr::read_csv(
  "proc/csps_demcat_ref.csv",
  show_col_types = FALSE
)

# match demographics and categories ------

raw_unq_demqs <- raw_tbl_dem_data |>
  dplyr::distinct(demographic) |>
  dplyr::mutate(
    uid_demq_txt = purrr::map_chr(
      .x = stringr::str_squish(tolower(demographic)),
      .f = ~ text_to_uid(
        .x,
        demq_regex$regex,
        demq_regex$uid_demq_txt
      )
    )
  )

raw_unq_demcats <- raw_tbl_dem_data |>
  dplyr::mutate(
    cat_text = stringr::str_squish(gsub(
      "\\s?\\((n=)?\\d.*$",
      "",
      tolower(category)
    ))
  ) |>
  dplyr::distinct(cat_text) |>
  dplyr::mutate(
    uid_cat_txt = purrr::map_chr(
      .x = cat_text,
      .f = ~ text_to_uid(
        .x,
        demcat_regex$regex,
        demcat_regex$uid_cat_txt,
        overrun = TRUE
      )
    )
  )

raw_unq_qm <- raw_tbl_dem_data |>
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


tbl_dem_data_proc <- raw_tbl_dem_data |>
  dplyr::mutate(
    cat_text = stringr::str_squish(gsub(
      "\\s?\\((n=)?\\d.*$",
      "",
      tolower(category)
    ))
  ) |>
  dplyr::left_join(raw_unq_demqs, by = "demographic") |>
  dplyr::left_join(raw_unq_demcats, by = "cat_text") |>
  dplyr::left_join(demcat_lookup, by = c("uid_demq_txt", "uid_cat_txt")) |>
  dplyr::left_join(raw_unq_qm, by = "question_measure")

# extract counts and generate response categories ------

tbl_demcat_counts <- tbl_dem_data_proc |>
  dplyr::filter(grepl("\\s?\\((n=)?\\d.*$", category)) |>
  dplyr::distinct(
    obj,
    obj_data,
    obj_year,
    uid_demq_txt,
    uid_cat_txt,
    uid_demcat_txt,
    category
  ) |>
  dplyr::mutate(
    value = stringr::str_extract(
      category,
      "\\s?\\((n=)?(\\d+,?\\d+).*$",
      group = 2
    ),
    value = readr::parse_number(value),
    uid_qm_txt = "meta.response_count",
    uid_qm_num = "0.00.001.00",
    response_category = "response_count"
  ) |>
  dplyr::select(
    obj,
    obj_data,
    obj_year,
    uid_demq_txt,
    uid_cat_txt,
    uid_demcat_txt,
    uid_demq_txt,
    uid_qm_num,
    uid_qm_txt,
    response_category,
    value
  )

tbl_resp_cat <- tbl_dem_data_proc |>
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

# output dataset

tbl_dem_data_out <- tbl_dem_data_proc |>
  tidyr::drop_na(value) |> # drop 16 missing values from 2019
  dplyr::left_join(
    tbl_resp_cat,
    by = c("uid_qm_num", "uid_qm_txt", "qm_text")
  ) |>
  dplyr::bind_rows(tbl_demcat_counts) |>
  dplyr::filter(uid_demcat_txt != "ALLRSP") |> # remove mean scores from 2018
  dplyr::left_join(
    demcat_ref |> dplyr::select(uid_demcat_txt, uid_demcat_num),
    by = "uid_demcat_txt"
  ) |>
  dplyr::mutate(
    uid_demq_txt = dplyr::if_else(
      is.na(uid_demq_txt) & obj_year == 2018 & uid_demcat_txt == "allrsp",
      "allrsp",
      uid_demq_txt
    )
  ) |>
  dplyr::select(
    data_type = obj_data,
    year = obj_year,
    uid_demq_txt,
    uid_demcat_num,
    uid_demcat_txt,
    uid_qm_num,
    uid_qm_txt,
    response_category,
    value
  ) |>
  dplyr::arrange(year, uid_demcat_num, uid_qm_num, response_category)

hash_time()

# csv file is ~26MB
readr::write_excel_csv(
  tbl_dem_data_out,
  file.path(
    "data",
    "03-demographics",
    paste0("csps_demographics_2009-2024_", .csps_hash_time$hash_short, ".csv")
  ),
  na = ""
)

# parquet is ~1MB
arrow::write_parquet(
  tbl_dem_data_out,
  file.path(
    "data",
    "03-demographics",
    paste0(
      "csps_demographics_2009-2024_",
      .csps_hash_time$hash_short,
      ".parquet"
    )
  )
)
