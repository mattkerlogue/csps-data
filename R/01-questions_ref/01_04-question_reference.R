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
    uid = purrr::map_chr(
      .x = stringr::str_squish(tolower(raw_label)),
      .f = ~ text_to_uid(.x, qs_ref$regex, qs_ref$uid_num)
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
  dplyr::filter(!is.na(uid) & !is.na(proc_measure)) |>
  dplyr::distinct(year, proc_measure, uid) |>
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
  dplyr::select(obj, raw_label, year, proc_measure, uid)

readr::write_excel_csv(
  tbl_qs_complete_match,
  "proc/01-questions_ref/01_04-tbl_qs_complete_match.csv",
  na = ""
)

# write output -----

tbl_measures_uid <- tbl_qs_complete_match |>
  dplyr::filter(!is.na(proc_measure)) |>
  dplyr::distinct(year, measure = proc_measure, uid)

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

# response_category = dplyr::case_when(
#       out_measure == "ees" ~ "index",
#       grepl("index", out_measure) ~ "index",
#       grepl("ts$", out_measure) ~ "theme",
#       out_measure == "response_rate" ~ "response_rate",
#       out_measure == "c01_1" ~ "leave_asap",
#       out_measure == "c01_2" ~ "leave_12m",
#       out_measure == "c01_3" ~ "leave_1yr",
#       out_measure == "c01_4" ~ "leave_3yr",
#       grepl("b\\d{2}\\-b\\d{2}", proc_response) ~ "theme",
#       grepl("b\\d{2} to b\\d{2}", proc_response) ~ "theme",
#       grepl("strongly agree or agree", proc_response) ~ "positive",
#       grepl("\'strongly agree\' or \'agree\'", proc_response) ~ "positive",
#       grepl("yes", proc_response) ~ "yes",
#       grepl("no\\b", proc_response) ~ "no",
#       grepl("prefer not to say", proc_response) ~ "no",
#       grepl("7\\-10", proc_response) ~ "r7_10",
#       grepl("7 to 10", proc_response) ~ "r7_10",
#       grepl("0\\-3", proc_response) ~ "r0_3",
#       grepl("6\\-10", proc_response) ~ "r6_10",
#       grepl("6 to 10", proc_response) ~ "r6_10",
#       grepl("always", proc_response) ~ "always_most",
#       grepl("seldom", proc_response) ~ "seldom_never",
#       grepl("weekly", proc_response) ~ "weekly_monthly",
#       grepl("excellent", proc_response) ~ "excellent_good",
#       grepl("as soon as possible", proc_response) ~ "asap",
#       grepl("productive", proc_response) ~ "highly_productive",
#       grepl("next 12 months", proc_response) ~ "next_12months",
#       grepl("next year", proc_response) ~ "next_year",
#       grepl("next three years", proc_response) ~ "next_3years",
#       grepl("ticking.*at least one", proc_response) ~ "multi_choice",
#       grepl("selecting", proc_response) ~ "multi_choice",
#       TRUE ~ NA_character_
#     )
