# Processed Data

The processed datasets are not included in this repository because they are derived from restricted DHS data distributed by the DHS Program.

The analytical workflow used in this project consisted of:

1. Selecting the required variables from the original DHS Children's Recode (KR) datasets in Stata.
2. Pooling all survey datasets into a single analysis dataset.
3. Preparing the pooled dataset in R through data cleaning, harmonizing DHS datasets, multiple imputation, and visualization.
4. Performing the final statistical analyses in Stata using the processed dataset.

Researchers wishing to reproduce the analysis should first obtain the original DHS datasets from the DHS Program and then follow the workflow documented in this repository.