# Local coverage builds (covr::package_coverage()) fail to link on machines where
# gfortran isn't installed at CRAN's expected /opt/gfortran path (e.g. Homebrew's
# gfortran instead), because covr's default covr.flags appends "-lgcov" to FLIBS,
# which forces the build through R's system FLIBS resolution instead of picking up
# the CFLAGS/CXXFLAGS/LDFLAGS instrumentation alone. Dropping FFLAGS/FCFLAGS/FLIBS
# from covr.flags sidesteps this entirely -- CEC has no Fortran source, so Fortran
# coverage instrumentation was never doing anything for this package anyway.
# See: https://github.com/r-lib/covr/issues/231#issuecomment-258858436
if (requireNamespace("covr", quietly = TRUE)) {
    options(covr.flags = c(CFLAGS = "--coverage", CXXFLAGS = "--coverage", LDFLAGS = "--coverage"))
}
