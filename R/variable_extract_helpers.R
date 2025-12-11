#' Extract first line of a CSV
#'
#' Speedy conversion of file's first line
#'
#' @param path file path
#' @param sep column separator
#'
#' @export
extract_csv_header <- function(path, sep = ",", nlines = 1) {
  scan(
    file = path,
    what = character(),
    sep = sep,
    quote = "\"",
    nlines = nlines,
    quiet = TRUE
  )
}

#' Extract first column from a CSV file
#'
#' @param path file path
#' @param ... arguments to pass to `readr::read_csv()`
#'
#' @export
extract_csv_col1 <- function(path, ...) {
  df <- readr::read_csv(
    file = path,
    col_select = 1,
    name_repair = "unique_quiet",
    show_col_types = FALSE,
    ...
  )

  df[[1]]
}

#' @rdname extract_csv_col1
#' @export
extract_csv_col2 <- function(path, ...) {
  df <- readr::read_csv(
    file = path,
    col_select = 1:2,
    name_repair = "unique_quiet",
    show_col_types = FALSE,
    ...
  )

  df
}

#' Extract a row/col from an Excel/ODS spreadsheet
#'
#' @param path file path
#' @param sheet sheet to read
#' @param row row to extract
#' @param col col to extract
#' @name extract_row_cols

#' @rdname extract_row
#' @export
extract_excel_row <- function(path, sheet = 1, row = 1) {
  df <- readxl::read_excel(
    path = path,
    sheet = sheet,
    skip = row - 1,
    n_max = 1,
    .name_repair = "unique_quiet",
    col_types = "text"
  )

  df <- df |> tidyr::pivot_longer(cols = everything())

  df$value
}

#' @rdname extract_row
#' @export
extract_excel_col <- function(path, sheet = 1, col = 1) {
  df <- readxl::read_excel(
    path = path,
    sheet = sheet,
    .name_repair = "unique_quiet"
  )
  df[[col]]
}

#' @rdname extract_row
#' @export
extract_ods_row <- function(path, sheet = 1, row = 1) {
  if (row == 0) {
    suppressMessages(
      df <- readODS::read_ods(
        path = path,
        sheet = sheet,
        col_types = NA,
        n_max = 0,
        progress = FALSE
      )
    )
    return(names(df))
  }

  suppressMessages(
    df <- readODS::read_ods(
      path = path,
      sheet = sheet,
      col_types = NA,
      skip = row - 1,
      n_max = row,
      progress = FALSE
    ) |>
      janitor::clean_names() |>
      tidyr::pivot_longer(cols = everything())
  )

  df$value
}


#' Extract columns from an ODS document
#'
#' @param path file path
#' @param sheet sheet to read
#' @param start_col start column
#' @param cols number of columns to extract
#' @param row_to_names row to use for names
#'
#' @export
extract_ods_cols <- function(
  path,
  sheet = 1,
  start_col = 1,
  cols = 1,
  row_to_names = NULL
) {
  suppressMessages(
    df <- readODS::read_ods(path = path, sheet = sheet, progress = FALSE)
  )
  df <- df[, start_col:(start_col + cols - 1)]

  if (!is.null(row_to_names)) {
    df <- df |> janitor::row_to_names(row_to_names)
  }

  df
}

#' Extract columns from an organisation results CSV
#'
#' @param path file path
#' @param cols cols to extract
#' @param col_names standardise column names
#'
#' @export
extract_csv_org_cols <- function(
  path,
  cols = 2,
  col_names = c("group", "organisation")
) {
  suppressMessages(df <- readr::read_csv(path, show_col_types = FALSE))

  if (length(cols) == 1) {
    cols <- 1:cols
  }

  df <- df[, cols]
  names(df) <- col_names

  return(df)
}

#' Extract columns from an organisation results ODS file
#'
#' @param path file path
#' @param sheet sheet to extract
#' @param cols cols to extract
#' @param skip rows to skip
#' @param col_names standardised column names
#'
#' @export
extract_ods_org_cols <- function(
  path,
  sheet,
  cols = 2,
  skip = 0,
  col_names = c("group", "organisation")
) {
  df <- readODS::read_ods(
    path,
    sheet,
    skip = skip,
    .name_repair = "unique_quiet",
    progress = FALSE
  )

  if (length(cols) == 1) {
    cols <- 1:cols
  }

  df <- df[, cols]
  names(df) <- col_names

  return(df)
}

#' Function to extract demographic column headers from Excel files
#'
#' @param path file path
#' @param sheet sheet to extract
#' @param rows rows to process
#' @param start_col skip to this column
#'
#' @export
extract_excel_dem_rows <- function(
  path,
  sheet,
  rows = 1,
  start_col = 0,
  insert = NULL
) {
  df <- tidyxl::xlsx_cells(path = path, sheets = sheet)

  if (!is.null(insert)) {
    df <- df |>
      dplyr::add_row(
        row = insert$row,
        col = insert$col,
        is_blank = FALSE,
        data_type = "character",
        character = insert$text
      ) |>
      dplyr::arrange(sheet, row, col)
  }

  df <- df |>
    dplyr::filter(row %in% rows & col >= start_col) |>
    dplyr::filter(!is_blank) |>
    dplyr::select(sheet, address, row, col, data_type, character) |>
    unpivotr::behead("up-left", demographic) |>
    dplyr::arrange(col, row) |>
    dplyr::select(demographic, category = character)
  return(df)
}

#' Function to extract demographic category columns from ODS file
#'
#' @param path file path
#' @param sheet sheet to extract
#' @param cols columns to subset to
#' @param skip rows to skip
#' @param col_names standardised names to use for column headers
#'
#' @export
extract_ods_dem_cols <- function(
  path,
  sheet,
  cols,
  skip,
  col_names = c("demographic", "category")
) {
  df <- readODS::read_ods(
    path = path,
    sheet = sheet,
    skip = skip,
    progress = FALSE
  )
  df <- df[, cols]
  names(df) <- col_names
  return(df)
}
