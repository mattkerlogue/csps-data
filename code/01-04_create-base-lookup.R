# 01-04.  Question & metrics metadata processing
#         > Question identifier lookup
# =========================================================================

# load data ---------------------------------------------------------------

tbl_qms_clean <- readr::read_csv("code/tbl_qms_clean.csv")
tbl_qms_1619_lookup <- readr::read_csv(
  "code/tbl_qms_1619_lookups.csv",
  col_types = readr::cols(.default = readr::col_character())
)
qm_regex <- readr::read_csv("code/question_regex.csv")


# create base table -------------------------------------------------------

identify_question <- function(q_text, regexes, qids) {
  qmatches <- purrr::map_lgl(
    .x = regexes,
    .f = ~grepl(.x, q_text, ignore.case = TRUE, perl = TRUE)
  )
  
  if (sum(qmatches) > 1) {
    qid <- paste0(
      "!! MULTIPLE MATCHES: ",
      paste0(qids[qmatches], collapse = ", "),
      collapse = ""
    )
  } else if (sum(qmatches) == 0) {
    qid <- "!! ZERO MATCHES"
  } else {
    qid <- qids[qmatches]
  }
  
  return(qid)
  
}

tbl_qms_base <- tbl_qms_clean |>
  dplyr::mutate(
    year = gsub("\\D", "", obj),
    .after = obj
  ) |>
  dplyr::left_join(tbl_qms_1619_lookup,
                   by = c("year" = "year", "obj_vals" = "measure")) |>
  dplyr::mutate(
    identifier_lookup = dplyr::if_else(
      is.na(label), obj_vals, label
    ),
    qid = purrr::map_chr(
      identifier_lookup, 
      ~identify_question(.x, qm_regex$regex_identifier, qm_regex$q_identifer))
  ) |>
  dplyr::filter(!grepl("!!", qid)) |>
  dplyr::mutate(
    year_mult = dplyr::if_else(year == "0913", 5, 1)
  ) |>
  tidyr::uncount(year_mult, .id = "year_diff") |>
  dplyr::mutate(
    year = dplyr::if_else(year == "0913", 2008 + year_diff, as.numeric(year))
  ) |>
  dplyr::select(
    year, qid, base_labels = obj_vals
  ) |>
  dplyr::distinct() |>
  dplyr::arrange(qid, year, base_labels)

readr::write_csv(tbl_qms_base, "code/tbl_qms_base_lookup.csv")
