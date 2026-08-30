# ellipse() is an internal (@noRd) pure function used by plot.cec() to
# compute the perimeter points of a covariance ellipse. Tested directly here,
# and its call arguments (which mean/covariance get passed in) are tested
# separately in test-plot-cec.R.

test_that("ellipse.circle.has.constant.radius.from.mean", {
    mean <- c(5, -3)
    cov <- diag(2)
    pts <- CEC:::ellipse(mean, cov, npoints = 100)

    expect_equal(dim(pts), c(100, 2))
    dists <- sqrt((pts[, 1] - mean[1])^2 + (pts[, 2] - mean[2])^2)
    expect_equal(dists, rep(2, 100), tolerance = 1e-8)
})

test_that("ellipse.is.centered.on.mean", {
    mean <- c(1, 2)
    cov <- matrix(c(2, 0.3, 0.3, 1), 2, 2)
    # Large npoints to shrink the O(1/npoints) discretization bias from the
    # -pi/+pi endpoint overlap in seq(-pi, pi, len = npoints).
    pts <- CEC:::ellipse(mean, cov, npoints = 10000)

    centroid <- colMeans(pts)
    expect_equal(centroid, mean, tolerance = 1e-3)
})

test_that("ellipse.axis.extents.match.eigenvalues", {
    # Axis-aligned covariance: extents along each axis are 2*sqrt(variance
    # along that axis). eigen() sorts eigenvalues in decreasing order, so the
    # larger-variance axis (column 2, variance 4) gets the larger extent
    # after eve rotates the local ellipse back into the original axes.
    mean <- c(0, 0)
    cov <- diag(c(1, 4))
    pts <- CEC:::ellipse(mean, cov, npoints = 1000)

    expect_equal(max(abs(pts[, 1])), 2 * sqrt(1), tolerance = 1e-3)
    expect_equal(max(abs(pts[, 2])), 2 * sqrt(4), tolerance = 1e-3)
})

test_that("ellipse.respects.npoints", {
    pts <- CEC:::ellipse(c(0, 0), diag(2), npoints = 37)
    expect_equal(nrow(pts), 37)
})
