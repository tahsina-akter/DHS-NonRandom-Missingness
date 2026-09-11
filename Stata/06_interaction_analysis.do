********************************************************************
* Interaction analysis between household wealth and survey period
*
* This model evaluates whether the association between household wealth and the usability of child height measurements changed across survey periods (2011–2016 vs. 2017–2022).
********************************************************************
clear

global OUT "../data/processed/selected"
use "$OUT/dhs_combined.dta"

* Survey-weighted logistic regression with wealth × survey period interaction
svyset psu_id [pw = sw], strata(stratum_id)

svy: logit height_usable child_age_months i.child_gender  i.child_illness children_under_5_in_hh mother_age i.mother_education i.currently_pregnant i.sex_of_hh_head i.residence_type i.wealth_index##i.survey_period, or allbase

estimates store WealthInteraction


* Joint significance test for the interaction terms


testparm i.wealth_index#i.survey_period


* Adjusted predicted probabilities


margins wealth_index, over(survey_period) predict(pr)

marginsplot, title("Predicted Probability of Usable Height by Wealth and Survey Period") ytitle("Predicted probability") xtitle("Household wealth quintile") legend(order(1 "2011–2016" 2 "2017–2022")) recast(line) ciopts(recast(rcap)) name(wealth_time, replace)



********************************************************************
* Interaction analysis between type of residence and survey period
*
* This model evaluates whether the association between the type of residence and the usability of child height measurements changed across survey periods (2011–2016 vs. 2017–2022).
********************************************************************
clear

use "$OUT/dhs_combined.dta"

* Survey-weighted logistic regression with residence_type × survey period interaction
svyset psu_id [pw = sw], strata(stratum_id)

svy: logit height_usable child_age_months i.child_gender  i.child_illness children_under_5_in_hh mother_age i.mother_education i.currently_pregnant i.sex_of_hh_head i.wealth_index i.residence_type##i.survey_period, or allbase

estimates store ResidenceInteraction


* Joint significance test for the interaction terms


testparm i.residence_type#i.survey_period


* Adjusted predicted probabilities


margins residence_type, over(survey_period) predict(pr)

marginsplot, title("Predicted Probability of Usable Height by Residence and Survey Period") ytitle("Predicted probability") xtitle("Type of Residence") legend(order(1 "2011–2016" 2 "2017–2022")) recast(line) ciopts(recast(rcap)) name(residence_time, replace)

save "$OUT/dhs_combined.dta", replace


*** Next, run R/07_multiple_imputation.R to perform the multiple imputation analysis using Predictive Mean Matching (PMM).
