\name{Conflicts}
\alias{Conflicts}
\encoding{UTF-8}
\title{Conflicts}
\description{
  Return the list of conflicts in a set of given packages.
}

\usage{
Conflicts(packages, cran)
}
\arguments{
  \item{packages}{Packages data.frame.}
  \item{cran}{CRAN data.}
}
\value{
  Returns a data.frame containing the list of objects from packages
  which names are in conflict with another object name in other CRAN
  packages.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{cran}
\keyword{package}
\keyword{conflicts}
