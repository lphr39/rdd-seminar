# Hansen exercise for the Mixtape / Remix seminar

Use Stata 18. Set this directory as the working directory, then run the wrapper:

```stata
do "run_all.do"
```

This track has one module, so `do "run_all.do" "1"` runs the same exercise.
From another working directory, supply the module selector and exercise folder:

```stata
do "/path/to/mixtape/exercises/run_all.do" "all" "/path/to/mixtape/exercises"
```

The exercise uses Cunningham's 214,558-observation teaching extract of Hansen
(2015), rather than the original paper's full replication sample. The dataset
is included in [data/](data/README.md), with Cunningham's upstream MIT notice.
The script installs missing `rdrobust`, `rddensity`, `lpdensity`, and `cmogram`
commands. Internet access is needed for missing commands or to restore a
missing dataset; a prepared installation can run the exercise offline.

Optionally verify the supplied input from this directory:

```sh
python fetch_sources.py --check
```

The wrapper runs [modules/01.do](modules/01.do). Save any unsaved dataset edits
before running it: the module loads its own dataset. The practice questions are
in [WORKSHEET.md](WORKSHEET.md).

PNG figures, editable Stata graphs, CSV tables, and `execution.log` go into
`results/`. The input dataset stays in `data/`. Re-running replaces outputs
with the same names. The dataset, figures, and CSVs are included in the repository;
execution logs and intermediate build files stay local.

Repeated BAC scores generate a mass-points notice. The code retains
`masspoints(adjust)`, which adjusts practical bandwidth calculations without
resolving every issue arising from a discrete running variable.

This do-file's analysis is unchanged by the repository reorganization. The
[presentation](../presentation/slides.pdf) now reads its figures and tables
from this sibling directory.
