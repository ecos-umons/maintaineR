ReadCRANData <- function(datadir) {
  res <- list(packages=readRDS(file.path(datadir, "rds", "packages.rds")),
              deps=readRDS(file.path(datadir, "rds", "deps.rds")),
              clones=readRDS(file.path(datadir, "clones.rds")),
              conflicts=readRDS(file.path(datadir, "conflicts.rds")))
  res$packages <- res$packages[!is.na(res$packages$mtime), ]
  res
}
