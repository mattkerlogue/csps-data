# Civil Service People Survey raw data

This folder contains the raw data files and reports downloaded from the UK
Government Web Archive or GOV.UK. Each year's results are stored in their own
folder.

The file [`00_data_files.yaml`](00_data_files.yaml) provides an index of all
the files contained within the sub-folders in YAML format to make it easy
to access. This is used to generate the [`00_data_files.csv`](00_data_files.csv)
and [`00_data_coverage.csv`](00_data_coverage.csv) files (via the script
[`R/utils/data_files_ref.R`](../R/utils/data_files_ref.R)). See the section
below on the YAML reference for

## Data coverage

Over the years a wide range of different types of data and reports have been
published about the Civil Service People Survey results:

* Data files
  * Benchmark scores: the Civil Service benchmark scores, the median of all
    participating organisation scores
  * Demographic scores: the results of all respondents split by demographic
    groups
  * Demographic scores - detailed ethnicity scores: further detail of
    demographic results, by ethnic group
  * Demographic scores - detailed gender scores: further detail of
    demographic results, by sex/gender
  * Demographic scores - detailed health scores: further detail of
    demographic results, by health status
  * Demographic scores - detailed sexual orientation scores: further detail of
    demographic results, by sexual orientation
  * Demographic scores - detailed socio-economic background scores: further
    detail of demographic results, by socio-economic background groups
  * Mean all respondents scores: the Civil Service mean results, i.e. results
    for all respondents combined, from 2021 this is included within the
    benchmark scores ODS file
  * Organisation scores: results by participating organisation, from 2021 this
    is included within the benchmark scores ODS file
* Other files
  * Benchmark scores report: from 2013 to 2019 a PDF report summarising the
    results for the Civil Service benchmark over time
  * CSPS questionnaire: the core questionnaire for the CSPS common to all
    organisation surveys
  * Departmental trends report: a PDF report summarising the headline scores
    for the main Whitehall departments over time, from 2013 to 2015 included in
    the summary of findings report
  * SCS results: a PDF report summarising the scores of the Senior Civil Service
  * Summary of findings reports: from 2013 to 2016 a PDF report of providing
    select highlight results; from 2023 onwards a GOV.UK HTML page
    providing select highlight results.
  * Technical guide: from 2013 to 2021 a PDF report containing technical
    information about the survey; in 2022 the technical guide was published
    as a GOV.UK HTML page; from 2023 onwards
    the technical guide has been renamed 'Quality and Methodology Information
    for the Civil Service People Survey'.

Where a documents have been published as GOV.UK HTML pages the relevant folder
contains a copy of the HTML page, a zip file containing the HMTL page and a
copy of its associated images, CSS, Javascript and other files, and a PDF print
preview of the page.

## Copyright and Licensing

The raw data from the People Survey is Crown Copyright, published and licensed
under the [Open Government Licence](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/)

## Sources

The files relating to the period 2009 to 2013 have been downloaded from the UK
Government Web Archive of the former Civil Service website. Files relating to
the period from 2014 onwards have been downloaded from the relevant publication
page of GOV.UK.

| Year | URL |
| ---- | --- |
| 2009-2013 | https://webarchive.nationalarchives.gov.uk/ukgwa/20140310230334/http://www.civilservice.gov.uk/about/improving/employee-engagement-in-the-civil-service/people-survey-2013 |
| 2014 | https://www.gov.uk/government/publications/civil-service-people-survey-2014-results |
| 2015 | https://www.gov.uk/government/publications/civil-service-people-survey-2015-results |
| 2016 | https://www.gov.uk/government/publications/civil-service-people-survey-2016-results |
| 2017 | https://www.gov.uk/government/publications/civil-service-people-survey-2017-results--2 |
| 2018 | https://www.gov.uk/government/publications/civil-service-people-survey-2018-results |
| 2019 | https://www.gov.uk/government/publications/civil-service-people-survey-2019-results |
| 2020 | https://www.gov.uk/government/publications/civil-service-people-survey-2020-results |
| 2021 | https://www.gov.uk/government/publications/civil-service-people-survey-2021-results |
| 2022 | https://www.gov.uk/government/publications/civil-service-people-survey-2022-results |
| 2023 | https://www.gov.uk/government/publications/civil-service-people-survey-2023-results |
| 2024 | https://www.gov.uk/government/publications/civil-service-people-survey-2024-results |
| 2025 | https://www.gov.uk/government/publications/civil-service-people-survey-2025-results |

## YAML reference

The file [`00_data_files.yaml`](00_data_files.yaml) is a YAML formatted
reference document of the files contained within the year-by-year subfolders.

The YAML file is a nested list with the first tier nodes representing
individual years (`csps2009`, `csps2010`, ..., `csps2024`, `csps2025`). Beneath
these year nodes are a series of key-value pairs relating to the individual
files.

