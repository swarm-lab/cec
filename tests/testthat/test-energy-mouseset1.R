B <- as.matrix(read.table(test_path("fixtures", "mouse1.data")))

test_that("test.type.covariance.mouseset1", {
    given.cov <- matrix(c(2, 1, 1, 3), 2, 2)
    expected.energy <- 3.540174056
    CE <- cec(B, centers = 1, type = "cov", param = given.cov, iter.max = 0)
    expect_equal(CE$cost, expected.energy)
})

test_that("test.type.fixedr.mouseset1", {
    r <- 1.5
    expected.energy <- 3.416637007
    CE <- cec(B, centers = 1, type = "fix", param = 1.5, iter.max = 0)
    expect_equal(CE$cost, expected.energy)
})

test_that("test.type.spherical.mouseset1", {
    expected.energy <- 3.403158062
    CE <- cec(B, centers = 1, type = "sp", iter.max = 0)
    expect_equal(CE$cost, expected.energy)
})

test_that("test.type.diagonal.mouseset1", {
    expected.energy <- 3.396500695
    CE <- cec(B, centers = 1, type = "diag", iter.max = 0)
    expect_equal(CE$cost, expected.energy)
})

test_that("test.type.all.mouseset1", {
    expected.energy <- 3.396472329
    CE <- cec(B, centers = 1, type = "all", iter.max = 0)
    expect_equal(CE$cost, expected.energy)
})
