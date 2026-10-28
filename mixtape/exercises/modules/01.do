* =====================================================================
* HANSEN (2015): COMPLETE REGRESSION DISCONTINUITY EXERCISE
* =====================================================================
* Run exercises/run_all.do from a fresh Stata 18 session.
* It combines hansen1.do, hansen2.do, and the outcome analysis in
* Section 6.6 of Causal Inference: The Remix.
*
* Source chapter:
* https://mixtape.scunning.com/06-regression_discontinuity
* Data: Scott Cunningham's public teaching extract of Hansen (2015).
* This is the chapter exercise, not a replication of the full paper.
*
* Contents:
*   1. Install missing packages and load the data.
*   2. Plot the BAC histogram (Figure 6.16) and test density continuity.
*   3. Estimate covariate balance (Table 6.6 and Figure 6.17).
*   4. Plot recidivism with linear/quadratic fits (Figure 6.18).
*   5. Estimate OLS models (Table 6.7).
*   6. Estimate local polynomial RD models (Table 6.8).
*   7. Export the three tables and close the log.
*
* All explanations and output labels are in English.
* Original hansen1.do and hansen2.do files are not needed at runtime.
* Graphs are saved as editable .gph files and as .png images.
* Tables are displayed and saved as .csv files.
* Existing results with the same names are replaced when rerunning.

version 18.0
clear all
set more off
set linesize 120
set scheme s2color
capture log close

* =====================================================================
* 1. SETUP, PACKAGES, AND DATA
* =====================================================================
* Run through ../run_all.do so the working directory and output paths agree.
* The optional argument is the exercises directory, supplied by the wrapper.
args project_dir
if `"`project_dir'"' == "" local project_dir `"`c(pwd)'"'
cd `"`project_dir'"'
confirm file "run_all.do"
confirm file "modules/01.do"
local project_dir `"`c(pwd)'"'
local project_dir = subinstr(`"`project_dir'"', char(92), "/", .)
local output_dir `"`project_dir'/results"'
local data_dir `"`project_dir'/data"'
capture mkdir `"`output_dir'"'
capture mkdir `"`data_dir'"'
log using "`output_dir'/execution.log", text replace

display as text "Exercise folder: `project_dir'"
display as text "Output folder: `output_dir'"

* Install only missing commands. Do not upgrade existing packages.
* rddensity requires lpdensity to draw its density diagnostic plot.
capture which rdrobust
if _rc {
    net install rdrobust, ///
        from("https://raw.githubusercontent.com/rdpackages/rdrobust/master/stata")
}
capture which rddensity
if _rc {
    net install rddensity, ///
        from("https://raw.githubusercontent.com/rdpackages/rddensity/master/stata")
}
capture which lpdensity
if _rc {
    net install lpdensity, ///
        from("https://raw.githubusercontent.com/nppackages/lpdensity/master/stata")
}
capture which cmogram
if _rc ssc install cmogram

* Record the installed versions in the analysis log.
which rdrobust
which rddensity
which lpdensity
which cmogram

* Download the public data once; use the local copy on later runs.
* Internet access is needed for the first download or missing packages.
local data_url "https://raw.githubusercontent.com/scunning1975/causal-inference-class/20143dee51505d827f572f444ac93ca9ca5e31da/hansen_dwi.dta"
capture confirm file "`data_dir'/hansen_dwi.dta"
if _rc copy "`data_url'" "`data_dir'/hansen_dwi.dta"
use "`data_dir'/hansen_dwi.dta", clear

confirm numeric variable bac1 recidivism male white aged acc
describe bac1 recidivism male white aged acc

* Keep original BAC for graphs and for commands using c(0.08).
* Center a separate variable at the cutoff for the OLS regressions.
rename bac1 bac1_orig
generate double bac1 = bac1_orig - 0.08
generate byte dui = (bac1_orig >= 0.08) if !missing(bac1_orig)
generate double bac1_sq = bac1^2

label variable bac1_orig "Blood Alcohol Content"
label variable bac1 "BAC minus 0.08"
label variable bac1_sq "Squared centered BAC"
label variable dui "DUI treatment indicator"
label variable recidivism "Recidivism"
label variable male "Male driver"
label variable white "White driver"
label variable aged "Driver age"
label variable acc "Accident"