The key for each file is written in the format `aaaa.b` where `aaaa` is the
content type of the file and `b` is a marker to denote the file format.

The possible content types are:

* `benchmarks`: the Civil Service benchmark (organisation median) scores for a
* `demographics`: the results of all respondents split by individual
  demographic groups and categories for a given year
  given year
* `details_*`: the detailed demographic results for a given year, specifically:
  * `details_ethnicity`: cross-tabs by ethnicity
  * `details_gender`: cross-tabs by sex/gender
  * `details_health`: cross-tabs by health status
  * `details_lgbt`: cross-tabs by sexual orientation
  * `details_seb`: cross-tabs by socio-economic background
* `means`: the all respondents (mean) scores for a given year
* `organisations`: the results of individual organisations for a given year
* `scs`: the scores for SCS respondents
* `report_*`: various reports published alongside the results, specifically:
  * `report_benchmark_report`: a PDF report version of the benchmark scores
  * `report_core_questionnaire`: the core questionnaire for the People Survey
  * `report_departmental_trends`: a document summarising the 2009-onwards
    trend in scores for selected departments
  * `report_scs_results`: a PDF report version of the SCS results
  * `report_summary_highlights`: a report summarising headline results and key
    findings
  * `report_technical_guide`: technical information about the methodology of
    the survey

The possible file format markers are:

* `c`: a comma-separated values (CSV) file
* `h`: an HTML file
* `o`: an Open Document Format Spreadsheet (ODS) file
* `p`: a PDF file
* `x`: an Excel file (either `.xls` or `.xslx` format)
* `z`: a zip archive file

YAML excerpt showing CSPS 2013 and CSPS 2024 nodes

```yaml
csps2013:
  benchmarks.c: "raw-data/2013/csps2013_benchmarks_20131125.csv"
  benchmarks.x: "raw-data/2013/csps2013_benchmarks_20131125.xlsx"
  organisations.c: "raw-data/2013/csps2013_allorganisations_20140213.csv"
  organisations.x: "raw-data/2013/csps2013_allorganisations_20140213.xlsx"
  demographics.c: "raw-data/2013/csps2013_demographic_results.csv"
  demographics.x: "raw-data/2013/csps2013_demographic_results.xlsx"
  scs.c: "raw-data/2013/csps2013_scs.csv"
  scs.x: "raw-data/2013/csps2013_scs.xlsx"
  report_benchmark_report.p: "raw-data/2013/csps2013_benchmark_report_20121125.pdf"
  report_demographic_results.p: "demoraw-data/2013/csps2013_demographic_results.pdf"
  report_core_questionnaire.p: "raw-data/2013/csps2013_questionnaire_core.pdf"
  report_scs_results.p: "raw-data/2013/csps2013_scs.pdf"
  report_summary_highlights.p: "raw-data/2013/csps2013_summary_of_findings.pdf"
  report_technical_guide.p: "raw-data/2013/csps2013_technicalguide.pdf"

csps2024:
  benchmarks.o: "raw-data/2024/Civil_Service_People_Survey_2024_Benchmark_Results.ods"
  demographics.o: "raw-data/2024/Civil-Service-People-Survey-2024-results-by-all-demographic-groups.ods"
  details_ethnicity.o: "raw-data/2024/Civil-Service-People-Survey-2024-results-by-ethnicity.ods"
  details_health.o: "raw-data/2024/Civil-Service-People-Survey-2024-results-by-long-term-health-status.ods"
  details_gender.o: "raw-data/2024/Civil-Service-People-Survey-2024-results-by-sex-and-gender.ods"
  details_lgbt.o: "raw-data/2024/Civil-Service-People-Survey-2024-results-by-sexual-orientation.ods"
  details_seb.o: "raw-data/2024/Civil-Service-People-Survey-2024-results-by-socio-economic-background.ods"
  report_summary_highlights.o: "raw-data/2024/Civil_Service_People_Survey_2024_-_Results_Highlights_Data_Companion.ods"
  report_summary_highlights.h: "raw-data/2024/Civil Service People Survey 2024 - Results Highlights - GOV.UK.html"
  report_summary_highlights.p: "raw-data/2024/Civil Service People Survey 2024 - Results Highlights - GOV.UK.pdf"
  report_summary_highlights.z: "raw-data/2024/Civil Service People Survey 2024 - Results Highlights - GOV.UK.zip"
  report_technical_guide.h: "raw-data/2024/Quality and Methodology Information for the Civil Service People Survey 2024 - GOV.UK.html"
  report_technical_guide.p: "raw-data/2024/Quality and Methodology Information for the Civil Service People Survey 2024 - GOV.UK.pdf"
  report_technical_guide.z: "raw-data/2024/Quality and Methodology Information for the Civil Service People Survey 2024 - GOV.UK.zip"
```
