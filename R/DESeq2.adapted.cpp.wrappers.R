#These functions were mostly extracted directly from the DEXSeq and DESeq2 source-code.
#
# Note that DEXSeq is licensed under the GPL v3, and DESeq2 is licensed under the LGPL v3. Therefore this
#   code packaged together is licensed under the GPL v3, as noted in the LICENSE file.
# Some code snippets are "united states government work" and thus cannot be
#   copyrighted. See the LICENSE file for more information.
#
# The current versions of the original functions upon which these were based can be found
#    here: http://github.com/Bioconductor-mirror/DESeq2
#         and
#    here: http://github.com/Bioconductor-mirror/DEXSeq
#
# Updated Authorship and license information can be found here:
#   here: http://github.com/Bioconductor-mirror/DESeq2/blob/master/DESCRIPTION
#         and
#   here: http://github.com/Bioconductor-mirror/DEXSeq/blob/master/DESCRIPTION

COMPILED_COMPONENTS_PACKAGE <- "JunctionSeq";

setJunctionSeqCompiledSourcePackage <- function(PACKAGE = c("JunctionSeq","DESeq2")){
  PACKAGE = match.arg(PACKAGE);
  if(PACKAGE == "DESeq2"){
    DESEQ2VERSTRING <- getNamespaceVersion("DESeq2");
    DESEQ2VER <- as.integer(strsplit(DESEQ2VERSTRING,".",fixed=TRUE)$version)
    if(DESEQ2VER[1] != 1){
      message("WARNING: JunctionSeq is NOT COMPATIBLE with the C++ binaries from DESeq2 v.",DESEQ2VERSTRING);
    } else if(DESEQ2VER[2] > 16){
      message("WARNING: JunctionSeq is NOT COMPATIBLE with the C++ binaries from DESeq2 v.",DESEQ2VERSTRING);
    }
  }
  COMPILED_COMPONENTS_PACKAGE <<- PACKAGE;
}

#From DESeq2:
# Fit dispersions for negative binomial GLM
#
# This function estimates the dispersion parameter (alpha) for negative binomial
# generalized linear models. The fitting is performed on the log scale.
#
# ySEXP n by m matrix of counts
# xSEXP m by k design matrix
# mu_hatSEXP n by m matrix, the expected mean values, given beta-hat
# log_alphaSEXP n length vector of initial guesses for log(alpha)
# log_alpha_prior_meanSEXP n length vector of the fitted values for log(alpha)
# log_alpha_prior_sigmasqSEXP a single numeric value for the variance of the prior
# min_log_alphaSEXP the minimum value of log alpha
# kappa_0SEXP a parameter used in calculting the initial proposal
#   for the backtracking search
#   initial proposal = log(alpha) + kappa_0 * deriv. of log lik. w.r.t. log(alpha)
# tolSEXP tolerance for convergence in estimates
# maxitSEXP maximum number of iterations
# use_priorSEXP boolean variable, whether to use a prior or just calculate the MLE
#
# return a list with elements: log_alpha, iter, iter_accept, last_change, initial_lp, intial_dlp, last_lp, last_dlp, last_d2lp
fitDispWrapper <- function (ySEXP, xSEXP, mu_hatSEXP, log_alphaSEXP, log_alpha_prior_meanSEXP,
                            log_alpha_prior_sigmasqSEXP, min_log_alphaSEXP, kappa_0SEXP,
                            tolSEXP, maxitSEXP, use_priorSEXP) {
  # test for any NAs in arguments
  arg.names <- names(formals(fitDispWrapper))
  na.test <- sapply(mget(arg.names), function(x) any(is.na(x)))
  if (any(na.test)) stop(paste("in call to fitDisp, the following arguments contain NA:",
                               paste(arg.names[na.test],collapse=", ")))
  fitDisp(ySEXP=ySEXP, xSEXP=xSEXP, mu_hatSEXP=mu_hatSEXP,
          log_alphaSEXP=log_alphaSEXP, log_alpha_prior_meanSEXP=log_alpha_prior_meanSEXP,
          log_alpha_prior_sigmasqSEXP=log_alpha_prior_sigmasqSEXP,
          min_log_alphaSEXP=min_log_alphaSEXP, kappa_0SEXP=kappa_0SEXP,
          tolSEXP=tolSEXP, maxitSEXP=maxitSEXP, use_priorSEXP=use_priorSEXP)
}



