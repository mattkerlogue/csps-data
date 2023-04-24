# 02-01.  Question & metrics metadata processing
#         > Extract data
# =========================================================================


# helper functions --------------------------------------------------------

source("code/02-00_data-extract-functions.R")

# 2009-2013 benchmarks ----------------------------------------------------

df_0913_bm <- adv_read_csv(
  path = "raw-data/2013/csps2013_benchmarks_20131125.csv",
  encoding = "latin1",
  col_types = "cnnnnn____"
)


# 2009-2012 organisation scores -------------------------------------------

# 2009 organisation scores
df_2009_org <- adv_read_csv(
  "raw-data/2009/csps2009_allorganisations_20140213.csv",
  col_types = paste0("c", "c", paste0(rep("n", 71), collapse = "")),
  encoding = "latin1", names_to = "measure", year = 2009
)

# 2010 organisation scores
df_2010_org <- adv_read_csv(
  "raw-data/2010/csps2010allorganisations_tcm6-38334.csv",
  col_types = paste0("c", "c", paste0(rep("n", 73), collapse = "")),
  names_to = "measure", year = 2010
)

# 2011 organisation scores
df_2011_org <- adv_read_csv(
  "raw-data/2011/csps2011_allorganisations_20120202.csv",
  col_types = paste0("c", "c", paste0(rep("n", 72), collapse = "")),
  names_to = "measure", year = 2011
)

# 2012 organisation scores
df_2012_org <- adv_read_csv(
  "raw-data/2012/csps2012_allorganisations_20130201.csv",
  col_types = paste0("c", "c", paste0(rep("n", 81), collapse = "")),
  names_to = "measure", year = 2012
)


# 2013 scores: organisation and demographic -------------------------------

# 2013 organisation scores
df_2013_org <- adv_read_csv(
  "raw-data/2013/csps2013_allorganisations_20140213.csv",
  col_types = paste0("c", "c", paste0(rep("n", 82), collapse = "")),
  names_to = "measure", year = 2013
)

# 2013 demographic scores
df_2013_dem <- adv_read_excel(
  path = "raw-data/2013/csps2013_demographic_results.xlsx",
  sheet = 1, layers = 2,
  layer_names = c("demographic1_var", "demographic1_cat"),
  year = 2013
)

# 2009-2013 SCS scores
df_2013_scs <- adv_read_csv(
  "raw-data/2013/csps2013_scs.csv",
  encoding = "latin1",
  col_types = "cnnnnn____"
) |>
  dplyr::mutate(
    demographic1_var = "Grade",
    demographic1_cat = "SCS"
  )



# 2014 scores -------------------------------------------------------------

# 2014 benchmark scores
df_2014_bm <- adv_read_csv(
  "raw-data/2014/csps2014_benchmarks.csv",
  col_types = paste0("c", paste0(rep("n", 6), collapse = ""))
)

# 2014 organisation scores
df_2014_org <- adv_read_csv(
  "raw-data/2014/csps2014_allorganisations_20141120.csv",
  col_types = paste0("c", "c", paste0(rep("n", 82), collapse = "")),
  names_to = "measure", year = 2014
)

# 2014 overall demographic scores
df_2014_dem <- adv_read_excel(
  path = "raw-data/2014/csps2014_demographics.xlsx",
  sheet = 1, layers = 2,
  layer_names = c("demographic1_var", "demographic1_cat"),
  contains_endnotes = TRUE, year = 2014
)


# 2014 scores: ethnicity --------------------------------------------------

# 2009-2014 ethnicity trend
df_0914_dem_ethnicity <- adv_read_excel (
  path = "raw-data/2014/csps2014_bme_detailedresults.xlsx" ,
  sheet = "Trend", layers = 2,
  layer_names = c("demographic1_cat", "year"),
  contains_endnotes = TRUE, drop_differences = TRUE
) |>
  dplyr::mutate(
    demographic1_var = "Ethnicity - binary",
  )

# 2014 detailed demographic results - white
df_2014_d2_white <- adv_read_excel (
  path = "raw-data/2014/csps2014_bme_detailedresults.xlsx",
  sheet = "2014 - White", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2014
) |>
  dplyr::mutate(
    demographic1_var = "Ethnicity - binary",
    demographic1_cat = "White",
  )

# 2014 detailed demographic results - white
df_2014_d2_em <- adv_read_excel (
  path = "raw-data/2014/csps2014_bme_detailedresults.xlsx",
  sheet = "2014 - BME", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2014
) |>
  dplyr::mutate(
    demographic1_var = "Ethnicity - binary",
    demographic1_cat = "BME",
  )

# 2009 organisation by ethnicity
df_2009_dorg_eth <- adv_read_excel (
  path = "raw-data/2014/csps2014_bme_detailedresults.xlsx",
  sheet = "Organisation-2009", layers = 2, col1_label = "organisation",
  layer_names = c("demographic1_cat", "measure"),
  drop_differences = TRUE, year = 2009
) |>
  dplyr::mutate(
    demographic1_var = "Ethnicity - binary",
  )

# 2010 organisation by ethnicity
df_2010_dorg_eth <- adv_read_excel (
  path = "raw-data/2014/csps2014_bme_detailedresults.xlsx",
  sheet = "Organisation-2010", layers = 2, col1_label = "organisation",
  layer_names = c("demographic1_cat", "measure"),
  drop_differences = TRUE, year = 2010
) |>
  dplyr::mutate(
    demographic1_var = "Ethnicity - binary",
  )

# 2011 organisation by ethnicity
df_2011_dorg_eth <- adv_read_excel (
  path = "raw-data/2014/csps2014_bme_detailedresults.xlsx",
  sheet = "Organisation-2011", layers = 2, col1_label = "organisation",
  layer_names = c("demographic1_cat", "measure"),
  drop_differences = TRUE, year = 2011
) |>
  dplyr::mutate(
    demographic1_var = "Ethnicity - binary",
  )

# 2012 organisation by ethnicity
df_2012_dorg_eth <- adv_read_excel (
  path = "raw-data/2014/csps2014_bme_detailedresults.xlsx",
  sheet = "Organisation-2012", layers = 2, col1_label = "organisation",
  layer_names = c("demographic1_cat", "measure"),
  drop_differences = TRUE, year = 2012
) |>
  dplyr::mutate(
    demographic1_var = "Ethnicity - binary",
  )

# 2013 organisation by ethnicity
df_2013_dorg_eth <- adv_read_excel (
  path = "raw-data/2014/csps2014_bme_detailedresults.xlsx",
  sheet = "Organisation-2013", layers = 2, col1_label = "organisation",
  layer_names = c("demographic1_cat", "measure"),
  drop_differences = TRUE, year = 2013
) |>
  dplyr::mutate(
    demographic1_var = "Ethnicity - binary",
  )

# 2014 organisation by ethnicity
df_2014_dorg_eth <- adv_read_excel (
  path = "raw-data/2014/csps2014_bme_detailedresults.xlsx",
  sheet = "Organisation-2014", layers = 2, col1_label = "organisation",
  layer_names = c("demographic1_cat", "measure"),
  drop_differences = TRUE, year = 2014
) |>
  dplyr::mutate(
    demographic1_var = "Ethnicity - binary",
  )


# 2014 scores: disability -------------------------------------------------

# 2009-2014 disability trend
df_0914_dem_disability <- adv_read_excel (
  path = "raw-data/2014/csps2014_disability_detailedresults.xlsx" ,
  sheet = "Trend", layers = 2,
  layer_names = c("demographic1_cat", "year"),
  contains_endnotes = TRUE, drop_differences = TRUE
) |>
  dplyr::mutate(
    demographic1_var = "Long-term health [J04/J4A]",
  )

# 2014 detailed demographic results - no ltli
df_2014_d2_noltli <- adv_read_excel (
  path = "raw-data/2014/csps2014_disability_detailedresults.xlsx",
  sheet = "2014 - No LTLI", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2014
) |>
  dplyr::mutate(
    demographic1_var = "Long-term health [J04/J4A]",
    demographic1_cat = "No long-term limiting illness/condition or an illness/condition has no impact on daily activities/work",
  )

# 2014 detailed demographic results - ltli
df_2014_d2_ltli <- adv_read_excel (
  path = "raw-data/2014/csps2014_disability_detailedresults.xlsx",
  sheet = "2014 - LTLI", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2014
) |>
  dplyr::mutate(
    demographic1_var = "Long-term health [J04/J4A]",
    demographic1_cat = "Long-term limiting illness or condition which has an impact on daily activities/work",
  )

