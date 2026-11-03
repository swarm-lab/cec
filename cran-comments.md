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
