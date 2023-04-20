# 01-01.  Question & metrics metadata processing
#         > Extract question wordings
# =========================================================================

# extract column headings
extract_header <- function(path, sep = ",") {
  scan(
    file = path,
    what = character(),
    sep = sep,
    quote = "\"",
    nlines = 1,
    quiet = TRUE
  )
}

extract_first_col <- function(path, locale = NULL) {
  
  if (is.null(locale)) {
    locale = readr::default_locale()
  }
  
  suppressMessages(df <- readr::read_csv(
    file = path,
    locale = locale,
    col_select = 1
  ))
  
  df[[1]]
}

extract_first_two_cols <- function(path, locale = NULL) {
  
  if (is.null(locale)) {
    locale = readr::default_locale()
  }
  
  suppressMessages(df <- readr::read_csv(
    file = path,
    locale = locale,
    col_select = 1:2
  ))
  
  df
}

extract_excel_row <- function(path, sheet = 1, row = 1) {
  df <- suppressMessages(readxl::read_excel(path = path, sheet = sheet))
  df <- df[row, ] |> tidyr::pivot_longer(cols = everything())
  df$value
}

extract_excel_col <- function(path, sheet = 1, col = 1) {
  df <- suppressMessages(readxl::read_excel(path = path, sheet = sheet))
  df[[col]]
}

extract_ods_row <- function(path, sheet = 1, row = 1) {
  df <- readODS::read_ods(path = path, sheet = sheet) |> janitor::clean_names()
  df <- df[row, ] |> tidyr::pivot_longer(cols = everything())
  df$value
}

extract_ods_cols <- function(path, sheet = 1, start_col = 1, cols = 1,
                             row_to_names = NULL) {
  df <- readODS::read_ods(path = path, sheet = sheet) |> janitor::clean_names() |>
    tibble::as_tibble()
  df <- df[,start_col:(start_col+cols-1)]
  
  if (!is.null(row_to_names)) {
    df <- df |> janitor::row_to_names(row_to_names)
  }
  
  df
  
}

# get questions -----------------------------------------------------------

# 2009-2013 benchmark scores are only available in a single 2013 publication
qm_0913_bm <- extract_first_col("raw-data/2013/csps2013_benchmarks_20131125.csv")

# 2009-2012 only organisation scores are published
qm_2009_org <- extract_header("raw-data/2009/csps2009_allorganisations_20140213.csv")
qm_2010_org <- extract_header("raw-data/2010/csps2010allorganisations_tcm6-38334.csv")
qm_2011_org <- extract_header("raw-data/2011/csps2011_allorganisations_20120202.csv")
qm_2012_org <- extract_header("raw-data/2012/csps2012_allorganisations_20130201.csv")

# 2013 contains organisation scores, demographic scores and scores for the SCS
# from 2009 to 2013
qm_2013_org <- extract_header("raw-data/2013/csps2013_allorganisations_20140213.csv")
qm_2013_dem <- extract_first_col("raw-data/2013/csps2013_demographic_results.csv")
qm_2013_scs <- extract_first_col("raw-data/2013/csps2013_scs.csv")

# 2014 contains benchmark scores, organisation scores and demographic scores
qm_2014_bm <- extract_first_col("raw-data/2014/csps2014_benchmarks.csv")
qm_2014_org <- extract_header("raw-data/2014/csps2014_allorganisations_20141120.csv")
qm_2014_dem <- extract_first_col("raw-data/2014/csps2014_demographics.csv")
qm_2014_dem <- qm_2014_dem[4:122]     # remove sheet header and notes

# 2014 also includes detailed demographic sheets, the layout of most sheets
# matches that of the main demographics, except the organisation sheets
qm_2014_dem_org <- extract_excel_row(
  "raw-data/2014/csps2014_bme_detailedresults.xlsx",
  sheet = "Organisation-2014"
)

