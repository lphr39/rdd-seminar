# Mixtape / Remix presentation

This is the original Cunningham-based English seminar: 45 main slides, ten supplementary slides, and four reference pages. The presentation is designed for 50-55 minutes plus a 20-minute Hansen exercise.

- [Presentation PDF](rdd_seminar.pdf)
- [Editable LaTeX](rdd_seminar.tex)
- [Bibliography](references.bib)
- [Hansen exercise and instructions](../exercises/README.md)
- [Figure provenance](assets/sources.json)

The empirical work now lives in the sibling `../exercises/` directory. Its saved figures and tables remain separate from the Cattaneo track. Private notes remain local under `notes/` and are excluded from Git.

## Build

From this directory on Windows:

```powershell
.\build.cmd
```

On other systems:

```sh
mkdir -p build
python3 build_tables.py
pdflatex -interaction=nonstopmode -halt-on-error -output-directory=build rdd_seminar.tex
biber --input-directory=build --output-directory=build rdd_seminar
pdflatex -interaction=nonstopmode -halt-on-error -output-directory=build rdd_seminar.tex
pdflatex -interaction=nonstopmode -halt-on-error -output-directory=build rdd_seminar.tex
cp build/rdd_seminar.pdf rdd_seminar.pdf
```

The build regenerates table fragments from the sibling Hansen CSV files and compiles the deck. It does not run Stata. All required figures are included. Python 3, pdfLaTeX, Biber, Beamer, Latin Modern, and the source's declared LaTeX packages are required. If the analysis changes, rerun the Hansen do-file first.

The original local preparation plan, figure refresh script, study notes, and scratch files are retained locally. The old package ZIP is a historical snapshot with the former paths and should not be used for the reorganized repository.
