\name{State}
\alias{State}
\encoding{UTF-8}
\title{State}
\description{
  Returns a data frame with package versions that were the last version
  available for each package on CRAN.
}

\usage{
State(packages, date)
}
\arguments{
  \item{packages}{Dataframe of all packages}
  \item{date}{Date to consider for CRAN}
}
\value{
  Returns a subset of \code{packages} with one row for each distinct
  package corresponding to the latest version available on CRAN at the
  time of \code{date}.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{state}
\keyword{cran}
