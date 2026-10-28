# Foundations and Extensions presentation

[rdd_cattaneo.pdf](rdd_cattaneo.pdf) is ready to teach. The editable main source
includes four files in teaching order:

1. `foundations_theory.tex`
2. `foundations_application.tex`
3. `extensions_theory.tex`
4. `extensions_applications.tex`

See the [course guide](../README.md) for source mapping and pacing, and the
[exercises](../exercises/README.md) for code and data preparation.

## Rebuild

From this directory:

```sh
python build.py
```

On Windows, `build.cmd` runs the same build. Requirements: Python 3 (standard
library), pdfLaTeX, Biber, Beamer, Latin Modern, and the LaTeX packages in the
source. The build uses saved CSVs to regenerate ten table fragments and runs
pdfLaTeX/Biber. It does not run Stata or download readings. All required figures
and CSV inputs are included. Build output goes to ignored `build/`.

If results change, rerun the relevant Stata module before rebuilding. Table
fragments are generated; edit the analysis rather than hand-editing the numbers.

`prepare_author_figures.py` refreshes theoretical diagrams from the supplied PDFs
in the repository's local `resources/` folder. It requires PyMuPDF and is optional
for compilation. Exact figure provenance is in `assets/sources.json`. Empirical
figures come from Stata and live in `../exercises/results/`.

Where the private local notes source is present, `python build.py --notes` also
builds it. That notes folder is excluded from Git and absent from public clones.
