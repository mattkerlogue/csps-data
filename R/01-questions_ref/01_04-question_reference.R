# CSPS data extraction and processing
# 01.04 question reference
# ======
# This script takes the output of script 01_03-regex_refinement.R, including
# output that has been manually edited to finalise regex development and
# create key reference files for data processing.

# load data ------

source("R/text_to_uid.R")

tbl_qs <- readr::read_csv(
  "proc/01-questions_ref/01_02-tbl_qs.csv",
  show_col_types = FALSE
)
qs_ref <- readr::read_csv(
  "proc/01-questions_ref/01_03-qs_ref.csv",
  show_col_types = FALSE
)

# match questions ------

tbl_qs_matched <- tbl_qs |>
  dplyr::mutate(
    uid_qm_num = purrr::map_chr(
      .x = stringr::str_squish(tolower(raw_label)),
      .f = ~ text_to_uid(.x, qs_ref$regex, qs_ref$uid_qm_num)
    ),
    uid_qm_txt = purrr::map_chr(
      .x = stringr::str_squish(tolower(raw_label)),
      .f = ~ text_to_uid(.x, qs_ref$regex, qs_ref$uid_qm_txt)
    )
  )

readr::write_excel_csv(
  tbl_qs_matched,
  "proc/01-questions_ref/01_03-tbl_qs_matched.csv",
  na = ""
)

# identify measures ------
# some datasets do not have question text/labels only measure/variable ids
# (e.g. `ees` or `B01` etc), these ids are not unique across years so a lookup
# is needed to enable alignment of this data to the common standard

tbl_detect_measures <- tbl_qs_matched |>
  dplyr::mutate(
    text = dplyr::case_when(
      !is.na(raw_measure) & !is.na(raw_label) ~ paste(raw_measure, raw_label),
      !is.na(raw_label) ~ raw_label,
      !is.na(raw_measure) ~ raw_measure,
      TRUE ~ NA_character_
    ) |>
      tolower() |>
      stringr::str_squish(),
    detect_measure = grepl(
      "b\\d{2}\\sto\\sb\\d{2}|[bcdejwv]{1,2}\\d{1,2}[a-i]?(?:[_-][a-e0-9]{0,4}[^_nyp\\s:\\.\\)])?|ees|[a-z]{2,5}_(?:p|ts|index)",
      text
    ),
    proc_measure = stringr::str_extract(
      text,
      "b\\d{2}\\sto\\sb\\d{2}|[bcdejwv]{1,2}\\d{1,2}[a-i]?(?:[_-][a-e0-9]{0,4}[^_nyp\\s:\\.\\)])?|ees|[a-z]{2,5}_(?:p|ts|index)",
    ),
    proc_measure = dplyr::if_else(
      grepl("-", proc_measure) |
        grepl("to", proc_measure) |
        nchar(text) > 11 & (proc_measure == "e1" | proc_measure == "d1"),
      NA_character_,
      proc_measure
    )
  )

tbl_yr_measures <- tbl_detect_measures |>
  dplyr::filter(!is.na(uid_qm_num) & !is.na(proc_measure)) |>
  dplyr::distinct(year, proc_measure, uid_qm_num, uid_qm_txt) |>
  dplyr::add_count(year, proc_measure) |>
  dplyr::filter(n == 1) |>
  dplyr::select(-n)

readr::write_excel_csv(
  tbl_yr_measures,
  "proc/01-questions_ref/01_04-tbl_yr_measures.csv",
  na = ""
)

# completely matched data ------
# testing that the matching process works

tbl_qs_complete_match <- tbl_detect_measures |>
  dplyr::rows_patch(tbl_yr_measures, by = c("year", "proc_measure")) |>
  dplyr::select(obj, raw_label, year, proc_measure, uid_qm_num, uid_qm_txt)

readr::write_excel_csv(
  tbl_qs_complete_match,
  "proc/01-questions_ref/01_04-tbl_qs_complete_match.csv",
  na = ""
)

# write output -----

tbl_measures_uid <- tbl_qs_complete_match |>
  dplyr::filter(!is.na(proc_measure)) |>
  dplyr::distinct(year, measure = proc_measure, uid_qm_num, uid_qm_txt)

readr::write_excel_csv(
  tbl_measures_uid,
  "proc/01-questions_ref/01_04-tbl_measures_uid.csv",
  na = ""
)

fs::file_copy(
  "proc/01-questions_ref/01_03-qs_ref.csv",
  "proc/csps_questions_ref.csv"
)

fs::file_copy(
  "proc/01-questions_ref/01_04-tbl_measures_uid.csv",
  "proc/csps_measures_lookup.csv"
)
