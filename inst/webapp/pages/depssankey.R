RenderDepsSankey <- function(package, deps, deps.type) {
  if (package %in% V(deps)$name) {
    g <- GraphSubset(deps, package, deps.type)
    if (length(E(g))) {
      RenderSankey(g)
    }
  } else {
    p(sprintf("%s not found", package))
  }
}

output$depssankey <- renderUI(list(
  h2("Dependency Sankey Graph"),
  sidebarLayout(
    sidebarPanel(
      radioButtons("depssankey.type", "Show",
                   c("Dependencies"="out",
                     "Reverse dependencies"="in")),
      width=2),
    mainPanel(uiOutput("depssankey.plot")))
))

output$depssankey.plot <- renderPrint({
  RenderDepsSankey(package(), deps(), input$depssankey.type)
})
