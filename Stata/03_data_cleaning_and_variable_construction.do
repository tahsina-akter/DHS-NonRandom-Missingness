
********************************************************************
* Step : Data cleaning and variable construction
********************************************************************

global OUT "../data/processed/selected"

use "$OUT/dhs_combined.dta", clear

********************************************************************
* Step : Construct anthropometric outcome variables
********************************************************************

* Height-for-age Z-score
gen haz = hw70/100

* Missing height measurement
gen height_missing = missing(hw70)

label define yesno 0 "No" 1 "Yes", replace
label values height_missing yesno
label variable height_missing "Missing height measurement"

* Biologically implausible HAZ (WHO criterion)
gen height_implausible = 0
replace height_implausible = 1 if !missing(haz) & (haz < -6 | haz > 6)

label values height_implausible yesno
label variable height_implausible "Biologically implausible height"

* Set implausible HAZ values to missing
replace haz = . if height_implausible == 1

* Usable height measurement
gen height_usable = 1
replace height_usable = 0 if height_missing == 1 | height_implausible == 1

label values height_usable yesno
label variable height_usable "Usable child height measurement"


********************************************************************
* Step : Recode analysis variables
********************************************************************

* Survey weight
gen sw = v005/1000000

* Rename variables
rename v012 mother_age
rename v137 children_under_5_in_hh
rename v213 currently_pregnant
rename b4 child_gender
rename hw1 child_age_months
rename v151 sex_of_hh_head
rename v106 mother_education
rename v190 wealth_index
rename v025 residence_type

* Child illness is defined as having at least one of the following conditions during the two weeks preceding the survey:
*   - Diarrhea (h11)
*   - Fever (h22)
*   - Cough (h31)

gen child_illness = 0

replace child_illness = 1 if h11 == 2 | h22 == 1 | h31 == 2

label define illness_lbl 0 "No or donot know" 1 "Yes", replace
label values child_illness illness_lbl
label variable child_illness "Child experienced illness in previous two weeks"

recode sex_of_hh_head (2=1 "Female") (1=0 "Male"), gen(female_hh_head)
* removed 3 unusual observation.
drop if female_hh_head == 3

recode residence_type (1=0 "Urban") (2=1 "Rural"), gen(rural)

recode mother_education (0=1 "No education") (1/max=0 "Educated"), gen(no_education)

recode child_age_months (min/23=0 "<2 years") (24/max=1 ">=2 years"), gen(child_age_group)


save "$OUT/dhs_combined.dta", replace


* Next, run Stata/04_descriptive_analysis.do to perform the survey-weighted descriptive analysis.
