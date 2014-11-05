ClonesWith <- function(packages, cran) {
  hashes <- unique(Clones(packages, cran)$hash)
  clones <- setkey(setkey(copy(cran$clones), hash)[hashes],
                   package, version, hash)
  clones[-clones[list(packages[[1]]), which=TRUE]]
}

Clones <- function(packages, cran) {
  cran$clones[packages]
}

FirstClones <- function(cran) {
  # returns first occurence of each clone
  clones <- setkey(merge(cran$packages[, list(package, version, mtime)],
                         cran$clones), hash)
  setnames(clones, c("package", "version"), c("first.package", "first.version"))
  clones[clones[, .I[which.min(mtime)], by=hash]$V1,
         list(first.package, first.version, hash)]
}

FirstClonesState <- function(cran, state) {
  # returns first occurence of each clone in a state
  merge(cran$clones[state[, list(package, version)]][!is.na(hash)],
        FirstClones(cran), by="hash")
}

CloneGraph <- function(cran, state, min.size=10, min.loc=3) {
  g <- graph.empty() + vertices(state$package)
  clones <- FirstClonesState(cran, state)[package != first.package &
                                          size >= min.size & loc >= min.loc]
  g <- g + edges(t(clones[, list(package, first.package)]), loc=clones$loc)
  E(g)$num.clones <- 1
  g
}

SimplifyCloneGraph <- function(g) {
  simplify(g, edge.attr.comb=list(num.clones="sum", loc="sum"))
}
