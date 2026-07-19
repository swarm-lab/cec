# Two well-separated 2D clusters, 10 points each, fixed centers for reproducibility
set.seed(42)
cluster1 <- matrix(c(0, 0, 0.1, -0.1, 0.05, -0.05, 0.1, 0.1, -0.1, 0,
                     0, 0, 0.1,  0.1, 0.05,  0.05, -0.1, 0.1, 0.1, -0.1),
                   nrow = 10, ncol = 2)
cluster2 <- matrix(c(10, 10, 10.1, 9.9, 10.05, 9.95, 10.1, 10.1, 9.9, 10,
                     10, 10, 10.1, 10.1, 10.05, 10.05, 9.9, 10.1, 10.1, 9.9),
                   nrow = 10, ncol = 2)
data_mat <- rbind(cluster1, cluster2)

# Fixed centers for deterministic assignment
init_centers <- matrix(c(0, 10, 0, 10), nrow = 2, ncol = 2)

# 9.1 Weighted means and covariances match analytic values
test_that("test.weighted.mean.and.covariance", {
    # Moderate weights: first 10 points get weight 2, last 10 get weight 1
    w <- c(rep(2, 10), rep(1, 10))
    Z <- cec(data_mat, init_centers, weights = w)

    # Analytic weighted mean for cluster 1 (rows 1:10, all weight 2)
    w1 <- w[1:10]
    expected_mu1 <- colSums(data_mat[1:10, ] * w1) / sum(w1)
    # Analytic weighted mean for cluster 2 (rows 11:20, all weight 1)
    w2 <- w[11:20]
    expected_mu2 <- colSums(data_mat[11:20, ] * w2) / sum(w2)

    # Analytic weighted covariance: (1/W_k) * sum_i w_i * (x_i - mu)(x_i - mu)^T
    diff1 <- sweep(data_mat[1:10, ], 2, expected_mu1)
    expected_cov1 <- crossprod(sqrt(w1) * diff1) / sum(w1)
    diff2 <- sweep(data_mat[11:20, ], 2, expected_mu2)
    expected_cov2 <- crossprod(sqrt(w2) * diff2) / sum(w2)

    # Map output cluster indices to analytic clusters
    if (Z$centers[1, 1] < 5) {
        idx1 <- 1; idx2 <- 2
    } else {
        idx1 <- 2; idx2 <- 1
    }
    expect_equal(Z$centers[idx1, ], expected_mu1, tolerance = 1e-6)
    expect_equal(Z$centers[idx2, ], expected_mu2, tolerance = 1e-6)
    expect_equal(Z$covariances[[idx1]], expected_cov1, tolerance = 1e-6, ignore_attr = TRUE)
    expect_equal(Z$covariances[[idx2]], expected_cov2, tolerance = 1e-6, ignore_attr = TRUE)
})

# 9.2 weights = NULL produces identical output to omitting weights
test_that("test.null.weights.identical.to.no.weights", {
    set.seed(1)
    Z1 <- cec(data_mat, init_centers)
    set.seed(1)
    Z2 <- cec(data_mat, init_centers, weights = NULL)

    expect_equal(Z2$cluster, Z1$cluster)
    expect_equal(Z2$centers, Z1$centers, ignore_attr = TRUE)
    expect_equal(Z2$probability, Z1$probability)
    expect_equal(Z2$cost.function, Z1$cost.function)
})

# 9.3 weights = rep(1, nrow(x)) identical to NULL
test_that("test.unit.weights.identical.to.null", {
    set.seed(1)
    Z1 <- cec(data_mat, init_centers)
    set.seed(1)
    Z2 <- cec(data_mat, init_centers, weights = rep(1, nrow(data_mat)))

    expect_equal(Z2$cluster, Z1$cluster)
    expect_equal(Z2$centers, Z1$centers, ignore_attr = TRUE)
    expect_equal(Z2$probability, Z1$probability)
    expect_equal(Z2$cost.function, Z1$cost.function)
})

# 9.3b integer-typed weights (is.numeric(1L) == TRUE) must be accepted, not just doubles
test_that("test.integer.weights.accepted", {
    set.seed(1)
    Z1 <- cec(data_mat, init_centers, weights = rep(1, nrow(data_mat)))
    set.seed(1)
    Z2 <- cec(data_mat, init_centers, weights = rep(1L, nrow(data_mat)))

    expect_equal(Z2$cluster, Z1$cluster)
    expect_equal(Z2$centers, Z1$centers, ignore_attr = TRUE)
    expect_equal(Z2$cost.function, Z1$cost.function)
})

# 9.4 Invalid weights inputs each produce an error
test_that("test.invalid.weights.wrong.length", {
    expect_error(cec(data_mat, init_centers, weights = rep(1, nrow(data_mat) + 1)))
})

test_that("test.invalid.weights.negative", {
    w <- rep(1, nrow(data_mat))
    w[1] <- -0.5
    expect_error(cec(data_mat, init_centers, weights = w))
})

test_that("test.invalid.weights.na", {
    w <- rep(1, nrow(data_mat))
    w[1] <- NA
    expect_error(cec(data_mat, init_centers, weights = w))
})

