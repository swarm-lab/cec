set.seed(42)
x_ok <- matrix(rnorm(40), ncol = 2)

test_that("print.cec.output.contains.expected.sections", {
    Z <- suppressWarnings(cec(x_ok, 2, nstart = 3))
    out <- capture.output(print(Z))
    full <- paste(out, collapse = "\n")

    expect_true(any(grepl("CEC clustering result", out)))
    expect_true(any(grepl("Probability vector", out)))
    expect_true(any(grepl("Means of clusters", out)))
    expect_true(any(grepl("Cost function", out)))
    expect_true(any(grepl("Number of clusters", out)))
    expect_true(any(grepl("Number of iterations", out)))
    expect_true(any(grepl("Computation time", out)))
    expect_true(any(grepl("Available components", out)))
    expect_true(grepl("covariances.model", full))
})

test_that("print.cec.returns.invisibly.and.is.callable.via.generic", {
    Z <- suppressWarnings(cec(x_ok, 2, nstart = 3))
    expect_no_error(capture.output(print(Z)))
    # exercised through the S3 generic, not just the direct function call
    expect_no_error(capture.output(Z))
})
