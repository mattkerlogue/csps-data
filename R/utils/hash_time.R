hash_time <- function(ts = Sys.time()) {
  if (file.exists(".csps_hash_time.rds")) {
    .csps_hash_time <<- readRDS(".csps_hash_time.rds")
  }

  if (".csps_hash_time" %in% ls(envir = .GlobalEnv, all.names = TRUE)) {
    usr_hash <- menu(
      c("Keep hash", "Generate new hash"),
      title = paste0(
        "A short hash of ",
        .csps_hash_time$hash_short,
        ", generated ",
        prettyunits::time_ago(.csps_hash_time$ts),
        " (",
        format(.csps_hash_time$ts, "%F %T"),
        "), has
      been detected. Do you want to keep this has or generate a new one?"
      )
    )
    if (usr_hash == 1) {
      return(invisible(NULL))
    }
  }

  hash <- cli::hash_sha1(as.character(round(ts)))

  hash_list <- list(
    ts = ts,
    hash = hash,
    hash_short = substr(hash, 1, 8)
  )

  .csps_hash_time <<- hash_list

  saveRDS(hash_list, ".csps_hash_time.rds")
}

.remove_hash_time_file <- function() {
  fs::file_delete(".csps_hash_time.rds")
}
