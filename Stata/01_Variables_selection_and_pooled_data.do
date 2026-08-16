/********************************************************************
Project: Non-Random Missingness in Anthropometric Measurements
Step : Select variables from DHS datasets
Author: Tahsina Akter
********************************************************************/

clear all
set more off

*--------------------------------------------------------------*
* Project directories
*--------------------------------------------------------------*

global RAW "../data/raw"
global OUT "../data/processed/selected"

*--------------------------------------------------------------*
* Variables required for analysis
*--------------------------------------------------------------*

local vars caseid v001 v002 v003 v005 v012 v013 v021 v022 v024 v025 v106 v137 v151 v155 v190 v213 b4 b8 m19 hw1 hw3 hw70 hw71 hw72 hw73 h11 h22 h31

********************************************************************
* Bangladesh DHS 2011
********************************************************************

use "$RAW/bd_11.dta", clear

keep `vars'

gen country = "Bangladesh"
gen year = "2011"


save "$OUT/bd11_selected.dta", replace


********************************************************************
* Bangladesh DHS 2014
********************************************************************

use "$RAW/bd_14.dta", clear

keep `vars'

gen country = "Bangladesh"
gen year = "2014"

save "$OUT/bd14_selected.dta", replace


********************************************************************
* Bangladesh DHS 2017–18
********************************************************************

use "$RAW/bd_17_18.dta", clear

keep `vars'

gen country = "Bangladesh"
gen year = "2017-18"

save "$OUT/bd17_18_selected.dta", replace


********************************************************************
* Bangladesh DHS 2022
********************************************************************

use "$RAW/bd_22.dta", clear

keep `vars'

gen country = "Bangladesh"
gen year = "2022"

save "$OUT/bd22_selected.dta", replace


********************************************************************
* Nepal DHS 2011
********************************************************************

use "$RAW/np_11.dta", clear

keep `vars'

gen country = "Nepal"
gen year = "2011"

save "$OUT/np11_selected.dta", replace


********************************************************************
* Nepal DHS 2016
********************************************************************

use "$RAW/np_16.dta", clear

keep `vars'

gen country = "Nepal"
gen year = "2016"

save "$OUT/np16_selected.dta", replace


********************************************************************
* Nepal DHS 2022
********************************************************************

use "$RAW/np_22.dta", clear

keep `vars'

gen country = "Nepal"
gen year = "2022"

save "$OUT/np22_selected.dta", replace


********************************************************************
* Pakistan DHS 2012–13
********************************************************************

use "$RAW/pk_12_13.dta", clear

keep `vars'

gen country = "Pakistan"
gen year = "2012-13"

save "$OUT/pk12_13_selected.dta", replace


********************************************************************
* Pakistan DHS 2017–18
********************************************************************

use "$RAW/pk_17_18.dta", clear

keep `vars'

gen country = "Pakistan"
gen year = "2017-18"

save "$OUT/pk17_18_selected.dta", replace


********************************************************************
* India DHS 2015–16
********************************************************************/

use "$RAW/in_15_16.dta", clear

keep `vars'

gen country = "India"
gen year = "2015-16"

save "$OUT/in15_16_selected.dta", replace


********************************************************************
* India DHS 2019–21
********************************************************************

use "$RAW/in_19_21.dta", clear

keep `vars'

gen country = "India"
gen year = "2019-21"

save "$OUT/in19_21_selected.dta", replace











********************************************************************
* Step : Pool selected DHS datasets
********************************************************************

use "$OUT/bd11_selected.dta", clear

append using "$OUT/bd14_selected.dta"
append using "$OUT/bd17_18_selected.dta"
append using "$OUT/bd22_selected.dta"

append using "$OUT/np11_selected.dta"
append using "$OUT/np16_selected.dta"
append using "$OUT/np22_selected.dta"

append using "$OUT/pk12_13_selected.dta"
append using "$OUT/pk17_18_selected.dta"

append using "$OUT/in15_16_selected.dta"
append using "$OUT/in19_21_selected.dta"

save "$OUT/dhs_combined.dta", replace


**** Next, run `R/02_data_preparation.R` to prepare the pooled dataset for survey-weighted analysis by constructing unique PSU and stratum identifiers and removing singleton strata.

