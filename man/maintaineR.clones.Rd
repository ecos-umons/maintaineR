\name{Clones}
\alias{Clones}
\alias{ClonesWith}
\alias{CloneGraph}
\alias{SimplifyCloneGraph}
\encoding{UTF-8}
\title{Clones}
\description{
  Clones manipulation functions
}

\usage{
ClonesWith(packages, cran)
Clones(packages, cran)
CloneGraph(cran, state, min.size=10, min.loc=3)
SimplifyCloneGraph(g)
}
\arguments{
  \item{packages}{Packages data.table.}
  \item{cran}{CRAN data.}
  \item{state}{CRAN snapshot.}
  \item{min.size}{Minimum AST size to consider.}
  \item{min.loc}{Minimum # LOC to consider.}
  \item{g}{Clone graph.}
}
\value{
  \code{Clones} returns a subset of \code{cran$clones} contaning the
  functions from \code{packages} which are duplicated in other CRAN
  packages.

  \code{ClonesWith} returns a subset of \code{cran$clones} contaning the
  clones wth \code{packages} contained in other CRAN packages.

  \code{CloneGraph} returns the clone graph for a given state.

  \code{SimplifyCloneGraph} simplifies the clone graph by merging
  multiple edges between two nodes.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{cran}
\keyword{package}
\keyword{clones}
