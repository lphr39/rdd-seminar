# Regression Discontinuity Designs

Seminar materials by Luis P. de la Horra, Universidad de Valladolid. The seminar covers sharp and fuzzy regression discontinuity designs, followed by a Stata exercise on DUI sanctions and recidivism using a teaching extract of Hansen (2015).

The presentation is designed for 50–55 minutes plus a 20-minute exercise. It contains 45 main slides, 10 supplementary slides, and four reference pages. All teaching materials are in English.

- [Presentation (PDF)](presentation/rdd_seminar.pdf)
- [Editable presentation (LaTeX)](presentation/rdd_seminar.tex)
- [Hansen exercise (Stata do-file)](presentation/practical/hansen_seminar.do)
- [Saved exercise figures and tables](presentation/practical/hansen_results/)
- [Bibliography](presentation/references.bib)
- [Sources and attribution](SOURCES.md)

## Run the Stata exercise

Use Stata 18 or later. Set the working directory to `presentation/practical`, then run the entire do-file:

```stata
do "hansen_seminar.do"
```

If the working directory differs, the script asks you to select the do-file so it can locate the exercise folder. For scripted execution, pass that folder as the optional argument:

```stata
do "/path/to/rdd-seminar/presentation/practical/hansen_seminar.do" "/path/to/rdd-seminar/presentation/practical"
```

On the first run, the script downloads [Scott Cunningham's public teaching extract](https://raw.githubusercontent.com/scunning1975/causal-inference-class/master/hansen_dwi.dta) and installs missing commands: `rdrobust`, `rddensity`, `lpdensity`, and `cmogram`. Internet access is required for those downloads. Subsequent runs use the cached dataset and installed commands. Stata itself is required separately.

The extract has 214,558 observations. This exercise reproduces the chapter's analysis of that extract, rather than the full original paper. All generated files go into `presentation/practical/hansen_results/`; rerunning replaces outputs with the same names. The repository includes saved PNG figures, editable Stata graphs, and CSV tables. The cached dataset and execution logs stay local.

The running variable contains repeated BAC values. A `Mass points detected in the running variable` message is a diagnostic notice, and the script retains `masspoints(adjust)`. The adjustment does not resolve every inference issue arising from discrete scores.

## Build the presentation

The PDF is ready to present. To rebuild it, install Python 3 (standard library only) and a LaTeX distribution with pdfLaTeX, Biber, Beamer, Latin Modern, and the packages declared in the source. All required figures and exercise tables are included, so rebuilding the presentation does not require running Stata or downloading the resource PDFs.

On Windows, run from the `presentation` folder:

```powershell
.\build.cmd
```

On other systems, run from the same folder:

```sh
mkdir -p build
python3 build_tables.py
pdflatex -interaction=nonstopmode -halt-on-error -output-directory=build rdd_seminar.tex
biber --input-directory=build --output-directory=build rdd_seminar
pdflatex -interaction=nonstopmode -halt-on-error -output-directory=build rdd_seminar.tex
pdflatex -interaction=nonstopmode -halt-on-error -output-directory=build rdd_seminar.tex
cp build/rdd_seminar.pdf rdd_seminar.pdf
```

If the exercise analysis changes, rerun the Stata do-file before rebuilding. The build regenerates the slide tables from the saved CSV files and compiles the slides; it does not rerun the empirical analysis.

## Readings

The seminar follows [Scott Cunningham's *Causal Inference: The Remix*](https://mixtape.scunning.com/), Chapter 6 and the fuzzy RD subsection of Chapter 7. Further reading:

- Cattaneo, Idrobo, and Titiunik (2020), [*A Practical Introduction to Regression Discontinuity Designs: Foundations*](https://doi.org/10.1017/9781108684606).
- Cattaneo, Idrobo, and Titiunik (2024), [*A Practical Introduction to Regression Discontinuity Designs: Extensions*](https://doi.org/10.1017/9781009441896).
- Hansen (2015), [“Punishment and Deterrence: Evidence from Drunk Driving”](https://doi.org/10.1257/aer.20130189).

Original studies are cited on the relevant slides. See [SOURCES.md](SOURCES.md) and the figure provenance file for attribution.
