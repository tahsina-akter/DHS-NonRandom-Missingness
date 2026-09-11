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

- `bd_11.dta` — Bangladesh 2011 (BDKR61FL.DTA)
- `bd_14.dta` — Bangladesh 2014 (BDKR72FL.DTA)
- `bd_17_18.dta` — Bangladesh 2017–18 (BDKR7RFL.DTA)
- `bd_22.dta` — Bangladesh 2022 (BDKR81FL.DTA)
- `in_15_16.dta` — India 2015–16 (IAKR74FL.DTA)
- `in_19_21.dta` — India 2019–21 (IAKR7EFL.DTA)
- `np_11.dta` — Nepal 2011 (NPKR61FL.DTA)
- `np_16.dta` — Nepal 2016 (NPKR7HFL.DTA)
- `np_22.dta` — Nepal 2022 (NPKR82FL.DTA)
- `pk_12_13.dta` — Pakistan 2012–13 (PKKR61FL.DTA)
- `pk_17_18.dta` — Pakistan 2017–18 (PKKR71FL.DTA)

The first step is to run:

`Stata/01_Variables_selection_and_pooled_data.do`

This script selects the required variables, harmonizes them across the DHS survey rounds, and creates the pooled dataset used in the subsequent analyses.