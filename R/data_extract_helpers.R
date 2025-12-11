#' Read a CSV file and convert into 'long' format
#'
#' @param path file path
#' @param type type of CSV being processed (either `benchmark_csv` or
#'   `organisation_csv`)
#' @param values_convert if necessary use `scale_100` to convert percentages
#'   from 0-1 decimal to 0-100 score
#' @param skip rows to skip
#' @param cols columns to subset to
#' @param na values to consider missing
#' @param ...
#'
#' @returns
#'
#' @export
#' @examples
long_csv <- function(
  path,
  type = NULL,
  values_convert = NULL,
  skip = 0,
  cols = NULL,
  na = c("", "NA", "n/a"),
  ...
) {
  df_in <- readr::read_csv(
    path,
    col_types = readr::cols(.default = readr::col_character()),
    show_col_types = FALSE,
    skip = skip,
    na = "",
    name_repair = "unique_quiet",
    ...
  )

  # column subset if required
  if (!is.null(cols)) {
    df_in <- df_in[, cols]
  }

  if (is.null(type)) {
    cli::cli_abort(c("x" = "{.arg type} must be set"))
  } else if (type$type == "benchmark_csv") {
    df_out <- df_in |>
      tidyr::pivot_longer(cols = -1, names_to = "year", values_to = "value") |>
      dplyr::mutate(
        year = as.integer(year),
        value = readr::parse_number(value, na = na)
      ) |>
      tidyr::drop_na(value)

    names(df_out)[1] <- "question_measure"
  } else if (type$type == "organisation_csv") {
    df_out <- df_in |>
      tidyr::pivot_longer(
        cols = c(-(type$org_cols)),
        names_to = "question_measure",
        values_to = "value"
      ) |>
      dplyr::mutate(value = readr::parse_number(value, na = na)) |>
      tidyr::drop_na(value)

    names(df_out)[type$org_cols] <- type$org_headers
  }

  if (!is.null(values_convert)) {
    if (values_convert == "scale_100") {
      df_out$value <- df_out$value * 100
    }
  }

  return(df_out)
}

#' Extract benchmark data from an ODS file
#'
#' @param path file path
#' @param sheet sheet to extract
#' @param skip rows to skip
#' @param cols columns to subset to
#' @param na values to consider missing
#'
#' @returns
#'
#' @export
#' @examples
extract_benchmark_ods <- function(
  path,
  sheet,
  skip = 0,
  cols = NULL,
  na = c("", "NA")
) {
  df_in <- readODS::read_ods(
    path,
    sheet = sheet,
    col_types = readr::cols(.default = readr::col_character()),
    skip = skip,
    progress = FALSE
  )

  if (!is.null(cols)) {
    df_in <- df_in[, cols]
  }

  df_out <- df_in |>
    tidyr::pivot_longer(cols = -1, names_to = "year", values_to = "value") |>
    dplyr::mutate(
      year = as.integer(year),
      value = readr::parse_number(value, na = na)
    ) |>
    tidyr::drop_na(value)

  names(df_out)[1] <- "question_measure"

  return(df_out)
}

#' Extract organisation scores from ODS file
#'
#' @param path file path
#' @param sheet sheet to extract
#' @param skip rows to skip
#' @param cols columns to subset to
#' @param org_cols columns containing organisation references
#' @param org_headers vector of standardised column headers
#' @param value_convert set to `scale_100` to convert percentages from 0-1 to 0-100
#' @param na values to consider missing
#'
#' @returns
#'
#' @export
#' @examples
extract_organisation_ods <- function(
  path,
  sheet,
  skip = 0,
  cols = NULL,
  org_cols,
  org_headers,
  value_convert = NULL,
  na = c("", "NA")
) {
  df_in <- readODS::read_ods(
    path,
    sheet = sheet,
    col_types = readr::cols(.default = readr::col_character()),
    skip = skip,
    progress = FALSE
  )

  if (!is.null(cols)) {
    df_in <- df_in[, cols]
  }

  df_out <- df_in |>
    tidyr::pivot_longer(
      cols = -all_of(org_cols),
      names_to = "question_measure",
      values_to = "value"
    ) |>
    dplyr::mutate(
      value = readr::parse_number(value, na = na)
    ) |>
    tidyr::drop_na(value)

  names(df_out)[org_cols] <- org_headers

  if (!is.null(value_convert)) {
    if (value_convert == "scale_100") {
      df_out$value <- df_out$value * 100
    }
  }

  return(df_out)
}

