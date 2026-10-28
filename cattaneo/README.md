# Cattaneo, Idrobo, and Titiunik seminar

The second presentation follows the conceptual progression of *Foundations*
(2020) and *Extensions* (2024). Theory comes first in each part; its empirical
examples follow at the end.

- [Presentation PDF](presentation/slides.pdf)
- [Editable main source](presentation/slides.tex)
- [Presentation and build instructions](presentation/README.md)
- [Stata entry point](exercises/run_all.do)
- [Exercise setup and runnable code](exercises/README.md)
- [Dataset sources and downloads](exercises/data/README.md)
- [Student worksheets](exercises/WORKSHEET.md)
- [Saved exercise figures and tables](exercises/results/)
- [Bibliography](presentation/references.bib)
- [Sources and attribution](../SOURCES.md)
- [Pinned source and package revisions](exercises/sources.lock.json)

## Sequence and source mapping

| Slides | Teaching block | Manual structure |
|---|---|---|
| 1-2 | Title and route through the course | Both manuals |
| 3-41 | Foundations theory | Sections 1-2: sharp RD; 3: plots; 4.1-4.3: estimation and inference; 4.4: covariates and clustering; 5: validation |
| 42-53 | Foundations application | Meyersson (2014), Turkish municipal elections; module 1 and worksheet A |
| 54-86 | Extensions theory | Section 2: local randomization; 3: fuzzy RD; 4: discrete scores; 5: multiple cutoffs and multiple scores |
| 87-108 | Extensions applications | Senate, SPP, probation, and media-market geography; modules 2-6 and worksheets B-F |
| 109-110 | References | Manuals and original studies |

This preserves the authors' theory order while moving empirical illustrations
to the end of the corresponding part. The seminar is an original teaching
synthesis rather than a page-by-page reproduction of the books.

## Suggested pacing

Allow roughly **5-6 hours of teaching and discussion**, plus **2-3 hours of
selected practical work**. Adjust for participants' experience with potential
outcomes, IV, and nonparametric estimation.

A four-session sequence, with lab time scheduled separately:

1. **90 minutes:** Foundations sharp RD, plots, and local estimation.
2. **90 minutes:** Foundations inference and validation, then the Turkish application.
3. **90 minutes:** Extensions theory in the book's order.
4. **90 minutes:** Extensions applications and interpretation discussion.

For a deeper course, split the third session into two, giving local randomization
and fuzzy RD more time. Worksheet A fits a first lab; B-C suit a second lab;
D-F can form optional labs or take-home work.

## Use and rebuild

Verify the included data and prepare isolated packages with `python fetch_sources.py` from
`exercises/`. In Stata 18, with that directory as the working directory, run
`do "run_all.do"`, or select one module with `do "run_all.do" "1"` through `"6"`.
Build the slides with `python build.py` from `presentation/`, or `build.cmd` on
Windows. The same entry-point names are used in the Mixtape track.

The examples explicitly discuss uncertainty, different estimands, a failed SPP
window-selection protocol, the probation tie rule and outcome selection, pooling,
and geographic support and dependence. Detailed study notes and an instructor
key remain local under `notes/`, which is explicitly gitignored. The original
teaching datasets are included under `exercises/data/`, with source links and
checksums. Reading PDFs, downloaded comparison code, package files, logs, and
QA files stay outside the public repository.