# 2009 organisation by disability
df_2009_dorg_dis <- adv_read_excel (
  path = "raw-data/2014/csps2014_disability_detailedresults.xlsx",
  sheet = "Organisation-2009", layers = 2, col1_label = "organisation",
  layer_names = c("demographic1_cat", "measure"),
  drop_differences = TRUE, year = 2009
) |>
  dplyr::mutate(
    demographic1_var = "Long-term health [J04/J4A]",
  )

# 2010 organisation by disability
df_2010_dorg_dis <- adv_read_excel (
  path = "raw-data/2014/csps2014_disability_detailedresults.xlsx",
  sheet = "Organisation-2010", layers = 2, col1_label = "organisation",
  layer_names = c("demographic1_cat", "measure"),
  drop_differences = TRUE, year = 2010
) |>
  dplyr::mutate(
    demographic1_var = "Long-term health [J04/J4A]",
  )

# 2011 organisation by disability
df_2011_dorg_dis <- adv_read_excel (
  path = "raw-data/2014/csps2014_disability_detailedresults.xlsx",
  sheet = "Organisation-2011", layers = 2, col1_label = "organisation",
  layer_names = c("demographic1_cat", "measure"),
  drop_differences = TRUE, year = 2011
) |>
  dplyr::mutate(
    demographic1_var = "Long-term health [J04/J4A]",
  )

# 2012 organisation by disability
df_2012_dorg_dis <- adv_read_excel (
  path = "raw-data/2014/csps2014_disability_detailedresults.xlsx",
  sheet = "Organisation-2012", layers = 2, col1_label = "organisation",
  layer_names = c("demographic1_cat", "measure"),
  drop_differences = TRUE, year = 2012
) |>
  dplyr::mutate(
    demographic1_var = "Long-term health [J04/J4A]",
  )

# 2013 organisation by disability
df_2013_dorg_dis <- adv_read_excel (
  path = "raw-data/2014/csps2014_disability_detailedresults.xlsx",
  sheet = "Organisation-2013", layers = 2, col1_label = "organisation",
  layer_names = c("demographic1_cat", "measure"),
  drop_differences = TRUE, year = 2013
) |>
  dplyr::mutate(
    demographic1_var = "Long-term health [J04/J4A]",
  )

# 2014 organisation by disability
df_2014_dorg_dis <- adv_read_excel (
  path = "raw-data/2014/csps2014_disability_detailedresults.xlsx",
  sheet = "Organisation-2014", layers = 2, col1_label = "organisation",
  layer_names = c("demographic1_cat", "measure"),
  drop_differences = TRUE, year = 2014
) |>
  dplyr::mutate(
    demographic1_var = "Long-term health [J04/J4A]",
  )


# 2014 scores: sex --------------------------------------------------------

# 2009-2014 sex trend
df_0914_dem_sex <- adv_read_excel (
  path = "raw-data/2014/csps2014_gender_detailedresults.xlsx" ,
  sheet = "Trend", layers = 2,
  layer_names = c("demographic1_cat", "year"),
  contains_endnotes = TRUE, drop_differences = TRUE
) |>
  dplyr::mutate(
    demographic1_var = "Sex [J01]",
  )

# 2014 detailed demographic results - female
df_2014_d2_female <- adv_read_excel (
  path = "raw-data/2014/csps2014_gender_detailedresults.xlsx",
  sheet = "2014 - female", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2014
) |>
  dplyr::mutate(
    demographic1_var = "Sex [J01]",
    demographic1_cat = "Female",
  )

# 2014 detailed demographic results - male
df_2014_d2_male <- adv_read_excel (
  path = "raw-data/2014/csps2014_gender_detailedresults.xlsx",
  sheet = "2014 - male", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2014
) |>
  dplyr::mutate(
    demographic1_var = "Sex [J01]",
    demographic1_cat = "Male",
  )

# 2009 organisation by sex
df_2009_dorg_sex <- adv_read_excel (
  path = "raw-data/2014/csps2014_gender_detailedresults.xlsx",
  sheet = "Organisation-2009", layers = 2, col1_label = "organisation",
  layer_names = c("demographic1_cat", "measure"),
  drop_differences = TRUE, year = 2009
) |>
  dplyr::mutate(
    demographic1_var = "Sex [J01]",
  )

# 2010 organisation by sex
df_2010_dorg_sex <- adv_read_excel (
  path = "raw-data/2014/csps2014_gender_detailedresults.xlsx",
  sheet = "Organisation-2010", layers = 2, col1_label = "organisation",
  layer_names = c("demographic1_cat", "measure"),
  drop_differences = TRUE, year = 2010
) |>
  dplyr::mutate(
    demographic1_var = "Sex [J01]",
  )

# 2011 organisation by sex
df_2011_dorg_sex <- adv_read_excel (
  path = "raw-data/2014/csps2014_gender_detailedresults.xlsx",
  sheet = "Organisation-2011", layers = 2, col1_label = "organisation",
  layer_names = c("demographic1_cat", "measure"),
  drop_differences = TRUE, year = 2011
) |>
  dplyr::mutate(
    demographic1_var = "Sex [J01]",
  )

# 2012 organisation by sex
df_2012_dorg_sex <- adv_read_excel (
  path = "raw-data/2014/csps2014_gender_detailedresults.xlsx",
  sheet = "Organisation-2012", layers = 2, col1_label = "organisation",
  layer_names = c("demographic1_cat", "measure"),
  drop_differences = TRUE, year = 2012
) |>
  dplyr::mutate(
    demographic1_var = "Sex [J01]",
  )

# 2013 organisation by sex
df_2013_dorg_sex <- adv_read_excel (
  path = "raw-data/2014/csps2014_gender_detailedresults.xlsx",
  sheet = "Organisation-2013", layers = 2, col1_label = "organisation",
  layer_names = c("demographic1_cat", "measure"),
  drop_differences = TRUE, year = 2013
) |>
  dplyr::mutate(
    demographic1_var = "Sex [J01]",
  )

# 2014 organisation by sex
df_2014_dorg_sex <- adv_read_excel (
  path = "raw-data/2014/csps2014_gender_detailedresults.xlsx",
  sheet = "Organisation-2014", layers = 2, col1_label = "organisation",
  layer_names = c("demographic1_cat", "measure"),
  drop_differences = TRUE, year = 2014
) |>
  dplyr::mutate(
    demographic1_var = "Sex [J01]",
  )


# 2014 scores: lgb --------------------------------------------------------

