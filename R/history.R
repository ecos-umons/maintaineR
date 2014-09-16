PackageHistory <- function(package, cran,
                           range=c(as.Date("0-1-1"), Sys.Date())) {
  res <- cran$packages[cran$packages$package == package,
                       c("version", "package", "mtime")]
  res$mtime <- as.Date(res$mtime)
  res <- res[with(res, order(mtime)), ]
  if (nrow(res)) {
    res$mtime2 <- Sys.Date()
    res$mtime2[-nrow(res)] <- res$mtime[2:nrow(res)]
  } else {
    res$mtime2 <- res$mtime
  }
  res <- res[res$mtime2 > range[1] & res$mtime <= range[2], ]
  res$mtime2[res$mtime2 > range[2]] <- range[2]
  res$mtime[res$mtime < range[1]] <- range[1]
  res
}
