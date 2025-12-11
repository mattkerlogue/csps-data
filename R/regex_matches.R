#' Find matches for a given regex
#'
#' Intended to be used within a purrr::map for use in checking the performance
#' of regexes, see 01-03_regex-refinement.R for example. In essence a method to
#' vectorise the `pattern` part of `grepl()`.
#'
#' @param regex A regular expression
#' @param text A vector of text to
#'
#' @returns A tibble with two columns showing the text tested and whether it
#'   was a match for the given regex
#'
#' @export
regex_matches <- function(regex, text) {
  tibble::tibble(
    text = text,
    match = grepl(regex, text, perl = TRUE)
  )
}
