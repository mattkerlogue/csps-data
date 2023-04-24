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

