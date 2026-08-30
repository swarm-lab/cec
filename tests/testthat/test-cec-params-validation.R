# Direct unit tests for the internal create.cec.params.for.models(), covering
# per-model-type validation branches not exercised by any existing cec()-level
# test (only weights + fixedr-negative/eigenvalues-negative smoke tests
# existed previously, in test-weighted.R).

test_that("create.cec.params.errors.on.type.length.mismatch", {
    expect_error(
        CEC:::create.cec.params.for.models(2, 2, c("covariance", "fixedr", "mean"), NULL),
        "illegal length of 'type' vector"
    )
})

# --- covariance -------------------------------------------------------------

test_that("create.cec.params.covariance.errors.on.missing.param", {
    expect_error(
        CEC:::create.cec.params.for.models(1, 2, "covariance"),
        "illegal 'param' length"
    )
})

test_that("create.cec.params.covariance.errors.on.non.array.param", {
    expect_error(
        CEC:::create.cec.params.for.models(1, 2, "covariance", "not a matrix"),
        "illegal parameter for 'covariance' type"
    )
})

test_that("create.cec.params.covariance.errors.on.wrong.dimension", {
    expect_error(
        CEC:::create.cec.params.for.models(1, 2, "covariance", matrix(1, 1, 1)),
        "illegal parameter for 'covariance' type"
    )
    # correct ncol but wrong nrow (non-square), a distinct branch from the
    # ncol mismatch above
    expect_error(
        CEC:::create.cec.params.for.models(1, 2, "covariance", matrix(1, nrow = 3, ncol = 2)),
        "illegal parameter for 'covariance' type"
    )
})

test_that("create.cec.params.covariance.errors.on.non.positive.definite", {
    not_pd <- matrix(c(1, 2, 2, 1), 2, 2)
    expect_error(
        CEC:::create.cec.params.for.models(1, 2, "covariance", not_pd),
        "must be positive-definite"
    )
})

test_that("create.cec.params.covariance.accepts.valid.matrix", {
    pd <- matrix(c(1, 0, 0, 1), 2, 2)
    models <- CEC:::create.cec.params.for.models(1, 2, "covariance", pd)
    expect_equal(models[[1]]$params$cov, pd)
})

# --- fixedr -------------------------------------------------------------

test_that("create.cec.params.fixedr.errors.on.missing.param", {
    expect_error(
        CEC:::create.cec.params.for.models(1, 2, "fixedr"),
        "illegal 'param' length"
    )
})

test_that("create.cec.params.fixedr.errors.on.wrong.length", {
    expect_error(
        CEC:::create.cec.params.for.models(1, 2, "fixedr", c(1, 2)),
        "illegal parameter for 'fixedr' type"
    )
})

test_that("create.cec.params.fixedr.errors.on.non.numeric", {
    expect_error(
        CEC:::create.cec.params.for.models(1, 2, "fixedr", "a"),
        "illegal parameter for 'fixedr' type"
    )
})

test_that("create.cec.params.fixedr.errors.on.non.positive", {
    expect_error(
        CEC:::create.cec.params.for.models(1, 2, "fixedr", 0),
        "illegal parameter for 'fixedr' type"
    )
    expect_error(
        CEC:::create.cec.params.for.models(1, 2, "fixedr", -1),
        "illegal parameter for 'fixedr' type"
    )
})

# --- eigenvalues -------------------------------------------------------------

test_that("create.cec.params.eigenvalues.errors.on.missing.param", {
    expect_error(
        CEC:::create.cec.params.for.models(1, 2, "eigenvalues"),
        "illegal 'param' length"
    )
})

test_that("create.cec.params.eigenvalues.errors.on.wrong.length", {
    expect_error(
        CEC:::create.cec.params.for.models(1, 2, "eigenvalues", 0.1),
        "invalid length"
    )
})

test_that("create.cec.params.eigenvalues.errors.on.non.positive", {
    expect_error(
        CEC:::create.cec.params.for.models(1, 2, "eigenvalues", c(-0.1, 0.2)),
        "all values must be greater than 0"
    )
})

# --- mean -------------------------------------------------------------

test_that("create.cec.params.mean.errors.on.missing.param", {
    expect_error(
        CEC:::create.cec.params.for.models(1, 2, "mean"),
        "illegal 'param' length"
    )
})

test_that("create.cec.params.mean.errors.on.wrong.length", {
    expect_error(
        CEC:::create.cec.params.for.models(1, 2, "mean", 1),
        "invalid length"
    )
})
