\name{Clones}
\alias{Clones}
\encoding{UTF-8}
\title{Clones}
\description{
  Return the list of clones in a set of given packages.
}

\usage{
Clones(packages, cran)
}
\arguments{
  \item{packages}{Packages data.frame.}
  \item{cran}{CRAN data.}
}
\value{
  Returns a data.frame containing the list of functions from packages
  which are duplicated in other CRAN packages.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{cran}
\keyword{package}
\keyword{clones}
