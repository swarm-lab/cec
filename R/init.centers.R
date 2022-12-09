#' @title Cluster Center Initialization
#' 
#' @description Internal function to automatically initialize the centers of the
#'  clusters before running the Cross-Entropy Clustering algorithm.
#' 
init.centers <- function(x, k, method = c("kmeans++", "random")) {
    method <- switch( 
        match.arg(method), 
        "kmeans++" = "kmeanspp", 
        "random" = "random",
        stop("Unknown intialization method."))
    
    if (!is.matrix(x)) {
        stop("init.centers: 'x' should be a matrix.")
    }
    
    if (k < 0) {
        stop("init.centers: 'k' should be greater than 0.")
    }

    .Call(cec_init_centers_r, x, as.integer(k), method)
}
