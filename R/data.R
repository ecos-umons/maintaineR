CheckURL <- function(url) {
  h = getCurlHandle()
  getURL(url, header=1, nobody=1, curl = h)
  as.logical(getCurlInfo(h, "response.code") == 200)
}

DownloadDataFile <- function(file, dest.root, url.root, download.once=FALSE) {
  dest <- file.path(dest.root, file)
  if (!download.once || !file.exists(dest)) {
    url <- file.path(url.root, file)
    if (CheckURL(url)) {
      if (!file.exists(dirname(dest))) {
        dir.create(dirname(dest), recursive=TRUE)
      }
      message(sprintf("Downloading %s", dest))
      download.file(url, dest, method="curl")
    }
  }
}

DataState <- function(packages, datadir) {
  file <- sprintf("%s_%s.rds", packages$package, packages$version)
  descfiles=file.exists(file.path(datadir, "descfiles", file))
  functions=file.exists(file.path(datadir, "functions", file))
  namespaces=file.exists(file.path(datadir, "namespaces", file))
  data.frame(Package=packages$package, Version=packages$version,
             Date=as.character(packages$mtime), "DESCRIPTION"=descfiles,
             "NAMESPACE"=namespaces, "Functions"=functions)
}

PackagesToDownload <- function(todl, packages, cran, g, options,
                               clones.size, clones.loc) {
  if (nrow(todl)) {
    if ("deps" %in% options) {
      deps <- data.frame(package=Dependencies(g, todl$package, "out"))
      todl <- rbind(todl, merge(packages, deps))
    }
    if ("rev.deps" %in% options) {
      rev.deps <- data.frame(package=Dependencies(g, todl$package, "in"))
      todl <- rbind(todl, merge(packages, rev.deps))
    }
    if ("clones" %in% options) {
      clones <- Clones(todl, cran)
      clones <- clones[clones$size >= clones.size &
                       clones$loc >= clones.loc, ]
      todl <- rbind(todl, merge(packages, clones[c("package", "version")]))
    }
    if ("conflicts" %in% options) {
      conflicts <- Conflicts(todl, cran)
      todl <- rbind(todl, merge(packages, conflicts[c("package", "version")]))
    }
  }
  unique(todl)
}

ReadCRANData <- function(datadir) {
  res <- list(packages=readRDS(file.path(datadir, "rds", "packages.rds")),
              deps=readRDS(file.path(datadir, "rds", "deps.rds")),
              clones=readRDS(file.path(datadir, "clones.rds")),
              conflicts=readRDS(file.path(datadir, "conflicts.rds")))
  res$packages <- res$packages[!is.na(res$packages$mtime), ]
  res
}
