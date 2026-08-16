********************************************************************
* Dashboard Data Preparation
********************************************************************

clear all
set more off

global OUT "../data/processed/selected"
global DASH "../data/processed/dashboard"

use "$OUT/dhs_combined.dta", clear

* Survey design
svyset psu_id [pweight=sw], strata(stratum_id) singleunit(centered)

* Period variable
gen period = ""
replace period = "2011-2016" if survey_period == 1
replace period = "2017-2022" if survey_period == 2
drop if period == ""

* Make sure country_cat exists and is labeled
tab country_cat

* Start fresh
capture postclose handle
postutil clear

* Save results to a real .dta file, not only tempfile
postfile handle str20 country str12 period double usable_pct unusable_pct n using "$DASH/overview_temp.dta", replace

levelsof country_cat, local(countries)
levelsof period, local(periods)

foreach c of local countries {
    local cname : label (country_cat) `c'

    foreach p of local periods {
        quietly count if country_cat == `c' & period == "`p'"
        if r(N) > 0 {
            quietly svy, subpop(if country_cat == `c' & period == "`p'"): mean height_usable
            matrix b = e(b)
            local usable = b[1,1] * 100
            local unusable = 100 - `usable'

            quietly count if country_cat == `c' & period == "`p'"
            local n = r(N)

            post handle ("`cname'") ("`p'") (`usable') (`unusable') (`n')
        }
    }
}

foreach p of local periods {
    quietly count if period == "`p'"
    if r(N) > 0 {
        quietly svy, subpop(if period == "`p'"): mean height_usable
        matrix b = e(b)
        local usable = b[1,1] * 100
        local unusable = 100 - `usable'

        quietly count if period == "`p'"
        local n = r(N)

        post handle ("All") ("`p'") (`usable') (`unusable') (`n')
    }
}

quietly svy: mean height_usable
matrix b = e(b)
local usable = b[1,1] * 100
local unusable = 100 - `usable'

quietly count
local n = r(N)

post handle ("All") ("All") (`usable') (`unusable') (`n')

postclose handle

use "$DASH/overview_temp.dta", clear

order country period usable_pct unusable_pct n
sort country period

duplicates drop country period usable_pct unusable_pct n, force

count
list, sepby(country)

export delimited using "$DASH/overview.csv", replace

clear

use "$OUT/dhs_combined.dta", clear

*------------------------------------------------------------
* 1. Survey design
*------------------------------------------------------------
svyset psu_id [pweight=sw], strata(stratum_id)

*------------------------------------------------------------
* 2. Create period from time
*------------------------------------------------------------
gen period = ""
replace period = "2011-2016" if survey_period == 1
replace period = "2017-2022" if survey_period == 2
drop if period == ""

*------------------------------------------------------------
* 3. Keep needed variables
*------------------------------------------------------------
keep country period height_usable sw stratum_id psu_id wealth_index mother_education residence_type child_gender

*------------------------------------------------------------
* 4. Start fresh
*------------------------------------------------------------
capture postclose handle
postutil clear

postfile handle  str20 country str12 period str25 variable str30 level double usable_pct unusable_pct n using "$DASH/subgroup_temp.dta", replace

*------------------------------------------------------------
* 5. Variables to summarize
*------------------------------------------------------------
local vars wealth_index mother_education residence_type child_gender

*------------------------------------------------------------
* 6. Loop over variables, countries, periods, and levels
*------------------------------------------------------------
levelsof country, local(countries)
levelsof period, local(periods)

foreach v of local vars {

    local vname "`v'"
    if "`v'" == "wealth_index" local vname "Wealth quintile"
    if "`v'" == "mother_education"  local vname "Maternal education"
    if "`v'" == "residence_type"   local vname "Residence"
    if "`v'" == "child_gender"     local vname "Child sex"

    capture confirm string variable `v'

    if _rc == 0 {
        * String variable
        levelsof `v', local(levels)

        foreach c of local countries {
            foreach p of local periods {
                foreach l of local levels {

                    quietly count if country == "`c'" & period == "`p'" & `v' == "`l'"
                    if r(N) > 0 {

                        quietly svy, subpop(if country == "`c'" & period == "`p'" & `v' == "`l'"): mean height_usable
                        matrix b = e(b)
                        local usable = b[1,1] * 100
                        local unusable = 100 - `usable'

                        quietly count if country == "`c'" & period == "`p'" & `v' == "`l'"
                        local n = r(N)

                        post handle ("`c'") ("`p'") ("`vname'") ("`l'") (`usable') (`unusable') (`n')
                    }
                }
            }
        }

        * All-country rows
        foreach p of local periods {
            foreach l of local levels {

                quietly count if period == "`p'" & `v' == "`l'"
                if r(N) > 0 {

                    quietly svy, subpop(if period == "`p'" & `v' == "`l'"): mean height_usable
                    matrix b = e(b)
                    local usable = b[1,1] * 100
                    local unusable = 100 - `usable'

                    quietly count if period == "`p'" & `v' == "`l'"
                    local n = r(N)

                    post handle ("All") ("`p'") ("`vname'") ("`l'") (`usable') (`unusable') (`n')
                }
            }
        }
    }
    else {
        * Numeric variable
        levelsof `v', local(levels)
        local vallab : value label `v'

        foreach c of local countries {
            foreach p of local periods {
                foreach l of local levels {

                    quietly count if country == "`c'" & period == "`p'" & `v' == `l'
                    if r(N) > 0 {

                        quietly svy, subpop(if country == "`c'" & period == "`p'" & `v' == `l'): mean height_usable
                        matrix b = e(b)
                        local usable = b[1,1] * 100
                        local unusable = 100 - `usable'

                        quietly count if country == "`c'" & period == "`p'" & `v' == `l'
                        local n = r(N)

                        local levname "`l'"
                        if "`vallab'" != "" {
                            local levname : label `vallab' `l'
                        }

                        post handle ("`c'") ("`p'") ("`vname'") ("`levname'") (`usable') (`unusable') (`n')
                    }
                }
            }
        }

        * All-country rows
        foreach p of local periods {
            foreach l of local levels {

                quietly count if period == "`p'" & `v' == `l'
                if r(N) > 0 {

                    quietly svy, subpop(if period == "`p'" & `v' == `l'): mean height_usable
                    matrix b = e(b)
                    local usable = b[1,1] * 100
                    local unusable = 100 - `usable'

                    quietly count if period == "`p'" & `v' == `l'
                    local n = r(N)

                    local levname "`l'"
                    if "`vallab'" != "" {
                        local levname : label `vallab' `l'
                    }

                    post handle ("All") ("`p'") ("`vname'") ("`levname'") (`usable') (`unusable') (`n')
                }
            }
        }
    }
}

postclose handle

*------------------------------------------------------------
* 7. Open, clean, inspect
*------------------------------------------------------------
use "$DASH/subgroup_temp.dta", clear

order country period variable level usable_pct unusable_pct n
sort variable country period level

duplicates drop country period variable level usable_pct unusable_pct n, force

count
list in 1/30, clean

*------------------------------------------------------------
* 8. Export CSV for Shiny
*------------------------------------------------------------
export delimited using "$DASH/subgroup.csv", replace

*** Run R/12_Dashboard.R to launch the interactive Shiny dashboard.
