* Extensions, Section 2: Senate elections, Cattaneo et al. (2015).
use "$CROOT/data/CIT_2024_CUP_locrand.dta", clear
assert T == (X>=0) if !missing(X,T)
summarize X Y T
rdplot Y X, p(1) graph_options(xtitle("Democratic margin at election t (pp)") ///
    ytitle("Democratic vote share at t+2 (%)") legend(off) graphregion(color(white)))
save_graph senate_plot
rdrobust Y X, p(1) all
save_rd, model(senate_continuity)

* Fisher's sharp null and a fixed-margins assignment mechanism.
rdrandinf Y X, wl(-2.5) wr(2.5) reps(10000) seed(50)
return list
local covs presdemvoteshlag1 demvoteshlag1 demvoteshlag2 ///
    demwinprv1 demwinprv2 dmidterm dpresdem dopen
* Like the authors, use approximate balance tests for faster selection.
rdwinselect X `covs', wobs(2) nwindows(50) approx seed(50)
return list
* Extract the selected window, rather than silently hard-coding a book value.
local wl=r(w_left)
local wr=r(w_right)
display as result "Selected window: [`wl', `wr']"
rdrandinf Y X, wl(`wl') wr(`wr') reps(10000) seed(50)
return list
matrix LR = (r(obs_stat),r(randpval),r(asy_pval),`wl',`wr')
matrix colnames LR = estimate fisher_p asymptotic_p window_left window_right
preserve
clear
svmat double LR, names(col)
export delimited using "$COUT/senate_randomization.csv", replace
restore
* Constant-effect inversion is optional: hundreds of randomization tests.
* rdrandinf Y X, wl(`wl') wr(`wr') seed(50) ci(0.05 -20(0.1)20)
foreach w in 0.6934 0.7652 1 2.5 {
    rdrandinf Y X, wl(-`w') wr(`w') reps(10000) seed(50)
}
