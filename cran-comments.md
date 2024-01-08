## Test environments

* local M1 OS X 14.1.1, R 4.3.2
* local M1 OS X 14.1.1, R-devel
* Github Actions "windows-latest (release)"
* Github Actions "macOS-latest (release)"
* Github Actions "ubuntu-latest (release)"
* Github Actions "ubuntu-latest (devel)"
* Github Actions "ubuntu-latest (oldrel-1)"
* r-hub Windows Server 2022, R-devel, 64 bit
* r-hub Ubuntu Linux 20.04.1 LTS, R-release, GCC
* r-hub Fedora Linux, R-devel, clang, gfortran
* r-hub Debian Linux, R-devel, GCC ASAN/UBSAN
* win-builder.r-project.org

## R CMD check results

There were no ERRORs or WARNINGs.

## Downstream dependencies

Downstream dependencies on CRAN and Bioconductor were checked with ‘revdepcheck::revdep_check()’. We checked 1 reverse dependencies, comparing R CMD check results across CRAN and dev versions of this package.

 * We saw 0 new problems
 * We failed to check 0 packages

## CRAN team comments

This submission fixes the following CRAN check issues:

Version: 0.11.0
Check: whether package can be installed
Result: WARN 
  Found the following significant warnings:
    cec_r.cpp:65:15: warning: format string is not a string literal (potentially insecure) [-Wformat-security]
    cec_r.cpp:75:11: warning: format string is not a string literal (potentially insecure) [-Wformat-security]
    cec_r.cpp:123:15: warning: format string is not a string literal (potentially insecure) [-Wformat-security]
    cec_r.cpp:133:11: warning: format string is not a string literal (potentially insecure) [-Wformat-security]
    cec_r.cpp:160:15: warning: format string is not a string literal (potentially insecure) [-Wformat-security]
    cec_r.cpp:167:15: warning: format string is not a string literal (potentially insecure) [-Wformat-security]
  See ‘/home/hornik/tmp/R.check/r-devel-clang/Work/PKGS/CEC.Rcheck/00install.out’ for details.
  * used C++ compiler: ‘Debian clang version 17.0.5 (1)’
Flavor: r-devel-linux-x86_64-debian-clang

Version: 0.11.0
Check: C++ specification
Result: NOTE 
    Specified C++11: please drop specification unless essential
Flavors: r-devel-linux-x86_64-debian-clang, r-devel-linux-x86_64-debian-gcc, r-devel-linux-x86_64-fedora-clang, r-devel-linux-x86_64-fedora-gcc, r-devel-windows-x86_64, r-patched-linux-x86_64, r-release-linux-x86_64, r-release-macos-arm64, r-release-macos-x86_64, r-release-windows-x86_64

Version: 0.11.0
Check: Rd files
Result: NOTE 
  checkRd: (-1) cec.Rd:164-165: Lost braces in \itemize; meant \describe ?
  checkRd: (-1) cec.Rd:166-168: Lost braces in \itemize; meant \describe ?
  checkRd: (-1) cec.Rd:169-172: Lost braces in \itemize; meant \describe ?
  checkRd: (-1) cec.Rd:173-175: Lost braces in \itemize; meant \describe ?
  checkRd: (-1) cec.Rd:176-177: Lost braces in \itemize; meant \describe ?
  checkRd: (-1) cec.Rd:178-180: Lost braces in \itemize; meant \describe ?
  checkRd: (-1) cec.Rd:181-182: Lost braces in \itemize; meant \describe ?
  checkRd: (-1) init.centers.Rd:19-20: Lost braces in \itemize; meant \describe ?
  checkRd: (-1) init.centers.Rd:21-22: Lost braces in \itemize; meant \describe ?
Flavors: r-devel-linux-x86_64-debian-clang, r-devel-linux-x86_64-debian-gcc

Version: 0.11.0
Check: whether package can be installed
Result: WARN 
  Found the following significant warnings:
    cec_r.cpp:65:15: warning: format string is not a string literal (potentially insecure) [-Wformat-security]
    cec_r.cpp:75:11: warning: format string is not a string literal (potentially insecure) [-Wformat-security]
    cec_r.cpp:123:15: warning: format string is not a string literal (potentially insecure) [-Wformat-security]
    cec_r.cpp:133:11: warning: format string is not a string literal (potentially insecure) [-Wformat-security]
    cec_r.cpp:160:15: warning: format string is not a string literal (potentially insecure) [-Wformat-security]
    cec_r.cpp:167:15: warning: format string is not a string literal (potentially insecure) [-Wformat-security]
  See ‘/data/gannet/ripley/R/packages/tests-clang/CEC.Rcheck/00install.out’ for details.
  * used C++ compiler: ‘clang version 17.0.5’
Flavor: r-devel-linux-x86_64-fedora-clang

---