* Negative estimates for recidivism indicate lower repeat offending.
* Outcomes are probabilities: -0.02 means -2 percentage points.

* =====================================================================
* 2. RUNNING-VARIABLE DIAGNOSTICS: HISTOGRAM AND DENSITY TEST
* =====================================================================
* BAC is recorded with limited precision, so repeated values and
* visible heaps can occur. Start by examining its distribution.

histogram bac1_orig, discrete width(0.001) color(gs10%90) ///
    xline(0.08) title("Figure 6.16: BAC histogram") ///
    xtitle("Blood Alcohol Content") name(fig616, replace)
graph save fig616 "`output_dir'/figure_6_16.gph", replace
graph export "`output_dir'/figure_6_16.png", name(fig616) width(2400) replace

* rddensity tests whether density changes at the treatment threshold.
* Read its test alongside the histogram: heaping complicates the
* interpretation of density discontinuities in these data.
rddensity bac1_orig, c(0.08) plot ///
    graph_opt(xline(0.08, lcolor(black)) legend(off) ///
        title("Density at the DUI threshold") ///
        xtitle("Blood Alcohol Content") ytitle("Density") ///
        name(density_diagnostic, replace))
graph save density_diagnostic "`output_dir'/density_diagnostic.gph", replace
graph export "`output_dir'/density_diagnostic.png", ///
    name(density_diagnostic) width(2400) replace

* =====================================================================
* 3. COVARIATE BALANCE: TABLE 6.6 AND FIGURE 6.17
* =====================================================================
* Characteristics determined before treatment should not jump at
* the cutoff. Estimate the same RD specification for each covariate.
* The window [0.03, 0.13] spans 0.05 BAC units per side.
* i.dui##c.bac1 includes treatment, centered BAC, and their interaction.
* Its treatment coefficient measures the discontinuity at BAC = 0.08.
* vce(robust) requests heteroskedasticity-robust standard errors.

matrix table6_6 = J(5, 4, .)
matrix colnames table6_6 = White Male Age Accident
matrix rownames table6_6 = DUI_effect Robust_SE Mean_outcome ///
    Untreated_mean_at_cutoff Observations

