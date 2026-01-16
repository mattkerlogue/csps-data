#' Function to extract response categories from text
#'
#' @param qm_text question/measure text
#' @param uid_qm_txt uid in text format
#' @param uid_qm_num uid in numeric format
#'
#' @export
extract_response_cat <- function(qm_text, uid_qm_txt, uid_qm_num) {
  qm_text <- stringr::str_squish(stringr::str_to_lower(qm_text))

  resp_text <- stringr::str_extract(qm_text, "\\s\\(((%|asked|b\\d).*)\\)", 1)

  response_category = dplyr::case_when(
    grepl("index$", uid_qm_txt) ~ "index",
    grepl("^1\\.02", uid_qm_num) ~ "theme",
    grepl("positive|.*strongly agree.*agree", resp_text) ~ "agreement",
    grepl("0([-–—])3", resp_text) ~ "num_00_03",
    grepl("6([-–—]|\\sto\\s)10", resp_text) ~ "num_06_10",
    grepl("7([-–—]|\\sto\\s)10", resp_text) ~ "num_07_10",
    grepl("%\\s(selecting(\\s')?)?no\\b'?$", resp_text) ~ "no",
    grepl("%\\s(selecting(\\s')?)?yes\\b'?$", resp_text) ~ "yes",
    grepl("prefer\\snot\\sto\\ssay'?$", resp_text) ~ "ptns",
    grepl(
      "at least.*option|this.option|multiple",
      resp_text
    ) ~ "multi_choice",
    grepl("prefer\\snot\\sto\\ssay.*at.least", resp_text) ~ "ptns_multi",
    grepl("%\\s(rating\\s)?'?often.*always'?$", resp_text) ~ "always_often",
    grepl("always.*most", resp_text) ~ "always_most",
    grepl("some.*always|always.*some", resp_text) ~ "always_some",
    grepl("seldom.*never", resp_text) ~ "seldom_never",
    grepl("weekly.*monthly", resp_text) ~ "weekly_monthly",
    grepl("excellent.*", resp_text) ~ "excellent_good",
    grepl("productive", resp_text) ~ "productive",
    grepl("soon.*possible", resp_text) ~ "int_leave_asap",
    grepl("next.12", resp_text) ~ "int_leave_12m",
    grepl("next.year", resp_text) ~ "int_stay_1yr",
    grepl("next.three", resp_text) ~ "int_stay_3yr",
    # guess response category for those without explicit info
    grepl("^b\\d{2}", qm_text) ~ "agreement",
    grepl("^d\\d{2}|e01|e03", qm_text) ~ "yes",
    grepl("^e06", qm_text) ~ "yes",
    grepl("^w0[1-3]", qm_text) ~ "num_07_10",
    qm_text == "w04" ~ "num_06_10",
    qm_text == "j04b" | qm_text == "w05" ~ "excellent_good",
    qm_text == "w07" ~ "always_often",
    qm_text == "w08" ~ "agreement",
    uid_qm_txt == "meta.response_rate" ~ "response_rate",
    uid_qm_txt == "dhb.reported_bullying" |
      uid_qm_txt == "dhb.bullying_resolved" ~ "yes",
    uid_qm_txt == "int.leave_asap" ~ "int_leave_asap",
    uid_qm_txt == "int.leave_next_12m" ~ "int_leave_12m",
    uid_qm_txt == "int.stay_next_year" ~ "int_stay_1yr",
    uid_qm_txt == "int.stay_three_years" ~ "int_stay_3yr",
    uid_qm_txt == "meta.response_count" ~ "response_count",
    grepl("^4.01.002", uid_qm_num) ~ "multi_choice",
    grepl("^6.01.002", uid_qm_num) ~ "multi_choice",
    grepl("^6.02.003", uid_qm_num) ~ "multi_choice",
    grepl("^6.03.001", uid_qm_num) ~ "multi_choice",
    grepl("^6.03.002", uid_qm_num) ~ "multi_choice",
    grepl("^6.04", uid_qm_num) ~ "yes",
    TRUE ~ NA_character_
  )

  return(response_category)
}
