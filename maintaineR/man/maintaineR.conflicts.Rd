\name{Conflicts}
\alias{Conflicts}
\encoding{UTF-8}
\title{Conflicts}
\description{
  Return the list of conflicts in a given package.
}

\usage{
Conflicts(package, version, cran)
}
\arguments{
  \item{package}{Package name.}
  \item{version}{The version of the package.}
  \item{cran}{CRAN data.}
}
\value{
  Returns a data.frame containing the list of objects which name is in
  conflict with another object name in other CRAN packages.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{cran}
\keyword{package}
\keyword{conflicts}
