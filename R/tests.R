#' @title Tests
#' 
#' @description Internal function to run tests on the output of \code{\link{cec}}.
#'  
#' @noRd
run.cec.tests <- function() {
    errors <- 0
    tests <- list.files(system.file("cec_tests", package = "CEC"))
    
    for (test in tests) {
        if (grepl(".R", test, perl = TRUE)) {
            testenv <- new.env()
            
            local({
                # Just to trick R CMD check...
                testname <- NULL
                setup <- NULL
            },
            testenv) 
            
            source(system.file("cec_tests", test, package = "CEC"), local = testenv)
            
            errors <- errors + local({
                local.errors <- 0
                cat(paste("Test:", testname, "\n"))        
                fs <- utils::lsf.str()        
                
                # Execute setup function if exists
                if ("setup" %in% fs) {
                    eval(expr = body(setup), envir = testenv)
                }      
                
                for (fn in fs) {
                    # Test cases 
                    if (grepl("test.", fn)) {      
                        cat(paste("---- ", fn))              
                        fbody <- body(eval(parse(text = fn)))
                        
                        # Evaluate test case function and catch (and count) errors
                        local.errors <- local.errors + tryCatch({                  
                            eval(expr = fbody, envir = testenv)
                            cat(": OK\n")
                            0
                        },
                        error = function(er) {                  
                            cat(": FAILED\n")
                            warning(er$message, immediate. = TRUE, call. = FALSE)
                            1
                        })             
                    }
                }
                
                local.errors
            },
            envir = testenv)}
    }
    
    if (errors > 0) {
        stop("One or more tests failed.")
    }
}


#' @title Print Message
#' 
#' @description Internal function to print messages.
#'  
#' @noRd
printmsg <- function(msg) {    
    if (!is.null(msg))
        paste(msg, ":")
    else ""      
}


#' @title Check Equality of Numeric Vectors
#' 
#' @description Internal function to check whether numeric vectors are equal
#'  enough.
#'  
#' @noRd
checkNumericVectorEquals <- function(ex, ac, msg = NULL, 
                                     tolerance = .Machine$double.eps ^ 0.5) {  
    if (length(ex) != length(ac)) {
        stop (paste(printmsg(msg), "The vectors have different lengths."))
    }
    
    for (i in seq(1, length(ex))) {      
        if (!isTRUE(all.equal.numeric(ex[i], ac[i], tolerance = tolerance))) {
            stop(paste(printmsg(msg), "The vectors differ at index:", i, 
                       ", expected:", ex[i], ", actual:", ac[i]))
        }
    }
}


#' @title Check Equality of Numeric Values
#' 
#' @description Internal function to check whether numeric values are equal
#'  enough.
#'  
#' @noRd
checkNumericEquals <- function(ex, ac, msg = NULL, 
                               tolerance = .Machine$double.eps ^ 0.5) {
    if(!is.numeric(ex)) {
        stop(paste(printmsg(msg), "The expression:", ex, "is not of numeric type."))
    }
    
    if(!is.numeric(ac)) {
        stop(paste(printmsg(msg), "The expression:", ac, "is not of numeric type."))
    }
    
    if (!isTRUE(all.equal.numeric(ex, ac, tolerance=tolerance))) {
        stop (paste(printmsg(msg), "The numeric values are different: expected:", 
                    ex, ", actual:", ac, ", difference:", abs(ex - ac)))
    }
}


#' @title Check Equality of Values
#' 
#' @description Internal function to check whether values are equal enough.
#'  
#' @noRd
checkEquals <- function(ex, ac, msg = NULL) {
    if (!isTRUE(identical(ex, ac))) {
        stop (paste(printmsg(msg), "The values are not identical: expected:", ex, 
                    ", actual:", ac))
    }
}


#' @title Check Thruthiness
#' 
#' @description Internal function to check whether an expression is truly true.
#'  
#' @noRd
checkTrue <- function(exp, msg = NULL) {
    if (!is.logical(exp)) {
        stop(paste(printmsg(msg), "The expression is not of logical type."))
    }
    
    if (!isTRUE(exp)) {
        stop(paste(printmsg(msg), "The expression is not TRUE."))
    }
}


#' @title Check Equality of Numeric Matrices
#' 
#' @description Internal function to check whether numeric matrices are equal
#'  enough.
#'  
#' @noRd
checkNumericMatrixEquals <- function(ex, ac, msg = NULL, 
                                     tolerance = .Machine$double.eps ^ 0.5) {
    
    if (nrow(ex) != nrow(ac)) {
        stop (paste(printmsg(msg), "The matrices have different dimensions."))
    }
    
    if (ncol(ex) != ncol(ac)) {
        stop (paste(printmsg(msg), "The matrices have different dimensions."))
    }
    
    for (i in seq(1, nrow(ex))){
        for (j in seq(1, ncol(ex))) {
            if (!isTRUE(all.equal.numeric(ex[i, j], ac[i, j], tolerance=tolerance))) {
                stop (paste(printmsg(msg), "The matrices differ at row:", i, " col:", 
                            j, ": expected:", ex[i, j], ", actual:",ac[i, j]))
            }
        }
    }
}


#' @title Maximum Likelihood of Covariance Matrix
#' 
#' @description Internal function to compute the maximum likelihood estimate of 
#'  a covariance matrix.
#'  
#' @noRd
cov.mle <- function(M) {
    mean <- colMeans(M)
    mat <- matrix(0, ncol(M), ncol(M))
    
    for (i in seq(1, nrow(M))) {
        v <- M[i,]   
        mat <- mat + (t(t(v - mean)) %*% t(v - mean))
    }
    
    mat / nrow(M)
}
