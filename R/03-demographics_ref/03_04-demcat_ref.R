# CSPS data extraction and processing
# 03.04 demographic reference files
# ======
# This script takes the output of script 03_03-demcat_development.R,
# including output that has been manually edited, and copies it to the
# proc folder to act as key reference files

fs::file_copy(
  "proc/03-demographics_ref/03_01-demographic_regex.csv",
  "proc/csps_demogqs_regex.csv"
)

fs::file_copy(
  "proc/03-demographics_ref/03_01-categories_regex.csv",
  "proc/csps_demcat_regex.csv"
)

fs::file_copy(
  "proc/03-demographics_ref/03_02-dem_cat_ref-lookup.csv",
  "proc/csps_demcat_lookup.csv"
)

fs::file_copy(
  "proc/03-demographics_ref/03_02-dem_cat_ref-edited.csv",
  "proc/csps_demcat_ref.csv"
)
