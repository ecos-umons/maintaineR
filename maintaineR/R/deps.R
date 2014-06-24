core.packages <- c("R", "base", "compiler", "datasets", "graphics",
                   "grDevices", "grid", "methods", "parallel", "profile",
                   "splines", "stats", "stats4", "tcltk", "tools",
                   "translations", "utils")

DependencyGraph <- function(deps, state,
                            types=c("depends", "imports", "linkingto")) {
  deps <- merge(deps[!deps$dependency %in% core.packages, ], state)
  deps <- deps[deps$type %in% types, c("package", "dependency", "type")]
  packages <- unique(union(state$package, deps$dependency))
  g <- graph.empty(directed=TRUE) + vertices(packages)
  g + edges(apply(deps, 1, function(e) c(e["package"], e["dependency"])))
}

Dependencies <- function(graph, nodes, type="out") {
  paths <- apply(shortest.paths(graph, nodes, mode=type), 2, min)
  names(paths)[paths < Inf]
}

GraphSubset <- function(graph, nodes, type) {
  deps <- Dependencies(graph, nodes, type)
  res <- induced.subgraph(graph, deps)
  V(res)$group <- 1
  V(res)[nodes]$group <- 2
  res
}
