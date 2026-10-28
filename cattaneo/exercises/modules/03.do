* Extensions, Section 3: Ser Pilo Paga, Londono-Velez et al. (2020).
* The sample already satisfies the programme's academic eligibility rule.
* X1 increases towards poverty eligibility. D is receipt; Y is enrolment.
use "$CROOT/cache/CIT_2024_CUP_fuzzy.dta", clear
assert T == (X1>=0) if !missing(X1,T)
summarize X1 T D Y
foreach v in D Y {
    rdplot `v' X1, p(1) graph_options(xtitle("Distance to poverty eligibility cutoff") ///
        ytitle("`v' (proportion)") legend(off) graphregion(color(white)))
    save_graph spp_`v'
    rdrobust `v' X1, p(1) all
    save_rd, model(spp_`v') scale(100)
}
rdrobust Y X1, p(1) fuzzy(D) all
save_rd, model(spp_fuzzy) scale(100)
local h=e(h_l)
* A common-window ratio illustrates the Wald formula. Different optimal
* windows for separate reduced-form and first-stage fits need not match it.
rdrobust D X1, p(1) h(`h')
scalar first_stage=e(tau_cl)
rdrobust Y X1, p(1) h(`h')
display "Common-window conventional Wald ratio: " e(tau_cl)/first_stage
local covs icfes_female icfes_age icfes_urm icfes_stratum icfes_famsize
rdwinselect X1 `covs', approx seed(50)
local wl=r(w_left)
local wr=r(w_right)
if missing(`wl',`wr') {
    display as error "No window passes this selection protocol."
    display as text "The next estimates use the book's fixed window for illustration only."
    display as text "They do not establish a credible local randomization result."
    local wl=-0.13000107
    local wr=0.13000107
}
rdrandinf D X1, wl(`wl') wr(`wr') reps(10000) seed(50)
rdrandinf Y X1, wl(`wl') wr(`wr') reps(10000) seed(50)
* Local-randomization TSLS below uses a large-sample approximation.
rdrandinf Y X1, wl(`wl') wr(`wr') fuzzy(D tsls) seed(50)
rddensity X1
foreach z of local covs {
    rdrobust `z' X1, bwselect(cerrd)
    save_rd, model(spp_balance_`z')
}
