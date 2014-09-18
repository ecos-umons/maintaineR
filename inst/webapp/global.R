library(extractoR.utils)
library(igraph)
library(timeline)
library(maintaineR)

if (!exists("datadir")) {
  stop("Please define a datadir variable.")
}

if (!file.exists(datadir)) {
  dir.create(datadir)
  message(sprintf("Directory %s not found. Created in %s", datadir, getwd()))
}

config <- file.path(datadir, "maintaineR.conf")

if (!file.exists(config)) {
  stop(sprintf("Please create file %s", config))
}

config <- as.list(read.dcf(config)[1, ])

cran <- ReadCRANData(datadir)

PackageFullName <- function(p) {
  paste(p["package"], p["version"], sep="_")
}

PackageLink <- function(p) {
  sprintf("?p=%s&v=%s", p["package"], p["version"])
}
