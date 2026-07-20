# C++ exceptions that guard against malformed input at the R/C++ boundary,
# but are unreachable through cec()'s public API because R's own validation
# (match.arg(), resolve.type(), create.cec.params.for.models()'s try.chol()/
# solve()) already prevents that malformed input from ever being built. These
# are "defense-in-depth" guards from findings 1-5: mirrored checks that only
# matter if the R-level validation is ever bypassed or weakened. Tested here
# by calling the internal .Call() entry points directly with hand-crafted
# arguments that skip the normal R-side construction/validation path.
#
# The value of these tests isn't modeling realistic user input (nothing a
# real caller does can reach these) -- it's confirming that the shared
# catch/describe_exception()/Rf_error() machinery in cec_r.cpp (the exact
# site of finding 1's PROTECT-stack leak) correctly translates every
# exception type into a clean R error instead of a crash.

set.seed(1)
x_ok <- matrix(rnorm(40), ncol = 2)

# Minimal valid harness mirroring what cec() itself builds before calling
# .Call(cec_r, ...), used as a baseline that each test corrupts one piece of.
base_centers <- list(init.method = "kmeanspp", var.centers = 2L)
base_control <- list(min.card = 1, max.iters = 10L, starts = 1L, threads = 1L)
base_weights <- rep(1.0, nrow(x_ok))
base_models <- list(list(type = "all", params = list()), list(type = "all", params = list()))

test_that("bypass.invalid.init.method", {
    expect_error(
        .Call(CEC:::cec_init_centers_r, x_ok, 1L, "bogus"),
        "invalid center method"
    )
})

test_that("bypass.invalid.model.name", {
    models <- base_models
    models[[1]]$type <- "totally_bogus_type"
    expect_error(
        .Call(CEC:::cec_r, x_ok, base_centers, base_control, models, base_weights),
        "invalid model name"
    )
})

test_that("bypass.invalid.parameter.type", {
    # non-REALSXP matrix passed directly, skipping cec()'s storage.mode(x) <-
    # "double" coercion (finding 3) -- hits the REALSXP defense-in-depth
    # check r_utils.h's get<r_ext_ptr<mat>>() adds (finding 5).
    bad_x <- matrix(1:40, ncol = 2)
    expect_error(
        .Call(CEC:::cec_init_centers_r, bad_x, 1L, "kmeanspp"),
        "invalid parameter type"
    )
})

test_that("bypass.missing.parameter", {
    # "fixedr" type with a params list present but missing its required "r" key
    models <- base_models
    models[[1]] <- list(type = "fixedr", params = list(dummy = 1))
    expect_error(
        .Call(CEC:::cec_r, x_ok, base_centers, base_control, models, base_weights),
        "missing parameter"
    )
})

test_that("bypass.invalid.model.parameter", {
    # non-positive-definite covariance smuggled past R's try.chol()/solve()
    # pre-validation in create.cec.params.for.models()
    bad_cov <- matrix(c(1, 2, 2, 1), 2, 2)  # eigenvalues 3, -1
    models <- base_models
    models[[1]] <- list(type = "covariance", params = list(cov = bad_cov))
    expect_error(
        .Call(CEC:::cec_r, x_ok, base_centers, base_control, models, base_weights),
        "invalid model parameter"
    )
})
