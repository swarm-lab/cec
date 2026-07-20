set.seed(42)
x_ok <- matrix(rnorm(40), ncol = 2)
Z <- suppressWarnings(cec(x_ok, 2, nstart = 3))

test_that("plot.cec.errors.on.non.2d.data", {
    Z3 <- Z
    Z3$data <- matrix(rnorm(30), ncol = 3)
    expect_error(plot(Z3), "2-dimensional")
})

# col/xlab/ylab resolution: mocking graphics::plot.default (or the plot
# generic) to capture its arguments proved unreliable here -- R's S3
# dispatch cache for base generics can keep resolving to whichever
# plot.default was already invoked earlier in a full test-suite run,
# regardless of a freshly-registered mock (reproduced via test_dir() across
# the whole suite, not just this file in isolation; not specific to this
# package). So these are verified behaviorally, against a null graphics
# device, rather than by capturing the resolved argument values.
test_that("plot.cec.col.xlab.ylab.resolution.does.not.error", {
    pdf(nullfile())
    on.exit(dev.off(), add = TRUE)

    expect_no_error(plot(Z))                                    # col defaults to cluster
    expect_no_error(plot(Z, col = "blue"))                       # explicit col override
    Znamed <- Z
    colnames(Znamed$data) <- c("alpha", "beta")
    expect_no_error(plot(Znamed))                                # xlab/ylab from colnames
    expect_no_error(plot(Znamed, xlab = "custom x", ylab = "custom y"))  # explicit override wins
})

# ellipse()-related behavior IS reliably testable: ellipse() is a plain,
# non-generic internal function private to this package, so mocking it via
# local_mocked_bindings(.package = "CEC") doesn't hit the base-S3-dispatch
# caching issue above.
test_that("plot.cec.model.true.draws.one.ellipse.per.retained.cluster.using.model.covariance", {
    calls <- list()
    local_mocked_bindings(
        ellipse = function(mean, cov, npoints = 250) {
            calls[[length(calls) + 1]] <<- list(mean = mean, cov = cov)
            matrix(0, npoints, 2)
        },
        .package = "CEC"
    )
    pdf(nullfile())
    on.exit(dev.off(), add = TRUE)

    plot(Z, model = TRUE, ellipses = TRUE)

    n_expected <- sum(!is.na(Z$means.model[, 1]))
    expect_equal(length(calls), n_expected)
    expect_equal(calls[[1]]$cov, Z$covariances.model[[1]])
})

test_that("plot.cec.model.false.uses.sample.covariance.and.centers", {
    calls <- list()
    local_mocked_bindings(
        ellipse = function(mean, cov, npoints = 250) {
            calls[[length(calls) + 1]] <<- list(mean = mean, cov = cov)
            matrix(0, npoints, 2)
        },
        .package = "CEC"
    )
    pdf(nullfile())
    on.exit(dev.off(), add = TRUE)

    plot(Z, model = FALSE, ellipses = TRUE)

    expect_equal(calls[[1]]$cov, Z$covariances[[1]])
    expect_equal(calls[[1]]$mean, Z$centers[1, ])
})

test_that("plot.cec.ellipses.false.draws.no.ellipses", {
    calls <- list()
    local_mocked_bindings(
        ellipse = function(mean, cov, npoints = 250) {
            calls[[length(calls) + 1]] <<- TRUE
            matrix(0, npoints, 2)
        },
        .package = "CEC"
    )
    pdf(nullfile())
    on.exit(dev.off(), add = TRUE)

    plot(Z, ellipses = FALSE)
    expect_equal(length(calls), 0)
})

test_that("plot.cec.skips.removed.clusters.when.drawing.ellipses", {
    Zna <- Z
    Zna$means.model[1, ] <- NA
    calls <- list()
    local_mocked_bindings(
        ellipse = function(mean, cov, npoints = 250) {
            calls[[length(calls) + 1]] <<- TRUE
            matrix(0, npoints, 2)
        },
        .package = "CEC"
    )
    pdf(nullfile())
    on.exit(dev.off(), add = TRUE)

    plot(Zna, ellipses = TRUE)
    expect_equal(length(calls), nrow(Zna$means.model) - 1)
})

test_that("plot.cec.warns.and.skips.a.single.failing.ellipse.instead.of.erroring", {
    calls <- list()
    local_mocked_bindings(
        ellipse = function(mean, cov, npoints = 250) {
            calls[[length(calls) + 1]] <<- TRUE
            if (length(calls) == 1) stop("simulated ellipse failure")
            matrix(0, npoints, 2)
        },
        .package = "CEC"
    )
    pdf(nullfile())
    on.exit(dev.off(), add = TRUE)

    n_expected <- sum(!is.na(Z$means.model[, 1]))
    expect_warning(plot(Z, ellipses = TRUE), "simulated ellipse failure")
    expect_equal(length(calls), n_expected)
})
