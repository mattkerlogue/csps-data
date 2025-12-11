# csps-data

**!! This repository is currently a work in progress and subject to change !!**

This repository stores published data from the UK [Civil Service People Survey](https://www.gov.uk/government/collections/civil-service-people-survey-hub)

While the published data for each year is generally published in a structured
format there is limited consistency between years and each year's data is stored
in a different location. The aim of this repository is to provide a single and
coherent set of data for multi-year analysis.

## Structure

The repository is structured as follows:

```shell
├── companion
├── data
├── proc
├── R
└── raw-data
```

The `raw-data` folder contains the original People Survey data files downloaded
from GOV.UK (see [Sources](#sources) for links). The `R` folder contains the
code for processing the data files, the `proc` folder contains both reference
data sets and intermediate outputs. The `data` folder contains the output data
files and the `companion` folder contains the Quarto source documents for
building this repositories companion documentation website/book.

## Sources

* 2009-2013: [UK Government Web Archive][ukgwa]
* 2014: [GOV.UK][govuk-14]
* 2015: [GOV.UK][govuk-15]
* 2016: [GOV.UK][govuk-16]
* 2017: [GOV.UK][govuk-17]
* 2018: [GOV.UK][govuk-18]
* 2019: [GOV.UK][govuk-19]
* 2020: [GOV.UK][govuk-20]
* 2021: [GOV.UK][govuk-21]
* 2022: [GOV.UK][govuk-22]
* 2023: [GOV.UK][govuk-23]
* 2024: [GOV.UK][govuk-24]

## Copyright and Licensing

The raw data from the People Survey is Crown Copyright, published and licensed
under the [Open Government Licence](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/)

The software code, processed data and documentation companion are copyright of
Matt Kerlogue (2025). The software code is licensed under the MIT License,
while the processed data and documentation companion are released under the
[Creative Commons Attribution License 4.0 (CC-BY-4.0)](https://creativecommons.org/licenses/by/4.0/).

The licenses are contained both at the root directory and in the relevant sub-folder.

[ukgwa]: https://webarchive.nationalarchives.gov.uk/ukgwa/20140310230334/http://www.civilservice.gov.uk/about/improving/employee-engagement-in-the-civil-service/people-survey-2013
[govuk-14]: https://www.gov.uk/government/publications/civil-service-people-survey-2014-results
[govuk-15]: https://www.gov.uk/government/publications/civil-service-people-survey-2015-results
[govuk-16]: https://www.gov.uk/government/publications/civil-service-people-survey-2016-results
[govuk-17]: https://www.gov.uk/government/publications/civil-service-people-survey-2017-results--2
[govuk-18]: https://www.gov.uk/government/publications/civil-service-people-survey-2018-results
[govuk-19]: https://www.gov.uk/government/publications/civil-service-people-survey-2019-results
[govuk-20]: https://www.gov.uk/government/publications/civil-service-people-survey-2020-results
[govuk-21]: https://www.gov.uk/government/publications/civil-service-people-survey-2021-results
[govuk-22]: https://www.gov.uk/government/publications/civil-service-people-survey-2022-results
[govuk-23]: https://www.gov.uk/government/publications/civil-service-people-survey-2023-results
[govuk-24]: https://www.gov.uk/government/publications/civil-service-people-survey-2024-results