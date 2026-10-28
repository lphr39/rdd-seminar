* Extensions, Section 4: Lindo, Sanders and Oreopoulos (2010).
* X is oriented so positive values receive probation. Check exact ties.
use "$CROOT/data/CIT_2024_CUP_discrete.dta", clear
summarize X T nextGPA
codebook X
tabulate X T if abs(X)<=0.021, missing
twoway histogram X, width(0.01) frequency xline(0) ///
    xtitle("Distance to probation cutoff") ytitle("Students") ///
    graphregion(color(white))
save_graph probation_histogram
rdplot nextGPA X, p(1) graph_options(xtitle("Distance to probation cutoff") ///
    ytitle("Next-term GPA") legend(off) graphregion(color(white)))
save_graph probation_plot
rdrobust nextGPA X, p(1) masspoints(adjust) all
save_rd, model(probation_continuity)
* A numerical diagnostic: clustering by score cannot create missing support.
rdrobust nextGPA X, p(1) vce(cluster X) all
save_rd, model(probation_cluster_score)
* The closest groups are X=-0.000005 (control) and X=0.01 (treated).
* The cutoff shift implements this tie rule, not a new substantive cutoff.
local covs hsgrade_pct totcredits_year1 age_at_entry male bpl_north_america
bitesti 275 67 0.5
rdwinselect X `covs', cutoff(0.00005) wmin(0.01) wstep(0.01) ///
    level(0.135) seed(50) approx
* Authors' smallest two-score window. Inspect balance before interpreting.
rdrandinf nextGPA X, wl(-0.005) wr(0.01) reps(10000) seed(50)
matrix LR = (r(obs_stat),r(randpval),r(asy_pval))
matrix colnames LR = estimate fisher_p asymptotic_p
preserve
clear
svmat double LR, names(col)
export delimited using "$COUT/probation_randomization.csv", replace
restore
foreach z of local covs {
    rdrandinf `z' X, wl(-0.005) wr(0.01) reps(10000) seed(50)
}
* These tests can undermine the local randomization interpretation.
* A small p-value is evidence to investigate, not a nuisance to remove.
