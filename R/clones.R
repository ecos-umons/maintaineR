ClonesWith <- function(packages, cran) {
  hashes <- unique(Clones(packages, cran)$hash)
  clones <- setkey(setkey(copy(cran$clones), hash)[hashes],
                   package, version, hash)
  clones[-clones[packages, which=TRUE]]
}

Clones <- function(packages, cran) {
  cran$clones[packages]
}
