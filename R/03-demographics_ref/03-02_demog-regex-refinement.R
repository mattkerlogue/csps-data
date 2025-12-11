# CSPS data extraction and processing
# 03.02 demographic regex refinement
# ======
# This script takes the output of script 03_01-extract-demogs.R,
# including output that has been manually edited, to help refine the
# development of organisational regexes.

# setup ------
source("R/regex_matches.R")
source("R/text_to_uid.R")

raw_tbl_dems <- readr::read_csv(
  "proc/03-demographics_ref/03_01-raw_tbl_dems.csv"
)

dem_regexes <- readr::read_csv(
  "proc/03-demographics_ref/03_01-demographic_regex.csv"
)

cat_regexes <- readr::read_csv(
  "proc/03-demographics_ref/03_01-categories_regex.csv"
)

# review demographic questions regexes ------

dem_regex_matched <- dem_regexes |>
  dplyr::mutate(
    matches = purrr::map(
      .x = regex,
      .f = ~ regex_matches(
        .x,
        stringr::str_squish(tolower(sort(unique(raw_tbl_dems$demographic))))
      )
    )
  )

dem_regex_matched_unnested <- dem_regex_matched |>
  tidyr::unnest(matches) |>
  dplyr::filter(match)

dem_to_uid <- raw_tbl_dems |>
  dplyr::mutate(
    uid = purrr::map_chr(
      .x = stringr::str_squish(tolower(demographic)),
      .f = ~ text_to_uid(
        .x,
        dem_regexes$regex,
        dem_regexes$uid_txt,
        overrun = TRUE
      )
    )
  )

dem_to_uid |> dplyr::filter(grepl(",", uid))
dem_to_uid |> dplyr::filter(is.na(uid))

# review category matches ------

cat_regex_matched <- cat_regexes |>
  dplyr::mutate(
    matches = purrr::map(
      .x = regex,
      .f = ~ regex_matches(
        .x,
        sort(unique(stringr::str_squish(gsub(
          "\\s?\\((n=)?\\d.*$",
          "",
          tolower(gsub("\n", " ", raw_tbl_dems$category, perl = TRUE))
        ))))
      )
    )
  )

cat_regex_matched_unnested <- cat_regex_matched |>
  tidyr::unnest(matches) |>
  dplyr::filter(match)

cat_to_uid <- raw_tbl_dems |>
  dplyr::mutate(
    uid = purrr::map_chr(
      .x = stringr::str_squish(gsub(
        "\\s?\\((n=)?\\d.*$",
        "",
        tolower(raw_tbl_dems$category),
        perl = TRUE
      )),
      .f = ~ text_to_uid(
        .x,
        cat_regexes$regex,
        cat_regexes$uid_txt,
        overrun = TRIE
      )
    )
  )

cat_to_uid |> dplyr::filter(grepl(",", uid))
cat_to_uid |> dplyr::filter(is.na(uid))


# get merged combinations of demographics and categories

tbl_dem_cat_matched <- raw_tbl_dems |>
  dplyr::mutate(
    uid_dem = purrr::map_chr(
      .x = stringr::str_squish(tolower(demographic)),
      .f = ~ text_to_uid(
        .x,
        dem_regexes$regex,
        dem_regexes$uid_txt,
        overrun = TRUE
      )
    ),
    uid_cat = purrr::map_chr(
      .x = stringr::str_squish(gsub(
        "\\s?\\((n=)?\\d.*$",
        "",
        tolower(raw_tbl_dems$category),
        perl = TRUE
      )),
      .f = ~ text_to_uid(
        .x,
        cat_regexes$regex,
        cat_regexes$uid_txt,
        overrun = TRIE
      )
    )
  )

dem_cat_ref <- tbl_dem_cat_matched |>
  dplyr::summarise(
    year_from = min(year),
    year_to = max(year),
    .by = c(uid_dem, uid_cat)
  ) |>
  dplyr::left_join(
    dem_regexes |>
      dplyr::select(uid_dem = uid_txt, demographic),
    by = "uid_dem"
  ) |>
  dplyr::left_join(
    cat_regexes |>
      dplyr::select(uid_cat = uid_txt, category),
    by = "uid_cat"
  )

readr::write_excel_csv(
  dem_cat_ref |>
    dplyr::mutate(uid_demcat = NA_character_),
  "proc/03-demographics_ref/03_02-dem_cat_ref.csv",
  na = ""
)
