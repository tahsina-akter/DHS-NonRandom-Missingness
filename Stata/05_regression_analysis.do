********************************************************************
* Step : Logistic regression
********************************************************************
clear
global OUT "../data/processed/selected"

use "$OUT/dhs_combined.dta"



********************************************************************
* Survey-weighted multivariable logistic regression: table-02
* Outcome: Usable height measurement
********************************************************************

svyset psu_id [pw = sw], strata(stratum_id)

svy: logit height_usable child_age_months i.child_gender  i.child_illness children_under_5_in_hh mother_age i.mother_education i.currently_pregnant i.wealth_index i.sex_of_hh_head i.residence_type, or allbase


********************************************************************
* Assess temporal variation in the determinants of usable height measurements

* The pooled DHS dataset is divided into two survey periods:
*   Period 1: 2011–2016
*   Period 2: 2017–2022
*
* Separate survey-weighted logistic regression models are fitted for each period to examine whether the associations between explanatory variables and usable height measurements changed over time.
********************************************************************


* Create survey period

gen survey_period = .

replace survey_period = 1 if year == "2011" | year == "2012-13" | year == "2014" | year == "2015-16" | year == "2016"
replace survey_period = 2 if year == "2017-18" | year == "2019-21" | year == "2022"

label define period_lbl 1 "2011-2016" 2 "2017-2022", replace

label values survey_period period_lbl
label variable survey_period "Survey period"

save "$OUT/dhs_combined.dta", replace


global TIMEPROC "../data/processed/time_processed"


*--------------------------------------------------------------*
* Create and save the 2011–2016 dataset
*--------------------------------------------------------------*

preserve

keep if survey_period == 1

save "$TIMEPROC/time1_2011_2016.dta", replace

restore

*--------------------------------------------------------------*
* Create and save the 2017–2022 dataset
*--------------------------------------------------------------*

preserve

keep if survey_period == 2

save "$TIMEPROC/time2_2017_2022.dta", replace

restore




********************************************************************
* Survey-weighted logistic regression by survey period: table-03
********************************************************************

use "$TIMEPROC/time1_2011_2016.dta", clear

svyset psu_id [pw = sw], strata(stratum_id)

svy: logit height_usable child_age_months i.child_gender  i.child_illness children_under_5_in_hh mother_age i.mother_education i.currently_pregnant i.wealth_index i.sex_of_hh_head i.residence_type, or allbase

estimates store Period1


use "$TIMEPROC/time2_2017_2022.dta", clear

svyset psu_id [pw = sw], strata(stratum_id)

svy: logit height_usable child_age_months i.child_gender  i.child_illness children_under_5_in_hh mother_age i.mother_education i.currently_pregnant i.wealth_index i.sex_of_hh_head i.residence_type, or allbase

estimates store Period2




*** supplementary regression analysis
*Survey-weighted logistic regression adjusted for country and survey period

use "$OUT/dhs_combined.dta", clear

encode country, gen(country_cat)

label variable country_cat "Country"

svyset psu_id [pw = sw], strata(stratum_id) singleunit(centered)

svy: logit height_usable child_age_months i.child_gender i.child_illness children_under_5_in_hh mother_age i.mother_education i.currently_pregnant i.wealth_index i.sex_of_hh_head i.residence_type i.country_cat i.survey_period, or

estimates store CountryTimeModel

save "$OUT/dhs_combined.dta", replace


*** After completing the regression analyses, run Stata/06_interaction_analysis.do to examine whether associations between measurement usability and key household characteristics vary across survey periods.

