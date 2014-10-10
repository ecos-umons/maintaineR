RenderNamespace <- function(package, packages, deps, namespace, conflicts,
                            sort, filters) {
  if (!is.null(namespace)) {
    conflicts <- merge(conflicts, packages[, list(package, version)])
    if ("functions" %in% filters) {
      conflicts <- conflicts[type == "function"]
      namespace <- namespace[sapply(namespace, function(f) {
        "function" %in% f$type
      })]
    }
    conflicts <- merge(conflicts, packages)
    if ("siblings" %in% filters) {
      reverse <- Dependencies(deps, package, "in", 1, 2)
      siblings <- Dependencies(deps, reverse, "out", 1, 2)
      conflicts <- conflicts[package %in% siblings]
    }
    if ("conflicts" %in% filters) {
      names <- sapply(namespace, function(f) f$name)
      namespace <- namespace[names %in% conflicts$name]
    }
    c <- switch(sort,
                alpha=setkey(conflicts, package, version),
                old=setkey(conflicts, mtime))
    res <- data.frame(Name=sapply(namespace, function(x) x$name),
                      Type=sapply(namespace,
                        function(x) paste(unique(x$type), collapse=", ")))
    confs <- split(apply(c, 1, function(p) {
      tagList(a(href=PackageLink(p), PackageFullName(p)), br())
    }), as.character(c$name))[res$Name]
    res$Conflicts <- lapply(as.character(res$Name), function(n) {
      if (n %in% names(confs)) confs[[n]] else "None"
    })
    MakeTable(res)
  } else {
    "No namespace to display"
  }
}

output$namespace <- renderUI(list(
  h2("Namespace"),
  sidebarLayout(
    sidebarPanel(
      radioButtons("namespace.sort", "Sort conflict packages by",
                   c("Oldest first"="old",
                     "Alphabetical"="alpha")),
      checkboxGroupInput("namespace.filters", "Show only",
                         c("Functions"="functions",
                           "Conflicts"="conflicts",
                           "Last CRAN version"="cran",
                           "Conflicts with sibling packages"="siblings")),
      width=2),
    mainPanel(uiOutput("namespace.table")))
))

output$namespace.table <- renderUI({
  packages <- if ("cran" %in% input$namespace.filters) state() else cran$packages
  RenderNamespace(package(), packages, deps(), namespace(), conflicts(),
                  input$namespace.sort, input$namespace.filters)
})
