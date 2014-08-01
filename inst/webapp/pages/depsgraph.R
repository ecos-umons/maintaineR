RenderDepsGraph <- function(package, deps, deps.type) {
  if (package %in% V(deps)$name) {
    g <- GraphSubset(deps, package, deps.type)
    if (length(E(g))) {
      RenderGraph(g)
    }
  } else {
    p(sprintf("%s not found", package))
  }
}

output$depsgraph <- renderUI(list(
  h2("Dependency Graph"),
  sidebarLayout(
    sidebarPanel(
      radioButtons("depsgraph.type", "Show",
                   c("Dependencies"="out",
                     "Reverse dependencies"="in")),
      width=2),
    mainPanel(uiOutput("depsgraph.plot")))
))

output$depsgraph.plot <- renderPrint({
  RenderDepsGraph(package(), deps(), input$depsgraph.type)
})