# 2015 contains benchmark scores, organisation scores, demographic scores
# and detailed demographic scores
qm_2015_bm <- extract_first_col("raw-data/2015/csps2015_benchmarks_csv.csv")
qm_2015_org <- extract_header("raw-data/2015/csps2015_allorganisations_csv.csv")
qm_2015_dem <- extract_first_col("raw-data/2015/Civil-Service-People-Survey-2015-results-by-demographic-groups-csv.csv")
qm_2015_dem <- qm_2015_dem[4:132] # remove sheet header and notes
qm_2015_dem_org <- extract_excel_row(
  "raw-data/2015/Civil-Service-People-Survey-2015-results-by-ethnicity.xlsx",
  sheet = "Organisation-2015"
)

# 2016 contains benchmark scores, organisation scores, demographic scores
# and detailed demographic scores
qm_2016_bm <- extract_first_two_cols("raw-data/2016/civil_service_peoples_survey_2016_benchmark_scores.csv")
qm_2016_org <- extract_header("raw-data/2016/civil_service_peoples_survey_2016_all_org_scores.csv")
qm_2016_dem <- extract_first_col(
  "raw-data/2015/Civil-Service-People-Survey-2015-results-by-demographic-groups-csv.csv"
)
qm_2016_dem <- qm_2016_dem[4:132] # remove sheet header and notes
qm_2016_dem_org <- extract_excel_row(
  "raw-data/2016/Civil-Service-People-Survey-2016-results-by-ethnicity.xlsx",
  sheet = "Organisation-2016"
)

# 2017 contains benchmark scores, organisation scores, demographic scores
# and detailed demographic scores
qm_2017_bm <- extract_first_two_cols("raw-data/2017/Civil_Service_People_Survey_2017_Benchmark_scores__CSV_.csv")
qm_2017_org <- extract_header("raw-data/2017/Civil_Service_People_Survey_2017_All_Organisation_Scores__CSV_.csv")
qm_2017_dem <- extract_excel_col("raw-data/2017/Civil_Service_People_Survey_2017_results_by_demographic_groups.xlsx")
qm_2017_dem <- qm_2017_dem[3:128] # remove sheet header and notes
qm_2017_dem_org <- extract_excel_row(
  "raw-data/2017/Civil_Service_People_Survey_2017_results_by_ethnicity.xlsx",
  sheet = "Organisation-2017"
)

# 2018 contains benchmark scores, mean scores of all respondents,
# organisation scores, demographic scores and detailed demographic scores
qm_2018_bm <- extract_first_two_cols("raw-data/2018/Civil-Service-People-Survey-2009-2018-Median-Benchmark-Scores.csv")
qm_2018_mean <- extract_first_two_cols("raw-data/2018/Civil-Service-People-Survey-2009-2018-Mean-Civil-Servants-Scores.csv")
qm_2018_org <- extract_header("raw-data/2018/Civil-Service-People-Survey-2018-All-Organisation-Scores-v2.0.csv")
qm_2018_dem <- extract_excel_col("raw-data/2018/Civil-Service-People-Survey-2018-results-by-all-demographic-groups.xlsx")
qm_2018_dem <- qm_2018_dem[3:129] # remove sheet header and notes
qm_2018_dem_org <- extract_excel_row(
  "raw-data/2018/Civil-Service-People-Survey-2018-results-by-ethnicity.xlsx",
  sheet = "Organisation-2018"
)

# 2019 contains benchmark scores, mean scores of all respondents,
# organisation scores, demographic scores and detailed demographic scores, it
# also contains results relating to the socio-economic background of civil
# servants and CSPS results split by those groupings
qm_2019_bm <- extract_first_two_cols("raw-data/2019/Civil-Service-People-Survey-2009-to-2019-Median-Benchmark-Scores-CSV.csv")
qm_2019_mean <- extract_first_two_cols("raw-data/2019/Civil-Service-People-Survey-2009-to-2019-Mean-Civil-Servants-Scores-CSV.csv")
qm_2019_org <- extract_header("raw-data/2019/Civil-Service-People-Survey-2019-All-Organisation-Scores-CSV-format.csv")
qm_2019_dem <- extract_excel_col("raw-data/2019/Civil-Service-People-Survey-2019-results-by-all-demographic-groups.xlsx")
qm_2019_dem <- qm_2019_dem[3:133] # remove sheet header and notes
qm_2019_dem_org <- extract_excel_row(
  "raw-data/2019/Civil-Service-People-Survey-2019-results-by-ethnicity.xlsx",
  sheet = "Organisation-2019"
)

