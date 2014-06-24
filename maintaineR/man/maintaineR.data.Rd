\name{ReadCRANData}
\alias{ReadCRANData}
\encoding{UTF-8}
\title{ReadCRANData}
\description{
  Reads data about CRAN packages, dependencies, clones and conflicts.
}

\usage{
ReadCRANData(datadir)
}
\arguments{
  \item{datadir}{Root data directory}
}
\value{
  A list with four elements containing loaded rds/packages.rds, rds/deps.rds,
  clones.rds and conflicts.rds from https://github.com/maelick/CRANData.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{read}
\keyword{cran}
\keyword{data}
\keyword{packages}
\keyword{dependencies}
\keyword{clones}
\keyword{conflicts}
