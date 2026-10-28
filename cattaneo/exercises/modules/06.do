* Extensions, Section 5.2: multiple scores, then geographic boundaries.
use "$CROOT/cache/CIT_2024_CUP_multiscore-nongeo.dta", clear
assert tr==(running_sisben>=0 & running_saber11>=0) ///
    if !missing(running_sisben,running_saber11,tr)
preserve
set seed 50
sample 2
twoway (scatter running_sisben running_saber11 if tr==0, msize(tiny) mcolor(navy%25)) ///
    (scatter running_sisben running_saber11 if tr==1, msize(tiny) mcolor(maroon%25)), ///
    xline(0) yline(0) xtitle("Exam score minus cutoff") ///
    ytitle("Poverty eligibility score minus cutoff") ///
    legend(order(1 "Ineligible" 2 "Eligible")) graphregion(color(white))
save_graph spp_two_scores
restore
* Signed Euclidean distance to each boundary point, in the authors' units.
foreach pair in "0 0" "30 0" "0 50" {
    tokenize `pair'
    generate double dist=sqrt((running_sisben-`1')^2+(running_saber11-`2')^2)*(2*tr-1)
    rdrobust spadies_any dist, p(1) all
    save_rd, model(boundary_`1'_`2') scale(100)
    drop dist
}

* Keele and Titiunik (2015), New Jersey media-market boundary.
use "$CROOT/cache/CIT_2024_CUP_multiscore-geo.dta", clear
twoway (scatter longitude latitude if treated==0, msize(tiny) mcolor(navy%30)) ///
    (scatter longitude latitude if treated==1, msize(tiny) mcolor(maroon%30)) ///
    (line long_border lat_border, lcolor(black)), ///
    xtitle("Latitude") ytitle("Longitude") ///
    legend(order(1 "New York DMA" 2 "Philadelphia DMA" 3 "Boundary")) ///
    graphregion(color(white))
save_graph geographic_boundary
foreach v in dist1 dist2 dist3 perp_dist {
    replace `v'=-`v' if treated==0
    rdrobust e2008g `v', p(1) all
    save_rd, model(geographic_`v') scale(100)
}
* Point b2: inspect the gap in support before calling an estimate local.
summarize dist2 if treated==1
summarize dist2 if treated==0
histogram dist2, xline(0) frequency xtitle("Signed chordal distance to b2 (km)") ///
    ytitle("Registered voters") graphregion(color(white))
save_graph geographic_distance
* Raw latitude/longitude Euclidean distances differ from chordal kilometres.
* Spatial dependence and other policies at a boundary require extra analysis.