# 2020 contains benchmark scores, mean scores of all respondents,
# organisation scores, demographic scores and detailed demographic scores, it
# also contains results relating to the socio-economic background of civil
# servants and CSPS results split by those groupings
qm_2020_bm <- extract_first_two_cols("raw-data/2020/Civil_Service_People_Survey_2009_to_2020_Median_Benchmark_Scores.csv")
qm_2020_mean <- extract_first_two_cols("raw-data/2020/Civil_Service_People_Survey_2009_to_2020_Mean_Benchmark_Scores.csv")
qm_2020_org <- readODS::read_ods(
  "raw-data/2020/Civil_Service_People_Survey_2020-_All_organisation_scores.ods",
  sheet = "Table_3_2") |> tibble::tibble()
qm_2020_dem <- extract_ods_row(
  "raw-data/2020/Civil-Service-People-Survey-2020-results-by-all-demographics-v2.ods",
  sheet = "Benchmarks", row = 4)
qm_2020_dem <- qm_2020_dem[3:146] # remove sheet header and notes
qm_2020_dem_org <- extract_ods_row(
  "raw-data/2020/Civil-Service-People-Survey-2020-results-by-ethnicity-v2.ods",
  sheet = "Organisations", row = 4)
qm_2020_dem_org <- qm_2020_dem_org[5:17]


# 2021 contains benchmark scores, mean scores of all respondents,
# organisation scores, demographic scores and detailed demographic scores, it
# also contains results relating to the socio-economic background of civil
# servants and CSPS results split by those groupings
qm_2021_bm <- extract_ods_cols(
  "raw-data/2021/Civil_Service_People_Survey_2009_2021_Benchmarks_v2.ods",
  sheet = "Table_1", start_col = 1, cols = 2, row_to_names = 4
)
qm_2021_mean <- extract_ods_cols(
  "raw-data/2021/Civil_Service_People_Survey_2009_2021_Benchmarks_v2.ods",
  sheet = "Table_2", start_col = 1, cols = 2, row_to_names = 4
)
qm_2021_org <- extract_ods_row(
  "raw-data/2021/Civil_Service_People_Survey_2009_2021_Benchmarks_v2.ods",
  sheet = "Table_3", row = 4
)
qm_2021_org <- qm_2021_org[5:130]
qm_2021_dem <- extract_ods_row(
  "raw-data/2021/Civil-Service-People-Survey-2021-results-by-all-demographics.ods",
  sheet = "Benchmarks", row = 4)
qm_2021_dem <- qm_2021_dem[3:147] # remove sheet header and notes
qm_2021_dem_org <- extract_ods_row(
  "raw-data/2021/Civil-Service-People-Survey-2021-results-by-ethnicity.ods",
  sheet = "Organisations", row = 4)
qm_2021_dem_org <- qm_2021_dem_org[6:18]

# 2022 contains benchmark scores, mean scores of all respondents,
# organisation scores; other results not yet published (as at 2023-04-19)
qm_2022_bm <- extract_ods_cols(
  "raw-data/2022/Civil_Service_People_Survey_2022_Benchmark_Results.ods",
  sheet = "Table_1", start_col = 1, cols = 2, row_to_names = 5
)
qm_2022_mean <- extract_ods_cols(
  "raw-data/2022/Civil_Service_People_Survey_2022_Benchmark_Results.ods",
  sheet = "Table_2", start_col = 1, cols = 2, row_to_names = 5
)
qm_2022_org <- extract_ods_row(
  "raw-data/2022/Civil_Service_People_Survey_2022_Benchmark_Results.ods",
  sheet = "Table_3", row = 5
)
qm_2022_org <- qm_2022_org[5:120]




# get unified data --------------------------------------------------------

# get names of question objects
#  - for some reason ls() doesn't work inside tibble::tibble()
nm_qms <- ls(pattern = "^qm_")

