# Raw Data

This project uses the DHS Children's Recode (KR) datasets from Bangladesh, India, Nepal, and Pakistan.

The original DHS datasets are not included in this repository because they are distributed under the DHS Program data-use agreement.

Researchers can request access to the required datasets from:

https://dhsprogram.com/data/

After obtaining the datasets, place the required KR files in this folder before starting the analysis workflow.

## File Naming Convention

To keep the raw data organized and make the analysis scripts easier to follow, save the DHS Children's Recode (KR) files using the following naming convention:

`<country>_<survey_year>.dta`

For example:

- `bd_11.dta` — Bangladesh 2011
- `bd_14.dta` — Bangladesh 2014
- `bd_17_18.dta` — Bangladesh 2017–18
- `bd_22.dta` — Bangladesh 2022
- `in_15_16.dta` — India 2015–16
- `in_19_21.dta` — India 2019–21
- `np_11.dta` — Nepal 2011
- `np_16.dta` — Nepal 2016
- `np_22.dta` — Nepal 2022
- `pk_12_13.dta` — Pakistan 2012–13
- `pk_17_18.dta` — Pakistan 2017–18

The first step is to run:

`Stata/01_Variables_selection_and_pooled_data.do`

This script selects the required variables, harmonizes them across the DHS survey rounds, and creates the pooled dataset used in the subsequent analyses.