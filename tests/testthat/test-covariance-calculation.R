B <- as.matrix(read.table(test_path("fixtures", "ball1.data")))
centers <- as.matrix(read.table(test_path("fixtures", "centers2.data")))

test_that("test.covariances.before.first.iteraion", {
    M <- matrix(c(-1, 102, 141, -1, 104, 2, -1, -1, 12, 4), 5, 2)
    cov <- cov.mle(M)
    C <- cec(M, centers = 1, iter.max = 0)
    expect_equal(C$covariances[[1]], cov, ignore_attr = TRUE)
})

test_that("test.covariances.after.point.movements.between.clusters", {
    cov <- cov.mle(B)
    C <- cec(B, centers = centers, type = "sp")
    expect_equal(C$covariances[[1]], cov, ignore_attr = TRUE)
})
