## Step : Create unique PSU and stratum identifiers for pooled multi-country DHS survey data


library(tidyverse)
library(haven)


# Read the pooled dataset
DHS <- read_dta("../data/processed/selected/dhs_combined.dta")

DHS %>%
  group_by(v022) %>%                       
  summarise(n_psu = n_distinct(v021)) %>%   
  filter(n_psu == 1)  

DHS <- DHS %>%
  mutate(
    orig_v021 = as.character(v021),
    orig_v022 = as.character(v022),   
    psu_id = paste(country, year, orig_v021, sep = "_"),
    stratum_id = paste(country, year, orig_v022, sep = "_")
  )



## step-4: Remove singleton strata before survey analysis.


singleton <- DHS %>%
  group_by(stratum_id) %>%                       
  summarise(n_psu = n_distinct(psu_id)) %>%   
  filter(n_psu == 1)  

DHS <- DHS %>%
  filter(!stratum_id %in% singleton$stratum_id)

# Save the prepared dataset
write_dta(DHS, "../data/processed/selected/dhs_combined.dta")


## Next step
# After completing this preparation step, run Stata/03_data_cleaning_and_variable_construction.do 
# to clean the pooled data and construct the analysis variables.