#From DESeq2:
# Fit beta coefficients for negative binomial GLM
#
# This function estimates the coefficients (betas) for negative binomial generalized linear models.
#
# ySEXP n by m matrix of counts
# xSEXP m by k design matrix
# nfSEXP n by m matrix of normalization factors
# alpha_hatSEXP n length vector of the disperion estimates
# contrastSEXP a k length vector for a possible contrast
# beta_matSEXP n by k matrix of the initial estimates for the betas
# lambdaSEXP k length vector of the ridge values
# tolSEXP tolerance for convergence in estimates
# maxitSEXP maximum number of iterations
# useQRSEXP whether to use QR decomposition
#
# Note: at this level the betas are on the natural log scale
fitBetaWrapper <- function (ySEXP, xSEXP, nfSEXP, alpha_hatSEXP, contrastSEXP,
                            beta_matSEXP, lambdaSEXP, tolSEXP, maxitSEXP, useQRSEXP) {
  if ( missing(contrastSEXP) ) {
    # contrast is not required, just give 1,0,0,...
    contrastSEXP <- c(1,rep(0,ncol(xSEXP)-1))
  }
  # test for any NAs in arguments
  arg.names <- names(formals(fitBetaWrapper))
  na.test <- sapply(mget(arg.names), function(x) any(is.na(x)))
  if (any(na.test)) stop(paste("in call to fitBeta, the following arguments contain NA:", paste(arg.names[na.test],collapse=", ")))
  
  fitBeta(ySEXP=ySEXP, xSEXP=xSEXP, nfSEXP=nfSEXP, alpha_hatSEXP=alpha_hatSEXP,
          contrastSEXP=contrastSEXP, beta_matSEXP=beta_matSEXP,
          lambdaSEXP=lambdaSEXP, tolSEXP=tolSEXP, maxitSEXP=maxitSEXP,
          useQRSEXP=useQRSEXP)
}


# Fit dispersions by evaluating over grid
#
# This function estimates the dispersion parameter (alpha) for negative binomial
# generalized linear models. The fitting is performed on the log scale.
#
# ySEXP n by m matrix of counts
# xSEXP m by k design matrix
# mu_hatSEXP n by m matrix, the expected mean values, given beta-hat
# disp_gridSEXP the grid over which to estimate
# log_alpha_prior_meanSEXP n length vector of the fitted values for log(alpha)
# log_alpha_prior_sigmasqSEXP a single numeric value for the variance of the prior
# use_priorSEXP boolean variable, whether to use a prior or just calculate the MLE
#
# return a list with elements: 
fitDispGridWrapper <- function(y, x, mu, logAlphaPriorMean,
                               logAlphaPriorSigmaSq, usePrior) {
  # test for any NAs in arguments
  arg.names <- names(formals(fitDispGridWrapper))
  na.test <- sapply(mget(arg.names), function(x) any(is.na(x)))
  if (any(na.test)) stop(paste("in call to fitDispGridWrapper, the following arguments contain NA:",
                               paste(arg.names[na.test],collapse=", ")))
  minLogAlpha <- log(1e-8)
  maxLogAlpha <- log(max(10, ncol(y)))
  dispGrid <- seq(from=minLogAlpha, to=maxLogAlpha, length=15)
  logAlpha <- fitDispGrid(ySEXP=y, xSEXP=x, mu_hatSEXP=mu, disp_gridSEXP=dispGrid,
                          log_alpha_prior_meanSEXP=logAlphaPriorMean,
                          log_alpha_prior_sigmasqSEXP=logAlphaPriorSigmaSq,
                          use_priorSEXP=usePrior)$log_alpha
  exp(logAlpha)
}


DESEQ2_HASNT_ECHOED_WARNING <- TRUE;
DESeq2.gt.1.14 <- function(){
  if(COMPILED_COMPONENTS_PACKAGE == "JunctionSeq"){
    return(TRUE);
  } else {
    out <- as.integer(strsplit(getNamespaceVersion("DESeq2"),".",fixed=TRUE)$version)[1] > 1 || 
           as.integer(strsplit(getNamespaceVersion("DESeq2"),".",fixed=TRUE)$version)[2] > 14;
    if(out && DESEQ2_HASNT_ECHOED_WARNING){
      DESEQ2_HASNT_ECHOED_WARNING <- FALSE;
      message("NOTE: Autodetected DESeq2 v1.15+. Adding simple weights to C++ function calls.");
    }
    return(out);
  }
}


