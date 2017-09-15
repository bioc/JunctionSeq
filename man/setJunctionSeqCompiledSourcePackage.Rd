\name{setJunctionSeqCompiledSourcePackage}
\docType{methods}
\alias{setJunctionSeqCompiledSourcePackage}
\title{
   Set the source of the internal compiled C++ binaries.
}
\description{
   This function sets the package that contains the compiled C++ binaries needed by JunctionSeq.
   
   This is intended for advanced users, or for users attempting to install testing versions of JunctionSeq without a C++ compiler.
}
\usage{
setJunctionSeqCompiledSourcePackage( PACKAGE = c("JunctionSeq","DESeq2") )
}

\arguments{
  \item{PACKAGE}{
    The name of the package where the compiled binaries are stored.
  }
}


\examples{

}