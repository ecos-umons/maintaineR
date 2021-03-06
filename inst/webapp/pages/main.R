MakeTable <- function(df, class="table") {
  elements <- apply(df, 1, function(x) tags$tr(lapply(x, tags$td)))
  tags$table(tags$tr(lapply(names(df), tags$th)), tagList(elements),
             class=class)
}

MakePackageList <- function(packages, date) {
  res <- packages[c("package", "version")]
  res <- res[order(res$package), ]
  res$package <- apply(res, 1, function(p) {
    tags$a(href=sprintf("?p=%s&d=%s", p["package"], date), p["package"])
  })
  MakeTable(res)
}

RenderTitle <- function(package, version, date) {
  if (is.null(package)) {
    "CRAN"
  } else if (is.null(version)) {
    sprintf("No version for %s at %s", package, date)
  } else {
    sprintf("%s %s (%s)", package, version, date)
  }
}

output$main <- renderUI({
  title <- RenderTitle(package(), version(), date())
  if (is.null(package())) {
    navbarPage(
      "maintaineR - CRAN dashboard",
      inverse=TRUE, collapsable=TRUE,
      tabPanel("Data", uiOutput("data")),
      tabPanel("Conflicts overview", uiOutput("conflicts.cran")),
      tabPanel("Clones overview", uiOutput("clones.cran")))
  } else {
    navbarPage(
      "maintaineR - CRAN dashboard",
      header=h3(title), inverse=TRUE, collapsable=TRUE,
      tabPanel("Summary", uiOutput("summary")),
      tabPanel("History", uiOutput("history")),
      navbarMenu("Dependencies",
        tabPanel("List", uiOutput("depslist")),
        tabPanel("Sankey", uiOutput("depssankey")),
        tabPanel("Graph", uiOutput("depsgraph"))
      ),
      tabPanel("Namespace", uiOutput("namespace")),
      tabPanel("Clones", uiOutput("clones")),
      tabPanel("Data", uiOutput("data")))
  }
})

output$pkglist <- renderUI(MakePackageList(state(), date()))