#' Extract data from demographic Excel/ODS files
#'
#' @param path file path
#' @param sheet sheet to extract
#' @param data_structure list providing details of the data structure
#' @param value_convert set to `scale_100` to convert percentages from 0-1 to 0-100
#' @param insert list of values to insert into dataset
#' @param skip rows to skip
#' @param .file_ext file extension (derived from path)
#'
#' @returns
#'
#' @export
#' @examples
extract_demographic_data <- function(
  path,
  sheet,
  data_structure = NULL,
  value_convert = NULL,
  insert = NULL,
  skip = 0,
  .file_ext = tools::file_ext(path)
) {
  .file_ext <- rlang::arg_match(.file_ext, c("xls", "xlsx", "ods"))
  if (.file_ext == "ods") {
    df_in <- readODS::read_ods(
      path,
      sheet = sheet,
      skip = skip,
      col_types = readr::cols(.default = readr::col_character()),
      progress = FALSE
    )

    if (!is.null(data_structure$drop_cols)) {
      df_in <- df_in[, -data_structure$drop_cols]
    }

    df_out <- df_in |>
      tidyr::pivot_longer(
        cols = -(1:2),
        names_to = "question_measure",
        values_to = "value"
      ) |>
      dplyr::mutate(
        value = readr::parse_number(value, na = data_structure$na)
      ) |>
      tidyr::drop_na(value)

    names(df_out)[c(1, 2)] <- c("demographic", "category")
  } else {
    df_in <- tidyxl::xlsx_cells(path, sheets = sheet)

    df_data <- df_in |>
      dplyr::filter(
        col >= data_structure$data_zone$col_start &
          row >= data_structure$data_zone$row_start &
          !is_blank
      ) |>
      dplyr::select(row, col, value = numeric)

    if (!is.null(insert)) {
      df_in <- df_in |>
        dplyr::add_row(
          row = insert$row,
          col = insert$col,
          is_blank = FALSE,
          data_type = "character",
          character = insert$text
        ) |>
        dplyr::arrange(sheet, row, col)
    }

    if (data_structure$demographics$orientation == "landscape") {
      df_dem_cats <- df_in |>
        dplyr::filter(
          col >= data_structure$demographics$start_index &
            row %in%
              c(
                data_structure$demographics$demographic_loc,
                data_structure$demographics$category_loc
              ) &
            !is_blank
        ) |>
        dplyr::mutate(
          name = dplyr::case_when(
            row == data_structure$demographics$demographic_loc ~ "demographic",
            row == data_structure$demographics$category_loc ~ "category",
          )
        ) |>
        dplyr::select(col, name, value = character) |>
        tidyr::pivot_wider(names_from = name, values_from = value) |>
        dplyr::arrange(col) |>
        tidyr::fill(demographic, .direction = "down")
    }

    if (data_structure$measures$orientation == "portrait") {
      df_measures <- df_in |>
        dplyr::filter(
          col == data_structure$measures$measure_loc &
            row >= data_structure$measures$start_index &
            !is_blank
        ) |>
        dplyr::select(row, question_measure = character)
    }

    if (
      data_structure$demographics$orientation == "landscape" &
        data_structure$measures$orientation == "portrait"
    ) {
      df_out <- df_data |>
        dplyr::left_join(df_dem_cats, by = "col") |>
        dplyr::left_join(df_measures, by = "row") |>
        dplyr::arrange(row, col) |>
        dplyr::select(demographic, category, question_measure, value)
    }

    if (!is.null(value_convert) && value_convert == "scale_100") {
      df_out <- df_out |>
        dplyr::mutate(
          value = dplyr::if_else(value <= 1, value * 100, value)
        )
    }
  }

  return(df_out)
}
