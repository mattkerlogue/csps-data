# csps-data

This repository stores published data from the UK [Civil Service People Survey](https://www.gov.uk/government/collections/civil-service-people-survey-hub)

The data includes the Civil Service benchmark and organisation scores for all
years. Demographic results are available from 2013 onwards.

While the published data for each year is generally published in a structured
format there is limited consistency between years and each year's data is stored
in a different location. The aim of this repository is to provide a single and
coherent set of data for multi-year analysis.

## Structure

The repository is structured as follows:

```shell
├── code          # code for processing the raw data
├── proc-data     # processed data
├── raw-data      # original raw data as published
└── README.md
```

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

## Copyright and Licensing

The raw data from the People Survey is Crown Copyright, published and licensed
under the [Open Government Licence](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/)

The software code contained in this repository to process the data is licensed
under the MIT License.

The processed data is released under the [Creative Commons Attribution License 4.0 (CC-BY-4.0)](https://creativecommons.org/licenses/by/4.0/).

The relevant licence is included in each sub-folder.

[ukgwa]: https://webarchive.nationalarchives.gov.uk/ukgwa/20140310230334/http://www.civilservice.gov.uk/about/improving/employee-engagement-in-the-civil-service/people-survey-2013
[govuk-14]: https://www.gov.uk/government/publications/civil-service-people-survey-2014-results
[govuk-15]: https://www.gov.uk/government/publications/civil-service-people-survey-2015-results
[govuk-16]: https://www.gov.uk/government/publications/civil-service-people-survey-2016-results
[govuk-17]: https://www.gov.uk/government/publications/civil-service-people-survey-2017-results--2
[govuk-18]: https://www.gov.uk/government/publications/civil-service-people-survey-2018-results
[govuk-19]: https://www.gov.uk/government/publications/civil-service-people-survey-2019-results
[govuk-20]: https://www.gov.uk/government/publications/civil-service-people-survey-2020-results
[govuk-21]: https://www.gov.uk/government/publications/civil-service-people-survey-2021-results