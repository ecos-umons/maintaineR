PackageHistory <- function(p, packages, range=c(as.Date("0-1-1"), Sys.Date())) {
  res <- packages[package == p, list(version, package, mtime)]
  res$mtime <- as.Date(res$mtime)
  res <- setkey(res, mtime)
  if (nrow(res)) {
    res$mtime2 <- Sys.Date()
    res$mtime2[-nrow(res)] <- res$mtime[2:nrow(res)]
  } else {
    res$mtime2 <- res$mtime
  }
  res <- res[mtime2 > range[1] & mtime <= range[2], ]
  res[mtime2 > range[2], "mtime2"] <- range[2]
  res[mtime < range[1], "mtime"] <- range[1]
  res
}
