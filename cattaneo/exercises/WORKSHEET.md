# RDD practical worksheets

Use Stata 18 and complete the setup in [README.md](README.md) before class.
Run each module from `run_all.do`. All output belongs to this Cattaneo track.
The completed teaching scripts provide commands to study and modify. Write your
interpretation before comparing it with the slides or discussing the output.

## A. Foundations application: Turkish municipal elections (35-45 minutes)

Run `do "run_all.do" "1"` after completing the Foundations theory.

1. Define the unit, score, cutoff, treatment, outcome, and causal estimand. Check
   which variables use percentages and which use proportions.
2. Examine the raw scatter and full-sample mean comparison. Explain why the latter
   can have a different sign from the local effect without a contradiction.
3. Compare the evenly spaced and quantile spaced plots. What does each point
   represent? Which plot regions have more observations per unit of score?
4. In the interacted OLS fit, write the fitted line on each side. Which coefficient
   estimates the cutoff jump? What restriction would omitting `TX` impose?
5. Compare uniform and triangular weights at bandwidth 20. Separate the role of
   weights from the role of sample restriction.
6. Read the MSE and CER results. Identify the conventional estimate, corrected
   estimate, RBC standard error, confidence interval, and effective sample sizes.
   Explain why an interval can be asymmetric around the conventional estimate.
7. Evaluate the three predetermined covariates. Would high-school completion for
   men measured in 2000 automatically be a valid pre-treatment placebo? Explain.
8. Read the density and placebo tests. Why do the placebo analyses stay on one
   side of zero? Does a nonsignificant test establish continuity?
9. Compare bandwidth sensitivity, local quadratic, and donut estimates. Explain
   what happens to the bias bandwidth. Does the donut's smaller p-value justify
   replacing the primary estimate?
10. Write a four-sentence result: treatment contrast, magnitude, uncertainty, and
    the population/policy margin to which it applies.

## B. Extensions application: U.S. Senate elections (25-35 minutes)

Run `do "run_all.do" "2"` after completing all Extensions theory.

1. Define `X`, `T`, and `Y`. Does `t+2` mean two years after the election?
2. Compare the continuity estimate with the selected-window difference in means.
   State each estimand and its assumptions. Must these numerical estimates agree?
3. Explain the assignment distribution behind the default Fisherian test. Which
   count does complete randomization hold fixed?
4. Inspect the sequence of balance tests and the selected window. What would the
   procedure do if the smallest window failed? Why must the outcome be excluded?
5. State the Fisherian sharp null and the zero average-effect null. Explain why
   rejecting one is not the same inferential statement as rejecting the other.
6. Interpret a displayed Monte Carlo p-value of zero with 10,000 draws. How would
   increasing the draws or changing the seed affect simulation uncertainty?
7. Compare windows 0.6934, 0.7652, 1, and 2.5. Discuss changing precision, changing
   populations, and changing plausibility of local randomization.
8. Optional: invert a grid of constant-effect hypotheses using the commented `ci()`
   command. State what model the resulting interval assumes.

## C. Extensions application: Ser Pilo Paga fuzzy RD (30-40 minutes)

Run `do "run_all.do" "3"`.

1. Explain how the supplied sample reduces a two-score eligibility rule to one score.
   Which direction of `X1` means greater eligibility?
2. Distinguish eligibility `T`, receipt `D`, and enrolment `Y`. Define first stage,
   reduced form, and receipt LATE.
3. Compare the two graphs. Why is the reduced form meaningful even before imposing
   exclusion and monotonicity for the receipt effect?
4. Compute the ratio using the common-window fits in the code. Why does dividing
   the separately optimized table rows not give the joint fuzzy estimate exactly?
5. Discuss the exclusion restriction for this policy. Could assignment change
   enrolment through a channel other than actual subsidy receipt?
6. Inspect `rdwinselect`. If it returns no accepted window, explain why the following
   book-window calculation remains an illustration under that protocol.
7. Interpret the covariate and density evidence without treating non-rejection as
   proof. What would a weak first stage change about inference?
8. State precisely which students the receipt LATE concerns. Can it be generalized
   to all Colombian students or all subsidy recipients?

## D. Extensions application: academic probation (25-35 minutes)

Run `do "run_all.do" "4"`.

1. Count units and distinct scores. Explain why these are different measures of
   information for local approximation.
2. Inspect the nearest score groups and the exact tie rule. Explain the authors'
   -0.000005 convention and why it is not evidence of a genuinely continuous score.
3. Compare the continuity and score-clustered estimates. What does clustering change?
   What identification problem does it leave unresolved?
4. Interpret the closest-window difference and randomization p-value. Compare the
   208 controls and 67 treated under the equal-probability count model.
5. Which covariate checks raise concerns? Why would adjusting a window or threshold
   merely to obtain a favorable test result be problematic?
6. Next-term GPA is missing for some students who leave. Explain why conditioning
   on continuing can compare different populations across treatment states.
7. Write a conclusion that distinguishes a positive observed GPA discontinuity
   from a causal effect for a stable population of students.

## E. Extensions application: multiple poverty cutoffs (20-30 minutes)

Run `do "run_all.do" "5"`.

1. Map each cutoff to its area and explain the reversed sign of the wealth score.
2. Compare cutoff-specific magnitudes and intervals. Does a significant estimate
   in one group and a nonsignificant estimate in another establish a difference?
3. Interpret `rdmc`'s weights. Why are they not generally the full-sample group shares?
4. Compare cutoff-specific aggregation with direct normalized pooling. State the
   assumptions behind an average cutoff interpretation.
5. Explain why these outcome discontinuities measure eligibility effects rather
   than treatment receipt LATEs.
6. Describe the additional constant-bias assumption needed to extrapolate a lower
   cutoff group's effect above its cutoff. This exercise does not estimate that model.

## F. Extensions application: multiple scores and geography (30-40 minutes)

Run `do "run_all.do" "6"`. The two-score dataset is larger, so allow extra time.

1. Write SPP's two-dimensional eligibility rule. Label the treated quadrant and
   both boundary segments. What changes at the corner compared with a single segment?
2. Compare effects at (0,0), (30,0), and (0,50), with coordinates ordered as poverty
   eligibility score and exam score. Why are these different local populations?
3. Explain why rescaling one score changes Euclidean distance and the observations
   used in a finite-bandwidth fit.
4. In the geographic data, identify the media markets, units, treatment contrast,
   and outcome. Explain why a boundary may change several relevant conditions.
5. Examine the distribution of distance to the middle boundary point. What do the
   approximately 0.31 and 0.42 km gaps imply for a boundary interpretation?
6. Compare point-specific chordal distances with distance to the whole boundary.
   Why do they define different estimands? Would Euclidean distance in raw degrees
   necessarily yield the same finite-sample estimates?
7. Discuss spatial dependence, residential sorting, and advertising spillovers.
   Which of these does a smooth-looking map or wide RBC interval resolve?
8. Interpret the geographic intervals. Do they demonstrate an effect of exactly zero?
