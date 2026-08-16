********************************************************************
* Sensitivity Analysis
*
* Survey-weighted logistic regression excluding child age to assess the robustness of the main findings.
********************************************************************
global OUT "../data/processed/selected"

use "$OUT/dhs_combined.dta", clear

svyset psu_id [pw = sw], strata(stratum_id) singleunit(centered)

svy: logit height_usable i.child_gender i.child_illness children_under_5_in_hh mother_age i.mother_education i.currently_pregnant i.wealth_index i.sex_of_hh_head i.residence_type, or

estimates store Sensitivity


* Next, run R/10_visualization.R to generate the figures for the report.