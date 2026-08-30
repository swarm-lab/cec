data("fourGaussians", package = "CEC")
centers <- as.matrix(read.table(test_path("fixtures", "four.gaussians.centers.data")))
expected <- dget(test_path("fixtures", "four.gaussians.result.dp"))

test_that("test.clustering.four.gaussians", {
    CEC <- cec(fourGaussians, centers)
    expect_equal(CEC$cluster, expected$cluster)
    expect_equal(CEC$cost, expected$cost)
    expect_equal(CEC$centers, expected$centers, ignore_attr = TRUE)
    expect_equal(CEC$data, fourGaussians, ignore_attr = TRUE)
    expect_equal(CEC$probability, expected$probability)
    expect_equal(CEC$nclusters, expected$nclusters)
    expect_equal(CEC$iterations, expected$iterations)
})

# Regression test for findings 6, 7, 9 (commit 575f073): these three fixes
# (energy()=0 for a zero-weight cluster instead of NaN; cov.h skipping
# division on ~0 weight instead of computing 0/0; near-zero/negative
# determinant flooring in cov_utils.cpp) are tightly coupled in the same
# numerical pathway, so rather than force them into independently-
# discriminating unit tests, they're covered by this integration scenario:
# a bit-identical, zero-variance sub-cluster mixed with a normal cluster.
# Empirically verified (against a worktree built at a2f47ca, immediately
# before 575f073) to fail with "clustering failed: all starts failed"
# pre-fix, and to succeed cleanly post-fix with a well-defined (all-zero,
# not NaN) covariance for the degenerate cluster.
test_that("test.zero.variance.subcluster.does.not.corrupt.energy", {
    set.seed(1)
    dup <- matrix(rep(c(3, 3), 15), ncol = 2, byrow = TRUE)
    normal <- matrix(rnorm(30, sd = 1), ncol = 2)
    x <- rbind(dup, normal)

    Z <- suppressWarnings(cec(x, 2, type = "spherical", nstart = 5, card.min = 1))
    expect_true(is.finite(Z$cost))
    expect_identical(Z$nclusters, 2L)
    for (cv in Z$covariances) {
        expect_false(any(is.nan(cv)))
        expect_true(all(is.finite(cv)))
    }
})

# Regression test for finding 8 (commit 575f073): per-start try/catch
# isolation in parallel_starter.h. Pre-fix, one unlucky start hitting an
# invalid covariance discarded the entire batch's already-accumulated
# results ("all starts failed"); post-fix, the batch succeeds using the
# starts that didn't fail. Empirically verified to fail pre-fix and pass
# post-fix against a mix of duplicate degenerate points and normal points
# with a high nstart.
test_that("test.one.failing.start.does.not.discard.batch", {
    set.seed(3)
    x <- rbind(
        matrix(c(0, 0, 0, 0, 0, 0), ncol = 2, byrow = TRUE),
        matrix(rnorm(20, sd = 5), ncol = 2)
    )

    Z <- suppressWarnings(cec(x, 3, nstart = 20, card.min = 1))
    expect_true(is.finite(Z$cost))
    for (cv in Z$covariances) {
        expect_false(any(is.nan(cv)))
    }
})
