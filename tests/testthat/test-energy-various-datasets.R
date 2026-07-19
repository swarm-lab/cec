two.gausses.4d <- as.matrix(read.table(test_path("fixtures", "two.gausses.4d.data")))

mouse3d <- as.matrix(read.table(test_path("fixtures", "mouse3d.data")))
C <- as.matrix(read.table(test_path("fixtures", "centers3d.data")))
C4 <- as.matrix(read.table(test_path("fixtures", "centers43d.data")))

test_that("test.type.covariance.various.datasets", {
    given.cov <- matrix(c(0.770118878, 0.005481129, -0.005991149, 0.005481129, 0.766972716,
                          0.008996509, -0.005991149, 0.008996509, 0.821481768), 3, 3)
    expected.energy <- 4.365855156
    CE <- cec(mouse3d, centers = C, type = "cov", param = given.cov, iter.max = 20)
    expect_equal(CE$cost, expected.energy)
})

test_that("test.type.fixedr.mixture", {
    r <- c(0.2, 0.3, 0.4)
    expected.energy <- 4.853461033
    CE <- cec(mouse3d, centers = C, type = c("fi", "fi", "fi"), param = r)
    expect_equal(CE$cost, expected.energy)
})

test_that("test.type.spherical.one.cluster.removed", {
    expected.energy <- 4.179257781
    expected.number.of.clusters <- 3
    CE <- cec(mouse3d, C4, type = "sp")
    expect_equal(CE$nclusters, expected.number.of.clusters)
    expect_equal(CE$cost, expected.energy)
})

test_that("test.type.diagonal.spherical.mixture", {
    expected.energy <- 4.177793598
    expected.number.of.clusters <- 3
    CE <- cec(mouse3d, C, type = c("diag", "diag", "sp"))
    expect_equal(CE$nclusters, expected.number.of.clusters)
    expect_equal(CE$cost, expected.energy)
})

test_that("test.type.eigenvalues.all.fixedr.mixture", {
    evals1 <- c(0.8240634, 0.7739987, 0.7595220)
    evals2 <- c(0.7240634, 0.5739987, 0.3595220)
    r <- 1.0
    expected.energy <- 4.323007035
    expected.number.of.clusters <- 3
    CE <- cec(mouse3d, C4, type = c("all", "eigen", "fixedr", "eigen"), param = list(evals1, r, evals2))
    expect_equal(CE$nclusters, expected.number.of.clusters)
    expect_equal(CE$cost, expected.energy)
})

test_that("test.type.mean.two.gaussians", {
    centers <- matrix(c(2, 4, 2, 4, 2, 4, 2, 4), 2, 4)
    means.param <- list(c(0, 0, 0, 0), c(5, 5, 5, 5))
    expected.energy <- 6.142651451
    cec <- cec(two.gausses.4d, centers, c("mean", "mean"), param = means.param)
    expect_equal(cec$cost, expected.energy)
})
