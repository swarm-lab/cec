## Test environments

* local macOS, ARM, R 4.6.1
* local macOS, ARM, R-devel (r90190)
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

There were no ERRORs or WARNINGs. The local checks returned no NOTEs. The
win-builder checks returned one NOTE each, described below.

## Downstream dependencies

Reverse dependencies were not checked for this submission.
'revdepcheck::revdep_check()' checked 0 packages. It could not install the
CRAN version of CEC after the archival.

## CRAN team comments

This is a new submission. CEC 0.12.0 was archived on 2026-09-16 because the
issues flagged as "clang23" on its CRAN check page were not corrected in time.

This version adds the missing standard library includes that clang 23 no
longer provides indirectly: `<cmath>` in the six `src/models/*.h` headers,
`<functional>` in `src/variable_starter.h`, `<iterator>` in `src/vec.h`,
`<limits>` in `src/init.cpp`, and `<utility>` in `src/r_ext_ptr.h` and
`src/common.h`.

A previous check also returned:

* Possibly misspelled words in DESCRIPTION:
  Spurek (19:35)

This is the correct spelling of that person's last name.

The win-builder check on R-oldrelease also returned:

* Found the following (possibly) invalid URLs:
  URL: https://en.wikipedia.org/wiki/K-means%2B%2B
  From: README.md
  Status: 403 Forbidden

This page exists. The win-builder check on R-devel did not report this URL.
