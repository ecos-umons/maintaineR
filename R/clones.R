Clones <- function(packages, cran) {
  hashes <- unique(merge(cran$clones, packages)["hash"])
  res <- merge(hashes, cran$clones[cran$clones$package != packages$package, ])
  merge(res, cran$packages[c("package", "version", "mtime")])
}
