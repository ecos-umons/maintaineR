\name{State}
\alias{State}
\alias{Date}
\encoding{UTF-8}
\title{State}
\description{
  Returns a data frame with package versions that were the last version
  available for each package on CRAN.
}

\usage{
State(packages, date)
Date(packages, package=NULL, version=NULL, date=NULL)
}
\arguments{
  \item{packages}{Dataframe of all packages}
  \item{date}{Date to consider for CRAN snapshot}
  \item{package}{Package}
  \item{version}{Version}
}
\value{
  \code{State} returns a subset of \code{packages} with one row for each distinct
  package corresponding to the latest version available on CRAN at the
  time of \code{date}.

  \code{Date} returns the date associated with a set of optionally
  specified package, version and date. If date is provided it will
  always return it. If package is provided but not the version, last
  version release date is returned, otherwise the version release date
  is returned.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{state}
\keyword{cran}
