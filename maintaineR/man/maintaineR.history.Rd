\name{History}
\alias{History}
\alias{PackageHistory}
\encoding{UTF-8}
\title{History}
\description{
  Return the history of a package
}

\usage{
PackageHistory(package, cran, range=c(as.Date("0-1-1"), Sys.Date()))
}
\arguments{
  \item{package}{Package name.}
  \item{cran}{CRAN data.}
  \item{range}{A Date vector of length 2 containing date range to use
    for the history.}
}
\value{
  Returns a data.frame containing the list of all versions of a package
  and the interval of time during which each version was the latest one
  avalaible.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{cran}
\keyword{package}
\keyword{history}
