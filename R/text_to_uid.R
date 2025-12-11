#' Find uid for given text string
#'
#' @param x A text string
#' @param regexes A vector of regular expressions
#' @param uids A vector of uids
#'
#' @returns A vector of uids
#'
#' @export
#' @examples
text_to_uid <- function(x, regexes, uids, overrun = FALSE) {
  if (length(regexes) != length(uids)) {
    cli::cli_abort(c(
      "x" = "{.arg regexes} and {.arg uids} must be the same length",
      "i" = "{.arg regexes} length: {length(regexes)}, {.arg uids} length: {length(uids)}"
    ))
  }
  matches <- logical(length(regexes))

  for (i in seq_along(regexes)) {
    if (is.na(regexes[i])) {
      next
    }
    if (grepl(regexes[i], x, perl = TRUE)) {
      matches[i] <- TRUE
    }
  }

  out <- uids[matches]

  if (length(out) == 0) {
    return(NA_character_)
  } else if (length(out) == 1) {
    return(out)
  } else {
    if (!overrun) {
      cli::cli_abort(c(
        "!" = "Text resulted in {length(out)} matches",
        "i" = "Text: {x}",
        "i" = "Matches: {out}"
      ))
    } else {
      return(paste0(out, collapse = ", "))
    }
  }
}
