# Sources and attribution

## Mixtape / Remix track

The original track follows Scott Cunningham's [Causal Inference: The Remix](https://mixtape.scunning.com/), especially [Chapter 6](https://mixtape.scunning.com/06-regression_discontinuity) and the fuzzy RD discussion in Chapter 7. Original figure URLs are recorded in [mixtape/presentation/assets/sources.json](mixtape/presentation/assets/sources.json). SVG-to-PDF versions preserve the original artwork for LaTeX.

The continuity schematic is a crop of page 3 of the supplied `rdd-smoothness-and-hoekstra.pdf`. Its hypothetical university example is not an empirical estimate from Hoekstra (2009). The complete handout stays local.

The Hansen exercise adapts Cunningham's chapter example and public [214,558-observation teaching extract](https://raw.githubusercontent.com/scunning1975/causal-inference-class/master/hansen_dwi.dta). The original study is Hansen (2015), [Punishment and Deterrence: Evidence from Drunk Driving](https://doi.org/10.1257/aer.20130189). The exercise does not replicate the paper's full original sample. Saved outputs are in `mixtape/exercises/hansen_results/`.

## Cattaneo, Idrobo, and Titiunik track

The second track follows both manuals' theoretical structure:

- [Foundations (2020)](https://doi.org/10.1017/9781108684606).
- [Extensions (2024)](https://doi.org/10.1017/9781009441896).
- The [Foundations erratum](https://rdpackages.github.io/references/Cattaneo-Idrobo-Titiunik_2020_CUP--erratum.pdf), including its correction of the leading bias order.

Theoretical diagrams are small vector crops from the user's supplied reading copies, with authorship and source section/figure cited on the relevant slides. Exact PDF pages, printed pages, figure numbers, and crop bounds are in [cattaneo/presentation/assets/sources.json](cattaneo/presentation/assets/sources.json). The full books are not redistributed in this repository.

The authors' code was located through their [official replication index](https://rdpackages.github.io/replication/). Exact versions used:

- [Foundations replication](https://github.com/rdpackages-replication/CIT_2020_CUP/tree/62bb142c65a9b1fb3b593d405a97ce1bec17aa50), revision `62bb142c65a9b1fb3b593d405a97ce1bec17aa50`.
- [Extensions replication](https://github.com/rdpackages-replication/CIT_2024_CUP/tree/192a67d70ec095182fc1f08fccb90a7c20167f83), revision `192a67d70ec095182fc1f08fccb90a7c20167f83`.

The seminar's Stata modules are teaching adaptations with new organization, exports, and explanatory comments. `fetch_sources.py` downloads the original authors' do-files and data unmodified into a local ignored cache. It also downloads isolated pinned versions of `rdrobust`, `rddensity`, `rdlocrand`, `rdmulti`, and `lpdensity`. All URLs and SHA-256 checksums are recorded in [sources.lock.json](cattaneo/exercises/sources.lock.json).

## Original empirical studies in the second track

| Application | Original source |
|---|---|
| Turkish municipal elections | Meyersson (2014), [Islamic Rule and the Empowerment of the Poor and Pious](https://doi.org/10.3982/ECTA9878) |
| U.S. Senate elections | Cattaneo, Frandsen, and Titiunik (2015), [Randomization Inference in the Regression Discontinuity Design](https://doi.org/10.1515/jci-2013-0010) |
| Ser Pilo Paga | Londoño-Vélez, Rodríguez, and Sánchez (2020), [Upstream and Downstream Impacts of College Merit-Based Financial Aid for Low-Income Students](https://doi.org/10.1257/pol.20180131) |
| Academic probation | Lindo, Sanders, and Oreopoulos (2010), [Ability, Gender, and Performance Standards](https://doi.org/10.1257/app.2.2.95) |
| Media-market geography | Keele and Titiunik (2015), [Geographic Boundaries as Regression Discontinuities](https://doi.org/10.1093/pan/mpu014) |

All empirical figures in the new track are generated from the teaching modules. Numerical tables use their executed Stata output rather than transcriptions of book results. These are companion-data illustrations, not complete replications of every original empirical paper. Small numerical differences from the manuals can reflect package updates; interpretive differences are discussed in the slides and private notes.

The bibliographies identify the methodological articles behind the procedures. Third-party figures, code, data, and publications retain their authorship and applicable terms. This repository grants no separate license to third-party material.
