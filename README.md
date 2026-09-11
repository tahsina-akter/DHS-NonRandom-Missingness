# Non-Random Missingness in Anthropometric Measurements

### A Multi-Country Analysis of South Asian DHS Data (2011–2022)

## Overview

Missing anthropometric measurements are routinely encountered in Demographic and Health Surveys (DHS) and are commonly excluded before analysis. However, whether these missing or biologically implausible observations occur randomly is rarely examined. Ignoring systematic missingness can introduce selection bias and affect statistical inference in studies of child nutrition.

The study evaluates whether missing or unusable Height-for-Age Z-score (HAZ) measurements are randomly distributed or systematically associated with observable demographic and socioeconomic characteristics in South Asian DHS surveys. Additionally, it compares complete-case analysis with multiple imputation to assess the impact of missing anthropometric data on substantive inference.

---

## Research Questions

This study addresses the following questions:

1. Are missing and biologically implausible child height measurements randomly distributed in South Asian DHS surveys?

2. Which child, maternal, and household characteristics are associated with the availability of usable anthropometric measurements?

3. Have these patterns changed over time?

4. Does multiple imputation materially change inference compared with complete-case analysis?

---

## Data

The analysis uses nationally representative **Children's Recode (KR)** datasets from eleven Demographic and Health Survey (DHS) rounds conducted between **2011 and 2022**.

### Countries included

- Bangladesh (2011, 2014, 2017–18, 2022)
- India (2015–16, 2019–21)
- Nepal (2011, 2016, 2022)
- Pakistan (2012–13, 2017–18)

The pooled dataset contains more than **560,000** children aged **0–59 months**.

---

## Data Availability

The original DHS datasets are not included in this repository.

The DHS Program distributes these datasets under a restricted data-use agreement.

Researchers wishing to reproduce the analysis should:

1. Register with the DHS Program.
2. Request access to the required Children's Recode (KR) datasets.
3. Download the approved datasets.
4. Place the raw files in `data/raw/`.
5. Run the analysis workflow in the order described below.

More information is available at:

https://dhsprogram.com/data/

---

## Methodology

The analytical workflow combines **Stata** and **R**.

### Stata

Stata is used for:

- Selection and harmonization of variables across DHS survey rounds
- Construction of the pooled dataset
- Data cleaning and variable construction
- Complex survey declaration
- Survey-weighted descriptive statistics
- Survey-weighted logistic regression
- Interaction models
- Marginal predicted probabilities
- Survey-weighted linear regression
- Multiple-imputation analysis
- Sensitivity analysis

### R

R is used for:

- Data preparation following the initial pooling step
- Multiple imputation using Predictive Mean Matching
- Exploratory and visualization analyses

The study explicitly accounts for DHS sampling weights, stratification, and clustering throughout the survey-weighted analyses.

---

## Statistical Methods

The analysis includes:

- Survey-weighted descriptive statistics
- Survey-weighted logistic regression
- Interaction analysis
- Marginal predicted probabilities
- Survey-weighted linear regression
- Multiple imputation using Predictive Mean Matching (PMM)
- Complete-case analysis
- Sensitivity analysis excluding child age

---

## Repository Structure

```text
DHS-NonRandom-Missingness/
│
├── data/
│   ├── raw/
│   │   └── README.md
│   │
│   └── processed/
│       ├── selected/
│       │   └── README.md
│       │
│       ├── time_processed/
│       │   └── README.md
│       │
│       ├── imputation_processed/
│           └── README.md      
├── R/
│   ├── 02_data_preparation.R
│   ├── 07_multiple_imputation.R
│   └── 10_visualization.R
│
├── Stata/
│   ├── 01_Variables_selection_and_pooled_data.do
│   ├── 03_data_cleaning_and_variable_construction.do
│   ├── 04_descriptive_analysis.do
│   ├── 05_regression_analysis.do
│   ├── 06_interaction_analysis.do
│   ├── 08_multiple_imputation_analysis.do
│   └── 09_sensitivity_analysis_excluding_child_age.do
│
├── references/
│
└── README.md
```


## Workflow

> **Working directory:** The scripts use relative file paths. Run the R scripts with the `R/` folder as the working directory and the Stata do-files with the `Stata/` folder as the working directory.

```
Raw DHS Children's Recode (KR) datasets
                    │
                    ▼
01_Variables_selection_and_pooled_data.do
                    │
                    ▼
02_data_preparation.R
                    │
                    ▼
03_data_cleaning_and_variable_construction.do
                    │
                    ▼
04_descriptive_analysis.do
                    │
                    ▼
05_regression_analysis.do
                    │
                    ▼
06_interaction_analysis.do
                    │
                    ▼
07_multiple_imputation.R
                    │
                    ▼
08_multiple_imputation_analysis.do
                    │
                    ▼
09_sensitivity_analysis_excluding_child_age.do
                    │
                    ▼
10_visualization.R
```



## Main Findings

The study demonstrates that:

- Approximately **17%** of child height measurements are either missing or biologically implausible.
- Height usability is **not randomly distributed** across the population.
- Younger children are substantially more likely to have unusable anthropometric measurements.
- Maternal education, household wealth, and place of residence are associated with the probability of obtaining usable height measurements.
- Although anthropometric missingness is systematically structured, complete-case and multiple-imputation analyses produce broadly similar conclusions for determinants of child HAZ.



## Software

- R (v4.3.1)
- Stata (v17)
- LaTeX / Overleaf



## Required R Packages

```
tidyverse
haven
survey
mice
mitools
ggplot2
lattice
scales
```


## Acknowledgements

This work was completed as part of the Bachelor of Science (Honours) programme in Applied Statistics at the Institute of Statistical Research and Training (ISRT), University of Dhaka.

The analysis uses data from the Demographic and Health Surveys (DHS) Program. The interpretations and conclusions presented in this repository are those of the author and do not necessarily reflect the views of the DHS Program.


## Contact

**Tahsina Akter**

Institute of Applied Statistics and Data Science (IASDS)

University of Dhaka

Email: takter28@isrt.ac.bd