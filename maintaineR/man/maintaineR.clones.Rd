\name{Clones}
\alias{Clones}
\encoding{UTF-8}
\title{Clones}
\description{
  Return the list of clones in a given package.
}

\usage{
Clones(package, version, cran)
}
\arguments{
  \item{package}{Package name.}
  \item{version}{The version of the package.}
  \item{cran}{CRAN data.}
}
\value{
  Returns a data.frame containing the list of functions duplicated in
  other CRAN packages.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{cran}
\keyword{package}
\keyword{clones}
