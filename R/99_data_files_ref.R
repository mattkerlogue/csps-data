data_files_yml <- yaml::read_yaml("raw-data/00_data_files.yaml")

data_files <- tibble::tibble(
  file_id = names(unlist(data_files_yml)),
  file_path = unlist(data_files_yml)
) |>
  tidyr::separate(
    col = file_id,
    into = c("year", "content", "file_type"),
    sep = "\\.",
    remove = FALSE
  ) |>
  dplyr::mutate(
    file_id = gsub("^\\d{4}\\.", "", file_id, perl = TRUE),
    year = as.integer(gsub("^csps", "", year, perl = TRUE)),
    file_type = dplyr::case_match(
      file_type,
      "c" ~ "csv",
      "o" ~ "ods",
      "x" ~ "xlsx"
    ),
    benchmark = content == "benchmarks" | content == "organisations",
    means = content == "means" |
      year >= 2021 & content == "benchmarks" |
      year >= 2019 & content == "organisations",
    organisations = content == "organisations" |
      year >= 2021 & content == "benchmarks",
    demographics = content == "demographics",
    details_ethnicity = content == "details_ethnicity",
    details_gender = content == "details_gender",
    details_health = content == "details_health",
    details_lgbt = content == "details_lgbt",
    details_seb = content == "details_seb",
    highlights = content == "highlights",
    scs = content == "scs" | content == "demographics",
    across(where(is.logical), ~ dplyr::if_else(.x == FALSE, NA, .x))
  ) |>
  dplyr::select(
    file_id,
    file_path,
    year,
    file_type,
    benchmark,
    means,
    organisations,
    demographics,
    details_ethnicity,
    details_gender,
    details_health,
    details_lgbt,
    details_seb,
    highlights,
    scs
  )

readr::write_excel_csv(data_files, "raw-data/00_data_files.csv", na = "")
