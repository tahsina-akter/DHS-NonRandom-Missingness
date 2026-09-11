# Time-Processed Data

This folder is used to store datasets generated during the temporal analysis of the pooled DHS data. The generated datasets are not included in the repository.

The temporal analysis was conducted to examine whether patterns and associations in height measurement usability changed across survey periods.

## Contents

The folder contains the processed datasets for the two survey periods used in the analysis:

- `time1_2011_2016.dta` — observations from the earlier survey period (2011–2016)
- `time2_2017_2022.dta` — observations from the later survey period (2017–2022)

These datasets are created during:

`Stata/05_regression_analysis.do`

and are used for the period-specific regression analyses and subsequent interaction analysis.

## Next Step

After completing the regression analysis, run:

`Stata/06_interaction_analysis.do`

This examines whether the associations between height measurement usability and key household characteristics vary across the two survey periods.