fitDisp <- function(ySEXP, xSEXP, mu_hatSEXP, log_alphaSEXP, log_alpha_prior_meanSEXP, log_alpha_prior_sigmasqSEXP, min_log_alphaSEXP, kappa_0SEXP, tolSEXP, maxitSEXP, use_priorSEXP) {  
  if(DESeq2.gt.1.14()){
    useWeightsSEXP <- FALSE
    weightsSEXP <- matrix(1, nrow=nrow(ySEXP), ncol=ncol(ySEXP))
    .Call('DESeq2_fitDisp', PACKAGE = COMPILED_COMPONENTS_PACKAGE, ySEXP, xSEXP, mu_hatSEXP, log_alphaSEXP, log_alpha_prior_meanSEXP, log_alpha_prior_sigmasqSEXP, min_log_alphaSEXP, kappa_0SEXP, tolSEXP, maxitSEXP, use_priorSEXP, weightsSEXP, useWeightsSEXP)
  } else {
    .Call('DESeq2_fitDisp', PACKAGE = COMPILED_COMPONENTS_PACKAGE, ySEXP, xSEXP, mu_hatSEXP, log_alphaSEXP, log_alpha_prior_meanSEXP, log_alpha_prior_sigmasqSEXP, min_log_alphaSEXP, kappa_0SEXP, tolSEXP, maxitSEXP, use_priorSEXP)
  }
  
}

fitBeta <- function(ySEXP, xSEXP, nfSEXP, alpha_hatSEXP, contrastSEXP, beta_matSEXP, lambdaSEXP, tolSEXP, maxitSEXP, useQRSEXP) {
  if(DESeq2.gt.1.14()){
    useWeightsSEXP <- FALSE
    weightsSEXP <- matrix(1, nrow=nrow(ySEXP), ncol=ncol(ySEXP))
    .Call('DESeq2_fitBeta', PACKAGE = COMPILED_COMPONENTS_PACKAGE, ySEXP, xSEXP, nfSEXP, alpha_hatSEXP, contrastSEXP, beta_matSEXP, lambdaSEXP, weightsSEXP, useWeightsSEXP, tolSEXP, maxitSEXP, useQRSEXP)
  } else {
    .Call('DESeq2_fitBeta', PACKAGE = COMPILED_COMPONENTS_PACKAGE, ySEXP, xSEXP, nfSEXP, alpha_hatSEXP, contrastSEXP, beta_matSEXP, lambdaSEXP, tolSEXP, maxitSEXP, useQRSEXP)
  }
}

#rlogGrid <- function(ySEXP, nfSEXP, betaSEXP, alphaSEXP, interceptSEXP, bgridSEXP, betapriorvarSEXP) {
#    .Call('DESeq2_rlogGrid', PACKAGE = COMPILED_COMPONENTS_PACKAGE, ySEXP, nfSEXP, betaSEXP, alphaSEXP, interceptSEXP, bgridSEXP, betapriorvarSEXP)
#}

fitDispGrid <- function(ySEXP, xSEXP, mu_hatSEXP, disp_gridSEXP, log_alpha_prior_meanSEXP, log_alpha_prior_sigmasqSEXP, use_priorSEXP) {
  if(DESeq2.gt.1.14()){
    useWeightsSEXP <- FALSE
    weightsSEXP <- matrix(1, nrow=nrow(ySEXP), ncol=ncol(ySEXP))
    .Call('DESeq2_fitDispGrid', PACKAGE = COMPILED_COMPONENTS_PACKAGE, ySEXP, xSEXP, mu_hatSEXP, disp_gridSEXP, log_alpha_prior_meanSEXP, log_alpha_prior_sigmasqSEXP, use_priorSEXP, weightsSEXP, useWeightsSEXP)    
  } else {
    .Call('DESeq2_fitDispGrid', PACKAGE = COMPILED_COMPONENTS_PACKAGE, ySEXP, xSEXP, mu_hatSEXP, disp_gridSEXP, log_alpha_prior_meanSEXP, log_alpha_prior_sigmasqSEXP, use_priorSEXP)
  }

}
