data_files_yml <- yaml12::read_yaml("raw-data/00_data_files.yaml")

data_files <- tibble::tibble(
  year = names(data_files_yml)
) |>
  dplyr::mutate(
    files = purrr::map(
      .x = year,
      .f = ~ data_files_yml[[.x]]
    )
  ) |>
  tidyr::unnest_longer(
    col = files,
    values_to = "file_path",
    indices_to = "file_id"
  ) |>
  dplyr::mutate(
    file_type = tools::file_ext(file_path),
    file_type = dplyr::if_else(grepl("xls", file_type), "xlsx", file_type),
    content = gsub("\\..$", "", file_id),
    file_id = paste(year, file_id, sep = "."),
    year = as.integer(gsub("csps", "", year))
  ) |>
  dplyr::select(file_id, year, content, file_type, file_path)

readr::write_excel_csv(data_files, "raw-data/00_data_files.csv")

data_coverage <- data_files |>
  dplyr::distinct(year, content) |>
  # add refs for data contained in other files
  dplyr::add_row(
    # 2009-12 benchmarks are contained in the 2013 benchmarks csv file
    # 2009-12 SCS scores are contained in the 2013 SCS csv file, from 2014
    #   onwards the SCS results are included as part of the demographic scores
    year = rep(2009:2012, 2),
    content = c(rep("benchmarks", 4), rep("scs", 4))
  ) |>
  dplyr::add_row(
    # from 2021 the mean and organisation scores are contained in the
    # benchmarks ods file
    year = rep(2021:2024, 2),
    content = c(rep("means", 4), rep("organisations", 4))
  ) |>
  dplyr::mutate(value = TRUE) |>
  tidyr::pivot_wider(names_from = year, values_from = value) |>
  dplyr::mutate(
    content = factor(
      content,
      levels = c(
        "benchmarks",
        "means",
        "organisations",
        "demographics",
        "details_ethnicity",
        "details_gender",
        "details_health",
        "details_lgbt",
        "details_seb",
        "scs",
        "report.benchmark_report",
        "report.departmental_trends",
        "report.summary_highlights",
        "report.demographic_results",
        "report.scs_results",
        "report.technical_guide",
        "report.core_questionnaire"
      )
    )
  ) |>
  dplyr::arrange(content)

readr::write_excel_csv(data_coverage, "raw-data/00_data_coverage.csv")
