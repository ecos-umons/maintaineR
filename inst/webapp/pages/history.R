RenderHistory <- function(package, deps, type, range) {
  if (!is.null(package)) {
    if (package %in% V(deps)$name) {
      packages <- package
      if ("deps" %in% type) {
        packages <- union(packages, Dependencies(deps, package))
      }
      if ("revdeps" %in% type) {
        packages <- union(packages, Dependencies(deps, package, "in"))
      }
      history <- lapply(packages, PackageHistory, cran, range)
      history <- history[sapply(history, nrow) > 0]
      print(timeline(FlattenDF(history)))
    }
  }
}

output$history <- renderUI(list(
  sidebarLayout(
    sidebarPanel(
      dateRangeInput("history.range", "History range",
                     start="1997-01-01"),
      checkboxGroupInput("history.type", "Show",
                         c("Dependencies"="deps",
                           "Reverse dependencies"="revdeps")),
      width=2),
    mainPanel(plotOutput("history.plot")))
))

output$history.plot <- renderPlot({
    RenderHistory(package(), deps(), input$history.type, input$history.range)
})
