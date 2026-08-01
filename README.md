# Non-Random Missingness in Anthropometric Measurements
### A Multi-Country Analysis of South Asian DHS Data (2011–2022)

## Overview

Missing anthropometric measurements are routinely encountered in Demographic and Health Surveys (DHS) and are commonly excluded before analysis. However, whether these missing or biologically implausible observations occur randomly is rarely examined. Ignoring systematic missingness can introduce selection bias and affect statistical inference in studies of child nutrition.

This repository contains the complete analytical workflow for my Bachelor of Science (Honours) research project at the Institute of Statistical Research and Training (ISRT), University of Dhaka.

The study evaluates whether missing or unusable Height-for-Age Z-score (HAZ) measurements are randomly distributed or systematically associated with observable demographic and socioeconomic characteristics in South Asian DHS surveys. In addition, it compares complete-case analysis with multiple imputation to assess the impact of anthropometric missingness on substantive inference.


## Research Questions

This study addresses the following questions:

1. Are missing and biologically implausible child height measurements randomly distributed in South Asian DHS surveys?

2. Which child, maternal, and household characteristics are associated with the availability of usable anthropometric measurements?

3. Have these patterns changed over time?

4. Does multiple imputation materially change inference compared with complete-case analysis?


## Data

The analysis uses nationally representative **Children's Recode (KR)** datasets from eleven Demographic and Health Survey (DHS) rounds conducted between **2011 and 2022**.

### Countries included

- Bangladesh (2011, 2014, 2017–18, 2022)
- India (2015–16, 2019–21)
- Nepal (2011, 2016, 2022)
- Pakistan (2012–13, 2017–18)

The pooled dataset contains more than **560,000** children aged **0–59 months**.



## Data Availability

The original DHS datasets are not included in this repository.

The DHS Program distributes these datasets under a restricted data-use agreement.

Researchers wishing to reproduce the analysis should:

1. Register with the DHS Program.
2. Request access to the required Children's Recode (KR) datasets.
3. Download the approved datasets.
4. Place the raw files in `data/raw/`.
5. Run the R scripts to generate the processed dataset used by the Stata analyses.

More information is available at:

https://dhsprogram.com/data/

---

## Methodology

The analytical workflow combines **R** and **Stata**.

### R

- Data import
- Harmonization of eleven DHS surveys
- Variable creation
- Data cleaning
- Multiple imputation
- Exploratory visualization

### Stata

- Construction of pooled datasets
- Complex survey declaration
- Survey-weighted descriptive statistics
- Survey-weighted logistic regression
- Interaction models
- Marginal predicted probabilities
- Survey-weighted linear regression
- Sensitivity analyses

The study explicitly accounts for DHS sampling weights, stratification, and clustering throughout all analyses.



## Statistical Methods

The analysis includes:

- Survey-weighted descriptive statistics
- Survey-weighted logistic regression
- Interaction analysis
- Marginal predicted probabilities
- Survey-weighted linear regression
- Multiple Imputation (Predictive Mean Matching)
- Complete-case analysis
- Sensitivity analysis



## Repository Structure

```
DHS-NonRandom-Missingness
│
├── data/
│   ├── raw/
│   └── processed/
│
├── R/
│
├── Stata/
│
├── outputs/
│   ├── figures/
│   └── tables/
│
├── docs/
│
├── references/
│
└── README.md
```



## Workflow

```
Raw DHS datasets
        │
        ▼
R
(Data cleaning & harmonization)
        │
        ▼
Processed dataset
        │
        ▼
Stata
(Statistical analyses)
        │
        ▼
Tables & Figures
        │
        ▼
Research report
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
ggplot2
lattice
scales
```


## Acknowledgements

This work was completed as part of the Bachelor of Science (Honours) programme in Applied Statistics at the Institute of Statistical Research and Training (ISRT), University of Dhaka.

The analysis uses data from the Demographic and Health Surveys (DHS) Program. The interpretations and conclusions presented in this repository are those of the author and do not necessarily reflect the views of the DHS Program.


## Contact

**Tahsina Akter**

Institute of Statistical Research and Training (ISRT)

University of Dhaka

Email: takter28@isrt.ac.bd