# 2014 detailed demographic results - sexual orientation by gender
df_2014_dem_lgbdet <- adv_read_excel (
  path = "raw-data/2014/csps2014_lgb_detailedresults.xlsx",
  sheet = "2014 - LGB by gender", layers = 2,
  layer_names = c("demographic1_cat", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2015
) |>
  dplyr::mutate(
    demographic1_var = "Sex [J01]",
    demographic2_var = "Sexual identity - expanded [J07]"
  )

# 2009-2014 lgb trend
df_0914_dem_lgb <- adv_read_excel (
  path = "raw-data/2014/csps2014_lgb_detailedresults.xlsx" ,
  sheet = "Trend", layers = 2,
  layer_names = c("demographic1_cat", "year"),
  contains_endnotes = TRUE, drop_differences = TRUE
) |>
  dplyr::mutate(
    demographic1_var = "Sexual identity [J07]",
  )

# 2014 detailed demographic results - heterosexual
df_2014_d2_hetero <- adv_read_excel (
  path = "raw-data/2014/csps2014_lgb_detailedresults.xlsx",
  sheet = "2014 - Heterosexual", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2014
) |>
  dplyr::mutate(
    demographic1_var = "Sexual identity [J07]",
    demographic1_cat = "Heterosexual/straight",
  )

# 2014 detailed demographic results - lgb
df_2014_d2_lgb <- adv_read_excel (
  path = "raw-data/2014/csps2014_lgb_detailedresults.xlsx",
  sheet = "2014 - LGB", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2014
) |>
  dplyr::mutate(
    demographic1_var = "Sexual identity [J07]",
    demographic1_cat = "LGB",
  )

# 2009 organisation by lgb
df_2009_dorg_lgb <- adv_read_excel (
  path = "raw-data/2014/csps2014_lgb_detailedresults.xlsx",
  sheet = "Organisation-2009", layers = 2, col1_label = "organisation",
  layer_names = c("demographic1_cat", "measure"),
  drop_differences = TRUE, year = 2009
) |>
  dplyr::mutate(
    demographic1_var = "Sexual identity [J07]",
  )

# 2010 organisation by lgb
df_2010_dorg_lgb <- adv_read_excel (
  path = "raw-data/2014/csps2014_lgb_detailedresults.xlsx",
  sheet = "Organisation-2010", layers = 2, col1_label = "organisation",
  layer_names = c("demographic1_cat", "measure"),
  drop_differences = TRUE, year = 2010
) |>
  dplyr::mutate(
    demographic1_var = "Sexual identity [J07]",
  )

# 2011 organisation by lgb
df_2011_dorg_lgb <- adv_read_excel (
  path = "raw-data/2014/csps2014_lgb_detailedresults.xlsx",
  sheet = "Organisation-2011", layers = 2, col1_label = "organisation",
  layer_names = c("demographic1_cat", "measure"),
  drop_differences = TRUE, year = 2011
) |>
  dplyr::mutate(
    demographic1_var = "Sexual identity [J07]",
  )

# 2012 organisation by lgb
df_2012_dorg_lgb <- adv_read_excel (
  path = "raw-data/2014/csps2014_lgb_detailedresults.xlsx",
  sheet = "Organisation-2012", layers = 2, col1_label = "organisation",
  layer_names = c("demographic1_cat", "measure"),
  drop_differences = TRUE, year = 2012
) |>
  dplyr::mutate(
    demographic1_var = "Sexual identity [J07]",
  )

# 2013 organisation by lgb
df_2013_dorg_lgb <- adv_read_excel (
  path = "raw-data/2014/csps2014_lgb_detailedresults.xlsx",
  sheet = "Organisation-2013", layers = 2, col1_label = "organisation",
  layer_names = c("demographic1_cat", "measure"),
  drop_differences = TRUE, year = 2013
) |>
  dplyr::mutate(
    demographic1_var = "Sexual identity [J07]",
  )

# 2014 organisation by lgb
df_2014_dorg_lgb <- adv_read_excel (
  path = "raw-data/2014/csps2014_lgb_detailedresults.xlsx",
  sheet = "Organisation-2014", layers = 2, col1_label = "organisation",
  layer_names = c("demographic1_cat", "measure"),
  drop_differences = TRUE, year = 2014
) |>
  dplyr::mutate(
    demographic1_var = "Sexual identity [J07]",
  )


# 2015 scores -------------------------------------------------------------

# 2015 benchmark scores
df_2015_bm <- adv_read_csv(
  "raw-data/2015/csps2015_benchmarks_csv.csv",
  col_types = paste0("c", paste0(rep("n", 7), collapse = ""))
)

# 2015 organisation scores
df_2015_org <- adv_read_csv(
  "raw-data/2015/csps2015_allorganisations_csv.csv",
  col_types = paste0("c", "c", paste0(rep("n", 161), collapse = "")),
  names_to = "measure", year = 2015
)

# 2015 overall demographic scores
df_2015_dem <- adv_read_excel(
  path = "raw-data/2015/Civil-Service-People-Survey-2015-results-by-demographic-groups.xlsx",
  sheet = 1, layers = 2,
  layer_names = c("demographic1_var", "demographic1_cat"),
  contains_endnotes = TRUE, year = 2015
)

# 2015 scores: ethnicity --------------------------------------------------

# 2015 detailed demographic results - white
df_2015_d2_white <- adv_read_excel (
  path = "raw-data/2015/Civil-Service-People-Survey-2015-results-by-ethnicity.xlsx",
  sheet = "2015 - White", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2015
) |>
  dplyr::mutate(
    demographic1_var = "Ethnicity - binary",
    demographic1_cat = "White",
  )

# 2015 detailed demographic results - ethnic minority
df_2015_d2_em <- adv_read_excel (
  path = "raw-data/2015/Civil-Service-People-Survey-2015-results-by-ethnicity.xlsx",
  sheet = "2015 - BME", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2015
) |>
  dplyr::mutate(
    demographic1_var = "Ethnicity - binary",
    demographic1_cat = "BME",
  )

# 2015 organisation by ethnicity
df_2015_dorg_eth <- adv_read_excel (
  path = "raw-data/2015/Civil-Service-People-Survey-2015-results-by-ethnicity.xlsx",
  sheet = "Organisation-2015", layers = 2, col1_label = "organisation",
  layer_names = c("demographic1_cat", "measure"),
  drop_differences = TRUE, year = 2015
) |>
  dplyr::mutate(
    demographic1_var = "Ethnicity - binary",
  )

# 2015 scores: disability -------------------------------------------------

# 2015 detailed demographic results - all health conditions
df_2015_dem_disdet <- adv_read_excel (
  path = "raw-data/2015/Civil-Service-People-Survey-2015-results-by-health-status.xlsx",
  sheet = "2015 - health categories", layers = 2,
  layer_names = c("demographic1_cat", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2015
) |>
  dplyr::mutate(
    demographic1_var = "Long-term health [J04/J4A]",
    demographic2_var = "Impact [J4A]",
  )

# 2015 detailed demographic results - no ltli
df_2015_d2_noltli <- adv_read_excel (
  path = "raw-data/2015/Civil-Service-People-Survey-2015-results-by-health-status.xlsx",
  sheet = "2015 - No LTLI", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2015
) |>
  dplyr::mutate(
    demographic1_var = "Long-term health [J04/J4A]",
    demographic1_cat = "No long-term limiting illness/condition or an illness/condition has no impact on daily activities/work",
  )

# 2015 detailed demographic results - ltli
df_2015_d2_ltli <- adv_read_excel (
  path = "raw-data/2015/Civil-Service-People-Survey-2015-results-by-health-status.xlsx",
  sheet = "2015 - LTLI", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2015
) |>
  dplyr::mutate(
    demographic1_var = "Long-term health [J04/J4A]",
    demographic1_cat = "Long-term limiting illness or condition which has an impact on daily activities/work",
  )

# 2015 organisation by disability
df_2015_dorg_dis <- adv_read_excel (
  path = "raw-data/2015/Civil-Service-People-Survey-2015-results-by-health-status.xlsx",
  sheet = "Organisation-2015", layers = 2, col1_label = "organisation",
  layer_names = c("demographic1_cat", "measure"),
  drop_differences = TRUE, year = 2015
) |>
  dplyr::mutate(
    demographic1_var = "Long-term health [J04/J4A]",
  )


# 2015 scores: sex --------------------------------------------------------

# 2015 detailed demographic results - female
df_2015_d2_female <- adv_read_excel (
  path = "raw-data/2015/Civil-Service-People-Survey-2015-results-by-gender.xlsx",
  sheet = "2015 - female", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2015
) |>
  dplyr::mutate(
    demographic1_var = "Sex [J01]",
    demographic1_cat = "Female",
  )

# 2015 detailed demographic results - male
df_2015_d2_male <- adv_read_excel (
  path = "raw-data/2015/Civil-Service-People-Survey-2015-results-by-gender.xlsx",
  sheet = "2015 - male", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2015
) |>
  dplyr::mutate(
    demographic1_var = "Sex [J01]",
    demographic1_cat = "Male",
  )

# 2015 organisation by sex
df_2015_dorg_sex <- adv_read_excel (
  path = "raw-data/2015/Civil-Service-People-Survey-2015-results-by-gender.xlsx",
  sheet = "Organisation-2015", layers = 2, col1_label = "organisation",
  layer_names = c("demographic1_cat", "measure"),
  drop_differences = TRUE, year = 2015
) |>
  dplyr::mutate(
    demographic1_var = "Sex [J01]",
  )


# 2015 scores: lgb --------------------------------------------------------

# 2015 detailed demographic results - sexual orientation by gender
df_2015_dem_lgbdet <- adv_read_excel (
  path = "raw-data/2015/Civil-Service-People-Survey-2015-results-by-sexual-identity.xlsx",
  sheet = "2015 - LGB by gender", layers = 2,
  layer_names = c("demographic1_cat", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2015
) |>
  dplyr::mutate(
    demographic1_var = "Sex [J01]",
    demographic2_var = "Sexual identity - expanded [J07]"
  )

# 2015 detailed demographic results - heterosexual
df_2015_d2_hetero <- adv_read_excel (
  path = "raw-data/2015/Civil-Service-People-Survey-2015-results-by-sexual-identity.xlsx",
  sheet = "2015 - Heterosexual", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2015
) |>
  dplyr::mutate(
    demographic1_var = "Sexual identity [J07]",
    demographic1_cat = "Heterosexual/straight",
  )

# 2015 detailed demographic results - lgb
df_2015_d2_lgb <- adv_read_excel (
  path = "raw-data/2015/Civil-Service-People-Survey-2015-results-by-sexual-identity.xlsx",
  sheet = "2015 - LGB", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2015
) |>
  dplyr::mutate(
    demographic1_var = "Sexual identity [J07]",
    demographic1_cat = "LGB",
  )

# 2015 organisation by lgb
df_2015_dorg_lgb <- adv_read_excel (
  path = "raw-data/2015/Civil-Service-People-Survey-2015-results-by-sexual-identity.xlsx",
  sheet = "Organisation-2015", layers = 2, col1_label = "organisation",
  layer_names = c("demographic1_cat", "measure"),
  drop_differences = TRUE, year = 2015
) |>
  dplyr::mutate(
    demographic1_var = "Sexual identity [J07]",
  )


# 2016 scores -------------------------------------------------------------

# 2016 benchmark scores
df_2016_bm <- adv_read_csv(
  "raw-data/2016/civil_service_peoples_survey_2016_benchmark_scores.csv",
  col_types = paste0("_c", paste0(rep("n", 7), collapse = "")),
  rename_first = "measure"
)

# 2016 organisation scores
df_2016_org <- adv_read_csv(
  "raw-data/2016/civil_service_peoples_survey_2016_all_org_scores.csv",
  col_types = paste0("c", "c", "c", paste0(rep("n", 85), collapse = "")),
  names_to = "measure", na = ".", year = 2016
)

# 2016 overall demographic scores
df_2016_dem <- adv_read_excel(
  path = "raw-data/2016/Civil-Service-People-Survey-2016-results-by-demographic-groups.xlsx",
  sheet = 1, layers = 2,
  layer_names = c("demographic1_var", "demographic1_cat"),
  contains_endnotes = TRUE, year = 2016
)

# 2016 scores: ethnicity --------------------------------------------------

# 2016 detailed demographic results - white
df_2016_d2_white <- adv_read_excel (
  path = "raw-data/2016/Civil-Service-People-Survey-2016-results-by-ethnicity.xlsx",
  sheet = "2016 - White", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2016
) |>
  dplyr::mutate(
    demographic1_var = "Ethnicity - binary",
    demographic1_cat = "White",
  )

# 2016 detailed demographic results - ethnic minority
df_2016_d2_em <- adv_read_excel (
  path = "raw-data/2016/Civil-Service-People-Survey-2016-results-by-ethnicity.xlsx",
  sheet = "2016 - BAME", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2016
) |>
  dplyr::mutate(
    demographic1_var = "Ethnicity - binary",
    demographic1_cat = "BAME",
  )

# 2016 organisation by ethnicity
df_2016_dorg_eth <- adv_read_excel (
  path = "raw-data/2016/Civil-Service-People-Survey-2016-results-by-ethnicity.xlsx",
  sheet = "Organisation-2016", layers = 2, col1_label = "organisation",
  layer_names = c("demographic1_cat", "measure"),
  drop_differences = TRUE, year = 2016
) |>
  dplyr::mutate(
    demographic1_var = "Ethnicity - binary",
  )

# 2016 scores: disability -------------------------------------------------

# 2016 detailed demographic results - all health conditions
df_2016_dem_disdet <- adv_read_excel (
  path = "raw-data/2016/Civil-Service-People-Survey-2016-results-by-health-status.xlsx",
  sheet = "2016 - health categories", layers = 2,
  layer_names = c("demographic1_cat", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2016
) |>
  dplyr::mutate(
    demographic1_var = "Long-term health [J04/J4A]",
    demographic2_var = "Impact [J4A]",
  )

# 2016 detailed demographic results - no ltli
df_2016_d2_noltli <- adv_read_excel (
  path = "raw-data/2016/Civil-Service-People-Survey-2016-results-by-health-status.xlsx",
  sheet = "2016 - No LTLI", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2016
) |>
  dplyr::mutate(
    demographic1_var = "Long-term health [J04/J4A]",
    demographic1_cat = "No long-term limiting illness/condition or an illness/condition has no impact on daily activities/work",
  )

# 2016 detailed demographic results - ltli
df_2016_d2_ltli <- adv_read_excel (
  path = "raw-data/2016/Civil-Service-People-Survey-2016-results-by-health-status.xlsx",
  sheet = "2016 - LTLI", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2016
) |>
  dplyr::mutate(
    demographic1_var = "Long-term health [J04/J4A]",
    demographic1_cat = "Long-term limiting illness or condition which has an impact on daily activities/work",
  )

# 2016 organisation by disability
df_2016_dorg_dis <- adv_read_excel (
  path = "raw-data/2016/Civil-Service-People-Survey-2016-results-by-health-status.xlsx",
  sheet = "Organisation-2016", layers = 2, col1_label = "organisation",
  layer_names = c("demographic1_cat", "measure"),
  drop_differences = TRUE, year = 2016
) |>
  dplyr::mutate(
    demographic1_var = "Long-term health [J04/J4A]",
  )


# 2016 scores: sex --------------------------------------------------------

# 2016 detailed demographic results - female
df_2016_d2_female <- adv_read_excel (
  path = "raw-data/2016/Civil-Service-People-Survey-2016-results-by-gender.xlsx",
  sheet = "2016 - Female", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2016
) |>
  dplyr::mutate(
    demographic1_var = "Sex [J01]",
    demographic1_cat = "Female",
  )

# 2016 detailed demographic results - male
df_2016_d2_male <- adv_read_excel (
  path = "raw-data/2016/Civil-Service-People-Survey-2016-results-by-gender.xlsx",
  sheet = "2016 - Male", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2016
) |>
  dplyr::mutate(
    demographic1_var = "Sex [J01]",
    demographic1_cat = "Male",
  )

# 2016 organisation by sex
df_2016_dorg_sex <- adv_read_excel (
  path = "raw-data/2016/Civil-Service-People-Survey-2016-results-by-gender.xlsx",
  sheet = "Organisation-2016", layers = 2, col1_label = "organisation",
  layer_names = c("demographic1_cat", "measure"),
  drop_differences = TRUE, year = 2016
) |>
  dplyr::mutate(
    demographic1_var = "Sex [J01]",
  )


# 2016 scores: lgb --------------------------------------------------------

# 2016 detailed demographic results - sexual orientation by gender
df_2016_dem_lgbdet <- adv_read_excel (
  path = "raw-data/2016/Civil-Service-People-Survey-2016-results-by-sexual-identity.xlsx",
  sheet = "2016 - LGBO by gender", layers = 2,
  layer_names = c("demographic1_cat", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2016
) |>
  dplyr::mutate(
    demographic1_var = "Sex [J01]",
    demographic2_var = "Sexual identity - expanded [J07]"
  )

# 2016 detailed demographic results - heterosexual
df_2016_d2_hetero <- adv_read_excel (
  path = "raw-data/2016/Civil-Service-People-Survey-2016-results-by-sexual-identity.xlsx",
  sheet = "2016 - Heterosexual", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2016
) |>
  dplyr::mutate(
    demographic1_var = "Sexual identity [J07]",
    demographic1_cat = "Heterosexual/straight",
  )

# 2016 detailed demographic results - lgb
df_2016_d2_lgb <- adv_read_excel (
  path = "raw-data/2016/Civil-Service-People-Survey-2016-results-by-sexual-identity.xlsx",
  sheet = "2016 - LGBO", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2016
) |>
  dplyr::mutate(
    demographic1_var = "Sexual identity [J07]",
    demographic1_cat = "LGBO",
  )

# 2016 organisation by lgb
df_2016_dorg_lgbo <- adv_read_excel (
  path = "raw-data/2016/Civil-Service-People-Survey-2016-results-by-sexual-identity.xlsx",
  sheet = "Organisation-2016", layers = 2, col1_label = "organisation",
  layer_names = c("demographic1_cat", "measure"),
  drop_differences = TRUE, year = 2016
) |>
  dplyr::mutate(
    demographic1_var = "Sexual identity [J07]",
  )

# 2017 scores -------------------------------------------------------------

# 2017 benchmark scores
df_2017_bm <- adv_read_csv(
  "raw-data/2017/Civil_Service_People_Survey_2017_Benchmark_scores__CSV_.csv",
  col_types = paste0("_c", paste0(rep("n", 9), collapse = "")),
  rename_first = "measure"
)

# 2017 organisation scores
df_2017_org <- adv_read_csv(
  "raw-data/2017/Civil_Service_People_Survey_2017_All_Organisation_Scores__CSV_.csv",
  col_types = paste0("c", "c", "c", paste0(rep("n", 84), collapse = "")),
  names_to = "measure", na = ".", year = 2017
)

# 2017 overall demographic scores
df_2017_dem <- adv_read_excel(
  path = "raw-data/2017/Civil_Service_People_Survey_2017_results_by_demographic_groups.xlsx",
  sheet = 1, layers = 2,
  layer_names = c("demographic1_var", "demographic1_cat"),
  contains_endnotes = TRUE, year = 2017
)

# 2017 scores: ethnicity --------------------------------------------------

# 2017 detailed demographic results - white
df_2017_d2_white <- adv_read_excel (
  path = "raw-data/2017/Civil_Service_People_Survey_2017_results_by_ethnicity.xlsx",
  sheet = "2017 - White", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2017
) |>
  dplyr::mutate(
    demographic1_var = "Ethnicity - binary",
    demographic1_cat = "White",
  )

# 2017 detailed demographic results - ethnic minority
df_2017_d2_em <- adv_read_excel (
  path = "raw-data/2017/Civil_Service_People_Survey_2017_results_by_ethnicity.xlsx",
  sheet = "2017 - Ethnic Minority", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2017
) |>
  dplyr::mutate(
    demographic1_var = "Ethnicity - binary",
    demographic1_cat = "Ethnic minority",
  )

# 2017 organisation by ethnicity
df_2017_dorg_eth <- adv_read_excel (
  path = "raw-data/2017/Civil_Service_People_Survey_2017_results_by_ethnicity.xlsx",
  sheet = "Organisation-2017", layers = 2, col1_label = "organisation",
  layer_names = c("demographic1_cat", "measure"),
  drop_differences = TRUE, year = 2017
) |>
  dplyr::mutate(
    demographic1_var = "Ethnicity - binary",
  )

# 2017 scores: disability -------------------------------------------------

# 2017 detailed demographic results - all health conditions
df_2017_dem_disdet <- adv_read_excel (
  path = "raw-data/2017/Civil_Service_People_Survey_2017_results_by_health_status.xlsx",
  sheet = "2017 - health categories", layers = 2,
  layer_names = c("demographic1_cat", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2017
) |>
  dplyr::mutate(
    demographic1_var = "Long-term health [J04/J4A]",
    demographic2_var = "Impact [J4A]",
  )

# 2017 detailed demographic results - no ltlc
df_2017_d2_noltlc <- adv_read_excel (
  path = "raw-data/2017/Civil_Service_People_Survey_2017_results_by_health_status.xlsx",
  sheet = "2017 - No LTLC", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2017
) |>
  dplyr::mutate(
    measure = tidyr::replace_na(measure, "Number of respondents"),
    demographic1_var = "Long-term health [J04/J4A]",
    demographic1_cat = "No long-term limiting illness/condition or an illness/condition has no impact on daily activities/work",
  )

# 2017 detailed demographic results - ltlc
df_2017_d2_ltlc <- adv_read_excel (
  path = "raw-data/2017/Civil_Service_People_Survey_2017_results_by_health_status.xlsx",
  sheet = "2017 - LTLC", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2017
) |>
  dplyr::mutate(
    measure = tidyr::replace_na(measure, "Number of respondents"),
    demographic1_var = "Long-term health [J04/J4A]",
    demographic1_cat = "Long-term limiting illness or condition which has an impact on daily activities/work",
  )

# 2017 organisation by disability
df_2017_dorg_dis <- adv_read_excel (
  path = "raw-data/2017/Civil_Service_People_Survey_2017_results_by_health_status.xlsx",
  sheet = "Organisation-2017", layers = 2, col1_label = "organisation",
  layer_names = c("demographic1_cat", "measure"),
  drop_differences = TRUE, year = 2017
) |>
  dplyr::mutate(
    demographic1_var = "Long-term health [J04/J4A]",
  )


# 2017 scores: sex --------------------------------------------------------

# 2017 detailed demographic results - female
df_2017_d2_female <- adv_read_excel (
  path = "raw-data/2017/Civil_Service_People_Survey_2017_results_by_gender.xlsx",
  sheet = "2017 - Female", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2017
) |>
  dplyr::mutate(
    demographic1_var = "Sex [J01]",
    demographic1_cat = "Female",
  )

# 2017 detailed demographic results - male
df_2017_d2_male <- adv_read_excel (
  path = "raw-data/2017/Civil_Service_People_Survey_2017_results_by_gender.xlsx",
  sheet = "2017 - Male", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2017
) |>
  dplyr::mutate(
    demographic1_var = "Sex [J01]",
    demographic1_cat = "Male",
  )

# 2017 detailed demographic results - identify another way
df_2017_d2_sexother <- adv_read_excel (
  path = "raw-data/2017/Civil_Service_People_Survey_2017_results_by_gender.xlsx",
  sheet = "2017 - Identify in another ", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2017
) |>
  dplyr::mutate(
    demographic1_var = "Sex [J01]",
    demographic1_cat = "I identify in another way",
  )

# 2017 organisation by sex
df_2017_dorg_sex <- adv_read_excel (
  path = "raw-data/2017/Civil_Service_People_Survey_2017_results_by_gender.xlsx",
  sheet = "Organisation-2017", layers = 2, col1_label = "organisation",
  layer_names = c("demographic1_cat", "measure"),
  drop_differences = TRUE, year = 2017
) |>
  dplyr::mutate(
    demographic1_var = "Sex [J01]",
  )


# 2017 scores: lgb --------------------------------------------------------

# 2017 detailed demographic results - sexual orientation by gender
df_2017_dem_lgbdet <- adv_read_excel (
  path = "raw-data/2017/Civil_Service_People_Survey_2017_results_by_sexual_orientation.xlsx",
  sheet = "2017 - LGBO by gender", layers = 2,
  layer_names = c("demographic1_cat", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2017
) |>
  dplyr::mutate(
    demographic1_var = "Sex [J01]",
    demographic2_var = "Sexual identity - expanded [J07]"
  )

# 2017 detailed demographic results - heterosexual
df_2017_d2_hetero <- adv_read_excel (
  path = "raw-data/2017/Civil_Service_People_Survey_2017_results_by_sexual_orientation.xlsx",
  sheet = "2017 - Heterosexual", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2017
) |>
  dplyr::mutate(
    measure = tidyr::replace_na(measure, "Number of respondents"),
    demographic1_var = "Sexual identity [J07]",
    demographic1_cat = "Heterosexual/straight",
  )

# 2017 detailed demographic results - lgb
df_2017_d2_lgb <- adv_read_excel (
  path = "raw-data/2017/Civil_Service_People_Survey_2017_results_by_sexual_orientation.xlsx",
  sheet = "2017 - LGBO", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2017
) |>
  dplyr::mutate(
    measure = tidyr::replace_na(measure, "Number of respondents"),
    demographic1_var = "Sexual identity [J07]",
    demographic1_cat = "LGBO",
  )

# 2017 organisation by lgb
df_2017_dorg_lgbo <- adv_read_excel (
  path = "raw-data/2017/Civil_Service_People_Survey_2017_results_by_sexual_orientation.xlsx",
  sheet = "Organisation-2017", layers = 2, col1_label = "organisation",
  layer_names = c("demographic1_cat", "measure"),
  drop_differences = TRUE, year = 2017
) |>
  dplyr::mutate(
    demographic1_var = "Sexual identity [J07]",
  )

# 2018 scores -------------------------------------------------------------

# 2018 benchmark scores
df_2018_bm <- adv_read_csv(
  "raw-data/2018/Civil-Service-People-Survey-2009-2018-Median-Benchmark-Scores.csv",
  col_types = paste0("_c", paste0(rep("n", 10), collapse = "")),
  rename_first = "measure"
)

# 2018 mean scores
df_2018_mean <- adv_read_csv(
  "raw-data/2018/Civil-Service-People-Survey-2009-2018-Mean-Civil-Servants-Scores.csv",
  col_types = paste0("_c", paste0(rep("n", 10), collapse = "")),
  rename_first = "measure"
)

# 2018 organisation scores
df_2018_org <- adv_read_csv(
  "raw-data/2018/Civil-Service-People-Survey-2018-All-Organisation-Scores-v2.0.csv",
  col_types = paste0("c", "c", "c", paste0(rep("n", 86), collapse = "")),
  names_to = "measure", na = ".", year = 2018
)

# 2018 overall demographic scores
df_2018_dem <- adv_read_excel(
  path = "raw-data/2018/Civil-Service-People-Survey-2018-results-by-all-demographic-groups.xlsx",
  sheet = 1, layers = 2,
  layer_names = c("demographic1_var", "demographic1_cat"),
  contains_endnotes = TRUE, year = 2018
)

# 2018 scores: ethnicity --------------------------------------------------

# 2018 detailed demographic results - white
df_2018_d2_white <- adv_read_excel (
  path = "raw-data/2018/Civil-Service-People-Survey-2018-results-by-ethnicity.xlsx",
  sheet = "2018 - White", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2018
) |>
  dplyr::mutate(
    demographic1_var = "Ethnicity - binary",
    demographic1_cat = "White",
  )

# 2018 detailed demographic results - ethnic minority
df_2018_d2_em <- adv_read_excel (
  path = "raw-data/2018/Civil-Service-People-Survey-2018-results-by-ethnicity.xlsx",
  sheet = "2018 - Ethnic Minority", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2018
) |>
  dplyr::mutate(
    demographic1_var = "Ethnicity - binary",
    demographic1_cat = "Ethnic minority",
  )

# 2018 organisation by ethnicity
df_2018_dorg_eth <- adv_read_excel (
  path = "raw-data/2018/Civil-Service-People-Survey-2018-results-by-ethnicity.xlsx",
  sheet = "Organisation-2018", layers = 2, col1_label = "organisation",
  layer_names = c("demographic1_cat", "measure"),
  drop_differences = TRUE, year = 2018
) |>
  dplyr::mutate(
    demographic1_var = "Ethnicity - binary",
  )

# 2018 scores: disability -------------------------------------------------

# 2018 detailed demographic results - all health conditions
df_2018_dem_disdet <- adv_read_excel (
  path = "raw-data/2018/Civil-Service-People-Survey-2018-results-by-health-status.xlsx",
  sheet = "2018 - health categories", layers = 2,
  layer_names = c("demographic1_cat", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2018
) |>
  dplyr::mutate(
    demographic1_var = "Long-term health [J04/J4A]",
    demographic2_var = "Impact [J4A]",
  )

# 2018 detailed demographic results - no ltlc
df_2018_d2_noltlc <- adv_read_excel (
  path = "raw-data/2018/Civil-Service-People-Survey-2018-results-by-health-status.xlsx",
  sheet = "2018 - No LTLC", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2018
) |>
  dplyr::mutate(
    measure = tidyr::replace_na(measure, "Number of respondents"),
    demographic1_var = "Long-term health [J04/J4A]",
    demographic1_cat = "No long-term limiting illness/condition or an illness/condition has no impact on daily activities/work",
  )

# 2018 detailed demographic results - ltlc
df_2018_d2_ltlc <- adv_read_excel (
  path = "raw-data/2018/Civil-Service-People-Survey-2018-results-by-health-status.xlsx",
  sheet = "2018 - LTLC", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2018
) |>
  dplyr::mutate(
    measure = tidyr::replace_na(measure, "Number of respondents"),
    demographic1_var = "Long-term health [J04/J4A]",
    demographic1_cat = "Long-term limiting illness or condition which has an impact on daily activities/work",
  )

# 2018 organisation by disability
df_2018_dorg_dis <- adv_read_excel (
  path = "raw-data/2018/Civil-Service-People-Survey-2018-results-by-health-status.xlsx",
  sheet = "Organisation-2018", layers = 2, col1_label = "organisation",
  layer_names = c("demographic1_cat", "measure"),
  drop_differences = TRUE, year = 2018
) |>
  dplyr::mutate(
    demographic1_var = "Long-term health [J04/J4A]",
  )


# 2018 scores: sex --------------------------------------------------------

# 2018 detailed demographic results - female
df_2018_d2_female <- adv_read_excel (
  path = "raw-data/2018/Civil-Service-People-Survey-2018-results-by-gender.xlsx",
  sheet = "2018 - Woman", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2018
) |>
  dplyr::mutate(
    demographic1_var = "Sex [J01]",
    demographic1_cat = "Woman",
  )

# 2018 detailed demographic results - male
df_2018_d2_male <- adv_read_excel (
  path = "raw-data/2018/Civil-Service-People-Survey-2018-results-by-gender.xlsx",
  sheet = "2018 - Man", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2018
) |>
  dplyr::mutate(
    demographic1_var = "Sex [J01]",
    demographic1_cat = "Man",
  )

# 2018 detailed demographic results - identify another way
df_2018_d2_sexother <- adv_read_excel (
  path = "raw-data/2018/Civil-Service-People-Survey-2018-results-by-gender.xlsx",
  sheet = "2018 - Identify in another way", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2018
) |>
  dplyr::mutate(
    demographic1_var = "Sex [J01]",
    demographic1_cat = "I identify in another way",
  )

# 2018 organisation by sex
df_2018_dorg_sex <- adv_read_excel (
  path = "raw-data/2018/Civil-Service-People-Survey-2018-results-by-gender.xlsx",
  sheet = "Organisation-2018", layers = 2, col1_label = "organisation",
  layer_names = c("demographic1_cat", "measure"),
  drop_differences = TRUE, year = 2018
) |>
  dplyr::mutate(
    demographic1_var = "Sex [J01]",
  )


# 2018 scores: lgb --------------------------------------------------------

# 2018 detailed demographic results - sexual orientation by gender
df_2018_dem_lgbdet <- adv_read_excel (
  path = "raw-data/2018/Civil-Service-People-Survey-2018-results-by-sexual-orientation.xlsx",
  sheet = "2018 - LGBO by gender", layers = 2,
  layer_names = c("demographic1_cat", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2018
) |>
  dplyr::mutate(
    demographic1_var = "Sex [J01]",
    demographic2_var = "Sexual identity - expanded [J07]"
  )

# 2018 detailed demographic results - heterosexual
df_2018_d2_hetero <- adv_read_excel (
  path = "raw-data/2018/Civil-Service-People-Survey-2018-results-by-sexual-orientation.xlsx",
  sheet = "2018 - Heterosexual", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2018
) |>
  dplyr::mutate(
    measure = tidyr::replace_na(measure, "Number of respondents"),
    demographic1_var = "Sexual identity [J07]",
    demographic1_cat = "Heterosexual/straight",
  )

# 2018 detailed demographic results - lgb
df_2018_d2_lgb <- adv_read_excel (
  path = "raw-data/2018/Civil-Service-People-Survey-2018-results-by-sexual-orientation.xlsx",
  sheet = "2018 - LGBO", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2018
) |>
  dplyr::mutate(
    measure = tidyr::replace_na(measure, "Number of respondents"),
    demographic1_var = "Sexual identity [J07]",
    demographic1_cat = "LGBO",
  )

# 2018 organisation by lgb
df_2018_dorg_lgbo <- adv_read_excel (
  path = "raw-data/2018/Civil-Service-People-Survey-2018-results-by-sexual-orientation.xlsx",
  sheet = "Organisation-2018", layers = 2, col1_label = "organisation",
  layer_names = c("demographic1_cat", "measure"),
  drop_differences = TRUE, year = 2018
) |>
  dplyr::mutate(
    demographic1_var = "Sexual identity [J07]",
  )

# 2019 scores -------------------------------------------------------------

# 2019 benchmark scores
df_2019_bm <- adv_read_csv(
  "raw-data/2019/Civil-Service-People-Survey-2009-to-2019-Median-Benchmark-Scores-CSV.csv",
  col_types = paste0("_c", paste0(rep("n", 11), collapse = "")),
  rename_first = "measure"
)

# 2019 mean scores
df_2019_mean <- adv_read_csv(
  "raw-data/2019/Civil-Service-People-Survey-2009-to-2019-Mean-Civil-Servants-Scores-CSV.csv",
  col_types = paste0("_c", paste0(rep("n", 11), collapse = "")),
  rename_first = "measure"
)

# 2019 organisation scores
df_2019_org <- adv_read_csv(
  "raw-data/2019/Civil-Service-People-Survey-2019-All-Organisation-Scores-CSV-format.csv",
  col_types = paste0("c", "c", "c", paste0(rep("n", 92), collapse = "")),
  names_to = "measure", na = ".", year = 2019
)

# 2019 overall demographic scores
df_2019_dem <- adv_read_excel(
  path = "raw-data/2019/Civil-Service-People-Survey-2019-results-by-all-demographic-groups.xlsx",
  sheet = 1, layers = 2,
  layer_names = c("demographic1_var", "demographic1_cat"),
  contains_endnotes = TRUE, year = 2019
)

# 2019 scores: ethnicity --------------------------------------------------

# 2019 detailed demographic results - white
df_2019_d2_white <- adv_read_excel (
  path = "raw-data/2019/Civil-Service-People-Survey-2019-results-by-ethnicity.xlsx",
  sheet = "2019 - White", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2019
) |>
  dplyr::mutate(
    demographic1_var = "Ethnicity - binary",
    demographic1_cat = "White",
  )

# 2019 detailed demographic results - ethnic minority
df_2019_d2_em <- adv_read_excel (
  path = "raw-data/2019/Civil-Service-People-Survey-2019-results-by-ethnicity.xlsx",
  sheet = "2019 - Ethnic Minority", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2019
) |>
  dplyr::mutate(
    demographic1_var = "Ethnicity - binary",
    demographic1_cat = "Ethnic minority",
  )

# 2019 organisation by ethnicity
df_2019_dorg_eth <- adv_read_excel (
  path = "raw-data/2019/Civil-Service-People-Survey-2019-results-by-ethnicity.xlsx",
  sheet = "Organisation-2019", layers = 2, col1_label = "organisation",
  layer_names = c("demographic1_cat", "measure"),
  drop_differences = TRUE, year = 2019
) |>
  dplyr::mutate(
    demographic1_var = "Ethnicity - binary",
  )

# 2019 scores: disability -------------------------------------------------

# 2019 detailed demographic results - all health conditions
df_2019_dem_disdet <- adv_read_excel (
  path = "raw-data/2019/Civil-Service-People-Survey-2019-results-by-health-status.xlsx",
  sheet = "2019 - health categories", layers = 2,
  layer_names = c("demographic1_cat", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2019
) |>
  dplyr::mutate(
    demographic1_var = "Long-term health [J04/J4A]",
    demographic2_var = "Impact [J4A]",
  )

# 2019 detailed demographic results - no ltlc
df_2019_d2_noltlc <- adv_read_excel (
  path = "raw-data/2019/Civil-Service-People-Survey-2019-results-by-health-status.xlsx",
  sheet = "2019 - No LTLC", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2019
) |>
  dplyr::mutate(
    demographic1_var = "Long-term health [J04/J4A]",
    demographic1_cat = "No long-term limiting illness/condition or an illness/condition has no impact on daily activities/work",
  )

# 2019 detailed demographic results - ltlc
df_2019_d2_ltlc <- adv_read_excel (
  path = "raw-data/2019/Civil-Service-People-Survey-2019-results-by-health-status.xlsx",
  sheet = "2019 - LTLC", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2019
) |>
  dplyr::mutate(
    demographic1_var = "Long-term health [J04/J4A]",
    demographic1_cat = "Long-term limiting illness or condition which has an impact on daily activities/work",
  )

# 2019 organisation by disability
df_2019_dorg_dis <- adv_read_excel (
  path = "raw-data/2019/Civil-Service-People-Survey-2019-results-by-health-status.xlsx",
  sheet = "Organisation-2019", layers = 2, col1_label = "organisation",
  layer_names = c("demographic1_cat", "measure"),
  drop_differences = TRUE, year = 2019
) |>
  dplyr::mutate(
    demographic1_var = "Long-term health [J04/J4A]",
  )


# 2019 scores: sex --------------------------------------------------------

# 2019 detailed demographic results - female
df_2019_d2_female <- adv_read_excel (
  path = "raw-data/2019/Civil-Service-People-Survey-2019-results-by-gender.xlsx",
  sheet = "2019 - Woman", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2019
) |>
  dplyr::mutate(
    demographic1_var = "Sex [J01]",
    demographic1_cat = "Woman",
  )

# 2019 detailed demographic results - male
df_2019_d2_male <- adv_read_excel (
  path = "raw-data/2019/Civil-Service-People-Survey-2019-results-by-gender.xlsx",
  sheet = "2019 - Man", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2019
) |>
  dplyr::mutate(
    demographic1_var = "Sex [J01]",
    demographic1_cat = "Man",
  )

# 2019 detailed demographic results - identify another way
df_2019_d2_sexother <- adv_read_excel (
  path = "raw-data/2019/Civil-Service-People-Survey-2019-results-by-gender.xlsx",
  sheet = "2019 - Identify in another way", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2019
) |>
  dplyr::mutate(
    demographic1_var = "Sex [J01]",
    demographic1_cat = "I identify in another way",
  )

# 2019 organisation by sex
df_2019_dorg_sex <- adv_read_excel (
  path = "raw-data/2019/Civil-Service-People-Survey-2019-results-by-gender.xlsx",
  sheet = "Organisation-2019", layers = 2, col1_label = "organisation",
  layer_names = c("demographic1_cat", "measure"),
  drop_differences = TRUE, year = 2019
) |>
  dplyr::mutate(
    demographic1_var = "Sex [J01]",
  )


# 2019 scores: lgb --------------------------------------------------------

# 2019 detailed demographic results - sexual orientation by gender
df_2019_dem_lgbdet <- adv_read_excel (
  path = "raw-data/2019/Civil-Service-People-Survey-2019-results-by-sexual-orientation.xlsx",
  sheet = "2019 - LGBO by gender", layers = 2,
  layer_names = c("demographic1_cat", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2019
) |>
  dplyr::mutate(
    demographic1_var = "Sex [J01]",
    demographic2_var = "Sexual identity - expanded [J07]"
  )

# 2019 detailed demographic results - heterosexual
df_2019_d2_hetero <- adv_read_excel (
  path = "raw-data/2019/Civil-Service-People-Survey-2019-results-by-sexual-orientation.xlsx",
  sheet = "2019 - Heterosexual", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2019
) |>
  dplyr::mutate(
    measure = tidyr::replace_na(measure, "Number of respondents"),
    demographic1_var = "Sexual identity [J07]",
    demographic1_cat = "Heterosexual/straight",
  )

# 2019 detailed demographic results - lgb
df_2019_d2_lgb <- adv_read_excel (
  path = "raw-data/2019/Civil-Service-People-Survey-2019-results-by-sexual-orientation.xlsx",
  sheet = "2019 - LGBO", layers = 2,
  layer_names = c("demographic2_var", "demographic2_cat"),
  contains_endnotes = TRUE, year = 2019
) |>
  dplyr::mutate(
    measure = tidyr::replace_na(measure, "Number of respondents"),
    demographic1_var = "Sexual identity [J07]",
    demographic1_cat = "LGBO",
  )

# 2019 organisation by lgb
df_2019_dorg_lgbo <- adv_read_excel (
  path = "raw-data/2019/Civil-Service-People-Survey-2019-results-by-sexual-orientation.xlsx",
  sheet = "Organisation-2019", layers = 2, col1_label = "organisation",
  layer_names = c("demographic1_cat", "measure"),
  drop_differences = TRUE, year = 2019
) |>
  dplyr::mutate(
    demographic1_var = "Sexual identity [J07]",
  )



# 2020 scores -------------------------------------------------------------

# 2020 benchmark scores
df_2020_bm <- adv_read_csv(
  "raw-data/2020/Civil_Service_People_Survey_2009_to_2020_Mean_Benchmark_Scores.csv",
  col_types = paste0("_c_", paste0(rep("n", 12), collapse = "")),
  rename_first = "measure"
)

# 2020 mean scores
df_2020_mean <- adv_read_csv(
  "raw-data/2020/Civil_Service_People_Survey_2009_to_2020_Mean_Benchmark_Scores.csv",
  col_types = paste0("_c_", paste0(rep("n", 12), collapse = "")),
  rename_first = "measure"
)

# 2020 organisation scores
df_2020_org1 <- adv_read_ods(
  "raw-data/2020/Civil_Service_People_Survey_2020-_All_organisation_scores.ods",
  sheet = "Table_1", start_row = 1, start_col = 3, layers = 1, 
  layer_labels = "organisation", year = 2020
)

df_2020_org2 <- adv_read_ods(
  "raw-data/2020/Civil_Service_People_Survey_2020-_All_organisation_scores.ods",
  sheet = "Table_2", start_row = 1, start_col = 3, layers = 1, 
  layer_labels = "organisation", year = 2020
)

# 2020 demographic scores
df_2020_dem <- adv_read_ods(
  "raw-data/2020/Civil-Service-People-Survey-2020-results-by-all-demographics-v2.ods",
  sheet = "Benchmarks", start_row = 5, start_col = 1, layers = 2, 
  layer_labels = c("demographic1_var", "demographic1_cat"), year = 2020
)


# 2020 scores: ethnicity --------------------------------------------------

# 2020 detailed demographic results - white
df_2020_d2_white <- adv_read_ods(
  "raw-data/2020/Civil-Service-People-Survey-2020-results-by-ethnicity-v2.ods",
  sheet = "White", start_row = 5, start_col = 1, layers = 2, 
  layer_labels = c("demographic2_var", "demographic2_cat"), year = 2020
) |>
  dplyr::mutate(
    demographic1_var = "Ethnicity - binary",
    demographic1_cat = "White",
  )

# 2020 detailed demographic results - ethnic minority
df_2020_d2_em <- adv_read_ods(
  "raw-data/2020/Civil-Service-People-Survey-2020-results-by-ethnicity-v2.ods",
  sheet = "Ethnic_Minority", start_row = 5, start_col = 1, layers = 2, 
  layer_labels = c("demographic2_var", "demographic2_cat"), year = 2020
) |>
  dplyr::mutate(
    demographic1_var = "Ethnicity - binary",
    demographic1_cat = "Ethnic minority",
  )

# 2020 organisation by ethnicity
df_2020_dorg_eth <- adv_read_ods(
  "raw-data/2020/Civil-Service-People-Survey-2020-results-by-ethnicity-v2.ods",
  sheet = "Organisations", start_row = 5, start_col = 3, layers = 2, 
  layer_labels = c("organisation", "demographic1_cat"), year = 2020
) |>
  dplyr::mutate(
    demographic1_var = "Ethnicity - binary"
  )


# 2020 scores: disability -------------------------------------------------

# 2020 detailed demographic results - no ltlc
df_2020_d2_noltlc <- adv_read_ods(
  "raw-data/2020/Civil-Service-People-Survey-2020-results-by-health-v2.ods",
  sheet = "No_LTLC", start_row = 5, start_col = 1, layers = 2, 
  layer_labels = c("demographic2_var", "demographic2_cat"), year = 2020
) |>
  dplyr::mutate(
    demographic1_var = "Z08: Limiting long-term illness, disability or health condition",
    demographic1_cat = "No long-term limiting condition, illness or disability"
  )

# 2020 detailed demographic results - ltlc
df_2020_d2_ltlc <- adv_read_ods(
  "raw-data/2020/Civil-Service-People-Survey-2020-results-by-health-v2.ods",
  sheet = "Has_LTLC", start_row = 5, start_col = 1, layers = 2, 
  layer_labels = c("demographic2_var", "demographic2_cat"), year = 2020
) |>
  dplyr::mutate(
    demographic1_var = "Z08: Limiting long-term illness, disability or health condition",
    demographic1_cat = "Long-term limiting condition, illness or disability"
  )

# 2020 organisation by disability
df_2020_dorg_dis <- adv_read_ods(
  "raw-data/2020/Civil-Service-People-Survey-2020-results-by-ethnicity-v2.ods",
  sheet = "Organisations", start_row = 5, start_col = 3, layers = 2, 
  layer_labels = c("organisation", "demographic1_cat"), year = 2020
) |>
  dplyr::mutate(
    demographic1_var = "Z08: Limiting long-term illness, disability or health condition"
  )


# 2020 scores: sex --------------------------------------------------------

# 2020 detailed splits for sex and gender
df_2019_dem_sexdet <- adv_read_ods(
  "raw-data/2020/Civil-Service-People-Survey-2020-results-by-gender-v2.ods",
  sheet = "Overview", start_row = 5, start_col = 1, layers = 2, 
  layer_labels = c("demographic1_var", "demographic1_cat"), year = 2020
)

# 2020 detailed demographic results - female
df_2020_d2_female <- adv_read_ods(
  "raw-data/2020/Civil-Service-People-Survey-2020-results-by-gender-v2.ods",
  sheet = "Female", start_row = 5, start_col = 1, layers = 2, 
  layer_labels = c("demographic2_var", "demographic2_cat"), year = 2020
) |>
  dplyr::mutate(
    demographic1_var = "J1A: Gender categorisation",
    demographic1_cat = "Female"
  )

# 2020 detailed demographic results - male
df_2020_d2_male <- adv_read_ods(
  "raw-data/2020/Civil-Service-People-Survey-2020-results-by-gender-v2.ods",
  sheet = "Male", start_row = 5, start_col = 1, layers = 2, 
  layer_labels = c("demographic2_var", "demographic2_cat"), year = 2020
) |>
  dplyr::mutate(
    demographic1_var = "J1A: Gender categorisation",
    demographic1_cat = "Male"
  )

# 2020 detailed demographic results - other
df_2020_d2_sexoth <- adv_read_ods(
  "raw-data/2020/Civil-Service-People-Survey-2020-results-by-gender-v2.ods",
  sheet = "Other", start_row = 5, start_col = 1, layers = 2, 
  layer_labels = c("demographic2_var", "demographic2_cat"), year = 2020
) |>
  dplyr::mutate(
    demographic1_var = "J1A: Gender categorisation",
    demographic1_cat = "Other"
  )

# 2020 organisation by gender
df_2020_dorg_sex <- adv_read_ods(
  "raw-data/2020/Civil-Service-People-Survey-2020-results-by-gender-v2.ods",
  sheet = "Organisations", start_row = 5, start_col = 3, layers = 2,
  layer_labels = c("organisation", "demographic1_cat"), year = 2020
) |>
  dplyr::mutate(
    demographic1_var = "J1A: Gender categorisation"
  ) |>
  dplyr::filter(
    measure != "response_order"
  )


# 2020 scores: lgb --------------------------------------------------------

# 2020 detailed splits for sexual orientation and gender
df_2019_dem_lgbdet <- adv_read_ods(
  "raw-data/2020/Civil-Service-People-Survey-2020-results-by-sexual-orientation-v2.ods",
  sheet = "Overview", start_row = 5, start_col = 1, layers = 2, 
  layer_labels = c("demographic1_cat", "demographic2_cat"), year = 2020
) |>
  dplyr::mutate(
    demographic1_var = "J1A: Gender categorisation",
    demographic2_var = "J07: Which of the following (sexual orientation) options best describes how you think of yourself?"
  )

# 2020 detailed demographic results - heterosexual
df_2020_d2_hetero <- adv_read_ods(
  "raw-data/2020/Civil-Service-People-Survey-2020-results-by-sexual-orientation-v2.ods",
  sheet = "Heterosexual", start_row = 5, start_col = 1, layers = 2, 
  layer_labels = c("demographic2_var", "demographic2_cat"), year = 2020
) |>
  dplyr::mutate(
    demographic1_var = "Z10: Sexual Orientation (grouped)",
    demographic1_cat = "Heterosexual/straight"
  )

# 2020 detailed demographic results - lgb+
df_2020_d2_lgb <- adv_read_ods(
  "raw-data/2020/Civil-Service-People-Survey-2020-results-by-sexual-orientation-v2.ods",
  sheet = "LGB+", start_row = 5, start_col = 1, layers = 2, 
  layer_labels = c("demographic2_var", "demographic2_cat"), year = 2020
) |>
  dplyr::mutate(
    demographic1_var = "Z10: Sexual Orientation (grouped)",
    demographic1_cat = "LGB+"
  )

df_2020_dorg_lgb <- adv_read_ods(
  "raw-data/2020/Civil-Service-People-Survey-2020-results-by-sexual-orientation-v2.ods",
  sheet = "Organisations", start_row = 5, start_col = 3, layers = 2,
  layer_labels = c("organisation", "demographic1_cat"), year = 2020
) |>
  dplyr::mutate(
    demographic1_var = "Z10: Sexual Orientation (grouped)"
  )

# combine scores ----------------------------------------------------------

ls_df <- ls(pattern = "df_\\d")
names(ls_df) <- ls_df

tbl_all_data <- purrr::map_dfr(
  .x = ls_df,
  .f = get,
  .id =  "source_obj"
)
