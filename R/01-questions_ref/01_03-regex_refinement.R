# 01-02.  Question & metrics metadata processing
#         > Test and refine regexes
# =========================================================================

# load data ---------------------------------------------------------------

source("R/regex_matches.R")

tbl_qs <- readr::read_csv(
  "proc/01-questions_ref/01_02-tbl_qs.csv",
  show_col_types = FALSE
)
qs_regexs <- readr::read_csv(
  "proc/01-questions_ref/01_02-regexes.csv",
  show_col_types = FALSE
)

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
  dplyr::distinct(uid_txt, regex, text) |>
  dplyr::add_count(uid_txt) |>
  dplyr::left_join(
    tbl_qs |>
      dplyr::mutate(text = stringr::str_squish(tolower(raw_label))) |>
      dplyr::distinct(year, text) |>
      dplyr::filter(year == max(year), .by = text),
    by = "text"
  ) |>
  dplyr::arrange(-n, uid_txt, -year, text) |>
  clipr::write_clip()

readr::write_excel_csv(
  qs_unnested_w_year,
  "proc/01-questions_ref/01_03-qs_unnested_w_year.csv",
  na = ""
)

# # unique questions --------------------------------------------------------

# unq_bigrams <- unq_qs |>
#   tidytext::unnest_ngrams(output = "word", input = stripped_label, n = 2) |>
#   dplyr::count(word)

# # function to detect entity in a vector
# find_in_vector <- function(x, vec) {
#   y <- vec[grepl(paste0("\\b", x, "\\b"), vec)]
#   if (length(y) != 1) {
#     return(NA_character_)
#   } else {
#     return(y)
#   }
# }

# # identify unique bigrams
# unq_bigrams <- unq_qms |>
#   tidytext::unnest_ngrams(output = "bigram", input = stripped_vals, n = 2, ) |>
#   dplyr::count(bigram) |>
#   dplyr::filter(n == 1) |>
#   dplyr::mutate(
#     src_q = purrr::map_chr(
#       .x = bigram,
#       .f = ~ find_in_vector(.x, unq_qms$stripped_vals)
#     )
#   ) |>
#   tidyr::drop_na(src_q)

# # get a list of unique words/bigrams
# unq_qs <- unq_words |>
#   dplyr::transmute(type = "word", phrase = word, src_q) |>
#   dplyr::bind_rows(
#     unq_bigrams |>
#       dplyr::transmute(type = "bigram", phrase = bigram, src_q)
#   ) |>
#   dplyr::nest_by(src_q) |>
#   dplyr::mutate(
#     n = nrow(data)
#   ) |>
#   dplyr::arrange(n) |>
#   dplyr::ungroup() |>
#   tidyr::unnest(data)

# # copy to clipboard to develop regex csv in spreadsheet editor
# unq_qs |>
#   readr::write_csv(
#     file.path(
#       "code",
#       paste0(as.integer(Sys.time()), "_unique_questions.csv")
#     )
#   )

# # !! MODIFY REGEX FILE MANUALLY

# # read in question regex
# qm_regex <- readr::read_csv("code/question_regex.csv")

# # get questions that match regex
# get_matches <- function(regex, vec) {
#   vec[grepl(regex, vec, ignore.case = TRUE, perl = TRUE)]
# }

# # match regex with questions
# tbl_match_qms <- qm_regex |>
#   dplyr::mutate(
#     matched_qs = purrr::map(
#       .x = regex_identifier,
#       .f = ~ get_matches(.x, unq_qms$stripped_vals)
#     )
#   ) |>
#   tidyr::unnest(matched_qs)

# # get questions not matched by regex
# xunq_qs <- unq_qms |>
#   dplyr::filter(!(stripped_vals %in% tbl_match_qms$matched_qs))

# # copy to clipboard to further refine regex csv
# xunq_qs |>
#   readr::write_csv(
#     file.path(
#       "code",
#       paste0(as.integer(Sys.time()), "_unmatched_questions.csv")
#     )
#   )

# # repeat from line 78 until all questions matched
