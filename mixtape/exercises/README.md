# Hansen exercise for the Mixtape / Remix seminar

Use Stata 18. Set this directory as the working directory, then run the full file:

```stata
do "hansen_seminar.do"
```

The do-file can also locate its folder through a file-selection dialog. For
scripted execution from another working directory, supply the exercise folder:

```stata
do "/path/to/mixtape/exercises/hansen_seminar.do" "/path/to/mixtape/exercises"
```

The exercise uses Cunningham's 214,558-observation teaching extract of Hansen
(2015), rather than the original paper's full replication sample. On first run
it downloads the data and installs missing `rdrobust`, `rddensity`, `lpdensity`,
and `cmogram` commands. Internet access is needed for that preparation. Later
runs use cached data and installed packages.

PNG figures, editable Stata graphs, CSV tables, the cached dataset, and execution
log go into `hansen_results/`. Re-running replaces outputs with the same names.
The public repository includes figures and CSVs; data and logs stay local.

Repeated BAC scores generate a mass-points notice. The code retains
`masspoints(adjust)`, which adjusts practical bandwidth calculations without
resolving every issue arising from a discrete running variable.

This do-file's analysis is unchanged by the repository reorganization. The
[presentation](../presentation/rdd_seminar.pdf) now reads its figures and tables
from this sibling directory.
