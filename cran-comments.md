## Test environments

* local M1 OS X 13.0.1, R 4.2.2
* local M1 OS X 13.0.1, R-devel
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

"Possibly misspelled words in DESCRIPTION:
  CEC (16:17, 19:5)
  Spurek (19:33)"
   
These are the correct spellings. 

"Found the following (possibly) invalid URLs:
      URL:
        From: README.md
        Message: Empty URL"

Fixed. 

## Downstream dependencies

There are currently no downstream dependencies for this package.

## CRAN team comments

"Please always write package names, software names and API (application
programming interface) names in single quotes in title and description.
e.g: --> 'CEC'
Please note that package names are case sensitive."

Fixed.

"Please do not use on.exit() to reset user's options(), working directory
or par() after you changed it in examples and vignettes and demos. e.g.:
man/cec.Rd
Please reset in the following way
e.g.:
oldpar <- par(mfrow = c(1,2))
...
par(oldpar)"

Fixed. 

---

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
