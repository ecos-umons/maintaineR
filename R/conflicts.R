Conflicts <- function(packages, cran) {
  res <- merge(cran$conflicts, packages)
  res <- merge(unique(res[c("name", "type")]),
               cran$conflicts[cran$conflicts$package != packages$package, ])
  merge(res, cran$packages[c("package", "version", "mtime")])
}
