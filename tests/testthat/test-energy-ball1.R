B <- as.matrix(read.table(test_path("fixtures", "ball1.data")))
C <- as.matrix(read.table(test_path("fixtures", "centers1.data")))

test_that("test.type.covariance.ball1", {
    given.cov <- matrix(c(2, 1, 1, 3), 2, 2)
    expected.energy <- 2.766927173
    CE <- cec(B, centers = 1, type = "cov", param = given.cov, iter.max = 0)
    expect_equal(CE$cost, expected.energy)
})

test_that("test.type.fixedr.ball1", {
    r <- 1.5
    expected.energy <- 2.410818718
    CE <- cec(B, centers = 1, type = "fix", param = 1.5, iter.max = 0)
    expect_equal(CE$cost, expected.energy)
})

test_that("test.type.spherical.ball1", {
    expected.energy <- 1.456430201
    CE <- cec(B, centers = 1, type = "sp", iter.max = 0)
    expect_equal(CE$cost, expected.energy)
})

test_that("test.type.diagonal.ball1", {
    cov <- cov.mle(B)
    expected.energy <- 1.45637452
    CE <- cec(B, centers = 1, type = "diag", iter.max = 0)
    expect_equal(CE$cost, expected.energy)
})

test_that("test.type.eigenvalues", {
    evals <- c(0.1, 0.22)
    expected.energy <- 1.734310397
    CE <- cec(B, centers = 1, type = "eigen", param = evals, iter.max = 0)
    expect_equal(CE$cost, expected.energy)
})

test_that("test.type.all.ball1", {
    expected.energy <- 1.455903678
    CE <- cec(B, centers = 1, type = "all", iter.max = 0)
    expect_equal(CE$cost, expected.energy)
})

test_that("test.type.mean", {
    expected.energy <- 1.455960581
    CE <- cec(B, 1, type = "mean", param = c(0, 0), iter.max = 0)
    expect_equal(CE$cost, expected.energy)
})

test_that("test.type.spherical.cluster.removing", {
    expected.energy <- 1.456430201
    CE <- cec(B, C, type = "sp", iter.max = 20)
    expect_equal(CE$cost, expected.energy)
})
