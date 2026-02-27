if (dir.exists("../docs")) {
  cli::cli_alert_warning("deleting existing root level {.file docs} folder")
  fs::dir_delete("../docs")
}

fs::dir_copy("_site", "../docs")
cli::cli_alert_success("files copied to {.file docs} folder at the root level")
