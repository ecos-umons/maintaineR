RenderSummary <- function(package, date, packages, descfile) {
  if (is.null(package)) {
    res <- packages[c("package", "version")]
    res <- res[order(res$package), ]
    res$package <- apply(res, 1, function(p) {
      tags$a(href=sprintf("?p=%s&d=%s", p["package"], date), p["package"])
    })
    MakeTable(res)
  } else if (is.null(descfile)) {
    "No DESCRIPTION file to display"
  } else if (nrow(descfile)) {
    MakeTable(descfile)
  }
}

output$summary <- renderUI(list(
  h2("DESCRIPTION file"),
  uiOutput("summary.table")
))

output$summary.table <- renderUI({
  RenderSummary(package(), date(), state(), descfile())
})
