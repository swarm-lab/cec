cov.mle <- function(M) {
    mean <- colMeans(M)
    mat <- matrix(0, ncol(M), ncol(M))

    for (i in seq(1, nrow(M))) {
        v <- M[i,]
        mat <- mat + (t(t(v - mean)) %*% t(v - mean))
    }

    mat / nrow(M)
}
