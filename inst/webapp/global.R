library(extractoR.utils)
library(data.table)
library(igraph)
library(timeline)
library(maintaineR)
library(shinyIncubator)
library(scales)
library(ggplot2)

if (!exists("datadir")) {
  datadir <- "../data"
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
config$Update <- as.logical(config$Update)
config$AllowDownload <- as.logical(config$AllowDownload)

DownloadDataFile("rds/packages.rds", datadir, config$RootURL, !config$Update)
DownloadDataFile("rds/deps.rds", datadir, config$RootURL, !config$Update)
DownloadDataFile("clones.rds", datadir, config$RootURL, !config$Update)
DownloadDataFile("conflicts.rds", datadir, config$RootURL, !config$Update)

cran <- ReadCRANData(datadir)
cran$deps.all <- {
  packages <- cran$packages[c("package", "version")]
  deps <- merge(packages, cran$deps)
  deps <- deps[deps$dependency %in% packages$package, ]
  DependencyGraph(deps, packages)
}

PackageFullName <- function(p) {
  paste(p["package"], p["version"], sep="_")
}

PackageLink <- function(p) {
  sprintf("?p=%s&v=%s", p["package"], p["version"])
}
