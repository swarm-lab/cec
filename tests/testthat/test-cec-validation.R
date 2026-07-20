set.seed(42)
x_ok <- matrix(rnorm(40), ncol = 2)

test_that("cec.errors.on.missing.x", {
    expect_error(cec(centers = 2), "Missing required argument: 'x'")
})

test_that("cec.errors.on.negative.iter.max", {
    expect_error(cec(x_ok, 2, iter.max = -1), "iter.max must be non-negative")
})

test_that("cec.errors.on.x.not.matrix", {
    expect_error(cec(as.data.frame(x_ok), 2), "'x' must be a matrix")
    expect_error(cec(1:10, 2), "'x' must be a matrix")
})

test_that("cec.errors.on.zero.column.x", {
    expect_error(cec(matrix(nrow = 10, ncol = 0), 2), "at least 1 column")
})

test_that("cec.errors.on.zero.row.x", {
    expect_error(cec(matrix(nrow = 0, ncol = 2), 2), "at least 1 row")
})

test_that("cec.errors.on.na.in.x", {
    x_na <- x_ok
    x_na[1, 1] <- NA
    expect_error(cec(x_na, 2), "should not contain NA values")
})

# Regression test for finding 1 (commit a2f47ca): pre-fix, nstart < 1 fell
# through to a misleading "all starts failed" clustering exception (from an
# integer division by zero in parallel_starter) instead of a clean,
# specific argument-validation error.
test_that("cec.errors.on.nstart.below.one", {
    expect_error(cec(x_ok, 2, nstart = 0), "nstart must be at least 1")
    expect_error(cec(x_ok, 2, nstart = -1), "nstart must be at least 1")
})

# Regression test for finding 3 (commit a2f47ca): pre-fix, non-double x
# reached REAL() directly inside the C++ layer and errored with
# "REAL() can only be applied to a 'numeric', not a 'integer'/'logical'"
# instead of being coerced to double like the existing weights coercion.
test_that("cec.accepts.integer.and.logical.x", {
    set.seed(7)
    xi <- matrix(as.integer(round(rnorm(40) * 10)), ncol = 2)
    xl <- matrix(sample(c(TRUE, FALSE), 40, replace = TRUE), ncol = 2)
    expect_no_error(suppressWarnings(cec(xi, 2, nstart = 5)))
    expect_no_error(suppressWarnings(cec(xl, 2, nstart = 5)))
})

test_that("cec.errors.on.non.numeric.weights", {
    expect_error(cec(x_ok, 2, weights = "a"), "must be a numeric vector")
})

test_that("cec.errors.on.na.in.centers.vector", {
    expect_error(cec(x_ok, c(1, NA)), "'centers' should not contain NA values")
})

test_that("cec.errors.on.centers.below.one", {
    expect_error(cec(x_ok, c(1, 0)), "'centers' must only contain integers greater")
})

test_that("cec.errors.on.centers.matrix.column.mismatch", {
    expect_error(cec(x_ok, matrix(rnorm(9), 3, 3)), "same number of columns")
})

test_that("cec.errors.on.centers.matrix.zero.rows", {
    expect_error(cec(x_ok, matrix(nrow = 0, ncol = 2)), "'centers' must have at least 1 row")
})

test_that("cec.errors.on.card.min.bad.format", {
    expect_error(cec(x_ok, 2, card.min = "abc"), "'card.min' in wrong format")
})

test_that("cec.errors.on.type.length.exceeding.var.centers", {
    expect_error(
        cec(x_ok, c(1, 2, 3), type = c("all", "spherical")),
        "'type' with length > 1"
    )
})

test_that("cec.accepts.explicit.centers.init.and.threads.auto", {
    expect_no_error(suppressWarnings(cec(x_ok, 2, centers.init = "random", nstart = 1)))
    expect_no_error(suppressWarnings(cec(x_ok, 2, threads = "auto", nstart = 1)))
})

test_that("cec.errors.on.mixed.model.types.in.split.mode", {
    expect_error(
        suppressWarnings(cec(x_ok, c(1, 2), split = TRUE, type = c("all", "spherical"))),
        "Mixing model types is currently not supported in split mode"
    )
})
