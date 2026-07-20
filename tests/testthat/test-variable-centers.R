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

test_that("cec.keep.removed.does.not.crash.when.a.cluster.is.actually.removed", {
    set.seed(1)
    x <- rbind(matrix(rnorm(60, sd = 0.3), ncol = 2),
               matrix(rnorm(6, mean = 50, sd = 0.1), ncol = 2))
    C <- suppressWarnings(
        cec(x, 3, keep.removed = TRUE, card.min = 5, nstart = 5)
    )
    removed <- is.na(C$centers[, 1])
    expect_true(any(removed))
    expect_true(all(is.na(C$means.model[removed, ])))
    expect_false(anyNA(C$means.model[!removed, ]))
})
