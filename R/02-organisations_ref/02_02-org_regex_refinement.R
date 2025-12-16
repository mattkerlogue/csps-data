# CSPS data extraction and processing
# 02.02 regex refinement
# ======
# This script takes the output of script 01_01-extract-organisations.R,
# including output that has been manually edited, to help refine the
# development of organisational regexes.

# setup ------

source("R/regex_matches.R")
source("R/text_to_uid_org_txt.R")

raw_tbl_orgs <- readr::read_csv(
  "proc/02-organisations_ref/02_01-raw_tbl_orgs.csv",
  show_col_types = FALSE
)

org_regex <- readr::read_csv(
  "proc/02-organisations_ref/02_01-org_regex.csv",
  show_col_types = FALSE
)

# match regexes to organisations ------

org_regexes_matched <- org_regex |>
  dplyr::mutate(
    matches = purrr::map(
      .x = regex,
      .f = ~ regex_matches(.x, stringr::str_squish(tolower(organisation_name)))
    )
  )

org_regexes_matched_unnested <- org_regexes_matched |>
  tidyr::unnest(matches) |>
  dplyr::filter(match)

org_regexes_matched_unnested |>
  dplyr::count(regex, organisation_name, sort = TRUE)


# match organisations to regexes ------

orgs_to_uid_org_txt <- raw_tbl_orgs |>
  dplyr::mutate(
    uid_org_txt = purrr::map_chr(
      .x = stringr::str_squish(tolower(organisation)),
      .f = ~ text_to_uid_org_txt(
        .x,
        org_regex$regex,
        org_regex$uid_org_txt,
        overrun = TRUE
      )
    )
  )

orgs_to_uid_org_txt |>
  dplyr::filter(is.na(uid_org_txt))

# organisation history ------
# file showing lifespan of organisations to develop a log of changes

org_history <- orgs_to_uid_org_txt |>
  dplyr::summarise(
    year_from = min(year),
    year_to = max(year),
    .by = c(uid_org_txt, organisation)
  ) |>
  dplyr::arrange(uid_org_txt, year_from)


readr::write_excel_csv(
  orgs_history,
  "proc/02-organisations_ref/02_02-org_history.csv",
  na = ""
)
