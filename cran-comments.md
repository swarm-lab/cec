## Test environments

* local OS X 26.2, R 4.5.2, ARM
* local OS X 26.2, R-devel, ARM
* Github Actions "windows-latest (release)"
* Github Actions "macOS-latest (release)"
* Github Actions "ubuntu-latest (oldrel-1)"
* Github Actions "ubuntu-latest (release)"
* Github Actions "ubuntu-latest (devel)"
* r-hub linux (R-devel)
* r-hub m1-san (R-devel)
* r-hub macos-arm64 (R-devel)
* r-hub windows (R-devel)
* win-builder.r-project.org

## R CMD check results

There were no ERRORs or WARNINGs.

## Downstream dependencies

Downstream dependencies on CRAN and Bioconductor were checked with 
‘revdepcheck::revdep_check()’. We checked 1 reverse dependencies from CRAN, 
comparing R CMD check results across CRAN and dev versions of this package.

 * We saw 0 new problems
 * We failed to check 0 packages

## CRAN team comments

Checks returns the following: 

* Possibly misspelled words in DESCRIPTION:
  Spurek (19:35)

This is the correct spelling of that person's last name. 

* CRAN repository db overrides:
  X-CRAN-Comment: Archived on 2026-01-15 as issues were not addressed
    in time.

This submission fix the issues previously reported. 
