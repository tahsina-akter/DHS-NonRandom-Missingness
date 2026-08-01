* Extracted from pooled_data_and_analysis.smcl
use "C:\Users\tahsi\OneDrive\Desktop\AST_450(Project)\v022\bd11a.dta"
append using "C:\Users\tahsi\OneDrive\Desktop\AST_450(Project)\v022\bd14a.dta"
append using "C:\Users\tahsi\OneDrive\Desktop\AST_450(Project)\v022\bd22a.dta"
append using "C:\Users\tahsi\OneDrive\Desktop\AST_450(Project)\v022\bd17_18.dta"
append using "C:\Users\tahsi\OneDrive\Desktop\AST_450(Project)\v022\np11a.dta"
append using "C:\Users\tahsi\OneDrive\Desktop\AST_450(Project)\v022\np16a.dta"
append using "C:\Users\tahsi\OneDrive\Desktop\AST_450(Project)\v022\np22a.dta"
append using "C:\Users\tahsi\OneDrive\Desktop\AST_450(Project)\v022\pk12_13.dta"
append using "C:\Users\tahsi\OneDrive\Desktop\AST_450(Project)\v022\pk17_18.dta"
append using "C:\Users\tahsi\OneDrive\Desktop\AST_450(Project)\v022\in19_21.dta"
append using "C:\Users\tahsi\OneDrive\Desktop\AST_450(Project)\v022\in15_16.dta"
save "C:\Users\tahsi\OneDrive\Desktop\AST_450(Project)\DHS.dta", replace
drop if v151==3  
* removed 3 unusual observation
drop if stratum_id=="India_2015-16_32410" | stratum_id== "India_2015-16_5521"  | stratum_id=="India_2015-16_57221" | stratum_id=="India_2015-16_57222" | stratum_id=="India_2015-16_57223" | stratum_id=="India_2015-16_58721" | stratum_id=="India_2015-16_58722" | stratum_id=="India_2015-16_63910" | stratum_id=="India_2015-16_902"  | stratum_id== "India_2015-16_912"   | stratum_id=="India_2019-21_1023" | stratum_id== "India_2019-21_3241" | stratum_id== "India_2019-21_57221"| stratum_id== "India_2019-21_57222"| stratum_id== "India_2019-21_83723"| stratum_id== "India_2019-21_83823" | stratum_id=="India_2019-21_84022" | stratum_id=="India_2019-21_84122"| stratum_id== "India_2019-21_84223" | stratum_id=="India_2019-21_84421"| stratum_id=="India_2019-21_84621" | stratum_id=="India_2019-21_84622" | stratum_id=="India_2019-21_84723"| stratum_id== "India_2019-21_89821"| stratum_id== "India_2019-21_89823"
save "C:\Users\tahsi\OneDrive\Desktop\AST_450(Project)\DHS.dta", replace
gen haz = hw70/100
gen height_missing = hw70 == .
label define missing 0 "no" 1 "yes"
label values height_missing missing
label variable height_missing "missing height"
gen height_implausible = (hw70 < -600 | hw70 > 600)
label variable height_implausible "biologically implausible height"
label define implausible 0 "no" 1 "yes"
label values height_implausible implausible
gen height_usable = (height_missing == 0 & height_implausible == 0)
label define usable 0 "no" 1 "yes"
label values height_usable usable
label variable height_usable "usable height for 1, otherwise 0"
tab height_missing
tab height_usable
tab height_implausible if( height_missing != 1)
save "C:\Users\tahsi\OneDrive\Desktop\AST_450(Project)\DHS.dta", replace
preserve
drop if stratum_id=="India_2015-16_2410" |  stratum_id=="India_2015-16_972" | stratum_id==  "Pakistan_2012-13_69"
restore
preserve
br if stratum_id=="India_2015-16_2410" |  stratum_id=="India_2015-16_972" | stratum_id==  "Pakistan_2012-13_69"
br if v025==1 & height_usable==1
gen sw = v005/1000000
svyset [pw=sw], strata( stratum_id ) psu( psu_id )
svy: mean haz if height_usable==1
svy: tab v025 height_usable, row
svy: ttest hw1 , by(height_usable)
codebook hw1
ttest hw1 , by(height_usable)
recode v106 (0/1 = 1 "illiterate") (2/max = 0 "literate"), gen(mother_literacy)
codebook v106
recode v025 ( = 1 "illiterate") (2/max = 0 "literate"), gen(mother_literacy)
codebook v025
recode v025 (1 = 0 "urban") (2 = 1 "rural"), gen(residence_type)
codebook
summary haz, detail
summarize haz, detail
replace haz = . if haz>10
summarize haz, detail
svy: mean haz
svy: logit height_usable v012 v137 i.v151 i.v190 i.v213 i.b4 i.child_illness hw1 i.mother_literacy i.residence_type, or allbase
recode v151 (2 = 1 "female") (1 = 0 "male"), gen(sex_of_hh_head)
svy: logit height_usable v012 v137 i.sex_of_hh_head i.v190 i.v213 i.b4 i.child_illness hw1 i.mother_literacy i.residence_type, or allbase
rename v012 mother_age
rename v137 children_under_5_in_hh
rename v213 currently_pregnant
rename b4 sex_of_child
rename hw1 child_age_months
save "C:\Users\tahsi\OneDrive\Desktop\AST_450(Project)\DHS.dta", replace
summarize mother_age child_age_months children_under_5_in_hh v106, detail
svy: mean child_age_months
tabstat child_age_months sex_of_child children_under_5_in_hh mother_age , stat(median)
recode child_age_months (min/23 = 0 "<2 years") (24/max =1 ">=2 years"), gen(child_2_years)
count( child_age_months == 0 )
count( child_age_months = 0 )
count if child_age_months = 0
tab child_2_years
codebook child_2_years
br if child_2_years==.
codebook b8
save "C:\Users\tahsi\OneDrive\Desktop\AST_450(Project)\DHS.dta", replace
preserve
clear
use "C:\Users\tahsi\OneDrive\Desktop\AST_450(Project)\DHS.dta"
preserve
restore
clear
use "C:\Users\tahsi\OneDrive\Desktop\AST_450(Project)\DHS.dta"
preserve
svy: mean haz if residence_type==1
drop if stratum_id=="India_2015-16_2410" |  stratum_id=="India_2015-16_972" | stratum_id==  "Pakistan_2012-13_69"
svy: mean haz if residence_type==1
svy: mean haz if residence_type==1 & height_usable==1
save "C:\Users\tahsi\OneDrive\Desktop\AST_450(Project)\DHS.dta", replace
mean haz if residence_type==1
tab residence_type height_usable, percent format(%9.3f)
svy: tab residence_type height_usable, percent format(%9.3f)
svy: tab residence_type height_usable,row percent format(%9.3f)
svy: tab residence_type height_usable,col percent format(%9.3f)
svy: tab residence_type height_usable,col
svy: tab residence_type height_usable,col count format(%9.3f)
svy: tab residence_type height_usable,col count
svy: tab residence_type height_usable,col count format (%15.0f)
svy: tab v190 height_usable,col count format(%9.3f)
svy: tab v190 height_usable,col percent format(%9.3f)
svy: tab v190 height_usable,col count format (%15.0f)
svy: tab v151 height_usable,col percent format(%9.3f)
svy: tab v151 height_usable,col count format (%15.0f)
svy: tab currently_pregnant height_usable,col percent format(%9.3f)
svy: tab currently_pregnant height_usable,col count format (%15.0f)
svy: tab child_illness height_usable,col percent format(%9.3f)
svy: tab child_illness height_usable,col count format (%15.0f)
svy: tab sex_of_child height_usable,col percent format(%9.3f)
svy: tab sex_of_child height_usable,col count format (%15.0f)
svy: ttest mother_literacy, by( height_usable )
ttest mother_literacy, by( height_usable )
ttest v106 , by( height_usable )
svy: tab v106 height_usable,col percent format(%9.3f)
svy: tab v106 height_usable,col count format (%15.0f)
save "C:\Users\tahsi\OneDrive\Desktop\AST_450(Project)\DHS.dta", replace
svy: ranksum mother_age , by( height_usable )
ranksum mother_age , by( height_usable )
svy: mean child_age_months by( height_usable )
svy: mean child_age_months, over( height_usable )
svy: mean mother_age , over( height_usable )
mean mother_age , over( height_usable )
summarize mother_age , over( height_usable )
summarize mother_age , by( height_usable )
summarize mother_age
svy: summarize mother_age , over( height_usable )
summarize child_age_months
summarize child_age_months if height_usable == 0 [pweight=sw]
svy: mean mother_age , over( height_usable )
estat sd
svy: mean child_age_months, over( height_usable )
estat sd
svy: mean children_under_5_in_hh , over( height_usable )
estat sd
svy: regress height_usable children_under_5_in_hh
svy: regress height_usable child_age_months
svy: regress height_usable mother_age
svy: mean haz , over( residence_type )
estat sd
tab height_usable
svy: mean haz , over( sex_of_hh_head )
estat sd
svy: mean haz , over( currently_pregnant )
estat sd
svy: mean haz , over( child_illness )
estat sd
svy: mean haz , over( sex_of_child )
estat sd
svy: mean haz , over( child_2_years )
codebook child_age_months children_under_5_in_hh mother_age
recode child_age_months (min/30 = 1 "younger") (31/max = 0 "older"), gen(ch_age)
svy: mean haz , over( ch_age )
estat sd
codebook children_under_5_in_hh
recode children_under_5_in_hh (min/2 = 0 "less") (3/max = 1 "more"), gen(under_5)
svy: mean haz , over( under_5 )
estat sd
recode v190kj (min/2 = 0 "less") (3/max = 1 "more"), gen(under_5)
codebook v190
recode v190 (min/2 = 1 "poor") (3/max = 0 "rich"), gen(wealth)
svy: mean haz , over( wealth )
estat sd
drop wealth
recode v190 (1= 1 "poor") (5 = 0 "rich"), gen(wealth)
svy: mean haz , over( wealth )
estat sd
tab wealth
replace wealth=. if wealth==2/4
replace wealth=. if wealth==2 | wealth==3 | wealth
drop wealth
recode v190 (1= 1 "poor") (5 = 0 "rich"), gen(wealth)
replace wealth=. if wealth==2 | wealth==3 | wealth==4
tab wealth
tab wealth height_usable
summarize mother_age, detail
preserve
save "C:\Users\tahsi\OneDrive\Desktop\AST_450(Project)\DHS.dta", replace
recode mother_age (min/27= 1 "younger") (28/max = 0 "older"), gen(mt_age)
svy: mean haz , over( mt_age )
estat sd
svy: mean haz , over( mother_literacy )
estat sd
svy: logit height_usable i.residence_type i.mt_age i.ch_age i.mother_literacy i.wealth i.sex_of_hh_head i.currently_pregnant i.child_age_months i.sex_of_child i.under_5, or allbase
codebook ch_age
codebook hw1
svy: logit height_usable i.residence_type i.mt_age i.mother_literacy i.wealth i.sex_of_hh_head i.currently_pregnant i.child_age_months i.sex_of_child i.under_5, or allbase
svy: logit height_usable i.residence_type i.mt_age i.mother_literacy i.wealth i.sex_of_hh_head i.currently_pregnant i.ch_age i.sex_of_child i.under_5, or allbase
save "C:\Users\tahsi\OneDrive\Desktop\AST_450(Project)\DHS.dta", replace
tab country year
svy: logit height_usable i.residence_type i.mt_age i.mother_literacy i.sex_of_hh_head i.currently_pregnant i.ch_age i.sex_of_child i.under_5, or allbase
svy: logit height_usable i.residence_type i.mt_age i.mother_literacy i.sex_of_hh_head i.currently_pregnant i.ch_age i.sex_of_child i.under_5, or allbase
tab mother_literacy
recode v106 ( = 1 "illiterate") (2/max = 0 "literate"), gen(mother_literacy)
codebook v106
recode v106 (0 = 1 "illiterate") (1/max = 0 "literate"), gen(mother_literacy)
drop mother_literacy
recode v106 (0 = 1 "illiterate") (1/max = 0 "literate"), gen(mother_literacy)
svy: mean haz , over( mother_literacy )
estat sd
tab mother_literacy
svy: logit height_usable i.residence_type i.mt_age i.mother_literacy i.sex_of_hh_head i.currently_pregnant i.ch_age i.sex_of_child i.under_5, or allbase
codebook height_usable residence_type mt_age mother_literacy sex_of_hh_head currently_pregnant ch_age sex_of_child under_5
codebook height_implausible
codebook height_usable
codebook height_implausible residence_type mt_age mother_literacy sex_of_hh_head currently_pregnant ch_age sex_of_child under_5
svy: logit height_implausible i.residence_type i.mt_age i.mother_literacy i.sex_of_hh_head i.currently_pregnant i.ch_age i.sex_of_child i.under_5, or allbase
svy: logit height_implausible i.residence_type i.mt_age i.mother_literacy i.sex_of_hh_head i.currently_pregnant i.ch_age i.sex_of_child i.under_5, or
svy: logit height_usable i.residence_type i.mt_age i.mother_literacy i.sex_of_hh_head i.currently_pregnant i.ch_age i.sex_of_child i.under_5, or allbase
recode mother_age (min/27= 1 "younger") (28/max = 0 "older"), gen(mt_age)
drop mt_age
save "C:\Users\tahsi\OneDrive\Desktop\AST_450(Project)\DHS.dta", replace
restore
use "C:\Users\tahsi\OneDrive\Desktop\AST_450(Project)\DHS.dta"
preserve
drop if mother_age<15
recode mother_age (min/28= 1 "younger") (28/max = 0 "older"), gen(mt_age)
svy: logit height_usable i.residence_type i.mt_age i.mother_literacy i.sex_of_hh_head i.currently_pregnant i.ch_age i.sex_of_child i.under_5, or allbase
svy: logit height_implausible i.residence_type i.mt_age i.mother_literacy i.sex_of_hh_head i.currently_pregnant i.ch_age i.sex_of_child i.under_5, or
restore
recode mother_age (min/27= 1 "younger") (28/max = 0 "older"), gen(mt_age)
svy: logit height_implausible i.residence_type i.mt_age i.mother_literacy i.sex_of_hh_head i.currently_pregnant i.ch_age i.sex_of_child i.under_5, or
svy: logit i.wealth, or
codebook wealth
svy: logit height_implausible i.wealth, or
svy: logit height_implausible i.residence_type i.mt_age i.mother_literacy i.sex_of_hh_head i.currently_pregnant i.ch_age i.sex_of_child i.under_5 i.child_illness , or
svy: logit height_usable i.residence_type i.mt_age i.mother_literacy i.sex_of_hh_head i.currently_pregnant i.ch_age i.sex_of_child i.under_5 i.child_illness , or
save "C:\Users\tahsi\OneDrive\Desktop\AST_450(Project)\DHS.dta", replace
svy: logit height_implausible i.wealth , or
preserve
drop wealth
recode v190 (1/2= 1 "poor") (3/5 = 0 "rich"), gen(wealth)
svy: logit height_implausible i.wealth , or
svy: mean haz , over( wealth )
estat sd
svy: logit height_implausible i.residence_type i.mt_age i.mother_literacy i.sex_of_hh_head i.currently_pregnant i.ch_age i.sex_of_child i.under_5 i.wealth , or
regress height_implausible wealth mt_age mother_literacy under_5 ch_age sex_of_hh_head residence_type sex_of_child currently_pregnant
svy: logit height_implausible i.residence_type i.mt_age i.mother_literacy i.sex_of_hh_head i.currently_pregnant i.ch_age i.sex_of_child i.under_5 i.wealth
regress height_implausible i.residence_type i.mt_age i.mother_literacy i.sex_of_hh_head i.currently_pregnant i.ch_age i.sex_of_child i.under_5 i.wealth , or
regress height_implausible i.residence_type i.mt_age i.mother_literacy i.sex_of_hh_head i.currently_pregnant i.ch_age i.sex_of_child i.under_5 i.wealth
svy: logit height_implausible i.residence_type i.mt_age i.mother_literacy i.sex_of_hh_head i.currently_pregnant i.ch_age i.sex_of_child i.under_5 i.wealth
estat vif
regress height_implausible i.residence_type i.mt_age i.mother_literacy i.sex_of_hh_head i.currently_pregnant i.ch_age i.sex_of_child i.under_5 i.wealth
estat vif
tab wealth mt_age mother_literacy under_5 ch_age sex_of_hh_head residence_type sex_of_child currently_pregnant, chi2
regress mother_age v190
regress height_implausible mother_age v190
estat vif
regress height_implausible residence_type mt_age mother_literacy sex_of_hh_head currently_pregnant ch_age sex_of_child under_5 wealth
estat vif
svy: logit height_implausible i.residence_type i.mt_age i.mother_literacy i.sex_of_hh_head i.currently_pregnant i.ch_age i.sex_of_child i.under_5 i.wealth, or allbase
save "C:\Users\tahsi\OneDrive\Desktop\AST_450(Project)\DHS.dta", replace
codebook height_implausible residence_type mt_age mother_literacy sex_of_hh_head currently_pregnant ch_age sex_of_child under_5 wealth
recode sex_of_child (2= 1 "female") (1 = 0 "male"), gen(child_gender)
codebook child_gender
svy: logit height_implausible i.residence_type i.mt_age i.mother_literacy i.sex_of_hh_head i.currently_pregnant i.ch_age i. i.under_5 i.wealth, or allbase
svy: logit height_implausible i.residence_type i.mt_age i.mother_literacy i.sex_of_hh_head i.currently_pregnant i.ch_age i.child_gender i.under_5 i.wealth, or allbase
save "C:\Users\tahsi\OneDrive\Desktop\AST_450(Project)\DHS.dta", replace
svy: logit height_usable i.residence_type i.mt_age i.mother_literacy i.sex_of_hh_head i.currently_pregnant i.ch_age i.child_gender i.under_5 i.wealth, or allbase
save "C:\Users\tahsi\OneDrive\Desktop\AST_450(Project)\DHS.dta", replace
svy: logit height_usable i.ch_age i.mother_literacy i.under_5 i.child_gender i.wealth i.currently_pregnanti.residence_type i.mt_age  i.sex_of_hh_head   , or allbase
svy: logit height_usable i.ch_age i.mother_literacy i.under_5 i.child_gender i.wealth i.currently_pregnant i.residence_type i.mt_age  i.sex_of_hh_head i.child_illness  , or allbase
svy: logit height_usable i.ch_age i.mother_literacy i.under_5 i.child_gender i.wealth i.currently_pregnant i.child_illness i.residence_type i.mt_age  i.sex_of_hh_head , or allbase
svy: logit height_implausible i.ch_age i.mother_literacy i.under_5 i.child_gender i.wealth i.currently_pregnant i.child_illness i.residence_type i.mt_age  i.sex_of_hh_head , or allbase
svy: logit height_implausible i.ch_age i.mother_literacy i.child_gender i.wealth i.currently_pregnant i.child_illness i.residence_type i.under_5 i.mt_age  i.sex_of_hh_head , or allbase
svy: logit height_implausible i.ch_age i.mother_literacy i.under_5 i.child_gender i.wealth i.currently_pregnant i.child_illness i.residence_type i.mt_age  i.sex_of_hh_head , or allbase
svy: logit height_usable i.ch_age i.mother_literacy i.child_gender i.wealth i.currently_pregnant i.child_illness i.residence_type i.under_5 i.mt_age  i.sex_of_hh_head , or allbase
svy: logit height_implausible i.ch_age i.mother_literacy i.child_gender i.wealth i.currently_pregnant i.child_illness i.residence_type i.under_5 i.mt_age  i.sex_of_hh_head , or allbase
br if ch_age==30 | ch_age == 31
br if hw1==30 | hw1 == 31
br if child_age_months ==30 | child_age_months == 31
svy: mean haz , over( ch_age )
svy: mean haz , over( mt_age )
tab sex_of_child height_usable
tab sex_of_child height_usable, col
tab sex_of_child height_usable, col chi
svy: tab sex_of_child height_usable, col chi
svy: tab sex_of_child height_usable, col
svy: tab child_illness height_usable, col
svy: tab v106 height_usable, col
svy: tab currently_pregnant height_usable, col
svy: tab v190 height_usable, col
svy: tab sex_of_hh_head height_usable, col
svy: tab residence_type height_usable, col
svy: ttest child_age_months, by( height_usable )
ttest child_age_months, by( height_usable )
ranksum mother_age , by( height_usable )
ranksum children_under_5_in_hh , by( height_usable )
svy: regress mother_age i.height_usable
svy: regress height_usable child_age_months
svy: regress height_usable children_under_5_in_hh
svy: regress height_usable mother_age
svy: tab sex_of_child height_usable, col
svy: tab residence_type
svy: tab residence_type, count format(%15f)
svy: tab residence_type, count format(%15.2f)
svy: tab residence_type, count format(%15.0f)
svy: mean mother_age
estat sd
svy: mean child_age_months
estat sd
svy: mean children_under_5_in_hh
estat sd
codebook child_2_years
svy: tab residence_type child_2_years , count format(%15.0f)
svy: mean haz
codebook child_2_years
svy: height_usable
svy: tab height_usable
svy: tab ch_age height_usable
svy: tab child_illness height_usable
svy: tab ch_age
svy: tab height_usable, count
svy: tab height_usable, count format(% 9.3f)
svy: tab height_usable, count format (%15.0f)
svy: tab currently_pregnant height_usable, count format (%15.0f)
svy: tab height_usable, count format (%15.0f)
svy: tab child_2_years , count format (%15.0f)
svy: tab ch_age , count format (%15.0f)
svy: tab ch_age height_usable , count format (%15.0f)
svy: tab child_gender child_2_years , count format(%15.0f)
svy: tab child_gender child_2_years , percent format(%9.3f)
svy: tab child_illness height_usable , count format (%15.0f)
svy: tab child_illness child_2_years , percent format(%9.3f)
svy: tab v106 height_usable , count format (%15.0f)
svy: tab v106 child_2_years , percent format(%9.3f)
svy: tab currently_pregnant height_usable , count format (%15.0f)
svy: tab currently_pregnant child_2_years , percent format(%9.3f)
svy: tab v190 height_usable , count format (%15.0f)
svy: tab v190 child_2_years , percent format(%9.3f)
svy: tab sex_of_hh_head height_usable , count format (%15.0f)
svy: tab sex_of_hh_head child_2_years , percent format(%9.3f)
svy: tab child_illness child_2_years , count format (%15.0f)
svy: tab v106 child_2_years , count format (%15.0f)
svy: tab child_gender child_2_years , col count format(%15.0f)
svy: tab child_gender child_2_years , col count format(%15.3f)
svy: tab child_illness child_2_years , col count format(%15.3f)
svy: tab v106 child_2_years , col count format(%15.3f)
svy: tab currently_pregnant child_2_years , col count format(%15.3f)
svy: tab v190 child_2_years , col count format(%15.3f)
svy: tab sex_of_hh_head child_2_years , col count format(%15.3f)
svy: tab residence_type child_2_years , col count format(%15.3f)
svy: mean haz , over( child_2_years )
svy: mean mother_age , over( child_2_years )
estat sd
svy: regress child_2_years mother_age
svy: mean ch_age , over( child_2_years )
estat sd
svy: regress child_2_years ch_age
svy: mean children_under_5_in_hh , over( child_2_years )
estat sd
svy: regress child_2_years children_under_5_in_hh
svy: regress child_2_years child_age_months
svy: mean child_age_months , over( child_2_years )
estat sd
codebook year
"2011" "2012-13" "2014" "2015-16" "2016" "2017-18" "2019-21" "2022"
gen time = .
replace time = 1 if year == "2011" | year == "2012-13" | year == "2014" | year == "2015-16" | year == "2016"
replace time = 2 if year == "2017-18" | year == "2019-21" | year == "2022"
tab height_usable time
tab height_usable time, percent
save "C:\Users\tahsi\OneDrive\Desktop\AST_450(Project)\DHS.dta", replace
preserve
save "C:\Users\tahsi\OneDrive\Desktop\AST_450(Project)\DHS.dta", replace
drop if time ==2
save "C:\Users\tahsi\OneDrive\Desktop\AST_450(Project)\time2.dta"
save "C:\Users\tahsi\OneDrive\Desktop\AST_450(Project)\time1.dta"
use  "C:\Users\tahsi\OneDrive\Desktop\AST_450(Project)\DHS.dta"
drop if time == 1
save "C:\Users\tahsi\OneDrive\Desktop\AST_450(Project)\time2.dta", replace
use  "C:\Users\tahsi\OneDrive\Desktop\AST_450(Project)\time1.dta"
svyset [pw=sw], strata( stratum_id ) psu( psu_id )
tab country year
svy: logit height_usable child_age_months i.child_gender i.child_illness children_under_5_in_hh mother_age i.v106 i.currently_pregnant i.v190 i.sex_of_hh_head i.residence_type, or
svy: logit height_usable child_age_months i.child_gender i.child_illness children_under_5_in_hh mother_age i.v106 i.currently_pregnant i.v190 i.sex_of_hh_head i.residence_type, or
use  "C:\Users\tahsi\OneDrive\Desktop\AST_450(Project)\time2.dta"
svy: logit height_usable child_age_months i.child_gender i.child_illness children_under_5_in_hh mother_age i.v106 i.currently_pregnant i.v190 i.sex_of_hh_head i.residence_type, or
tab height_usable
use  "C:\Users\tahsi\OneDrive\Desktop\AST_450(Project)\time1.dta"
tab height_usable
exit, clear
