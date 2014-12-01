RenderFunctions <- function(functions) {
  refs <- tagList(lapply(split(functions, 1:nrow(functions)), function(f) {
    if (is.na(as.character(f$name)[1])) {
      name <- "Anonymous function"
    } else {
      name <- as.character(as.expression(f$name))
    }
    text <- sprintf("%s in %s at lines %d to %d",
                    name, f$file, f$begin.line, f$end.line)
    tagList(text, tags$br())
  }))
  tagList(p(refs), tags$pre(functions[1]$body))
}

RenderClones <- function(package, packages, code, clones, sort,
                         filter.size, filter.loc) {
  if (!is.null(code)) {
    clones <- merge(clones[size >= filter.size & loc >= filter.loc],
                    packages[, list(package, version, mtime)])
    switch(sort, alpha=setkey(clones, package, version),
           old=setkey(clones, mtime))
    if (nrow(clones)) {
      hashes <- unique(as.character(clones$hash))
      functions <- split(code, code$hash)[hashes]
      res <- data.table(Function=lapply(functions, RenderFunctions),
                        Size=sapply(functions, function(f) f[1]$size),
                        LOC=sapply(functions, function(f) f[1]$loc),
                        Packages=split(apply(clones, 1,
                          function(p) {
                            tagList(a(href=PackageLink(p), PackageFullName(p)), br())
                          }), as.character(clones$hash))[hashes],
                        Hash=hashes)
      if (nrow(res)) {
        setorder(res, -Size, Hash)
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
  packages <- if ("cran" %in% input$clones.filters) state() else cran$packages
  RenderClones(package(), packages, code(), clones(), input$clones.sort,
               input$clones.filter.size, input$clones.filter.loc)
})

ClonesMetrics <- function(clones) {
  m1 <- clones[, list("n.clones"=length(unique(.SD$hash)),
                      "loc"=sum(.SD$loc),
                      "size"=sum(.SD$size)),
               by=list(package, version)]
  res <- clones[setkey(clones, hash),
                allow.cartesian=TRUE][package != i.package]
  m2 <- res[, list("n.pkgs"=length(unique(.SD$i.package))),
            by=list(package, version)]
  merge(m1, m2, by=c("package", "version"))
}

labels <- c("n.clones"="# clones", "loc"="# cloned LOC",
            "size"="Cloned AST size", "n.pkgs"="# cloned packages")
choices <- names(labels)
names(choices) <- labels

PlotClonesMetrics <- function(metrics, x, y, col, size,
                              show.labels, log.scale.x, log.scale.y) {
  res <- ggplot(metrics, aes_string(x=x, y=y)) + geom_point(shape=1) +
    geom_point(aes_string(size=col, color=size)) +
      labs(x=labels[x], y=labels[y], col=labels[col], size=labels[size])
  if (log.scale.x) {
    res <- res + scale_x_continuous(trans=log10_trans())
  }
  if (log.scale.y) {
    res <- res + scale_y_continuous(trans=log10_trans())
  }
  if (show.labels) {
    res <- res + geom_text(aes(label=package), size=3)
  }
  res
}

output$clones.cran <- renderUI(list(
  h2("Clones"),
  sidebarLayout(
    sidebarPanel(
      numericInput("clones.cran.filter.size", "Minimum clone AST size", 10, 0),
      numericInput("clones.cran.filter.loc", "Minimum clone LOC", 3, 0),
      selectInput("clones.cran.x", "X variable", choices),
      selectInput("clones.cran.y", "Y variable", choices, "n.pkgs"),
      selectInput("clones.cran.col", "Color variable", choices, "size"),
      selectInput("clones.cran.size", "Size variable", choices, "loc"),
      checkboxInput("clones.cran.labels", "Show package names"),
      checkboxInput("clones.cran.log.x", "Use X axis log scale"),
      checkboxInput("clones.cran.log.y", "Use Y axis log scale"),
      uiOutput("clones.cran.filters"),
      width=2),
    mainPanel(plotOutput("clones.cran.plot", height="600px")))
))

clones.metrics <- reactive({
  packages <- state()[, list(package, version, mtime)]
  packages <- data.table(packages, key=c("package", "version"))

  clones <- data.table(cran$clones, key=c("package", "version", "hash"))
  clones$hash <- as.character(clones$hash)
  clones <- setkey(packages[clones, nomatch=0], "package", "version", "hash")
  clones <- clones[hash %in% clones[, length(unique(.SD$package)),
                                    by=hash][V1 > 1, hash]]
  clones <- clones[size >= input$clones.cran.filter.size &
                   loc >= input$clones.cran.filter.loc]

  ClonesMetrics(clones)
})

output$clones.cran.filters <- renderUI({
  m <- clones.metrics()
  size <- c(min(m$size), max(m$size))
  loc <- c(min(m$loc), max(m$loc))
  n.pkgs <- c(min(m$n.pkgs), max(m$n.pkgs))
  n.clones <- c(min(m$n.clones), max(m$n.clones))
  list(tags$br(),
       tags$h4("Plot Filters"),
       sliderInput("clones.cran.slider.size", "AST size",
                   size[1], size[2], size, step=1),
       sliderInput("clones.cran.slider.loc", "# Cloned LOC",
                   loc[1], loc[2], loc, step=1),
       sliderInput("clones.cran.slider.nclones", "# clones",
                   n.clones[1], n.clones[2], n.clones, step=1),
       sliderInput("clones.cran.slider.npkgs", "# cloned packages",
                   n.pkgs[1], n.pkgs[2], n.pkgs, step=1))
})

output$clones.cran.plot <- renderPlot({
  m <- clones.metrics()
  if (!is.null(input$clones.cran.slider.size)) {
    m <- m[size >= input$clones.cran.slider.size[1] &
           size <= input$clones.cran.slider.size[2] &
           loc >= input$clones.cran.slider.loc[1] &
           loc <= input$clones.cran.slider.loc[2] &
           n.clones >= input$clones.cran.slider.nclones[1] &
           n.clones <= input$clones.cran.slider.nclones[2] &
           n.pkgs >= input$clones.cran.slider.npkgs[1] &
           n.pkgs <= input$clones.cran.slider.npkgs[2]]
  }
  PlotClonesMetrics(m, input$clones.cran.x, input$clones.cran.y,
                    input$clones.cran.col, input$clones.cran.size,
                    input$clones.cran.labels,
                    input$clones.cran.log.x, input$clones.cran.log.y)
})
