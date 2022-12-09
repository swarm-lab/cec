#' @title Cluster Center Initialization
#' 
#' @description \code{init.centers} automatically initializes the centers of the
#'  clusters before running the Cross-Entropy Clustering algorithm.
#'  
#' @param x A numeric matrix of data. Each row corresponds to a distinct
#'  observation; each column corresponds to a distinct variable/dimension. It
#'  must not contain \code{NA} values.
#' 
#' @param k An integer indicating the number of cluster centers to initialize. 
#' 
#' @param method A character string indicating the initialization method to use. 
#'  It can take the following values:
#'  \itemize{
#'   \item{"kmeans++": }{the centers are selected using the k-means++ algorithm.
#'    }
#'   \item{"random": }{the centers are randomly selected among the values in
#'    \code{x}}
#'  }
#' 
#' @return A matrix with \code{k} rows and \code{ncol(x)} columns.
#' 
#' @references Arthur, D., & Vassilvitskii, S. (2007). k-means++: the advantages 
#'  of careful seeding. Proceedings of the Eighteenth Annual ACM-SIAM Symposium 
#'  on Discrete Algorithms, 1027–1035.
#' 
#' @examples
#' ## See the examples provided with the cec() function.
#' 
#' @export
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
