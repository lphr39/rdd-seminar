# Regression Discontinuity Designs

Seminar materials by Luis P. de la Horra, Universidad de Valladolid. Two independent English teaching tracks share this repository. Each has its own presentation, editable LaTeX sources, Stata exercises, and saved empirical results.

| Track | Presentation | Exercises | Scope |
|---|---|---|---|
| **Mixtape / Remix** | [PDF](mixtape/presentation/rdd_seminar.pdf), [LaTeX](mixtape/presentation/rdd_seminar.tex) | [Hansen do-file](mixtape/exercises/hansen_seminar.do), [instructions](mixtape/exercises/README.md) | Original 50-55 minute presentation and 20-minute Hansen exercise |
| **Cattaneo, Idrobo, and Titiunik** | [PDF](cattaneo/presentation/rdd_cattaneo.pdf), [LaTeX](cattaneo/presentation/rdd_cattaneo.tex) | [Stata wrapper](cattaneo/exercises/run_all.do), [worksheets](cattaneo/exercises/WORKSHEET.md), [instructions](cattaneo/exercises/README.md) | Longer course based on both Foundations (2020) and Extensions (2024) |

## Organization

```text
mixtape/
  presentation/       original deck, bibliography, included figures, build script
  exercises/          Hansen exercise and hansen_results/
cattaneo/
  presentation/       second deck, bibliography, theoretical figures, build scripts
  exercises/          six Stata modules, worksheets, source lock, results/
```

Study notes, downloaded readings, data/package caches, execution logs, and build or review files are excluded from Git. The notes remain available locally.

The former `presentation/` repository paths now live under `mixtape/`. Relative paths in the original deck and table builder have been updated. Its content and the Hansen exercise remain available as a separate track.

## Cattaneo track: theory before practice

The deck has 108 teaching slides followed by two reference pages. It follows the manuals' theoretical progression, with empirical examples at the end of each part:

1. **Foundations theory:** sharp RD and its local effect, RD plots, local polynomial estimation, inference, covariates, clustering, validation and falsification.
2. **Foundations application:** Turkish municipal elections and women's education.
3. **Extensions theory:** local randomization, fuzzy RD, discrete scores, multiple cutoffs, multiple scores and geographic boundaries.
4. **Extensions applications:** U.S. Senate elections, Ser Pilo Paga, academic probation, and media-market boundaries.

See the [teaching guide](cattaneo/README.md) for source mapping, slide ranges, and pacing. This is a course-length resource that can span several sessions. All empirical tables use saved output from the accompanying Stata code.

From `cattaneo/exercises`, prepare the pinned data and isolated Stata packages:

```sh
python fetch_sources.py
```

Then in Stata 18, with that directory as the working directory:

```stata
do "run_all.do"
```

Use `do "run_all.do" "1"` through `"6"` for individual modules. The full analysis can take several minutes, particularly the randomization simulations. PDFs, graphs, and CSV tables are included for teaching without rerunning Stata.

## Rebuilding the presentations

Both tracks require Python 3 and a LaTeX distribution with pdfLaTeX, Biber, Beamer, Latin Modern, and the packages declared in the sources. Python build scripts use the standard library. All figures needed for compilation are included.

- From `mixtape/presentation` on Windows: `build.cmd`.
- From `cattaneo/presentation`: `python build.py` (or `build.cmd` on Windows).

Rebuilding uses saved exercise CSVs and does not rerun empirical analysis or fetch readings. See each presentation's README for platform-independent commands and details. Optional figure refresh scripts require additional packages and local source readings.

## Readings and attribution

- Cunningham, [Causal Inference: The Remix](https://mixtape.scunning.com/), Chapter 6 and the fuzzy RD discussion in Chapter 7.
- Cattaneo, Idrobo, and Titiunik (2020), [A Practical Introduction to Regression Discontinuity Designs: Foundations](https://doi.org/10.1017/9781108684606).
- Cattaneo, Idrobo, and Titiunik (2024), [A Practical Introduction to Regression Discontinuity Designs: Extensions](https://doi.org/10.1017/9781009441896).
- Authors' [official replication index](https://rdpackages.github.io/replication/).

See [SOURCES.md](SOURCES.md) for empirical studies, figure provenance, and source-code attribution. Each track has its own bibliography. Third-party material retains its authors' applicable terms.
