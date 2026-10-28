* Cattaneo et al. seminar: run from this directory in Stata 18.
* do "run_all.do"             runs all modules
* do "run_all.do" "1"         runs only module 1 (1 through 6)
* do "/path/run_all.do" "all" "/path/to/exercises"
* First run: python fetch_sources.py (also downloads isolated Stata packages).
* Re-running replaces only this track's saved results and graphs.
version 18.0
args module project_dir
if `"`module'"' == "" local module "all"
if !inlist("`module'", "all", "1", "2", "3", "4", "5", "6") {
    display as error "Module must be all or an integer from 1 to 6."
    exit 198
}
if `"`project_dir'"' == "" local project_dir `"`c(pwd)'"'
cd `"`project_dir'"'
confirm file "run_all.do"
confirm file "cache/ado/rdrobust.ado"
global CROOT `"`c(pwd)'"'
global COUT `"$CROOT/results"'
capture mkdir "$COUT"
adopath ++ "$CROOT/cache/ado"
* Reload ado commands if the session previously used another package version.
discard
set more off
set linesize 120
set scheme s2color
set seed 50
capture log close cattaneo
log using "$COUT/execution.log", text replace name(cattaneo)
foreach cmd in rdrobust rdbwselect rdplot rddensity rdrandinf rdwinselect rdmc rdms {
    which `cmd'
}
capture program drop save_rd
program define save_rd
    syntax, MODEL(string) [SCALE(real 1)]
    post rdpost ("`model'") (e(tau_cl)*`scale') (e(tau_bc)*`scale') ///
        (e(se_tau_rb)*`scale') (e(pv_rb)) (e(ci_l_rb)*`scale') ///
        (e(ci_r_rb)*`scale') (e(h_l)) (e(h_r)) (e(N_h_l)) (e(N_h_r))
end
capture program drop save_graph
program define save_graph
    args name
    graph export "$COUT/`name'.png", width(1800) replace
    graph export "$COUT/`name'.pdf", replace
    graph save "$COUT/`name'.gph", replace
end
capture postclose rdpost
forvalues m=1/6 {
    if "`module'" == "all" | "`module'" == "`m'" {
        postfile rdpost str48 model double tau_cl tau_bc se_rb p_rb ci_l ci_r ///
            h_l h_r n_l n_r using "$COUT/rd_results_0`m'.dta", replace
        do "$CROOT/modules/0`m'.do"
        postclose rdpost
        preserve
        use "$COUT/rd_results_0`m'.dta", clear
        export delimited using "$COUT/rd_results_0`m'.csv", replace
        restore
    }
}
preserve
clear
forvalues m=1/6 {
    capture confirm file "$COUT/rd_results_0`m'.dta"
    if !_rc append using "$COUT/rd_results_0`m'.dta"
}
export delimited using "$COUT/rd_results.csv", replace
restore
display as result "All requested modules completed. Results: $COUT"
log close cattaneo
* These globals only hold this exercise's paths.
macro drop CROOT COUT