# function to extract question labels from objects
get_vals <- function(x, class) {
  if (class == "character") {
    return(get(x))
  } else if (class == "tbl_df") {
    
    df <- get(x)
    
    if ("Label" %in% names(df)) {
      return(df[["Label"]])
    } else if ("Question text" %in% names(df)) {
      return(df[["Question text"]])
    } else {
      return(NULL)
    }
    
  } else {
    return(NULL)
  }
}

# unified table of values
tbl_qms <- tibble::tibble(
  obj = nm_qms
) |>
  dplyr::mutate(
    obj_class = purrr::map_chr(.x = obj, .f = ~class(get(.x))[1]),
    obj_vals = purrr::map2(.x = obj, .y = obj_class, .f = get_vals)
  ) |>
  tidyr::unnest(obj_vals) |>
  dplyr::mutate(
    # handle windows encoding errors
    obj_vals = iconv(obj_vals, "UTF-8", "UTF-8", "")
  ) |>
  tidyr::drop_na(obj_vals) |>
  dplyr::filter(obj_vals != "")

# add cleaned version of questions, stripping question numbers,
# square brackets, scale/logic information
tbl_qms_clean <- tbl_qms |> 
  dplyr::mutate(
    # remove some scale information
    stripped_vals = gsub("\\(0=not.*", "", obj_vals),
    stripped_vals = gsub("\\(0=not.*", "", stripped_vals),
    stripped_vals = gsub("\\(% strongly.*", "", stripped_vals),
    # convert between word underscores
    stripped_vals = gsub("_([A-z])", " \\1", stripped_vals),
    # remove question numbers in scale information
    stripped_vals = gsub("(.*\\(%.*)([A-Z]\\d{2}.*)", "\\1", stripped_vals),
    # remove question logic/routing
    stripped_vals = gsub("\\s\\(Asked.*\\)", ": ", stripped_vals),
    # remove extract colons
    stripped_vals = gsub(": : ", ": ", stripped_vals),
    # remove explanatory notes
    stripped_vals = gsub("\\s\\d$", "", stripped_vals),
    stripped_vals = gsub("\\s\\[note.*", "", stripped_vals),
    # remove aggregation information
    stripped_vals = gsub("\\s\\([A-Z]\\d{2}.*", "", stripped_vals),
    # remove aggregation information
    stripped_vals = gsub("\\s\\(mean weight.*", "", stripped_vals),
    # remove leading question number
    stripped_vals = gsub(
      "^[A-Z]\\d{2}[A-Z]?_\\d{1,2}[\\.|\\:]?\\s?|^[A-Z]\\d{2}\\_[A-Z][:|\\.]\\s?|^[A-Z]\\d{2}[A-Z]?[\\.|\\:]\\s?|^[A-Z]\\d{2}\\s|^[A-Z]\\.\\s|^\\w+[\\.|\\:]",
      "", 
      stripped_vals,
    ),
    # replace quotation marks
    stripped_vals = gsub("<94>", "\"", stripped_vals),
    stripped_vals = gsub("<92>", "\"", stripped_vals),
    # remove square brackets (variable terms)
    stripped_vals = gsub("\\[", "", stripped_vals),
    stripped_vals = gsub("\\]", "", stripped_vals),
    # remove leading space
    stripped_vals = gsub("^\\s", "", stripped_vals),
    # remove notes with trailing space
    stripped_vals = gsub("\\d?\\s?$", "", stripped_vals),
    # remove trailing spaces
    stripped_vals = gsub("\\s?$", "", stripped_vals),
    # remove calculation information
    stripped_vals = gsub("\\s\\(mean.*$", "", stripped_vals),
    stripped_vals = gsub("\\s\\(high.*$", "", stripped_vals),
    stripped_vals = gsub("\\s\\(indicates.*$", "", stripped_vals),
    # replace punctuation
    stripped_vals = gsub(" – ", ": ", stripped_vals),
    # convert to lower case
    stripped_vals = tolower(stripped_vals)
  )

readr::write_csv(tbl_qms_clean, "code/tbl_qms_clean.csv")

