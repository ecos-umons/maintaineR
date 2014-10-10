core.packages <- c("R", "base", "compiler", "datasets", "graphics",
                   "grDevices", "grid", "methods", "parallel", "profile",
                   "splines", "stats", "stats4", "tcltk", "tools",
                   "translations", "utils")

DependencyGraph <- function(deps, state,
                            types=c("depends", "imports", "linkingto")) {
  deps <- merge(setkey(copy(deps), dependency)[!core.packages], state,
                by=c("package", "version"))
  deps <- setkey(deps, type)[types][, list(package, dependency)]
  packages <- unique(union(state$package, deps$dependency))
  g <- graph.empty(directed=TRUE) + vertices(packages)
  g + edges(t(as.matrix(deps)))
}

Dependencies <- function(graph, nodes, type="out", min.dist=0, max.dist=Inf) {
  if (length(nodes)) {
    paths <- apply(shortest.paths(graph, nodes, mode=type), 2, min)
    names(paths)[min.dist <= paths & paths < max.dist]
  } else character(0)
}

GraphSubset <- function(graph, nodes, type) {
  deps <- Dependencies(graph, nodes, type)
  res <- induced.subgraph(graph, deps)
  V(res)$group <- 1
  V(res)[nodes]$group <- 2
  res
}
