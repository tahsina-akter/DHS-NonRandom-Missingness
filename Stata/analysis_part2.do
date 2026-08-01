use "C:\Users\tahsi\OneDrive\Desktop\AST_450(Project)\DHS_short.dta"
 svyset [pw=sw], strata( stratum_id ) psu( psu_id )
 
 svy: logit height_usable child_age_months i.child_gender i.child_illness children_under_5_in_hh mother_age i.orig_mother_edu i.currently_pregnant i.orig_wealth_index i.sex_of_hh_head i.residence_type, or allbase
 
  svy: logit height_usable c.child_age_months i.child_gender i.child_illness c.children_under_5_in_hh c.mother_age i.orig_mother_edu i.currently_pregnant i.orig_wealth_index i.sex_of_hh_head i.residence_type##i.time, or allbase 
testparm i.residence_type#i.time
margins residence_type, over(time) predict(pr)
marginsplot, title("Predicted Probability of Usable Height by Residence and Survey Period") ytitle("Predicted Probability") xtitle("Place of Residence") legend(order(1 "2011–2016" 2 "2017–2022")) recast(line) ciopts(recast(rcap))


svy: logit height_usable c.child_age_months i.child_gender i.child_illness c.children_under_5_in_hh c.mother_age i.orig_mother_edu i.currently_pregnant i.sex_of_hh_head i.residence_type i.orig_wealth_index##i.time, or allbase
testparm i.orig_wealth_index#i.time
margins orig_wealth_index, over(time) predict(pr)
marginsplot, title("Predicted Probability of Usable Height by Wealth and Survey Period") ytitle("Predicted Probability") xtitle("Wealth Quintile") legend(order(1 "2011–2016" 2 "2017–2022")) recast(line) ciopts(recast(rcap))

svy: mean haz , over( currently_pregnant )
estat sd

svy: regress haz i.child_gender

svy: regress haz i.orig_mother_edu
testparm i.orig_mother_edu


* Full model with residence#time interaction
svy: logit height_usable ///
    c.child_age_months ///
    i.child_gender i.child_illness ///
    c.children_under_5_in_hh c.mother_age ///
    i.orig_mother_edu i.currently_pregnant ///
    i.orig_wealth_index i.sex_of_hh_head ///
    i.residence_type##i.time, or allbase

* Joint test of interaction terms
testparm i.residence_type#i.time

* Predicted probabilities by residence within each time period
margins residence_type, over(time) predict(pr)

* Plot
marginsplot, title("Predicted Probability of Usable Height by Wealth and Survey Period", size(medsmall)) ytitle("Predicted probability", size(medsmall)) xtitle("Wealth quintile", size(medsmall)) ylabel(, grid glcolor(gs14) glwidth(thin) angle(horizontal)) yscale(range(0.88 0.95)) xlabel(, labsize(medsmall)) legend(order(1 "2011–2016" 2 "2017–2022") pos(6) ring(0) col(2) size(small)) recast(line) plot1opts(lcolor(navy) lwidth(medthick)) plot2opts(lcolor(maroon) lwidth(medthick)) ciopts(recast(rcap) lwidth(thin)) graphregion(color(white)) plotregion(color(white)) name(wealth_time, replace)


svy: regress haz c.child_age_months i.child_gender i.child_illness c.children_under_5_in_hh c.mother_age i.orig_mother_edu i.currently_pregnant i.orig_wealth_index i.residence_type i.sex_of_hh_head

estimates store CC_haz

cd "C:\Users\tahsi\OneDrive\Desktop\AST_450(Project)\imp_files"
dir
use dhs_imp_1.dta, clear
gen _mj = 1

forvalues j = 2/20 {
	  append using dhs_imp_`j'.dta
      replace _mj = `j' if missing(_mj) 
  }
  
bysort _mj: gen long _mi_id = _n
   
save "stacked_imp_long.dta", replace
use "stacked_imp_long.dta", clear
 rename _mi_id pid
mi import flong, m(_mj) id(_mi_id) clear
 mi describe
 
 tab _mj
 
 mi register imputed haz child_age_months

mi register regular child_gender child_illness children_under_5_in_hh mother_age orig_mother_edu currently_pregnant orig_wealth_index residence_type sex_of_hh_head psu_id stratum_id sw


mi describe
 mi misstable summarize haz child_age_months
 
 mi svyset psu_id [pweight = sw], strata(stratum_id) vce(linearized) singleunit(centered)
 mi estimate, vceok: svy: regress haz  c.child_age_months i.child_gender i.child_illness  c.children_under_5_in_hh c.mother_age i.orig_mother_edu i.currently_pregnant i.orig_wealth_index i.residence_type i.sex_of_hh_head
 estimates store MI
 
 