# C++ exceptions reachable from R through the public API (adversarial data
# through cec(), no internal-call bypass needed). Exceptions only reachable
# by bypassing R's own validation (defense-in-depth guards) are covered
# separately in test-cpp-exceptions-internal.R.
#
# Note on invalid_covariance (thrown in starter.cpp): every per-start
# attempt is individually wrapped in try/catch(clustering_exception&) at the
# parallel_starter.h/variable_starter.cpp level (finding 8's isolation fix),
# so a single start hitting invalid_covariance is swallowed there and never
# reaches describe_exception() as long as other starts succeed. That throw
# line is already exercised (confirmed via covr) by
# test.one.failing.start.does.not.discard.batch in test-clustering.R, which
# constructs data where some starts are expected to hit exactly this.

test_that("clustering.impossible.for.every.start.surfaces.as.clean.error", {
    # 20 near-identical points forced into 2 clusters with an aggressive
    # weight-sum card.min: every start ends up with all_clusters_removed
    # (thrown in starter.cpp) or an unrecoverable state, and since every
    # start fails, the failure propagates past all the per-start/per-thread
    # catch layers to cec_r.cpp's own "all starts failed" clustering_exception,
    # which reaches describe_exception() and is translated to a clean R
    # error rather than a crash or silent corruption.
    set.seed(1)
    near_dup <- matrix(rep(c(1, 1), 20) + rnorm(40, sd = 1e-8), ncol = 2, byrow = TRUE)

    expect_error(
        cec(near_dup, 2, card.min = "90%", nstart = 3),
        "all starts failed"
    )
})

test_that("split.mode.initial.clustering.failure.surfaces.as.clean.error", {
    # Regression test: when split = TRUE and every attempt at the initial
    # (pre-split) clustering fails to produce a valid result (e.g. too few
    # points for the enforced card.min floor), cec_starter::start legitimately
    # returns a null clustering_results (all per-start attempts caught their
    # own clustering_exception internally, so nothing propagates as a throw).
    # mp_start_subtask::operator() used to hand that null result straight to
    # split_starter::start(), which dereferenced it unconditionally
    # (cl_res->cluster_number) and segfaulted the R process. Both call sites
    # now guard against a null initial result, so this surfaces as the same
    # clean "all starts failed" error as the non-split path instead of a
    # crash.
    set.seed(1)
    x <- matrix(runif(6), 3, 2)

    expect_error(
        cec(x, 1, iter.max = 10, card.min = 3, split = TRUE, split.tries = 1,
            split.limit = 2, split.depth = 1, split.initial.starts = 1),
        "all starts failed"
    )
})
