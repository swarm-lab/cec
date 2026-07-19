set.seed(1234567)
X1 <- matrix(rnorm(1000), 500, 2)
X2 <- rbind(X1, X1 + 5)
X3 <- rbind(X2, X1 + 10)

test_that("test.should.use.1.cluster", {
    C <- cec(X1, 1:3, "sp", keep.removed = TRUE, iter.max = 0, card.min = 4, nstart = 10)
    expect_equal(nrow(C$centers), 1)
})

test_that("test.should.use.2.cluster", {
    C <- cec(X2, 1:3, "sp", keep.removed = TRUE, iter.max = 0, card.min = 4, nstart = 10)
    expect_equal(nrow(C$centers), 2)
})

test_that("test.should.use.3.cluster", {
    C <- cec(X3, 1:3, "sp", keep.removed = TRUE, iter.max = 0, card.min = 4, nstart = 5)
    expect_equal(nrow(C$centers), 3)
})
