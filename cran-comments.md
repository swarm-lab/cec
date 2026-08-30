## Test environments

* local macOS Tahoe 26.6.2, R 4.6.1, ARM
* local macOS Tahoe 26.6.2, R-devel (4.7.0), ARM
* Github Actions "windows-latest (release)"
* Github Actions "macOS-latest (release)"
* Github Actions "ubuntu-latest (oldrel-1)"
* Github Actions "ubuntu-latest (release)"
* Github Actions "ubuntu-latest (devel)"
* r-hub linux (R-devel)
* r-hub macos (R-devel)
* r-hub windows (R-devel)
* win-builder.r-project.org (R-release)
* win-builder.r-project.org (R-devel)
* win-builder.r-project.org (R-oldrelease)

## R CMD check results

There were no ERRORs or WARNINGs.

## Downstream dependencies

Downstream dependencies on CRAN and Bioconductor were checked with
'revdepcheck::revdep_check()'. We checked 1 reverse dependency from CRAN,
comparing R CMD check results across CRAN and dev versions of this package.

 * We saw 0 new problems
 * We failed to check 0 packages

## CRAN team comments

This is a resubmission fixing the WARNING reported for the previous version
on `r-release-macos-x86_64` (ambiguous reversed comparison operator,
`-Wambiguous-reversed-operator`, in `src/vec.h`).

A previous check also returned:

* Possibly misspelled words in DESCRIPTION:
  Spurek (19:35)

This is the correct spelling of that person's last name.
