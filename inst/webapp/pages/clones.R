RenderFunctions <- function(functions) {
  refs <- tagList(lapply(functions, function(f) {
    name <- as.character(f$name)
    name <- if (is.na(name[1])) "Anonymous function" else name
    file <- attr(f$ref, "srcfile")$filename
    text <- sprintf("%s in %s at lines %d to %d",
                    name, file, f$ref[1], f$ref[3])
    tagList(text, tags$br())
  }))
  tagList(p(refs), tags$pre(functions[[1]]$body))
}

RenderClones <- function(package, packages, code, clones, sort,
                         filter.size, filter.loc, filters) {
  if (!is.null(code)) {
    if ("cran" %in% filters) {
      clones <- merge(clones, packages[c("package", "version")])
    }
    clones <- switch(sort,
                     alpha=clones[order(apply(clones, 1, PackageFullName)), ],
                     old=clones[order(clones$mtime), ])
    if (nrow(clones)) {
      res <- data.frame(Hash=unique(as.character(clones$hash)),
                        stringsAsFactors=FALSE)
      res$Functions <- lapply(res$Hash, function(f) code[[f]])
      res$Size <- sapply(res$Functions, function(f) f[[1]]$size)
      res$LOC <- sapply(res$Functions, function(f) {
        length(strsplit(f[[1]]$body, "\n")[[1]])
      })
      res$Functions <- lapply(lapply(res$Hash, function(f) code[[f]]),
                              RenderFunctions)
      res$Packages <- split(apply(clones, 1, function(p) {
        tagList(a(href=PackageLink(p), PackageFullName(p)), br())
      }), as.character(clones$hash))[res$Hash]
      res <- res[res$Size >= filter.size & res$LOC >= filter.loc,
                 c("Functions", "Size", "LOC", "Packages", "Hash")]
      if (nrow(res)) {
        res <- res[order(-res$Size, res$Hash), ]
        MakeTable(res)
      }
    }
  } else {
    "No clones to display"
  }
}

output$clones <- renderUI(list(
  h2("Clones"),
  sidebarLayout(
    sidebarPanel(
      numericInput("clones.filter.size", "Minimum clone AST size", 10, 0),
      numericInput("clones.filter.loc", "Minimum clone LOC", 3, 0),
      radioButtons("clones.sort", "Sort packages by",
                   c("Oldest first"="old",
                     "Alphabetical"="alpha")),
      checkboxGroupInput("clones.filters", "Show only",
                         c("Last CRAN version"="cran")),
      width=2),
    mainPanel(uiOutput("clones.table")))
))

output$clones.table <- renderUI({
    RenderClones(package(), state(), code(), clones(), input$clones.sort,
                 input$clones.filter.size, input$clones.filter.loc,
                 input$clones.filters)
})
