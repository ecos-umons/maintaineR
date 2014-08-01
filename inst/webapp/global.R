library(extractoR.utils)
library(igraph)
library(timeline)
library(maintaineR)

datadir <- "../../data"
cran <- ReadCRANData(datadir)

PackageFullName <- function(p) {
  paste(p["package"], p["version"], sep="_")
}

PackageLink <- function(p) {
  sprintf("?p=%s&v=%s", p["package"], p["version"])
}
