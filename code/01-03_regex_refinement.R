# 01-02.  Question & metrics metadata processing
#         > Test final regexes
# =========================================================================


# load data ---------------------------------------------------------------

tbl_qms_clean <- readr::read_csv("code/tbl_qms_clean.csv")
qm_regex <- readr::read_csv("code/question_regex.csv")


# matching function -------------------------------------------------------

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

tbl_qms_matched <- tbl_qms_clean |>
  dplyr::mutate(
    qid = purrr::map_chr(obj_vals, ~identify_question(.x, qm_regex$regex_identifier, qm_regex$q_identifer))
  )

regex_issues <- tbl_qms_matched |>
  dplyr::filter(grepl("\\!\\!", qid)) |>
  dplyr::arrange(qid)

regex_issues |> readr::write_csv(
  file.path(
    "code",
    paste0(as.integer(Sys.time()), "_regex_issues.csv")
  )
)

