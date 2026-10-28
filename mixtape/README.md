# Mixtape / Remix seminar

This is the original English RDD seminar by Luis P. de la Horra, Universidad
de Valladolid. It follows Cunningham's *Causal Inference: The Remix*, Chapter 6
and the fuzzy RD discussion in Chapter 7, with a Stata exercise using the
teaching extract of Hansen (2015).

- [Presentation PDF](presentation/slides.pdf)
- [Editable LaTeX source](presentation/slides.tex)
- [Presentation and build instructions](presentation/README.md)
- [Stata entry point](exercises/run_all.do)
- [Practical worksheet](exercises/WORKSHEET.md)
- [Exercise setup and instructions](exercises/README.md)
- [Dataset and source notice](exercises/data/README.md)
- [Saved exercise figures and tables](exercises/results/)
- [Bibliography](presentation/references.bib)
- [Sources and attribution](../SOURCES.md)

## Sequence and pacing

Allow **50-55 minutes for the presentation**, followed by a **20-minute exercise**.
The PDF has 45 main slides, ten supplementary slides, and four reference pages.

1. RD intuition and assignment rules.
2. Sharp RD identification through continuity.
3. Estimation and design diagnostics.
4. Fuzzy RD and instrumental variables.
5. DUI sanctions and recidivism using Hansen's teaching extract.

## Use and rebuild

The PDF and saved results are ready to use. To run the exercise, open Stata 18,
set `exercises/` as the working directory, and run `do "run_all.do"`.
The Hansen teaching dataset is included. Internet access is needed only if
required Stata commands have not yet been installed, or a missing input must be restored.

To rebuild the slides, run `python build.py` from `presentation/`, or `build.cmd`
on Windows. Python 3,
pdfLaTeX, Biber, and the source's declared LaTeX packages are required. The
presentation README also gives commands for other systems. Rebuilding reads
saved exercise results and does not rerun Stata.

Private study notes remain local in `notes/`, excluded from Git.
This track is independent of the [longer Cattaneo track](../cattaneo/README.md).
