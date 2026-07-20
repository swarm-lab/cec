x_ok <- matrix(rnorm(20), ncol = 2)

test_that("init.centers.errors.on.non.matrix.x", {
    expect_error(init.centers(as.data.frame(x_ok), 2), "should be a matrix")
})

# Regression test for finding 2 (commit a2f47ca): pre-fix, a 0-row x reached
# a confusing low-level REAL()-coercion error instead of a clean
# argument-validation error.
test_that("init.centers.errors.on.zero.row.x", {
    expect_error(init.centers(matrix(nrow = 0, ncol = 2), 2), "at least 1 row")
})

# Regression test for finding 2 (commit a2f47ca): pre-fix, k = 0 silently
# succeeded and caused an out-of-bounds write in kmeanspp_init (k < 0 was
# rejected, but k == 0 was not, contradicting the error message).
test_that("init.centers.errors.on.k.leq.zero", {
    expect_error(init.centers(x_ok, 0), "'k' should be greater than 0")
    expect_error(init.centers(x_ok, -1), "'k' should be greater than 0")
})

test_that("init.centers.errors.on.unknown.method", {
    expect_error(init.centers(x_ok, 2, method = "bogus"))
})

# Regression test for finding 3 (commit a2f47ca): pre-fix, non-double x
# reached REAL() directly and errored instead of being coerced to double.
test_that("init.centers.accepts.integer.x", {
    xi <- matrix(as.integer(round(rnorm(20) * 10)), ncol = 2)
    expect_no_error(init.centers(xi, 2))
})

test_that("init.centers.kmeanspp.and.random.methods.work", {
    expect_equal(dim(init.centers(x_ok, 2, method = "kmeans++")), c(2, 2))
    expect_equal(dim(init.centers(x_ok, 2, method = "random")), c(2, 2))
})
