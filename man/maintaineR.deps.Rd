\name{Dependencies}
\alias{Dependencies}
\alias{DependencyGraph}
\alias{GraphSubset}
\encoding{UTF-8}
\title{Dependencies}
\description{
  Functions to work with CRAN package depencency graph.
}

\usage{
DependencyGraph(deps, state, types=c("depends", "imports", "linkingto"))
Dependencies(graph, nodes, type="out", min.dist=0, max.dist=Inf)
GraphSubset(graph, nodes, type)
}
\arguments{
  \item{deps}{Dependencies.}
  \item{state}{data.frame with CRAN packages.}
  \item{types}{Types of dependencies to take into account.}
  \item{graph}{Dependency graph}
  \item{nodes}{A character vector containing package name}
  \item{type}{Direcotion of the dependency ("out" for dependency and
    "in" for reverse dependency).}
  \item{min.dist}{Only packages with a greater or equal distance to one
    of the nodes will be considerd.}
  \item{max.dist}{Only packages with a strictly smaller distance to one
    of the nodes will be considerd.}
}
\value{
  \code{DependencyGraph} returns the dependency graph for a given state
  of CRAN.

  \code{Dependencies} returns all packages reachable in the graph from
  or to a set of packages regarding minimum and maximum distances.

  \code{GraphSubset} returns the subset of the dependency graph
  including as nodes all nodes returned by \code{Dependencies}.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{grah}
\keyword{subset}
\keyword{dependencies}