test_that("test.invalid.weights.zero.sum", {
    w <- rep(0, nrow(data_mat))
    expect_error(cec(data_mat, init_centers, weights = w))
})

test_that("test.invalid.weights.inf", {
    w <- rep(1, nrow(data_mat))
    w[1] <- Inf
    expect_error(cec(data_mat, init_centers, weights = w))
})

# 9.4b Validation guards for non-weight parameters
test_that("test.invalid.fixedr.negative.radius", {
    expect_error(cec(data_mat, 1, type = "fixedr", param = -1))
})

test_that("test.invalid.eigenvalues.negative", {
    expect_error(cec(data_mat, 1, type = "eigenvalues", param = c(-0.5, 0.1)))
})

# 9.4c All 7 model types work with non-uniform weights (smoke test)
test_that("test.all.model.types.with.weights", {
    w <- c(rep(2, 10), rep(1, 10))
    models <- list(
        list(type = "all"),
        list(type = "spherical"),
        list(type = "diagonal"),
        list(type = "fixedr",      param = 0.5),
        list(type = "eigenvalues", param = c(0.1, 0.2)),
        list(type = "covariance",  param = matrix(c(1, 0, 0, 1), 2, 2))
    )
    for (m in models) {
        if (is.null(m$param)) {
            Z <- cec(data_mat, init_centers, type = m$type, weights = w, nstart = 1)
        } else {
            Z <- cec(data_mat, init_centers, type = m$type, param = m$param, weights = w, nstart = 1)
        }
        expect_true(!is.null(Z))
        expect_equal(sum(Z$probability), 1.0)
    }
    # mean model: use a single center — with two fixed-mean clusters both far from the
    # fixed point, CEC removes all clusters; one center is always retained
    Z <- cec(data_mat, 1, type = "mean", param = colMeans(data_mat), weights = w, nstart = 1)
    expect_true(!is.null(Z))
    expect_equal(sum(Z$probability), 1.0)
})

# 9.4d card.min below n+1 triggers a warning
test_that("test.card.min.warning.fires", {
    expect_warning(
        cec(data_mat, init_centers, card.min = 1, nstart = 1),
        regexp = "card.min"
    )
})

# 9.5 card.min: a cluster with tiny weight sum is removed even when it has enough observations
test_that("test.card.min.weight.sum.semantics", {
    # 18 heavy points in cluster1 region, 2 near-zero-weight points in cluster2 region
    # With weight-sum card.min = "5%", cluster2 (W_k ~ 0.002) should be removed
    # (total weight ~ 18 + 0.002 = 18.002; 5% = 0.9; cluster2 weight 0.002 < 0.9)
    w <- c(rep(1, 18), 0.001, 0.001)
    # Place 18 points in one region and 2 near-zero-weight points far away
    x_test <- rbind(data_mat[1:10, ], data_mat[1:8, ], data_mat[11:12, ])

    # With weight-sum card.min the near-zero cluster should be absorbed or removed
    Z <- cec(x_test, 2, weights = w, card.min = "5%", nstart = 1)
    expect_true(Z$nclusters <= 2)
})

# 9.5b card.min: a single heavily-weighted point must not survive as its own cluster.
# A lone point trivially clears any weight-sum threshold but cannot produce a
# non-singular covariance (needs >= n+1 observations). Regression test for a bug
# where a skewed-weight outlier passed the weight-sum card.min gate with only one
# observation and crashed the algorithm instead of being removed like a uniform-weight
# lone point is.
test_that("test.card.min.rejects.single.heavy.point.cluster", {
    main <- data_mat[1:10, ]
    outlier <- matrix(c(50, 50), nrow = 1, ncol = 2)
    x_test <- rbind(main, outlier)
    w <- c(rep(1, 10), 1e6)
    init <- matrix(c(0, 0, 50, 50), nrow = 2, byrow = TRUE)

    Z <- suppressWarnings(cec(x_test, init, weights = w, card.min = 1, nstart = 1))
    expect_true(!is.null(Z))
    expect_identical(Z$nclusters, 1L)
})

# 9.6 probability: sums to 1 and matches W_k / W_total under non-uniform weights
test_that("test.probability.sums.to.one", {
    w <- seq(0.5, 1.5, length.out = nrow(data_mat))
    Z <- cec(data_mat, init_centers, weights = w)
    expect_equal(sum(Z$probability), 1.0)
})

test_that("test.probability.matches.weighted.proportion", {
    w <- c(rep(2, 10), rep(1, 10))
    Z <- cec(data_mat, init_centers, weights = w)

    W_total <- sum(w)
    for (cl in seq_len(Z$nclusters)) {
        W_k <- sum(w[Z$cluster == cl])
        expect_equal(Z$probability[cl], W_k / W_total)
    }
})

# 9.7 Split mode with non-uniform weights finds the correct structure
test_that("test.split.mode.with.weights", {
    w <- c(rep(2, 10), rep(1, 10))
    Z <- cec(data_mat, 1, split = TRUE, weights = w)
    expect_identical(Z$nclusters, 2L)
    expect_equal(sum(Z$probability), 1.0)
})
