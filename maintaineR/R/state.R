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

StateData <- function(cran, datadir, params=list()) {
  date <- Date(cran$packages, params$package, params$version, params$date)
  state <- State(cran$packages, date)
  if (is.null(params[["package"]])) {
    list(date=date, state=state)
  } else {
    package <- params$package
    versions <- cran$packages[cran$packages$package == package, ]
    version <- state[state$package == package, ]$version
    filename <- sprintf("%s_%s.rds", package, version)
    descfile <- ReadDataFile(file.path(datadir, "descfiles", filename))
    deps <- DependencyGraph(cran$deps, state)
    code <- ReadDataFile(file.path(datadir, "functions", filename))
    clones <- Clones(package, version, cran)
    namespace <- ReadDataFile(file.path(datadir, "namespaces", filename))$res
    conflicts <- Conflicts(package, version, cran)
    list(date=date, packages=state, package=package, version=version,
         versions=versions, descfile=descfile, deps=deps,
         code=code, clones=clones, namespace=namespace, conflicts=conflicts)
  }
}
