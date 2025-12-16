# CSPS data extraction and processing
# 03.03 combined demographic cateogires
# ======
# This script takes the output of script 03_02-demog_regex_refinement.R,
# including output that has been manually edited, to finalise regexes and
# create question/category lookups.

# setup ------

demcat_ref <- readr::read_csv(
  "proc/03-demographics_ref/03_02-dem_cat_ref-edited.csv",
  show_col_types = FALSE
)

# processing ------

# subset to just the uids

demcat_ref2 <- demcat_ref |>
  dplyr::arrange(uid_demq_txt, uid_demcat_txt, uid_cat_txt) |>
  dplyr::mutate(
    sort_order = dplyr::row_number(),
    .by = uid_demq_txt
  )

# get unique list of combined categories

unq_demcat <- demcat_ref |>
  dplyr::distinct(uid_demcat_txt) |>
  dplyr::arrange(uid_demcat_txt) |>
  dplyr::left_join(
    demcat_ref2 |>
      dplyr::summarise(sort_order = min(sort_order), .by = uid_demcat_txt),
    by = "uid_demcat_txt"
  )

# export ------

readr::write_excel_csv(
  unq_demcat |>
    dplyr::mutate(
      uid_demcat_num = NA_integer_,
      resp_type = NA_character_,
      label_short = NA_character_,
      label_long = NA_character_,
    ) |>
    dplyr::relocate(uid_demcat_num, .after = uid_demcat),
  "proc/03-demographics_ref/03_03-unq_demcat.csv",
  na = ""
)
