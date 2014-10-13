\name{Clones}
\alias{Clones}
\alias{ClonesWith}
\encoding{UTF-8}
\title{Clones}
\description{
  Clones manipulation functions
}

\usage{
ClonesWith(packages, cran)
Clones(packages, cran)
}
\arguments{
  \item{packages}{Packages data.table.}
  \item{cran}{CRAN data.}
}
\value{
  \code{Clones} returns a subset of \code{cran$clones} contaning the
  functions from \code{packages} which are duplicated in other CRAN
  packages.

  \code{ClonesWith} returns a subset of \code{cran$clones} contaning the
  clones wth \code{packages} contained in other CRAN packages.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{cran}
\keyword{package}
\keyword{clones}
