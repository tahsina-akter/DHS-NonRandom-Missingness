library(anthro)
library(tidyverse)
library(survey)
library(haven)


DHS <- read_dta("data/processed/dhs_combined.dta")

DHS %>%
  group_by(v022) %>%                       
  summarise(n_psu = n_distinct(v021)) %>%   
  filter(n_psu == 1)  

DHS <- DHS %>%
  mutate(
    orig_v021 = as.character(v021),
    orig_v022 = as.character(v022),   
    psu_id = paste(country, orig_v021, sep = "_"),
    stratum_id = paste(country, orig_v022, sep = "_")
  )

DHS %>%
  group_by(stratum_id) %>%                       
  summarise(n_psu = n_distinct(psu_id)) %>%   
  filter(n_psu == 1)  

write_dta(DHS, "C:/Users/tahsi/OneDrive/Desktop/AST_450(Project)/DHS.dta")


dat1 <- DHS %>% 
  filter(height_usable==1)

dat1 %>%
  group_by(stratum_id) %>%                       
  summarise(n_psu = n_distinct(psu_id)) %>%   
  filter(n_psu == 1) 

dat2 <- DHS %>% 
  filter(height_usable==0)

missing <-dat2 %>%
  group_by(stratum_id) %>%                       
  summarise(n_psu = n_distinct(psu_id)) %>%   
  filter(n_psu == 1) 


