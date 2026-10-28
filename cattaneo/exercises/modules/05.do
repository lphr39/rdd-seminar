* Extensions, Section 5.1: SPP eligibility at three area-specific cutoffs.
use "$CROOT/data/CIT_2024_CUP_multicutoff.dta", clear
tabulate sisben_area cutoff
rdmc spadies_any sisben_score, c(cutoff)
ereturn list
matrix list e(weights)
matrix list e(coefs)
* Export each cutoff separately for a clearly labelled slide table.
foreach c in -57.21 -56.32 -40.75 {
    rdrobust spadies_any sisben_score if cutoff==`c', c(`c') p(1) all
    save_rd, model(cutoff_`c') scale(100)
}
generate double xnorm=sisben_score-cutoff
rdplot spadies_any xnorm, p(1) graph_options(xtitle("Score minus own area cutoff") ///
    ytitle("Immediate enrolment (proportion)") legend(off) graphregion(color(white)))
save_graph multicutoff_pooled
rdrobust spadies_any xnorm, p(1) all
save_rd, model(cutoff_normalized_pool) scale(100)
* Outcome is enrolment; the discontinuity is an eligibility effect.
* No treatment-receipt variable is present in this multi-cutoff dataset.
