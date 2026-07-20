# cec.interactive() (reached via cec(..., interactive = TRUE)) drives a
# readline()-based REPL loop. readline() is documented to return "" immediately
# without blocking whenever R is run non-interactively -- which testthat runs
# always are -- so no mocking is required; only the plot() calls need a null
# graphics device to keep test output/artifacts quiet.

set.seed(1)
# Two well-separated blobs (not pure noise): a single nstart = 1 attempt must
# reliably find both clusters regardless of platform-level floating-point
# differences (BLAS/LAPACK) in the clustering internals -- an unstructured
# noise dataset left this test flaky on non-macOS CI runners, occasionally
# failing with "all starts failed" even though set.seed() fixes the R-level
# RNG stream identically across platforms.
x_ok <- rbind(matrix(rnorm(20, mean = 0), ncol = 2),
              matrix(rnorm(20, mean = 10), ncol = 2))

test_that("cec.interactive.readline.true.runs.to.completion", {
    pdf(nullfile())
    on.exit(dev.off(), add = TRUE)

    invisible(capture.output(
        Z <- suppressWarnings(cec(x_ok, 2, interactive = TRUE, iter.max = 3, readline = TRUE, nstart = 1))
    ))

    expect_s3_class(Z, "cec")
    # the loop's break check runs before the final increment, so it can run
    # one iteration past iter.max
    expect_lte(Z$iterations, 4)
})

test_that("cec.interactive.readline.false.runs.to.completion", {
    pdf(nullfile())
    on.exit(dev.off(), add = TRUE)

    Z <- suppressWarnings(
        cec(x_ok, 2, interactive = TRUE, iter.max = 3, readline = FALSE, nstart = 1)
    )
    expect_s3_class(Z, "cec")
    # the loop's break check runs before the final increment, so it can run
    # one iteration past iter.max
    expect_lte(Z$iterations, 4)
})

test_that("cec.interactive.rejects.non.2d.data", {
    pdf(nullfile())
    on.exit(dev.off(), add = TRUE)
    x3 <- matrix(rnorm(30), ncol = 3)
    expect_error(
        cec(x3, 2, interactive = TRUE, nstart = 1),
        "interactive mode available only for 2-dimensional data"
    )
})

test_that("cec.interactive.rejects.split.and.multi.start.and.variable.centers", {
    expect_error(cec(x_ok, 1, interactive = TRUE, split = TRUE), "split mode")
    expect_error(cec(x_ok, c(1, 2), interactive = TRUE), "variable centers")
    expect_error(cec(x_ok, 2, interactive = TRUE, nstart = 2), "multiple starts")
})
