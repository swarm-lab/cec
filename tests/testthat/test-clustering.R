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
