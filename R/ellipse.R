#' @title Ellipse
#' 
#' @description Internal function to compute points on an ellipse's perimeter 
#'  for a given mean vector and covariance matrix.
#' 
#' @noRd
ellipse <- function(mean, cov, npoints = 250) {
    E <- eigen(cov, symmetric = TRUE)
    eve <- E$vec
    eva <- E$val
    r <- seq(-pi, pi, len = npoints)
    Xa <- 2 * sqrt(eva[1]) * cos(r)
    Ya <- 2 * sqrt(eva[2]) * sin(r)
    mm <- c(rep(mean[1], npoints), rep(mean[2], npoints))
    means.multiplied <- matrix(mm, nrow = length(Ya), ncol = 2)
    pts <- cbind(Xa,Ya)
    pts <- pts %*% eve
    pts[, 1] <- pts[, 1] * -1
    pts <- pts + means.multiplied
    pts
}
