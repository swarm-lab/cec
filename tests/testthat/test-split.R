set.seed(12345678)
data("threeGaussians", package = "CEC")
data("fourGaussians", package = "CEC")
data("mixShapes", package = "CEC")

mixShapesReduced <- mixShapes[seq(1, nrow(mixShapes), 2), ]

test_that("test.should.split.to.4.cluster", {
    expected.cost <- 2.530237
    tolerance <- 0.001
    C <- cec(fourGaussians, nstart = 5)
    expect_equal(C$nclusters, 4)
    expect_equal(C$cost, expected.cost, tolerance = tolerance)
})

test_that("test.should.split.to.7.cluster", {
    expected.cost <- 10.16551
    tolerance <- 0.001
    C <- cec(mixShapesReduced, 2, nstart = 2, split = TRUE)
    expect_equal(C$nclusters, 7)
    expect_equal(C$cost, expected.cost, tolerance = tolerance)
})

test_that("test.should.limit.split.to.4.cluster", {
    C <- cec(mixShapesReduced, 1, nstart = 2, split = TRUE, split.limit = 4)
    expect_equal(C$nclusters, 4)
})

test_that("test.should.split.to.3.cluster.fixed.mean", {
    C <- cec(threeGaussians, , "mean", param = c(0, 0), nstart = 8)
    expect_equal(C$nclusters, 3)
    expect_equal(C$cost, 1.726595, tolerance = 0.00001)
})
