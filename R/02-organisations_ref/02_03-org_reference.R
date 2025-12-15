# CSPS data extraction and processing
# 02.03 organisation reference datasets
# ======
# This script copies the organisation regex and history files to the proc/
# folder as key reference files

fs::file_copy(
  "proc/02-organisations_ref/02_01-org_regex.csv",
  "proc/csps_org_regex.csv"
)

fs::file_copy(
  "proc/02-organisations_ref/02_02-org_history_log.csv",
  "proc/csps_org_changes.csv"
)

fs::file_copy(
  "proc/02-organisations_ref/02_02-org_history_notes.csv",
  "proc/csps_org_notes.csv"
)
