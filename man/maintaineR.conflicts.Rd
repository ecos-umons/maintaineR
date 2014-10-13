\name{Conflicts}
\alias{Conflicts}
\alias{ConflictsWith}
\encoding{UTF-8}
\title{Conflicts}
\description{
  Conflicts manipulation functions
}

\usage{
ConflictsWith(packages, cran)
Conflicts(packages, cran)
}
\arguments{
  \item{packages}{Packages data.frame.}
  \item{cran}{CRAN data.}
}
\value{
  \code{Conflicts} returns a subset of \code{cran$conflicts} contaning
  the objects from \code{packages} which names are duplicated in other
  CRAN packages.

  \code{ConflictsWith} returns a subset of \code{cran$conflicts}
  contaning the conflicts wth \code{packages} contained in other CRAN
  packages.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{cran}
\keyword{package}
\keyword{conflicts}
