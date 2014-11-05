DownloadInput <- function(allow.download) {
  if (allow.download) {
    list(actionButton("data.download", "Download"),
         checkboxGroupInput("data.download.options", "",
                            c("DESCRIPTION file"="descfiles",
                              "NAMESPACE content"="namespaces",
                              "Functions list"="functions"),
                            c("descfiles", "namespaces", "functions")),
         checkboxGroupInput("data.download.options2", "",
                            c("Dependencies"="deps",
                              "Reverse dependencies"="rev.deps",
                              "Conflicting packages"="conflicts",
                              "Cloned packages"="clones")))
  } else NULL
}

output$data <- renderUI(list(
  h2("Data Management"),
  sidebarLayout(
    sidebarPanel(
      textInput("data.search", "Search",
                if (!is.null(package())) sprintf("^%s$", package()) else ""),
      checkboxInput("data.search.case", "Ignore case", is.null(package())),
      numericInput("data.nrow", "Maximum number of results", 100),
      radioButtons("data.sort", "Sort packages by",
                   c("Packages"="packages",
                     "Date"="date")),
      checkboxGroupInput("data.filters", "Show only",
                         c("Last CRAN version"="last"),
                         if (is.null(package())) "last" else NULL),
      numericInput("data.clones.size", "Minimum clone AST size", 10, 0),
      numericInput("data.clones.loc", "Minimum clone LOC", 3, 0), p(),
      DownloadInput(config$AllowDownload),
      width=2),
    mainPanel(uiOutput("data.output"), uiOutput("data.table")))
))

data.state <- reactive({
  packages <- if ("last" %in% input$data.filters) state() else cran$packages
  if (input$data.sort == "date") {
    packages[order(packages$mtime, decreasing=TRUE), ]
  } else {
    packages[with(packages, order(package, -rank(version))), ]
  }
})

data.state.sub <- reactive({
  packages <- data.state()
  packages <- packages[grep(input$data.search, packages$package,
                            ignore.case=input$data.search.case), ]
  packages[1:min(input$data.nrow, nrow(packages)), ]
})

DownloadWithProgress <- function(todl, options, session, config, datadir) {
  files <- sprintf("%s_%s.rds", todl$package, todl$version)
  files <- merge(options, files)
  files <- file.path(files[[1]], files[[2]])
  files <- files[!file.exists(file.path(datadir, files))]
  if (length(files)) {
    withProgress(session, {
      setProgress("Downloading data")
      for (f in files) {
        setProgress(detail=sprintf("Downloading %s", f))
        DownloadDataFile(f, datadir, config$RootURL, TRUE)
      }
      setProgress("Download finished", "Please refresh the page")
      Sys.sleep(2)
    })
  }
}

output$data.table <- renderUI({
  res <- DataState(data.state.sub(), datadir)
  if (config$AllowDownload) {
    res$Download <- lapply(sprintf("download %s %s", res$Package, res$Version),
                           checkboxInput, "")
  }
  res$Package <- by(res, 1:nrow(res), function(p) {
    tags$a(href=sprintf("?p=%s&v=%s", p$Package, p$Version), p$Package)
  })
  MakeTable(res)
})

observe({
  if (!is.null(input$data.download) &&
      input$data.download > 0 &&
      config$AllowDownload) isolate({
    packages <- if ("last" %in% input$data.filters) state() else cran$packages
    packages <- packages[c("package", "version")]
    todl <- data.state.sub()[c("package", "version")]
    todl <- todl[sapply(sprintf("download %s %s", todl$package, todl$version),
                        function(p) input[[p]]), ]
    todl <- PackagesToDownload(todl, packages, cran, cran$deps.all,
                               input$data.download.options2,
                               input$data.clones.size, input$data.clones.loc)
    DownloadWithProgress(todl, input$data.download.options,
                         session, config, datadir)
  })
})
