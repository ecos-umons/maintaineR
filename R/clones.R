Clones <- function(package, version, cran) {
  res <- unique(cran$clones[cran$clones$package == package &
                            cran$clones$version == version, ]["hash"])
  res <- merge(res, cran$clones[cran$clones$package != package, ])
  merge(res, cran$packages[c("package", "version", "mtime")])
}
