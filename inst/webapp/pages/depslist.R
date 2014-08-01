RenderDepsList <- function(package, deps, date) {
  if (!is.null(package)) {
    deps.out <- setdiff(Dependencies(deps, package, type="out"), package)
    deps.in <- setdiff(Dependencies(deps, package, type="in"), package)
    res <- data.frame(Type=c(rep("Dependency", length(deps.out)),
                        rep("Reverse", length(deps.in))))
    res$Package <- lapply(c(deps.out, deps.in), function(p) {
      tags$a(href=sprintf("?p=%s&d=%s", p, date), p)
    })
    MakeTable(res)
  }
}

output$depslist <- renderUI(list(
  h2("Dependency list"),
  uiOutput("depslist.table")
))

output$depslist.table <- renderUI({
  RenderDepsList(package(), deps(), date())
})
