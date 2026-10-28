# Cattaneo, Idrobo, and Titiunik: practical exercises

These Stata 18 exercises accompany [the second presentation](../presentation/slides.pdf).
The presentation completes the Foundations theory before application A, then
completes all Extensions theory before applications B-F.

## Preparation

Install Stata 18 and Python 3. Run this once from this folder:

```sh
python fetch_sources.py
```

The datasets are already included in [data/](data/README.md). This command verifies
them and prepares the authors' original do-files and isolated Stata packages in
`cache/`. Missing data are restored from the authors' sources. Every input uses
a pinned Git revision and a SHA-256
checksum in [sources.lock.json](sources.lock.json). The standard-library Python
script changes no global Stata installation. Verify the cache offline with:

```sh
python fetch_sources.py --check
```

Open Stata, set this folder as its working directory, and run:

```stata
do "run_all.do"
```

To run one module, supply its number:

```stata
do "run_all.do" "1"
```

From another working directory, give the do-file's full path and this directory
as the second optional argument, after the module selector:

```stata
do "/path/to/rdd-seminar/cattaneo/exercises/run_all.do" "all" "/path/to/rdd-seminar/cattaneo/exercises"
```

Run the wrapper rather than a module by itself: it defines the paths, loads the
isolated package directory, opens result tables, and defines export helpers.
The scripts load the example data with `use ..., clear`, so save any current
dataset edits first. Paths containing spaces are supported when quoted.

## Modules and original code

| Worksheet | Module | Application | Original authors' do-file |
|---|---|---|---|
| A | `modules/01.do` | Turkish municipalities: sharp RD | [Foundations: polecon](https://github.com/rdpackages-replication/CIT_2020_CUP/blob/62bb142c65a9b1fb3b593d405a97ce1bec17aa50/CIT_2020_CUP_polecon.do) |
| B | `modules/02.do` | U.S. Senate: local randomization | [Extensions: locrand](https://github.com/rdpackages-replication/CIT_2024_CUP/blob/192a67d70ec095182fc1f08fccb90a7c20167f83/CIT_2024_CUP_locrand.do) |
| C | `modules/03.do` | Ser Pilo Paga: fuzzy RD | [Extensions: fuzzy](https://github.com/rdpackages-replication/CIT_2024_CUP/blob/192a67d70ec095182fc1f08fccb90a7c20167f83/CIT_2024_CUP_fuzzy.do) |
| D | `modules/04.do` | Academic probation: discrete GPA | [Extensions: discrete](https://github.com/rdpackages-replication/CIT_2024_CUP/blob/192a67d70ec095182fc1f08fccb90a7c20167f83/CIT_2024_CUP_discrete.do) |
| E | `modules/05.do` | Ser Pilo Paga: multiple cutoffs | [Extensions: multicutoff](https://github.com/rdpackages-replication/CIT_2024_CUP/blob/192a67d70ec095182fc1f08fccb90a7c20167f83/CIT_2024_CUP_multicutoff.do) |
| F | `modules/06.do` | Two-score SPP and geographic RD | [Extensions: nongeographic](https://github.com/rdpackages-replication/CIT_2024_CUP/blob/192a67d70ec095182fc1f08fccb90a7c20167f83/CIT_2024_CUP_multiscore-nongeo.do), [geographic](https://github.com/rdpackages-replication/CIT_2024_CUP/blob/192a67d70ec095182fc1f08fccb90a7c20167f83/CIT_2024_CUP_multiscore-geo.do) |

The original code is downloaded unmodified for comparison. The seminar modules
are separately authored teaching adaptations, with a smaller sequence of commands,
portable paths, labelled exports, and explicit interpretation cautions. They are
not full replications of every table in the original empirical papers.

## Outputs and important interpretation points

- `results/rd_results.csv` combines the saved module result files. Columns distinguish
  conventional estimates, bias-corrected estimates, robust standard errors and
  intervals, bandwidths, and effective sample sizes. Each module also has its own
  `rd_results_0N.csv`; the combined table is assembled from these published CSVs,
  so running one module retains the others' results even in a fresh Git clone
  with no intermediate DTA files.
- PNG, PDF, and editable Stata GPH graphs are saved in `results/`. Re-running
  replaces outputs for the selected modules. A complete run also replaces the
  combined CSV and `execution.log`.
- The repository includes the input datasets, figures, and CSV output. Downloaded
  comparison code, package files, logs, and intermediate DTA results stay local.
  See [data/README.md](data/README.md) for original source links and notices.
- `rdrobust` point estimates and RBC intervals have different centers. Do not
  silently combine the conventional estimate with an uncorrected interval.
- SPP estimates in proportions are multiplied by 100 in the exported RD table.
  Turkey and Senate outcomes already use percentage units. Probation uses GPA points.
- The SPP approximate balance protocol can select **no window**. The script then
  labels the book's fixed-window calculations as illustrations rather than accepted
  local randomization results. It does not lower the balance threshold to force selection.
- The probation controls at an exact original tie have transformed score -0.000005.
  The closest-score assignment imbalance and covariate checks require discussion.
- `reps(10000) seed(50)` fixes Monte Carlo randomization draws. This can take several
  minutes. A simulated p-value of zero is not a literal zero probability.
- `masspoints(adjust)` addresses practical bandwidth calculations, not all identification
  or inference issues caused by discrete scores. Geographic baseline intervals do
  not model spatial dependence.

Use [WORKSHEET.md](WORKSHEET.md) for tasks and interpretation questions.
