# CSPS data extraction and processing
# 01.03 regex refinement
# ======
# This script takes the output of script 01_02-regex_development.R, including
# output that has been manually edited to assist in the development of
# regexes by identifying where a regex matches with multiple questions.

# load data ------

source("R/utils/regex_matches.R")

# read table of all questions
tbl_qs <- readr::read_csv(
  "proc/01-questions_ref/01_02-tbl_qs.csv",
  show_col_types = FALSE
)

# read manually constructed regexes
qs_regexs <- readr::read_csv(
  "proc/01-questions_ref/01_02-regexes.csv",
  show_col_types = FALSE
)

# run matches ------

# match regexes to questions
qs_regexes_matched <- qs_regexs |>
  dplyr::mutate(
    matches = purrr::map(
      .x = regex,
      .f = ~ regex_matches(.x, stringr::str_squish(tolower(tbl_qs$raw_label)))
    )
  )

qs_regexes_matched_unnested <- qs_regexes_matched |>
  tidyr::unnest(matches) |>
  dplyr::filter(match) |>
  dplyr::mutate(
    stripped_text = stringr::str_squish(
      stringr::str_remove_all(
        stringr::str_remove_all(
          stringr::str_remove_all(
            stringr::str_remove_all(
              text,
              "\\b([A-z]{1,5}[\\d_-]+\\w*\\b)[\\.:]?"
            ),
            "\\(.*$"
          ),
          "\\?"
        ),
        "\\d+$"
      )
    )
  )

qs_unnested_w_year <- qs_regexes_matched_unnested |>
  dplyr::distinct(uid_qm_txt, regex, text) |>
  dplyr::add_count(uid_qm_txt) |>
  dplyr::left_join(
    tbl_qs |>
      dplyr::mutate(text = stringr::str_squish(tolower(raw_label))) |>
      dplyr::distinct(year, text) |>
      dplyr::filter(year == max(year), .by = text),
    by = "text"
  ) |>
  dplyr::arrange(-n, uid_qm_txt, -year, text)

# export unnested table of questions
readr::write_excel_csv(
  qs_unnested_w_year,
  "proc/01-questions_ref/01_03-qs_unnested_w_year.csv",
  na = ""
)

# question ref ------
# base table for manual editing, use latest question label as a guide

tbl_qm_ref <- qs_unnested_w_year |>
  dplyr::arrange(uid_qm_txt, -year) |>
  dplyr::distinct(uid_qm_txt, regex, .keep_all = TRUE) |>
  dplyr::select(
    uid_qm_txt,
    regex,
    label = text
  ) |>
  dplyr::mutate(
    uid_qm_num = NA_character_,
    .after = uid_qm_txt
  )

readr::write_excel_csv(
  tbl_qm_ref,
  "proc/01-questions_ref/01_03-tbl_qm_ref.csv",
  na = ""
)
