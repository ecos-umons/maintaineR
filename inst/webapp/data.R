ParseParams <- function(session) {
  params <- parseQueryString(session$clientData$url_search)
  date <- Date(cran$packages, params$p, params$v, params$d)
  list(package=params$p, version=params$v, date=date)
}

params <- reactive(ParseParams(session))

package <- reactive(params()$package)
version <- reactive(params()$version)
date <- reactive(Date(cran$packages, package(), version(), params()$date))
state <- reactive(State(cran$packages, date()))

versions <- reactive({
    cran$packages[package == package(), ]$version
})

version <- reactive({
    state()[package == package(), ]$version
})

filename <- reactive({
    sprintf("%s_%s.rds", package(), version())
})

descfile <- reactive({
    filename <- file.path(datadir, "descfiles", filename())
    if (file.exists(filename)) readRDS(filename)
})

deps <- reactive({
  DependencyGraph(cran$deps, state())
})

code <- reactive({
  filename <- file.path(datadir, "functions", filename())
  if (file.exists(filename)) readRDS(filename)
})

clones <- reactive({
  ClonesWith(list(package(), version()), cran)
})

namespace <- reactive({
  filename <- file.path(datadir, "namespaces", filename())
  if (file.exists(filename)) readRDS(filename)
})

conflicts <- reactive({
  ConflictsWith(list(package(), version()), cran)
})
