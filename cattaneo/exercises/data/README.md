# Authors' companion datasets

All seven companion datasets are included here, unchanged from the authors'
files. Their versions and SHA-256 checksums are pinned in
[../sources.lock.json](../sources.lock.json).

| Module | Dataset | Authors' download |
|---|---|---|
| 1 | Turkish municipalities | [CIT_2020_CUP_polecon.dta](https://raw.githubusercontent.com/rdpackages-replication/CIT_2020_CUP/62bb142c65a9b1fb3b593d405a97ce1bec17aa50/CIT_2020_CUP_polecon.dta) |
| 2 | Senate elections | [CIT_2024_CUP_locrand.dta](https://raw.githubusercontent.com/rdpackages-replication/CIT_2024_CUP/192a67d70ec095182fc1f08fccb90a7c20167f83/CIT_2024_CUP_locrand.dta) |
| 3 | SPP fuzzy RD | [CIT_2024_CUP_fuzzy.dta](https://raw.githubusercontent.com/rdpackages-replication/CIT_2024_CUP/192a67d70ec095182fc1f08fccb90a7c20167f83/CIT_2024_CUP_fuzzy.dta) |
| 4 | Academic probation | [CIT_2024_CUP_discrete.dta](https://raw.githubusercontent.com/rdpackages-replication/CIT_2024_CUP/192a67d70ec095182fc1f08fccb90a7c20167f83/CIT_2024_CUP_discrete.dta) |
| 5 | SPP multiple cutoffs | [CIT_2024_CUP_multicutoff.dta](https://raw.githubusercontent.com/rdpackages-replication/CIT_2024_CUP/192a67d70ec095182fc1f08fccb90a7c20167f83/CIT_2024_CUP_multicutoff.dta) |
| 6 | SPP multiple scores | [CIT_2024_CUP_multiscore-nongeo.dta](https://raw.githubusercontent.com/rdpackages-replication/CIT_2024_CUP/192a67d70ec095182fc1f08fccb90a7c20167f83/CIT_2024_CUP_multiscore-nongeo.dta) |
| 6 | Media-market geography | [CIT_2024_CUP_multiscore-geo.dta](https://raw.githubusercontent.com/rdpackages-replication/CIT_2024_CUP/192a67d70ec095182fc1f08fccb90a7c20167f83/CIT_2024_CUP_multiscore-geo.dta) |

The authors publish these files in their [Foundations](https://github.com/rdpackages-replication/CIT_2020_CUP)
and [Extensions](https://github.com/rdpackages-replication/CIT_2024_CUP) companion
repositories. Neither source repository specifies an explicit redistribution
licence. The original authors retain their rights; this repository assigns no
new licence to their data. The copies and source links identify the authors and
original studies. Run `python fetch_sources.py` from the exercise directory to
verify these files and prepare the pinned Stata packages. Missing inputs are
restored from the source URLs above.
