csps_orgs <- arrow::read_parquet(
  "data/02-organisations/csps_organisations_2009-2024_5b58c24b.parquet"
)

csps_org_log <- readr::read_csv("proc/csps_org_changes.csv")

csps_org_year <- csps_orgs |>
  dplyr::distinct(year, uid_org_txt)

csps_org_chain_base <- csps_org_year |>
  dplyr::arrange(uid_org_txt, year) |>
  dplyr::mutate(
    year_prev1 = dplyr::lag(year),
    year_nxt = year - 1 == year_prev1,
    uid_prev1 = dplyr::if_else(year_nxt, uid_org_txt, NA_character_),
    .by = uid_org_txt
  ) |>
  dplyr::left_join(
    csps_org_log |>
      dplyr::filter(successor_type == "direct") |>
      dplyr::transmute(
        year,
        uid_org_txt,
        year_prev2 = year - 1,
        uid_prev2 = previous_uid_org_txt
      ),
    by = c("year", "uid_org_txt")
  ) |>
  dplyr::mutate(
    year_prev = dplyr::case_when(
      !is.na(year_prev2) ~ year_prev2,
      year_nxt ~ year_prev1,
      TRUE ~ NA_real_,
    ),
    uid_prev = dplyr::case_when(
      is.na(year_prev) ~ NA_character_,
      !is.na(uid_prev2) ~ uid_prev2,
      TRUE ~ uid_prev1
    ),
    present_id = paste(year, uid_org_txt, sep = "_"),
    previous_id = dplyr::if_else(
      is.na(year_prev),
      NA_character_,
      paste(year_prev, uid_prev, sep = "_")
    )
  ) |>
  dplyr::arrange(year) |>
  dplyr::select(year, uid_org_txt, present_id, previous_id) |>
  tidyr::drop_na()

make_chain <- function(start_id, df = csps_org_chain_base) {
  if (!(start_id %in% df$present_id)) {
    return(NULL)
  }

  id_check <- TRUE

  org_chain <- c(start_id)
  current_id <- start_id

  while (id_check) {
    if (current_id %in% df$present_id) {
      current_id <- df$previous_id[df$present_id == current_id]
      org_chain <- c(org_chain, current_id)
    } else {
      id_check <- FALSE
    }
  }

  return(org_chain)
}

csps_org_chains <- csps_org_chain_base |>
  dplyr::select(-previous_id) |>
  dplyr::mutate(
    org_yr_id = purrr::map(
      .x = present_id,
      .f = make_chain
    )
  ) |>
  tidyr::unnest(org_yr_id) |>
  dplyr::select(trend_group = present_id, org_yr_id) |>
  dplyr::arrange(trend_group, org_yr_id)

readr::write_excel_csv(csps_org_chains, "proc/99-testing/99-org-chains.csv")
