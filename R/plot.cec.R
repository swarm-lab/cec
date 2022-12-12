#' @title Plot CEC Objects
#'
#' @description \code{plot.cec} presents the results from the \code{\link{cec}}
#'  function in the form of a plot. The colors of the data points represent the
#'  cluster they belong to. Ellipses are drawn to represent the covariance
#'  (of either the model or the sample) of each cluster.
#'
#' @param x A \code{\link{cec}} object resulting from the \code{\link{cec}}
#'  function.
#'
#' @param col A specification for the default plotting color of the points in 
#'  the clusters. See \code{\link{par}} for more details.
#' 
#' @param cex A numerical value giving the amount by which plotting text and 
#'  symbols should be magnified relative to the default. See \code{\link{par}} 
#'  for more details. 
#' 
#' @param pch Either an integer specifying a symbol or a single character to be 
#'  used as the default in plotting points. See \code{\link{par}} for more 
#'  details. 
#' 
#' @param cex.centers The same as \code{cex}, except that it applies only to the 
#'  centers' means.
#' 
#' @param pch.centers The same as \code{pch}, except that it applies only to the 
#'  centers' means.
#'  
#' @param ellipses If this parameter is TRUE, covariance ellipses will be drawn.
#'
#' @param ellipses.lwd The line width of the covariance ellipses. See \code{lwd}
#'  in \code{\link{par}} for more details.
#'  
#' @param ellipses.lty The line type of the covariance ellipses. See \code{lty}
#'  in \code{\link{par}} for more details.
#' 
#' @param model If this parameter is TRUE, the model (expected) covariance will
#'  be used for each cluster instead of the sample covariance (MLE) of the 
#'  points in the cluster, when drawing the covariance ellipses.
#' 
#' @param xlab A label for the x axis. See \link{plot} for more details.
#' 
#' @param ylab A label for the y axis. See \link{plot} for more details.
#' 
#' @param ... Additional arguments passed to \code{plot} when drawing data 
#'  points.
#' 
#' @return This function returns nothing.
#' 
#' @seealso \code{\link{cec}}, \code{\link{print.cec}}
#' 
#' @keywords hplot
#' 
#' @examples
#' ## See the examples provided with the cec() function.
#'
#' @export
plot.cec <- function(x, col, cex = 0.5, pch = 19, cex.centers = 1, 
                     pch.centers = 8, ellipses = TRUE, ellipses.lwd = 4, 
                     ellipses.lty = 2, model = TRUE, xlab, ylab, ...) {
    if (ncol(x$data) != 2) {
        stop("Plotting is available only for 2-dimensional data.")
    }
    
    if (!methods::hasArg(col)) {
        col <- x$cluster
    }
    
    if (!is.null(colnames(x$data))) {
        xl <- colnames(x$data)[1]
        yl <- colnames(x$data)[2]
    }  else {
        xl <- "x"
        yl <- "y"
    }
    
    if (methods::hasArg(xlab)) {
        xl <- xlab
    }
    
    if (methods::hasArg(ylab)) {
        yl <- ylab
    }
    
    plot(x$data, col = col, cex = cex, pch = pch, xlab = xl, ylab = yl, ...)
    
    if (model) {
        covs <- x$covariances.model
        means <- x$means.model
    } else {
        covs <- x$covariances
        means <- x$centers
    }
    
    graphics::points(x$means.model, cex = cex.centers, pch = pch.centers)   
    
    if (ellipses) {    
        for (i in 1:nrow(means))     
            if (!is.na(means[i, 1])) {         
                tryCatch({
                    cov <- covs[[i]]
                    pts <- ellipse(means[i, ], cov)
                    graphics::lines(pts, lwd = ellipses.lwd, lty = ellipses.lty)
                },
                finally = {})
            }
    }  
}
