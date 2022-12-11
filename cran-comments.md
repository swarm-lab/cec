## Test environments

* local M1 OS X 12.3.1, R 4.2.2
* Github Actions "windows-latest (release)"
* Github Actions "macOS-latest (release)"
* Github Actions "ubuntu-latest (release)"
* Github Actions "ubuntu-latest (devel)"
* Github Actions "ubuntu-latest (oldrel-1)"
* r-hub Windows Server 2022, R-devel, 64 bit
* r-hub Ubuntu Linux 20.04.1 LTS, R-release, GCC
* r-hub Fedora Linux, R-devel, clang, gfortran
* win-builder.r-project.org

## R CMD check results

There were no ERRORs or WARNINGs.

There was 1 NOTE:
"Possibly misspelled words in DESCRIPTION:
   Spurek (18:35)"
   
This is the correct spelling. 

## Downstream dependencies

There are currently no downstream dependencies for this package.

## CRAN team comments

The package appeared to have been "orphaned" and I am "adopting" it as new 
maintainer. CRAN check errors were not corrected for months, there has not been 
any activity on the package's GitHub repository in more than a year, and the 
previous maintainer have not replied to my or others' messages to fix the check
errors. 

I have conserved the attribution structure of the package and just added myself 
as the new maintainer. I have also fixed the check errors, updated the 
documentation, and made code modifications that do not alter the usage of 
user-facing functions or modify their output for maintaining continuity with the
previous versions of the package on CRAN. 

If this "adoption" is not acceptable for CRAN policies, please disregard this 
submission. 
