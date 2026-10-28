# Mixtape / Remix practical worksheet

This 20-minute exercise follows the sharp and fuzzy RD presentation. It uses
Cunningham's 214,558-observation teaching extract of Hansen (2015), rather than
the original paper's full replication sample.

Set `exercises/` as the working directory in Stata 18 and run:

```stata
do "run_all.do"
```

The wrapper runs [modules/01.do](modules/01.do). The module contains the complete
worked analysis. See [README.md](README.md) for initial downloads and output files.

## A. Assignment and the research question (3 minutes)

1. Identify the unit, BAC score, 0.08 cutoff, treatment contrast, and recidivism outcome.
2. Explain why treatment effects at the cutoff need not apply to all drivers.
3. Distinguish a percentage-point change in recidivism from a percentage change.

## B. Support and credibility (5 minutes)

1. Inspect the BAC histogram and density diagnostic. What could precise sorting
   or recording practices imply for identification?
2. Explain the mass-points notice. What does `masspoints(adjust)` address, and
   which concerns about discrete support remain?
3. Read the covariate plots and Table 6.6. Do the magnitudes and intervals support
   comparable predetermined characteristics near 0.08? Does non-rejection prove balance?

## C. Estimation and inference (7 minutes)

1. Compare the linear and quadratic outcome plots and OLS estimates in Table 6.7.
   How do the score interactions allow different relationships on the two sides?
2. In Table 6.8, compare local constant, linear, and quadratic fits. Identify their
   bandwidths and effective sample sizes.
3. Distinguish the bias-corrected estimate and RBC standard error from conventional
   regression output. Explain the interval reported in the presentation.
4. Discuss why a larger overall dataset need not eliminate approximation bias or
   provide many distinct BAC values arbitrarily close to the threshold.

## D. Interpretation (5 minutes)

Write a short conclusion stating the local treatment contrast, effect magnitude,
uncertainty, and main identifying assumptions. Discuss whether the observed
effect of crossing the sanction threshold can separately identify each mechanism
within the sanction package.

Results appear in `results/` as CSV tables and PNG/GPH graphs. Re-running replaces
the selected exercise's saved outputs. The input dataset is included in `data/`,
and the execution log remains local.
