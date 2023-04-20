# 01-02.  Question & metrics metadata processing
#         > Analyse wording for regex construction
# =========================================================================


# load data ---------------------------------------------------------------

tbl_qms_clean <- readr::read_csv("code/tbl_qms_clean.csv")

# unique questions --------------------------------------------------------

unq_qms <- tbl_qms_clean |>
  dplyr::arrange(stripped_vals) |>
  # drop single word entities (e.g. question numbers/variable names)
  dplyr::mutate(
    qnum_only = !grepl(" ", stripped_vals),
  ) |>
  dplyr::filter(!qnum_only) |>
  #  replace punctuation
  dplyr::mutate(
    stripped_vals = gsub("_", ": ", stripped_vals)
  ) |>
  # get invidual
  dplyr::distinct(stripped_vals)

# function to detect entity in a vector
find_in_vector <- function(x, vec) {
  y <- vec[grepl(paste0("\\b", x, "\\b"), vec)]
  if (length(y) != 1) {
    return(NA_character_)
  } else {
    return(y)
  }
}

# identify any unique words - words used only in a single question
unq_words <- unq_qms |>
  tidytext::unnest_tokens(output = "word", input = stripped_vals) |>
  dplyr::count(word) |>
  dplyr::anti_join(tidytext::stop_words, by = "word") |>
  dplyr::filter(n == 1) |>
  dplyr::mutate(
    src_q = purrr::map_chr(
      .x = word,
      .f = ~find_in_vector(.x, unq_qms$stripped_vals))
  )

# identify unique bigrams
unq_bigrams <- unq_qms |>
  tidytext::unnest_ngrams(output = "bigram", input = stripped_vals, n = 2, ) |>
  dplyr::count(bigram) |>
  dplyr::filter(n == 1) |>
  dplyr::mutate(
    src_q = purrr::map_chr(
      .x = bigram,
      .f = ~find_in_vector(.x, unq_qms$stripped_vals))
  ) |>
  tidyr::drop_na(src_q)

# get a list of unique words/bigrams
unq_qs <- unq_words |>
  dplyr::transmute(type = "word", phrase = word, src_q) |>
  dplyr::bind_rows(
    unq_bigrams |>
      dplyr::transmute(type = "bigram", phrase = bigram, src_q)
  ) |>
  dplyr::nest_by(src_q) |>
  dplyr::mutate(
    n = nrow(data)
  ) |>
  dplyr::arrange(n) |>
  dplyr::ungroup() |>
  tidyr::unnest(data)

# copy to clipboard to develop regex csv in spreadsheet editor
unq_qs |> readr::write_csv(
  file.path(
    "code",
    paste0(as.integer(Sys.time()), "_unique_questions.csv")
  )
)

# !! MODIFY REGEX FILE MANUALLY

# read in question regex
qm_regex <- readr::read_csv("code/question_regex.csv")

# get questions that match regex
get_matches <- function(regex, vec) {
  vec[grepl(regex, vec, ignore.case = TRUE, perl = TRUE)]
}

# match regex with questions
tbl_match_qms <- qm_regex |>
  dplyr::mutate(
    matched_qs = purrr::map(
      .x = regex_identifier,
      .f = ~get_matches(.x, unq_qms$stripped_vals)
    )
  ) |>
  tidyr::unnest(matched_qs)

# get questions not matched by regex
xunq_qs <- unq_qms |>
  dplyr::filter(!(stripped_vals %in% tbl_match_qms$matched_qs))

# copy to clipboard to further refine regex csv
xunq_qs |> readr::write_csv(
  file.path(
    "code",
    paste0(as.integer(Sys.time()), "_unmatched_questions.csv")
  )
)

# repeat from line 78 until all questions matched