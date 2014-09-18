Date <- function(packages, package, version, date) {
  if (is.null(date)) {
    as.Date(max({
      if (is.null(package)) {
        packages$mtime
      } else if (is.null(version)) {
        packages[packages$package == package, ]$mtime
      } else {
        packages[packages$package == package &
                 packages$version == version, ]$mtime
      }
    }))
  } else {
    as.Date(date)
  }
}

State <- function(packages, date) {
  res <- packages[as.Date(packages$mtime) <= date, ]
  res <- res[with(res, order(as.character(mtime), decreasing=TRUE)), ]
  res[!duplicated(res["package"]), ]
}

ReadDataFile <- function(filename) {
  if (file.exists(filename)) readRDS(filename)
}