local col = 0
foreach outcome in white male aged acc {
    local ++col
    regress `outcome' i.dui##c.bac1 ///
        if inrange(bac1_orig, 0.03, 0.13), vce(robust)
    estimates store balance_`outcome'

    matrix table6_6[1, `col'] = _b[1.dui]
    matrix table6_6[2, `col'] = _se[1.dui]
    matrix table6_6[4, `col'] = _b[_cons]
    matrix table6_6[5, `col'] = e(N)
    quietly summarize `outcome' if e(sample), meanonly
    matrix table6_6[3, `col'] = r(mean)
}

* As in Table 6.7, the chapter's reported means match the regression
* intercepts. Distinguish the sample means from fitted cutoff values.
display as text "Table 6.6: Covariate balance at the DUI cutoff"
matlist table6_6, format(%12.4f) rowtitle(Statistic)

* Dots show mean outcomes within BAC bins. Each fitted line uses
* observations on its own side of the threshold.
foreach outcome in male white aged acc {
    local panel_title : variable label `outcome'
    cmogram `outcome' bac1_orig if inrange(bac1_orig, 0.03, 0.13), ///
        scatter cut(0.08) line(0.08) lfit title("`panel_title'")

    * Without by(), cmogram names its graph _graph0. Rename that graph
    * explicitly for consistent behavior in Stata 17 and Stata 18.
    * cmogram does not accept name() as a direct option.
    graph rename _graph0 balance_plot_`outcome', replace
}

* Each covariate has its own units, so do not force a shared y-axis.
graph combine balance_plot_male balance_plot_white ///
    balance_plot_aged balance_plot_acc, cols(2) ///
    title("Figure 6.17: Covariate balance across BAC") ///
    name(fig617, replace)
graph save fig617 "`output_dir'/figure_6_17.gph", replace
graph export "`output_dir'/figure_6_17.png", name(fig617) width(2400) replace

* =====================================================================
* 4. RECIDIVISM PLOTS: FIGURE 6.18
* =====================================================================
* Compare linear (lfit) and quadratic (qfit) specifications.
* cut(0.08) fits separate curves; line(0.08) marks the threshold.
* Use original BAC, not centered BAC, with this cutoff.

cmogram recidivism bac1_orig if inrange(bac1_orig, 0.03, 0.13), ///
    scatter cut(0.08) line(0.08) lfit title("Linear fit")
graph rename _graph0 recid_linear, replace

cmogram recidivism bac1_orig if inrange(bac1_orig, 0.03, 0.13), ///
    scatter cut(0.08) line(0.08) qfit title("Quadratic fit")
graph rename _graph0 recid_quadratic, replace

graph combine recid_linear recid_quadratic, cols(2) ycommon ///
    xsize(12) ysize(7) ///
    title("Figure 6.18: DUI penalties and recidivism") ///
    name(fig618, replace)
graph save fig618 "`output_dir'/figure_6_18.gph", replace
graph export "`output_dir'/figure_6_18.png", name(fig618) width(2400) replace

* =====================================================================
* 5. RECIDIVISM OLS MODELS: TABLE 6.7
* =====================================================================
* Fit different slopes, and then different quadratic trends, on each
* side. Use the fixed window [0.03, 0.13] and equal observation weights.
* These specifications reproduce the chapter's published coefficients
* without additional demographic controls.

matrix table6_7 = J(5, 2, .)
matrix colnames table6_7 = Linear Quadratic
matrix rownames table6_7 = DUI_effect Robust_SE Mean_outcome ///
    Untreated_mean_at_cutoff Observations

forvalues p = 1/2 {
    local trends "bac1"
    if `p' == 2 local trends "bac1 bac1_sq"

    regress recidivism i.dui##c.(`trends') ///
        if inrange(bac1_orig, 0.03, 0.13), vce(robust)
    estimates store recid_ols_p`p'

    matrix table6_7[1, `p'] = _b[1.dui]
    matrix table6_7[2, `p'] = _se[1.dui]
    matrix table6_7[4, `p'] = _b[_cons]
    matrix table6_7[5, `p'] = e(N)
    quietly summarize recidivism if e(sample), meanonly
    matrix table6_7[3, `p'] = r(mean)
}

* Correction to the published table: 0.1171 and 0.1113 match the
* regression intercepts, not the sample mean of the dependent variable.
* They estimate the untreated outcome at the cutoff. Report the
* actual sample mean and the intercept as separate rows.
display as text "Table 6.7: OLS estimates of DUI on recidivism"
matlist table6_7, format(%12.4f) rowtitle(Statistic)

* =====================================================================
* 6. LOCAL POLYNOMIAL RD: TABLE 6.8
* =====================================================================
* Let rdrobust choose its own bandwidths using the full BAC sample.
* Do not apply the fixed OLS window to these models.
* p(0), p(1), p(2): local constant, linear, and quadratic estimation.
* q = p + 1 by default: polynomial used to estimate bias.
* bwselect(msetwo): different MSE-optimal bandwidths per side.
* kernel(triangular): give more weight to observations near the cutoff.
* vce(nn 3): heteroskedasticity-robust nearest-neighbor variance.
* masspoints(adjust): allow for repeated BAC values during bandwidth
* selection. This option does not remove observations at the cutoff.
* "Mass points detected in the running variable" is a diagnostic notice,
* not a fatal error. BAC has repeated recorded values; retain adjustment.
*
* Pair e(tau_bc), the bias-corrected effect, with e(se_tau_rb), its
* robust bias-corrected standard error, for the table's robust method.

matrix table6_8 = J(8, 3, .)
matrix colnames table6_8 = Constant Linear Quadratic
matrix rownames table6_8 = DUI_effect Robust_BC_SE Polynomial_order ///
    Bandwidth_left Bandwidth_right Effective_N_left Effective_N_right ///
    Effective_N_total

forvalues p = 0/2 {
    local col = `p' + 1
    * Reload to avoid a repeated-call issue in rdrobust version 11.1.1.
    capture program drop rdrobust

    rdrobust recidivism bac1_orig, c(0.08) p(`p') ///
        kernel(triangular) bwselect(msetwo) ///
        vce(nn 3) masspoints(adjust) all
    estimates store recid_rd_p`p'

    matrix table6_8[1, `col'] = e(tau_bc)
    matrix table6_8[2, `col'] = e(se_tau_rb)
    matrix table6_8[3, `col'] = e(p)
    matrix table6_8[4, `col'] = e(h_l)
    matrix table6_8[5, `col'] = e(h_r)
    matrix table6_8[6, `col'] = e(N_h_l)
    matrix table6_8[7, `col'] = e(N_h_r)
    matrix table6_8[8, `col'] = e(N_h_l) + e(N_h_r)
}

* Correction to the published table: its effective observation counts
* match only the left side. Show both sides and their sum explicitly.
display as text "Table 6.8: Local polynomial RD estimates of DUI on recidivism"
matlist table6_8, format(%12.4f) rowtitle(Statistic)

* =====================================================================
* 7. PLOTS FOR TABLE 6.8
* =====================================================================
* Restore the models estimated for Table 6.8 and reuse their bandwidths.
* Display only observations within each model's estimation window.
*
* Dots are unweighted means within 10 bins per side.
* Binning is a display choice and does not change the RD estimates.
* Curves show conventional local polynomial fits; the bias-corrected
* effect reported in Table 6.8 is displayed separately in the subtitle.

forvalues p = 0/2 {
    estimates restore recid_rd_p`p'

    local cutoff = e(c)
    local hl = e(h_l)
    local hr = e(h_r)
    local xmin = `cutoff' - `hl'
    local xmax = `cutoff' + `hr'

    local effect : display %6.4f e(tau_bc)
    local hl_label : display %6.3f `hl'
    local hr_label : display %6.3f `hr'

    local fit_title "Local constant"
    if `p' == 1 local fit_title "Local linear"
    if `p' == 2 local fit_title "Local quadratic"

    * Reload to avoid stale internal state across repeated rdplot calls.
    capture program drop rdplot

    rdplot recidivism bac1_orig if inrange(bac1_orig, `xmin', `xmax'), ///
        c(`cutoff') p(`p') h(`hl' `hr') kernel(triangular) ///
        nbins(10 10) masspoints(adjust) ///
        graph_options( ///
            title("`fit_title'") ///
            subtitle("Bias-corrected effect = `effect'" ///
                "h left = `hl_label'; h right = `hr_label'", size(small)) ///
            xtitle("Blood Alcohol Content") ytitle("Recidivism") ///
            xline(`cutoff', lpattern(dash) lcolor(red)) legend(off) ///
            name(table68_p`p', replace))

    graph save table68_p`p' "`output_dir'/table6_8_plot_p`p'.gph", replace
    graph export "`output_dir'/table6_8_plot_p`p'.png", ///
        name(table68_p`p') width(1800) replace
}

* Share the vertical scale. Horizontal ranges differ because the
* three specifications use different bandwidths.
graph combine table68_p0 table68_p1 table68_p2, cols(3) ycommon ///
    xsize(16) ysize(6) ///
    title("Table 6.8: Local polynomial RD fits") ///
    name(table68_plots, replace)

graph save table68_plots "`output_dir'/table6_8_plots.gph", replace
graph export "`output_dir'/table6_8_plots.png", ///
    name(table68_plots) width(3000) replace

* Leave the final RD model active for subsequent commands.
estimates restore recid_rd_p2
* Export each named matrix without changing the active dataset.
foreach tab in 6_6 6_7 6_8 {
    preserve
    clear
    svmat double table`tab', names(col)
    local rownames : rownames table`tab'
    generate str40 statistic = ""
    local row = 0
    foreach stat of local rownames {
        local ++row
        replace statistic = "`stat'" in `row'
    }
    order statistic
    export delimited using "`output_dir'/table_`tab'.csv", replace
    restore
}

log close
