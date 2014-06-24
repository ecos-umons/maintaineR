\name{StateData}
\alias{StateData}
\encoding{UTF-8}
\title{StateData}
\description{
  Returns data for a given package, version and/or date.
}

\usage{
StateData(cran, datadir, params=list())
}
\arguments{
  \item{cran}{CRAN data}
  \item{datadir}{Root data directory}
  \item{params}{List containing a combination of package, version, date
    or none.}
}
\value{
  Returns a list with date and state (if no package specified in params)
  or a list with package, version, versions, filename, descfile, deps,
  code, clones, namespace and conflicts.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{state}
\keyword{cran}
\keyword{data}
