********************************************************************
* Step    : Multiple Imputation Analysis :table-06
********************************************************************/

clear all
set more off

*--------------------------------------------------------------*
* Project directories
*--------------------------------------------------------------*

global OUT "../data/processed/selected"
global IMP "../data/processed/imputation_processed"


********************************************************************
* Step : Complete-case analysis

* Fit the survey-weighted linear regression model using only complete observations. These estimates will later be compared with those obtained from multiple imputation.
********************************************************************

use "$OUT/dhs_combined.dta", clear

svyset psu_id [pw=sw], strata(stratum_id) singleunit(centered)

svy: regress haz child_age_months i.child_gender i.child_illness children_under_5_in_hh mother_age i.mother_education i.currently_pregnant i.wealth_index i.residence_type i.sex_of_hh_head

estimates store CC_haz


********************************************************************
* Step : Stack the 20 imputed datasets exported from R
********************************************************************

use "$IMP/dhs_imputation.dta", clear

gen _mj = 0

forvalues j = 1/20 {
    append using "$IMP/dhs_imp_`j'.dta"
    replace _mj = `j' if missing(_mj)
}

save "$IMP/stacked_imp_long.dta", replace


********************************************************************
* Step : Import stacked data into Stata's MI framework
********************************************************************


use "$IMP/stacked_imp_long.dta", clear

mi import flong, m(_mj) id(pid) clear

mi describe

tab _mj


********************************************************************
* Step : Register imputed and regular variables
********************************************************************

mi register imputed haz child_age_months

mi register regular child_gender child_illness children_under_5_in_hh mother_age mother_education currently_pregnant wealth_index residence_type sex_of_hh_head psu_id stratum_id sw


********************************************************************
* Step : Check the multiply imputed data
********************************************************************

mi describe

mi misstable summarize haz child_age_months


********************************************************************
* Step : Survey-weighted regression after multiple imputation
********************************************************************

mi svyset psu_id [pweight = sw], strata(stratum_id) vce(linearized) singleunit(centered)


mi estimate, vceok: svy: regress haz child_age_months i.child_gender i.child_illness children_under_5_in_hh mother_age i.mother_education i.currently_pregnant i.wealth_index i.residence_type i.sex_of_hh_head

estimates store MI_haz


*** Next, run Stata/09_sensitivity_analysis_excluding_child_age.do to assess the robustness of the height-usability regression results after excluding child age as a covariate.