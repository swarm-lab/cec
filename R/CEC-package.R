#' @title Cross-Entropy Clustering
#'
#' @description CEC divides data into Gaussian type clusters. The implementation
#'  allows the simultaneous use of various type Gaussian mixture models,
#'  performs the reduction of unnecessary clusters and it's able to discover new
#'  groups. Based on Spurek, P. and Tabor, J. (2014) <doi:10.1016/j.patcog.2014.03.006>
#'  \code{cec}.
#'
#' @name CEC-package
#' 
#' @docType package
#' 
#' @author Konrad Kamieniecki
#' 
#' @seealso \code{\link{cec}}
#' 
#' @keywords package multivariate cluster models
#' 
NULL


#' @title Four Gaussian Clusters
#'
#' @description Matrix of 2-dimensional points forming four Gaussian clusters.
#'
#' @name fourGaussians
#' 
#' @docType data
#' 
#' @keywords datasets
#' 
#' @examples
#' data(fourGaussians)
#' plot(fourGaussians, cex = 0.5, pch = 19);
#'
NULL


#' @title Three Gaussian Clusters
#'
#' @description Matrix of 2-dimensional points forming three Gaussian clusters.
#'
#' @name threeGaussians
#' 
#' @docType data
#' 
#' @keywords datasets
#' 
#' @examples
#' data(threeGaussians)
#' plot(threeGaussians, cex = 0.5, pch = 19);
#'
NULL


#' @title Mixed Shapes Clusters 
#'
#' @description Matrix of 2-dimensional points that form circular and elliptical 
#'  patterns.
#'
#' @name mixShapes
#' 
#' @docType data
#' 
#' @keywords datasets
#' 
#' @examples
#' data(mixShapes)
#' plot(mixShapes, cex = 0.5, pch = 19);
#'
NULL


#' @title T-Shaped Clusters
#'
#' @description Matrix of 2-dimensional points that form the letter T.
#'
#' @name Tset
#' 
#' @docType data
#' 
#' @keywords datasets
#' 
#' @examples
#' data(Tset)
#' plot(Tset, cex = 0.5, pch = 19);
#'
NULL
