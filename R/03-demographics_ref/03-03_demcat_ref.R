# CSPS data extraction and processing
# 03.03 demographic reference
# ======
# This script takes the output of script 03_03-demog-regex_refinement.R,
# including output that has been manually edited to finalise regex development
# and create key reference files for data processing.

# setup ------

demcat_ref <- readr::read_csv(
  "proc/03-demographics_ref/03_02-dem_cat_ref-edited.csv",
  show_col_types = FALSE
)

# processing ------

# subset to just the uids

demcat_ref2 <- demcat_ref |>
  dplyr::arrange(uid_dem, uid_demcat, uid_cat) |>
  dplyr::mutate(
    sort_order = dplyr::row_number(),
    .by = uid_dem
  )

# get unique list of combined categories

unq_demcat <- demcat_ref |>
  dplyr::distinct(uid_demcat) |>
  dplyr::arrange(uid_demcat) |>
  dplyr::left_join(
    demcat_ref2 |>
      dplyr::summarise(sort_order = min(sort_order), .by = uid_demcat),
    by = "uid_demcat"
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

fs::file_copy(
  "proc/03-demographics_ref/03_01-demographic_regex.csv",
  "proc/csps_demogqs_regex.csv"
)

fs::file_copy(
  "proc/03-demographics_ref/03_01-categories_regex.csv",
  "proc/csps_demcat_regex.csv"
)

fs::file_copy(
  "proc/03-demographics_ref/03_02-dem_cat_ref-edited.csv",
  "proc/csps_demcat_lookup.csv"
)
