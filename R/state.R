Date <- function(packages, package=NULL, version=NULL, date=NULL) {
  if (is.null(date)) {
    if (!is.null(package)) {
      packages <- packages[package == package, ]
      if (!is.null(version)) packages <- packages[version == version, ]
    }
    as.Date(max(packages$mtime))
  } else as.Date(date)
}

State <- function(packages, date=Sys.Date()) {
  packages[packages[as.Date(mtime) <= date, .I[which.max(mtime)],
                    by=package]$V1]
}

ReadDataFile <- function(filename) {
  if (file.exists(filename)) readRDS(filename)
}
