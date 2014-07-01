args <- commandArgs(trailingOnly=TRUE)
dest.root <- args[1]
dest.root <- "data_test"
my.packages <- args[-1]
my.packages <- c("XML")
only.last <- TRUE
download.deps <- TRUE
download.rev.deps <- FALSE
download.conflicts <- TRUE
download.clones <- TRUE
clones.filter.ast <- 10
clones.filter.loc <- 3
url.root <- "https://raw.githubusercontent.com/maelick/CRANData/master"
update <- TRUE

library(RCurl)
library(maintaineR)
library(igraph)

CheckURL <- function(url) {
  h = getCurlHandle()
  getURL(url, header=1, nobody=1, curl = h)
  as.logical(getCurlInfo(h, "response.code") == 200)
}

DownloadFile <- function(file, dest.root, url.root, download.once=FALSE) {
  dest <- file.path(dest.root, file)
  if (!download.once || !file.exists(dest)) {
    url <- file.path(url.root, file)
    if (CheckURL(url)) {
      if (!file.exists(dirname(dest))) {
        dir.create(dirname(dest), recursive=TRUE)
      }
      message("Downloading %s", dest)
      download.file(url, dest, method="curl")
    }
  }
}

DownloadFile("rds/packages.rds", dest.root, url.root, !update)
DownloadFile("rds/deps.rds", dest.root, url.root, !update)
DownloadFile("clones.rds", dest.root, url.root, !update)
DownloadFile("conflicts.rds", dest.root, url.root, !update)

DownloadPackage <- function(package, version, dest.root, url.root) {
  file <- sprintf("%s_%s.rds", package, version)
  DownloadFile(file.path("descfiles", file), dest.root, url.root, TRUE)
  DownloadFile(file.path("functions", file), dest.root, url.root, TRUE)
  DownloadFile(file.path("namespaces", file), dest.root, url.root, TRUE)
}

DownloadPackages <- function(packages, dest.root, url.root) {
  invisible(apply(packages[c("package", "version")], 1, function(p) {
    DownloadPackage(p[1], p[2], dest.root, url.root)
  }))
}

packages <- readRDS(file.path(dest.root, "rds/packages.rds"))
if (only.last) {
  packages <- State(packages, Sys.Date())
}
packages <- packages[c("package", "version")]

deps <- merge(packages, readRDS(file.path(dest.root, "rds/deps.rds")))
deps <- deps[deps$dependency %in% packages$package, ]
g <- DependencyGraph(deps, packages)
deps <- data.frame(package=Dependencies(g, my.packages, "out"))
rev.deps <- data.frame(package=Dependencies(g, my.packages, "in"))

clones <- merge(packages, readRDS(file.path(dest.root, "clones.rds")))
hashes <- clones[clones$package %in% my.packages &
                 clones$size > clones.filter.ast &
                 clones$loc > clones.filter.loc, ]$hash
conflicts <- merge(packages, readRDS(file.path(dest.root, "conflicts.rds")))
func.names <- conflicts[conflicts$type == "function" &
                        conflicts$package %in% my.packages, ]$name

todl <- rbind(conflicts[conflicts$name %in% as.character(unique(func.names)),
                        c("package", "version")],
              clones[clones$hash %in% as.character(unique(hashes)),
                        c("package", "version")],
              packages[packages$package %in% my.packages, ],
              if (download.deps) merge(packages, deps),
              if (download.rev.deps) merge(packages, rev.deps))

DownloadPackages(unique(todl), dest.root, url.root)
