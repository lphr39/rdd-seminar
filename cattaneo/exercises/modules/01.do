* Foundations, Sections 2-5: Meyersson (2014), Turkish municipalities.
* Authors' original: cache/CIT_2020_CUP_polecon.do
* Y is female high-school completion in percentage points, not a proportion.
use "$CROOT/cache/CIT_2020_CUP_polecon.dta", clear
assert T == (X>=0) if !missing(X,T)
summarize Y X T
ttest Y, by(T)

* Section 3: plotting choices are separate from estimation choices.
twoway scatter Y X, msize(tiny) mcolor(navy%35) xline(0) ///
    xtitle("Islamic margin of victory in 1994 (pp)") ///
    ytitle("Female high-school completion in 2000 (%)") legend(off) ///
    graphregion(color(white))
save_graph turkey_raw
rdplot Y X, p(1) nbins(20 20) binselect(es) ///
    graph_options(xtitle("Islamic margin of victory (pp)") ///
    ytitle("Female high-school completion (%)") legend(off) graphregion(color(white)))
save_graph turkey_bins_es
rdplot Y X, p(1) nbins(20 20) binselect(qs) ///
    graph_options(xtitle("Islamic margin of victory (pp)") ///
    ytitle("Female high-school completion (%)") legend(off) graphregion(color(white)))
save_graph turkey_bins_qs

* Section 4: fixed-window OLS illustrates separate intercepts and slopes.
generate double TX = T*X
regress Y T X TX if abs(X)<=20, vce(robust)
rdrobust Y X, p(1) kernel(uniform) h(20) all
save_rd, model(turkey_uniform20)
rdrobust Y X, p(1) kernel(triangular) h(20) all
save_rd, model(turkey_triangular20)
rdbwselect Y X, p(1) kernel(triangular) all
rdrobust Y X, p(1) kernel(triangular) bwselect(mserd) all
save_rd, model(turkey_mserd)
local hl=e(h_l)
local hr=e(h_r)
local bl=e(b_l)
local br=e(b_r)
rdplot Y X if X>=-`hl' & X<=`hr', p(1) h(`hl' `hr') ///
    kernel(triangular) graph_options(xtitle("Islamic margin of victory (pp)") ///
    ytitle("Female high-school completion (%)") legend(off) graphregion(color(white)))
save_graph turkey_local
rdrobust Y X, p(1) kernel(triangular) bwselect(cerrd) all
save_rd, model(turkey_cerrd)
rdrobust Y X, p(2) kernel(triangular) all
save_rd, model(turkey_quadratic)
forvalues k=1/3 {
    local factor = 0.5*`k'
    rdrobust Y X, p(1) h(`=`hl'*`factor'' `=`hr'*`factor'') ///
        b(`=`bl'*`factor'' `=`br'*`factor'') all
    save_rd, model(turkey_bandwidth_`k')
}

* Section 5: predetermined variables only. Contemporaneous covariates
* in the full authors' dataset are not automatically valid placebo outcomes.
foreach z in lpop1994 partycount i89 {
    rdrobust `z' X, p(1) bwselect(cerrd) all
    save_rd, model(balance_`z')
}
rddensity X, plot
save_graph turkey_density
scalar density_p = e(pv_q)
* Non-overlapping placebo fits stay on a single side of the true cutoff.
rdrobust Y X if X<0, c(-20) p(1) h(10) all
save_rd, model(placebo_minus20)
rdrobust Y X if X>=0, c(20) p(1) h(10) all
save_rd, model(placebo_plus20)
rdrobust Y X if abs(X)>0.5, p(1) all
save_rd, model(turkey_donut)
* Removing a donut increases extrapolation. It changes the analysis.
