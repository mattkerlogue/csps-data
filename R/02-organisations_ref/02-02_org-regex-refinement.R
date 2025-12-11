source("R/regex_matches.R")
source("R/text_to_uid.R")

raw_tbl_orgs <- readr::read_csv(
  "proc/02-organisations_ref/02_01-raw_tbl_orgs.csv",
  show_col_types = FALSE
)

org_regex <- readr::read_csv(
  "proc/02-organisations_ref/02_01-org_regex.csv",
  show_col_types = FALSE
)

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

orgs_to_uid <- raw_tbl_orgs |>
  dplyr::mutate(
    uid = purrr::map_chr(
      .x = stringr::str_squish(tolower(organisation)),
      .f = ~ text_to_uid(.x, org_regex$regex, org_regex$uid_txt, overrun = TRUE)
    )
  )

orgs_to_uid |>
  dplyr::filter(is.na(uid))

org_history <- orgs_to_uid |>
  dplyr::summarise(
    year_from = min(year),
    year_to = max(year),
    .by = c(uid, organisation)
  ) |>
  dplyr::arrange(uid, year_from)

readr::write_excel_csv(
  orgs_history,
  "proc/02-organisations_ref/02_02-org_history.csv",
  na = ""
)
