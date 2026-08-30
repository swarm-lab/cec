# Changelog

## CEC v0.12.0

### New features

- [`cec()`](https://swarm-lab.github.io/cec/reference/cec.md) now
  accepts an optional `weights` argument: a numeric vector of
  non-negative values, one per observation. Cluster means, covariances,
  and the returned `$probability` field are all weight-aware. When
  `weights = NULL` (default), behaviour is identical to previous
  versions.

### Breaking changes

- When `weights` is non-uniform, `$probability` now reports the weighted
  mixing proportion `W_k / W_total` rather than the observation-count
  fraction `n_k / m`.
- When `weights` is non-uniform, `card.min` is now interpreted as a
  minimum weight sum rather than a minimum observation count.

### Minor improvements and fixes

- Fixed a crash with non-uniform `weights`: a cluster with fewer
  observations than dimensions could pass the weight-sum-based
  `card.min` check and produce a singular covariance. Cluster removal
  now also enforces a minimum observation count.
- Fixed a crash in `cec(..., keep.removed = TRUE)` whenever a cluster
  was actually removed during clustering
  (`Error in matrix(NA, 1, ncol(center)) : non-numeric matrix extent`).
- [`plot.cec()`](https://swarm-lab.github.io/cec/reference/plot.cec.md)
  now warns and skips a single cluster’s covariance ellipse if it cannot
  be drawn (e.g. a degenerate covariance), instead of failing the whole
  plot. Previously the surrounding `tryCatch` had no `error` handler and
  so provided no protection.
- Error messages for internal clustering failures now include the
  underlying cause instead of a generic message.
- Fixed a C++20 compiler warning (ambiguous reversed comparison
  operators) flagged by CRAN’s macOS checks.

------------------------------------------------------------------------

## CEC v0.11.3

CRAN release: 2026-02-04

### New features

- N/A.

### Minor improvements and fixes

- Fixing typo in Makevars.

------------------------------------------------------------------------

## CEC v0.11.2

CRAN release: 2024-10-10

### New features

- N/A.

### Minor improvements and fixes

- Fixing CRAN NO_REMAP error with R \> 4.5.0.

------------------------------------------------------------------------

## CEC v0.11.1

CRAN release: 2024-01-08

### New features

- N/A.

### Minor improvements and fixes

- Fixing new CRAN check errors.

------------------------------------------------------------------------

## CEC v0.11.0

CRAN release: 2022-12-13

### New features

- New maintainer.
- New logo.

### Minor improvements and fixes

- Refactoring/reorganizing R code for easier maintenance.
- Improving of documentation.
- Moving to GitHub actions for CI instead of Travis.

------------------------------------------------------------------------

## CEC v0.10.3

CRAN release: 2021-09-21

### New features

- N/A.

### Minor improvements and fixes

- Fixing gcc-11 issues.
- Fixing other CRAN issues.

------------------------------------------------------------------------

## CEC v0.10.2

CRAN release: 2018-07-26

### New features

- Adding fixed mean model.
- Adding data set: threeGaussians.

### Minor improvements and fixes

- Fixing compilation issues on some platforms.

------------------------------------------------------------------------

## CEC v0.10.1

CRAN release: 2018-07-09

### New features

- Rewriting all C the code in C++11.
- Adding split method.
- Adding threads.

### Minor improvements and fixes

- N/A.

------------------------------------------------------------------------

## CEC v0.9.4

CRAN release: 2016-04-24

### New features

- N/A.

### Minor improvements and fixes

- Adding README.md.
- Lots of refactoring.
- Small fixes.

------------------------------------------------------------------------

## CEC v0.9.3

CRAN release: 2015-02-03

### New features

- Changing the way initial centers vector is handled: for each start,
  length(centers) clusterings are performed.
- Adding two datasets: fourGaussians and mixShapes.

### Minor improvements and fixes

- Giving up support of -1 iterations (fixing memcheck problems).

------------------------------------------------------------------------

## CEC v0.9.2

CRAN release: 2014-11-15

### New features

- N/A

### Minor improvements and fixes

- Checking input data for NA values (session crushing).
- Changing ‘ZERO_EPSILON’ to ‘1.0e-32’.
- Lots of refactoring.

## CEC v0.9.1

CRAN release: 2014-10-09

Initial Release.
