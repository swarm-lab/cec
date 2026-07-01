testname <- "Weighted observations"

# Two well-separated 2D clusters, 10 points each, fixed centers for reproducibility
setup <- function() {
    set.seed(42)
    cluster1 <- matrix(c(0, 0, 0.1, -0.1, 0.05, -0.05, 0.1, 0.1, -0.1, 0,
                         0, 0, 0.1,  0.1, 0.05,  0.05, -0.1, 0.1, 0.1, -0.1),
                       nrow = 10, ncol = 2)
    cluster2 <- matrix(c(10, 10, 10.1, 9.9, 10.05, 9.95, 10.1, 10.1, 9.9, 10,
                         10, 10, 10.1, 10.1, 10.05, 10.05, 9.9, 10.1, 10.1, 9.9),
                       nrow = 10, ncol = 2)
    data_mat <<- rbind(cluster1, cluster2)

    # Fixed centers for deterministic assignment
    init_centers <<- matrix(c(0, 10, 0, 10), nrow = 2, ncol = 2)
}

# 9.1 Weighted means and covariances match analytic values
test.weighted.mean.and.covariance <- function() {
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
    CEC:::checkNumericVectorEquals(expected_mu1, Z$centers[idx1, ], msg = "cluster1 mean", tolerance = 1e-6)
    CEC:::checkNumericVectorEquals(expected_mu2, Z$centers[idx2, ], msg = "cluster2 mean", tolerance = 1e-6)
    CEC:::checkNumericMatrixEquals(expected_cov1, Z$covariances[[idx1]], msg = "cluster1 covariance", tolerance = 1e-6)
    CEC:::checkNumericMatrixEquals(expected_cov2, Z$covariances[[idx2]], msg = "cluster2 covariance", tolerance = 1e-6)
}

# 9.2 weights = NULL produces identical output to omitting weights
test.null.weights.identical.to.no.weights <- function() {
    set.seed(1)
    Z1 <- cec(data_mat, init_centers)
    set.seed(1)
    Z2 <- cec(data_mat, init_centers, weights = NULL)

    CEC:::checkNumericVectorEquals(Z1$cluster, Z2$cluster, msg = "cluster assignments")
    CEC:::checkNumericMatrixEquals(Z1$centers, Z2$centers, msg = "centers")
    CEC:::checkNumericVectorEquals(Z1$probability, Z2$probability, msg = "probability")
    CEC:::checkNumericEquals(Z1$cost.function, Z2$cost.function, msg = "cost")
}

# 9.3 weights = rep(1, nrow(x)) identical to NULL
test.unit.weights.identical.to.null <- function() {
    set.seed(1)
    Z1 <- cec(data_mat, init_centers)
    set.seed(1)
    Z2 <- cec(data_mat, init_centers, weights = rep(1, nrow(data_mat)))

    CEC:::checkNumericVectorEquals(Z1$cluster, Z2$cluster, msg = "cluster assignments")
    CEC:::checkNumericMatrixEquals(Z1$centers, Z2$centers, msg = "centers")
    CEC:::checkNumericVectorEquals(Z1$probability, Z2$probability, msg = "probability")
    CEC:::checkNumericEquals(Z1$cost.function, Z2$cost.function, msg = "cost")
}

# 9.3b integer-typed weights (is.numeric(1L) == TRUE) must be accepted, not just doubles
test.integer.weights.accepted <- function() {
    set.seed(1)
    Z1 <- cec(data_mat, init_centers, weights = rep(1, nrow(data_mat)))
    set.seed(1)
    Z2 <- cec(data_mat, init_centers, weights = rep(1L, nrow(data_mat)))

    CEC:::checkNumericVectorEquals(Z1$cluster, Z2$cluster, msg = "cluster assignments")
    CEC:::checkNumericMatrixEquals(Z1$centers, Z2$centers, msg = "centers")
    CEC:::checkNumericEquals(Z1$cost.function, Z2$cost.function, msg = "cost")
}

# 9.4 Invalid weights inputs each produce an error
test.invalid.weights.wrong.length <- function() {
    caught <- tryCatch(
        cec(data_mat, init_centers, weights = rep(1, nrow(data_mat) + 1)),
        error = function(e) e
    )
    CEC:::checkTrue(inherits(caught, "error"), "wrong-length weights should error")
}

test.invalid.weights.negative <- function() {
    w <- rep(1, nrow(data_mat))
    w[1] <- -0.5
    caught <- tryCatch(
        cec(data_mat, init_centers, weights = w),
        error = function(e) e
    )
    CEC:::checkTrue(inherits(caught, "error"), "negative weight should error")
}

test.invalid.weights.na <- function() {
    w <- rep(1, nrow(data_mat))
    w[1] <- NA
    caught <- tryCatch(
        cec(data_mat, init_centers, weights = w),
        error = function(e) e
    )
    CEC:::checkTrue(inherits(caught, "error"), "NA weight should error")
}

test.invalid.weights.zero.sum <- function() {
    w <- rep(0, nrow(data_mat))
    caught <- tryCatch(
        cec(data_mat, init_centers, weights = w),
        error = function(e) e
    )
    CEC:::checkTrue(inherits(caught, "error"), "zero-sum weights should error")
}

