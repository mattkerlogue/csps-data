# CSPS data extraction and processing
# 01.02 regex development
# ======
# This script takes the output of script 01_01-extract_questions.R and
# processes it into intermediate outputs to support development of regexes
# that can be used to uniquely identify questions/measures over time.

# load data ------

raw_tbl_qs <- readr::read_csv(
  "proc/01-questions_ref/01_01-raw_tbl_qs.csv",
  show_col_types = FALSE
)

# reference table ------
tbl_qs <- raw_tbl_qs |>
  dplyr::mutate(
    year = as.integer(gsub(".*(\\d{4}).*", "\\1", obj)),
    proc_label = stringr::str_squish(tolower(raw_label)),
    stripped_label = stringr::str_squish(
      stringr::str_remove_all(
        stringr::str_remove_all(
          stringr::str_remove_all(
            stringr::str_remove_all(
              proc_label,
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

readr::write_excel_csv(
  tbl_qs,
  "proc/01-questions_ref/01_02-tbl_qs.csv",
  na = ""
)

## unique questions ---
unq_qs <- tbl_qs |>
  dplyr::mutate(
    stripped_label = stringr::str_remove_all(
      stripped_label,
      "[\\d\\(\\)\\[\\]\\.?]"
    )
  ) |>
  dplyr::distinct(stripped_label) |>
  dplyr::arrange(stripped_label) |>
  dplyr::filter(stripped_label != "")

readr::write_excel_csv(
  unq_qs,
  "proc/01-questions_ref/01_02-unq_qs.csv",
  na = ""
)

readr::write_excel_csv(
  unq_qs |>
    dplyr::mutate(
      regex = NA_character_,
      uid_txt = NA_character_,
      uid_num = NA_character_
    ),
  "proc/01-questions_ref/01_02-unq_qs_regex.csv",
  na = ""
)
