# 02-00.  Question & metrics metadata processing
#         > Data extraction functions
# =========================================================================

.base_csps_table <- function() {
  tibble::tibble(
    year = character(),
    organisation = character(),
    demographic1_var = character(),
    demographic1_cat = character(),
    demographic2_var = character(),
    demographic2_cat = character(),
    measure = character(),
    value = numeric()
  )
}

.coerce_to_csps_table <- function(df, year = NULL) {
  
  # ensure year is provided
  if (is.null(year)) {
    if (!("year" %in% names(df))) {
      cli::cli_abort("year required")
    }
  } else {
    if ("year" %in% names(df)) {
      cli::cli_warn("year defined in data and supplied as argument, using data")
    } else if (grepl("20\\d{2}", year) && length(year) == 1) {
      df$year <- as.character(year)
    } else {
      cli::cli_abort("year must be a single item vector of four digits")
    }
  }
  
  # check for measure
  if (!("measure" %in% names(df))) {
    cli::cli_abort("measure is missing from the data")
  }
  
  # check for value
  if (!("value" %in% names(df))) {
    cli::cli_abort("value is missing from the data")
  }

  # ensure value is numeric
  df$value <- as.numeric(df$value)
  
  # scale up percentages
  df <- df |>
    dplyr::mutate(
      value = dplyr::case_when(
        is.na(value) ~ NA_real_,
        Mod(value) > 1 ~ value,
        value >= 0 & value <= 1 ~ value * 100,
        TRUE ~ value
      )
    )
  
  # drop organisation grouping and codes
  if (sum(grepl("dep.*group", names(df), ignore.case = TRUE)) > 0) {
    group_col <- which(grepl("dep.*group", names(df), ignore.case = TRUE))
    df <- df |> dplyr::select(-all_of(group_col))
  }
  if (sum(grepl("org.*code", names(df), ignore.case = TRUE)) > 0) {
    group_col <- which(grepl("org.*code", names(df), ignore.case = TRUE))
    df <- df |> dplyr::select(-all_of(group_col))
  }
  
  # ensure everything except value is character
  df <- df |>
    dplyr::mutate(
      across(-value, as.character)
    )
  
  # join to the base format
  df_out <- .base_csps_table() |>
    dplyr::bind_rows(df)
  
  return(df_out)
  
}

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
                         names_to = c("year", "measure", "organisation", 
                                      "demographic1_cat"),
                         contains_blanks = FALSE, contains_endnotes = FALSE,
                         rename_first = NULL, drop_na_vals = TRUE, year = NULL,
                         ...) {
  
  if (is.null(encoding)) {
    locale <- readr::default_locale()
  } else {
    locale <- readr::locale(encoding = encoding)
  }
  
  if (is.null(na)) {
    na <- c("", "NA", "n/a", "N/A")
  } else {
    na <- unique(c("", "NA", "n/a", "N/A", na))
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
  
  df_out <- .coerce_to_csps_table(df_pivot, year = year)
  
  return(df_out)
  
}

adv_read_excel <- function(path, sheet, layers = 1, layer_names,
                           col1_label = c("measure", "organisation"),
                           contains_endnotes = FALSE,
                           drop_differences = FALSE, year = NULL) {
  
  df <- tidyxl::xlsx_cells(path, sheet, include_blank_cells = FALSE)
  
  col1_label <- match.arg(col1_label)
  
  df <- df |>
    dplyr::mutate(
      character = dplyr::if_else(address == "A1", col1_label, character)
    )
  
  if (contains_endnotes) {
    notes_header <- df[["row"]][which(df[["character"]] == "Notes")]
    df <- df |> 
      dplyr::filter(row < notes_header)
  }
  
  df <- df |>
    dplyr::mutate(
      value = dplyr::if_else(data_type == "numeric", 
                             as.character(numeric),
                             character)
    )
  
  layer_vals <- df |>
    dplyr::filter(row <= layers) |>
    dplyr::filter(col != 1) |>
    dplyr::select(row, col, value) |>
    dplyr::mutate(
      value = stringr::str_squish(value),
      layer = paste0("layer", row)
    ) |>
    dplyr::select(-row) |>
    tidyr::pivot_wider(names_from = layer, values_from = value) |>
    dplyr::arrange(col) |>
    tidyr::fill(layer1)
  
  layer_cols <- paste0("layer", seq_len(layers))
  names(layer_cols) <- layer_names
  
  n_detect <- grepl("\\(n=\\d", layer_vals$layer2)
  
  if (sum(n_detect) > 0) {
    n_df <- layer_vals |>
      dplyr::filter(grepl("\\(n=\\d", layer_vals$layer2)) |>
      tidyr::separate(layer2, into = c("layer2", "value"), sep = "\\s\\(n=") |>
      dplyr::mutate(
        measure = "Number of responses",
        value = readr::parse_number(gsub("\\)", "", value))
      ) |>
      dplyr::select(-col, tidyselect::all_of(layer_cols), measure, value)
  }
  
  layer_vals <- layer_vals |>
    dplyr::mutate(
      layer2 = gsub("\\s\\(n=\\d.*$", "", layer2)
    )
  
  col1_vals <- df |>
    dplyr::filter(col == 1, row > layers) |>
    dplyr::select(row, character) |>
    dplyr::mutate(character = stringr::str_squish(character)) |>
    dplyr::rename("{col1_label}" := character)
  
  df_out <- df |> 
    dplyr::filter(col != 1) |>
    dplyr::left_join(layer_vals, by = "col") |>
    dplyr::left_join(col1_vals, by = "row") |>
    dplyr::filter(row > layers) |>
    dplyr::select(
      {{ col1_label }},
      tidyselect::all_of(layer_cols),
      value = numeric
    )
  
  if (drop_differences) {
    chk_col <- names(layer_cols)[layer_cols == "layer1"]
    
    drop_rows <- grepl("difference", df_out[[chk_col]], ignore.case = TRUE)
    
    df_out <- df_out[!drop_rows, ]
  }
  
  if (sum(n_detect) > 0) {
    df_out <- df_out |>
      dplyr::bind_rows(n_df)
  }
  
  df_out <- .coerce_to_csps_table(df_out, year = year)
  
  return(df_out)
  
}