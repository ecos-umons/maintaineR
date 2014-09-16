Conflicts <- function(package, version, cran) {
  res <- cran$conflicts[cran$conflicts$package == package &
                        cran$conflicts$version == version, ]
  res <- merge(unique(res[c("name", "type")]),
               cran$conflicts[cran$conflicts$package != package, ])
  merge(res, cran$packages[c("package", "version", "mtime")])
}
