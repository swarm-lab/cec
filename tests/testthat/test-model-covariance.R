# Direct unit tests for the internal model.mean()/model.covariance()
# helpers. Most branches (per-model-type extraction) are already exercised
# indirectly through cec()'s normal usage across model types (see
# test-weighted.R's test.all.model.types.with.weights). This file targets
# the NA-handling branch specifically (only reached when a cluster is
# removed and keep.removed = TRUE preserves its NA row) that isn't
# otherwise exercised.

test_that("model.covariance.na.branch.returns.na.matrix", {
    na_cov <- matrix(NA_real_, 2, 2)
    result <- CEC:::model.covariance("all", na_cov, c(0, 0), list())
    expect_true(all(is.na(result)))
    expect_equal(dim(result), c(2, 2))
})

test_that("model.mean.na.branch.returns.na.vector", {
    na_center <- c(NA_real_, NA_real_)
    result <- CEC:::model.mean("all", na_center, list())
    expect_true(all(is.na(result)))
    expect_null(dim(result))
    expect_equal(length(result), 2)
})