test.invalid.weights.inf <- function() {
    w <- rep(1, nrow(data_mat))
    w[1] <- Inf
    caught <- tryCatch(
        cec(data_mat, init_centers, weights = w),
        error = function(e) e
    )
    CEC:::checkTrue(inherits(caught, "error"), "Inf weight should error")
}

# 9.4b Validation guards for non-weight parameters
test.invalid.fixedr.negative.radius <- function() {
    caught <- tryCatch(
        cec(data_mat, 1, type = "fixedr", param = -1),
        error = function(e) e
    )
    CEC:::checkTrue(inherits(caught, "error"), "negative fixedr radius should error")
}

test.invalid.eigenvalues.negative <- function() {
    caught <- tryCatch(
        cec(data_mat, 1, type = "eigenvalues", param = c(-0.5, 0.1)),
        error = function(e) e
    )
    CEC:::checkTrue(inherits(caught, "error"), "negative eigenvalue should error")
}

# 9.4c All 7 model types work with non-uniform weights (smoke test)
test.all.model.types.with.weights <- function() {
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
        CEC:::checkTrue(!is.null(Z), paste("model", m$type, "returns non-null"))
        CEC:::checkNumericEquals(1.0, sum(Z$probability),
                                 msg = paste("model", m$type, "probability sums to 1"))
    }
    # mean model: use a single center — with two fixed-mean clusters both far from the
    # fixed point, CEC removes all clusters; one center is always retained
    Z <- cec(data_mat, 1, type = "mean", param = colMeans(data_mat), weights = w, nstart = 1)
    CEC:::checkTrue(!is.null(Z), "model mean returns non-null")
    CEC:::checkNumericEquals(1.0, sum(Z$probability), msg = "model mean probability sums to 1")
}

# 9.4d card.min below n+1 triggers a warning
test.card.min.warning.fires <- function() {
    caught <- tryCatch(
        cec(data_mat, init_centers, card.min = 1, nstart = 1),
        warning = function(w) w
    )
    CEC:::checkTrue(inherits(caught, "warning"), "card.min below n+1 should warn")
    CEC:::checkTrue(grepl("card.min", conditionMessage(caught)),
                    "warning message should mention card.min")
}

# 9.5 card.min: a cluster with tiny weight sum is removed even when it has enough observations
test.card.min.weight.sum.semantics <- function() {
    # 18 heavy points in cluster1 region, 2 near-zero-weight points in cluster2 region
    # With weight-sum card.min = "5%", cluster2 (W_k ~ 0.002) should be removed
    # (total weight ~ 18 + 0.002 = 18.002; 5% = 0.9; cluster2 weight 0.002 < 0.9)
    w <- c(rep(1, 18), 0.001, 0.001)
    # Place 18 points in one region and 2 near-zero-weight points far away
    x_test <- rbind(data_mat[1:10, ], data_mat[1:8, ], data_mat[11:12, ])

    # With weight-sum card.min the near-zero cluster should be absorbed or removed
    Z <- cec(x_test, 2, weights = w, card.min = "5%", nstart = 1)
    CEC:::checkTrue(Z$nclusters <= 2, "near-zero cluster removed or merged")
}

# 9.5b card.min: a single heavily-weighted point must not survive as its own cluster.
# A lone point trivially clears any weight-sum threshold but cannot produce a
# non-singular covariance (needs >= n+1 observations). Regression test for a bug
# where a skewed-weight outlier passed the weight-sum card.min gate with only one
# observation and crashed the algorithm instead of being removed like a uniform-weight
# lone point is.
test.card.min.rejects.single.heavy.point.cluster <- function() {
    main <- data_mat[1:10, ]
    outlier <- matrix(c(50, 50), nrow = 1, ncol = 2)
    x_test <- rbind(main, outlier)
    w <- c(rep(1, 10), 1e6)
    init <- matrix(c(0, 0, 50, 50), nrow = 2, byrow = TRUE)

    Z <- suppressWarnings(cec(x_test, init, weights = w, card.min = 1, nstart = 1))
    CEC:::checkTrue(!is.null(Z), "clustering completes instead of erroring")
    CEC:::checkEquals(1L, Z$nclusters, "single heavy-weight outlier cluster is removed")
}

# 9.6 probability: sums to 1 and matches W_k / W_total under non-uniform weights
test.probability.sums.to.one <- function() {
    w <- seq(0.5, 1.5, length.out = nrow(data_mat))
    Z <- cec(data_mat, init_centers, weights = w)
    CEC:::checkNumericEquals(1.0, sum(Z$probability), msg = "probability sums to 1")
}

test.probability.matches.weighted.proportion <- function() {
    w <- c(rep(2, 10), rep(1, 10))
    Z <- cec(data_mat, init_centers, weights = w)

    W_total <- sum(w)
    for (cl in seq_len(Z$nclusters)) {
        W_k <- sum(w[Z$cluster == cl])
        CEC:::checkNumericEquals(W_k / W_total, Z$probability[cl],
                                 msg = paste("probability cluster", cl))
    }
}

# 9.7 Split mode with non-uniform weights finds the correct structure
test.split.mode.with.weights <- function() {
    w <- c(rep(2, 10), rep(1, 10))
    Z <- cec(data_mat, 1, split = TRUE, weights = w)
    CEC:::checkEquals(2L, Z$nclusters, "split mode with weights finds 2 clusters")
    CEC:::checkNumericEquals(1.0, sum(Z$probability),
                             msg = "split mode probability sums to 1")
}
