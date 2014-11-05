Date <- function(packages, p=NULL, v=NULL, d=NULL) {
  if (is.null(d)) {
    if (!is.null(p)) {
      packages <- packages[package == p]
      if (!is.null(version)) packages <- packages[version == v]
    }
    as.Date(max(packages$mtime))
  } else as.Date(d)
}

State <- function(packages, date=Sys.Date()) {
  packages[packages[as.Date(mtime) <= date, .I[which.max(mtime)],
                    by=package]$V1]
}

ReadDataFile <- function(filename) {
  if (file.exists(filename)) readRDS(filename)
}
