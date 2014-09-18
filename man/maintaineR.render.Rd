\name{Render}
\alias{Render}
\alias{RenderSankey}
\alias{RenderGraph}
\encoding{UTF-8}
\title{Render}
\description{
  Functions to render dependency graph.
}

\usage{
RenderSankey(graph, id=NULL)
RenderGraph(graph, id=NULL)
}
\arguments{
  \item{graph}{Dependency graph.}
  \item{id}{Id of the HTML element.}
}
\value{
  \code{RenderSankey} renders the graph using rCharts sankey
  extension.

  \code{RenderGraph} renders the graph using d3Network.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{grah}
\keyword{render}
\keyword{dependency}
