#' @title Ball
#' 
#' @description Internal function to generate a cluster of points uniformly 
#'  distributed inside a disc.
#'  
#' @noRd
ball <- function(n = 4000, r = 1, dim = 2) { 
    M <- matrix(0, n, dim)
    count <- 0;
    rr <- r ^ 2
    while (count < n) {
        p <- stats::runif(dim, -r, r)
        
        if (sum(p ^ 2) <= rr) {
            count <- count + 1
            M[count, ] <- p
        }      
    }
    
    M
}


#' @title Volume of a Ball
#' 
#' @description Internal function to compute the volume of a ball in \code{n}
#'  dimensions. 
#' 
#' @noRd
nballvolume <- function(r, n)  {
    k <- as.integer(n / 2)
    
    if (n %% 2 == 0) {
        pi ^ k / factorial(k) * r ^ n
    } else {
        2 * factorial(k) * (4 * pi) ^ k / factorial(n) * r ^ n
    }
}


#' @title Mouse
#' 
#' @description \code{mouseset} generates a cluster of points uniformly 
#'  distributed inside a "mouse head" shape. 
#'  
#' @param n The number of points (default: 4000). 
#' 
#' @param r.head The radius of the mouse's head (default: 2). 
#' 
#' @param r.left.ear,r.right.ear The radii of the left and right ear of the 
#'  mouse's head (default: 1.1). 
#' 
#' @param left.ear.dist,right.ear.dist The distance between the center of the 
#'  mouse's head and the center of the left and right ear (default: 2.5).  
#' 
#' @param dim The dimensionality of the mouse's head (default: 2).
#' 
#' @return A matrix with \code{n} rows and \code{dim} columns. 
#' 
#' @examples
#' plot(mouseset())
#' 
#' @export
mouseset <- function(n = 4000, r.head = 2, r.left.ear = 1.1, r.right.ear = 1.1, 
                     left.ear.dist = 2.5, right.ear.dist = 2.5, dim = 2) {
    vh <- nballvolume(r.head, dim)
    vl <- nballvolume(r.left.ear, dim)
    vr <- nballvolume(r.right.ear, dim)
    
    if (dim < 2) {
        stop("Illegal argument: 'dim' must be strictly greater than 1.")
    }
    
    pos.h <- rep(0, dim)
    
    pos.l <- pos.h
    pos.r <- pos.h
    
    l.offset <- left.ear.dist / sqrt(2)
    r.offset <- right.ear.dist / sqrt(2)
    
    pos.l[1] <- pos.l[1] - l.offset
    pos.l[2] <- pos.l[2] + l.offset
    
    pos.r[1] <- pos.r[1] + r.offset
    pos.r[2] <- pos.r[2] + r.offset
    
    hh <- r.head ^ 2
    ll <- r.left.ear ^ 2
    rr <- r.right.ear ^ 2
    
    centers <- rbind(pos.h, pos.l, pos.r)
    rs <- c(r.head, r.left.ear, r.right.ear)
    rrs <- c(hh, ll, rr)
    
    M <- matrix(0, n, dim)  
    
    count <- 0
    
    while (count < n) {
        gen <- min(1000, n - count)
        s <- sample(x = c(1, 2, 3), size = gen, prob = c(vh, vl, vr), replace = TRUE)
        
        for (i in s) {
            r <- rs[i]
            random.p <- stats::runif(dim, -r, +r)
            p <- centers[i,] + random.p
            
            if (sum(random.p ^ 2) < rrs[i]) {
                if (i == 1) {
                    count <- count + 1
                    M[count, ] <- p
                } else if (i == 2) {
                    if (sum((p - pos.h) ^ 2) > hh && sum((p - pos.r) ^ 2) > rr) {
                        count <- count + 1
                        M[count,] <- p
                    }
                } else if (i == 3) {
                    if (sum((p - pos.h) ^ 2) > hh && sum((p - pos.l) ^ 2) > ll) { 
                        count <- count + 1
                        M[count,] <- p
                    }                   
                }
            }
        }   
    }
    
    M
}
