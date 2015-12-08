# functions to deal with covariates

# force interactive covariates into the additive covariate matrix
#
# addcovar and intcovar are two matrices
# intcovar columns should all be within the addcovar columns
# tol is tolerance for determining matching columns
force_intcovar <-
    function(addcovar=NULL, intcovar=NULL, tol=1e-12)
{
    if(is.null(intcovar)) # no intcovar, so return addcovar w/o change
        return(addcovar)

    if(is.null(addcovar)) # no addcovar, so just return intcovar
        return(intcovar)

    if(!is.matrix(addcovar)) addcovar <- as.matrix(addcovar)
    if(!is.matrix(intcovar)) intcovar <- as.matrix(intcovar)

    stopifnot(nrow(addcovar) == nrow(intcovar))
    n.addcovar <- ncol(addcovar)
    n.intcovar <- ncol(intcovar)

    # look for matching columns
    full <- cbind(addcovar, intcovar)
    has_match <- find_matching_cols(full, tol)
    if(any(has_match > 0))
        full <- full[, has_match<0, drop=FALSE]

    if(ncol(full)==0) return(NULL)

    full
}

# drop linearly dependent columns
# if intercept=TRUE, add intercept before checking and then remove afterwards
drop_depcols <-
    function(covar=NULL, intercept=FALSE, tol=1e-12)
{
    if(is.null(covar)) return(covar)

    if(any(is.na(covar)))
        stop("covar shouldn't contain missing values")

    if(!is.matrix(covar)) covar <- as.matrix(covar)
    if(intercept) covar <- cbind(rep(1, nrow(covar)), covar)

    if(ncol(covar) <= 1) return(covar)

    depcols <- sort(find_lin_indep_cols(covar, tol))
    if(intercept) {
        if(depcols[1] != 1)
            message("oops in drop_depcols; I figured the intercept would always be included.")
        depcols <- depcols[-1]
    }
    if(length(depcols)==0) return(NULL)

    covar[, depcols, drop=FALSE]
}

# drop columns from X covariates that are already in addcovar
drop_xcovar <-
    function(covar=NULL, Xcovar=NULL, tol=1e-12)
{
    if(is.null(Xcovar) || is.null(covar)) return(Xcovar)

    if(!is.matrix(covar)) covar <- as.matrix(covar)
    if(!is.matrix(Xcovar)) Xcovar <- as.matrix(Xcovar)

    stopifnot(nrow(covar) == nrow(Xcovar))

    # find columns that match a previous column
    matches <- find_matching_cols(cbind(covar, Xcovar), tol)[-(1:ncol(covar))]

    if(all(matches > 0)) return(NULL)

    # drop the columns with matches
    Xcovar[,matches<0,drop=FALSE]
}