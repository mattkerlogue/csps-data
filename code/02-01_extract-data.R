# 02-01.  Question & metrics metadata processing
#         > Extract data
# =========================================================================


# helper functions --------------------------------------------------------

csv_cols_info <- function(path, encoding = NULL, what = c("basic", "extended"),
                          ...) {
  
  if (is.null(encoding)) {
    locale <- readr::default_locale()
  } else {
    locale <- readr::locale(encoding = encoding)
  }
  
  df <- suppressMessages(readr::read_csv(
    file = path, locale = locale, n_max = 1,
    col_types = readr::cols(.default = readr::col_character()),
    ...
  )) |>
    tidyr::pivot_longer(cols = everything())
  
  what <- match.arg(what)
  
  cols_out <- paste(crayon::yellow(df$name), df$value, sep = crayon::yellow(": "))
  
  if (nrow(df) <= 10) {
    what <- "extended"
  }
  
  if (what == "basic") {
    cols_out <- cols_out[1:10]
    cat(paste(nrow(df), "columns\n"))
    cat(c(cols_out, "..."), sep = crayon::red(" | "))
  } else {
    cat(paste(nrow(df), "columns\n"))
    cat(cols_out, sep=crayon::red(" | "))
  }
  
}

adv_read_csv <- function(path, encoding = NULL, na = NULL,
                              col_types = NULL,
                          names_to = c("year", "variable", "organisation", 
                                       "demographic"),
                         contains_blanks = FALSE, contains_endnotes = FALSE,
                         rename_first = NULL, drop_na_vals = TRUE,
                          ...) {
  
  if (is.null(encoding)) {
    locale <- readr::default_locale()
  } else {
    locale <- readr::locale(encoding = encoding)
  }
  
  if (is.null(na)) {
    na <- c("", "NA", "n/a", "N/A")
  }
  
  df <- suppressMessages(readr::read_csv(
    file = path, locale = locale, na = na, col_types = col_types, ...
  ))
  
  if (contains_blanks) {
    df <- df |> janitor::remove_empty(which = c("rows", "cols"))
  }
  
  if (contains_endnotes) {
    df <- df |> dplyr::slice_head(n = which(df[[1]] == "Notes"))
  }
  
  if (!is.null(rename_first)) {
    names(df)[1] <- rename_first
  }
  
  names_to <- match.arg(names_to)
  
  df_pivot <- df |>
    tidyr::pivot_longer(cols = where(is.numeric), names_to = names_to) |>
    janitor::clean_names()
  
  if (drop_na_vals) {
    df_pivot <- df_pivot |> tidyr::drop_na()
  }
  
  return(df_pivot)
  
}


# 2009-2013 benchmarks ----------------------------------------------------

df_0913_bm <- adv_read_csv(
  path = "raw-data/2013/csps2013_benchmarks_20131125.csv",
  encoding = "latin1",
  col_types = "cnnnnn____"
)


# 2009-2012 organisation scores -------------------------------------------

df_2009_org <- adv_read_csv(
  "raw-data/2009/csps2009_allorganisations_20140213.csv",
  col_types = paste0("c", "c", paste0(rep("n", 71), collapse = "")),
  encoding = "latin1",
  names_to = "variable"
  )

df_2010_org <- adv_read_csv(
  "raw-data/2010/csps2010allorganisations_tcm6-38334.csv",
  col_types = paste0("c", "c", paste0(rep("n", 73), collapse = "")),
  names_to = "variable"
)

df_2011_org <- adv_read_csv(
  "raw-data/2011/csps2011_allorganisations_20120202.csv",
  col_types = paste0("c", "c", paste0(rep("n", 72), collapse = "")),
  names_to = "variable"
)

df_2012_org <- adv_read_csv(
  "raw-data/2012/csps2012_allorganisations_20130201.csv",
  col_types = paste0("c", "c", paste0(rep("n", 81), collapse = "")),
  names_to = "variable"
)


# 2013 detailed scores ----------------------------------------------------

df_2013_org <- adv_read_csv(
  "raw-data/2013/csps2013_allorganisations_20140213.csv",
  col_types = paste0("c", "c", paste0(rep("n", 82), collapse = "")),
  names_to = "variable"
)

df_2013_dem <- adv_read_csv(
  "raw-data/2013/csps2013_demographic_results.csv",
  col_types = paste0("c", paste0(rep("n", 83), collapse = "")),
  names_to = "demographic"
)

df_2013_scs <- adv_read_csv(
  "raw-data/2013/csps2013_scs.csv",
  encoding = "latin1",
  col_types = "cnnnnn____"
)


# 2014 scores -------------------------------------------------------------

df_2014_bm <- adv_read_csv(
  "raw-data/2014/csps2014_benchmarks.csv",
  col_types = paste0("c", paste0(rep("n", 6), collapse = ""))
)


df_2014_org <- adv_read_csv(
  "raw-data/2014/csps2014_allorganisations_20141120.csv",
  col_types = paste0("c", "c", paste0(rep("n", 82), collapse = "")),
  names_to = "variable"
)

df_2014_dem <- adv_read_csv(
  "raw-data/2014/csps2014_demographics.csv",
  col_types = paste0("c", paste0(rep("n", 169), collapse = "")),
  names_to = "demographic", contains_blanks = TRUE, contains_endnotes = TRUE,
  rename_first = "measure", drop_na_vals = TRUE, skip = 2
)

