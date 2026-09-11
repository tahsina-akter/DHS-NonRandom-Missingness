********************************************************************
* Step : Descriptive analysis
********************************************************************
clear

global OUT "../data/processed/selected"

use "$OUT/dhs_combined.dta"


********************************************************************
* Step : Specify the complex survey design
********************************************************************

svyset psu_id [pw = sw], strata(stratum_id)

count

describe

summarize sw


********************************************************************
* Step : Distribution of height measurement usability
********************************************************************

svy: tab height_usable, percent

********************************************************************
* Survey-weighted descriptive statistics: table-01
* Categorical variables
********************************************************************


svy: tab child_gender height_usable, column percent
svy: tab child_illness height_usable, column percent
svy: tab mother_education height_usable, column percent
svy: tab currently_pregnant height_usable, column percent
svy: tab wealth_index height_usable, column percent
svy: tab sex_of_hh_head height_usable, column percent
svy: tab residence_type height_usable, column percent


svy: mean child_age_months, over(height_usable)
estat sd

svy: mean mother_age, over(height_usable)
estat sd

svy: mean children_under_5_in_hh, over(height_usable)
estat sd


********************************************************************
* supplementary analysis
********************************************************************


** Pooled Sample Composition by Country and Survey Round

tab country

svyset psu_id [pw = sw], strata(stratum_id)
svy: tab country, count
svy: tab country, percent


** Descriptive characteristics stratified by child age

use "$OUT/dhs_combined.dta", clear


svyset psu_id [pw = sw], strata(stratum_id)

svy: mean child_age_months
estat sd

svy: tab child_gender child_age_group

svy: tab child_illness child_age_group

svy: mean mother_age
estat sd

svy: tab mother_education child_age_group

svy: tab currently_pregnant child_age_group

svy: tab wealth_index child_age_group

svy: tab sex_of_hh_head child_age_group

svy: mean children_under_5_in_hh
estat sd

svy: tab residence_type child_age_group




svy: mean child_age_months, over(child_age_group)
estat sd

svy: tab child_gender child_age_group, column pearson

svy: tab child_illness child_age_group, column pearson

svy: mean mother_age, over(child_age_group)
estat sd

svy: tab mother_education child_age_group, column pearson

svy: tab currently_pregnant child_age_group, column pearson

svy: tab wealth_index child_age_group, column pearson

svy: tab sex_of_hh_head child_age_group, column pearson

svy: mean children_under_5_in_hh, over(child_age_group)
estat sd

svy: tab residence_type child_age_group, column pearson





** Survey-weighted mean HAZ by child, maternal and household characteristics


use "$OUT/dhs_combined.dta", clear

svyset psu_id [pw = sw], strata(stratum_id) singleunit(centered)


* Sex of child

tabstat haz, by(child_gender) statistics(mean sd n)

svy: regress haz i.child_gender

testparm i.child_gender



* Child illness

tabstat haz, by(child_illness) statistics(mean sd n)

svy: regress haz i.child_illness

testparm i.child_illness



* Mother's education

tabstat haz, by(mother_education) statistics(mean sd n)

svy: regress haz i.mother_education

testparm i.mother_education



* Wealth index

tabstat haz, by(wealth_index) statistics(mean sd n)

svy: regress haz i.wealth_index

testparm i.wealth_index



* Residence


tabstat haz, by(residence_type) statistics(mean sd n)

svy: regress haz i.residence_type

testparm i.residence_type

* Next, run Stata/05_regression_analysis.do to perform the survey-weighted regression analyses.
