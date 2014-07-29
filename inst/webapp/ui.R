library(shiny)

shinyUI(fluidPage(
  tags$head(
    tags$link(rel="stylesheet", href="http://timelyportfolio.github.io/rCharts_d3_sankey/libraries/widgets/d3_sankey/css/sankey.css"),
    tags$script(src="http://timelyportfolio.github.io/rCharts_d3_sankey/libraries/widgets/d3_sankey/js/d3.v3.js"),
    tags$script(src="http://timelyportfolio.github.io/rCharts_d3_sankey/libraries/widgets/d3_sankey/js/sankey.js"),
    tags$style("
    .rChart {
      display: block;
      margin-left: auto;
      margin-right: auto;
      width: 960px;
      height: 800px;
    }")
  ),
  titlePanel(textOutput("title"), "maintaineR CRAN Dashboard"),
  tabsetPanel(
    tabPanel("Summary", uiOutput("summary")),
    tabPanel(
      "History",
      sidebarLayout(
        sidebarPanel(
          dateRangeInput("history.range", "History range",
                         start="1997-01-01"),
          checkboxGroupInput("history.type", "Show",
                             c("Dependencies"="deps",
                               "Reverse dependencies"="revdeps")),
          ## checkboxGroupInput("history.type", "Show",
          ##                    c("Dependencies"="deps",
          ##                      "Reverse dependencies"="revdeps",
          ##                      "Conflicts"="conflicts",
          ##                      "Maintainer's packages"="maintainer")),
          width=2),
        mainPanel(plotOutput("history")))
    ),
    tabPanel("Dependency list", uiOutput("deps.list")),
    tabPanel(
      "Dependency graph",
      sidebarLayout(
        sidebarPanel(
          radioButtons("deps.type", "Show",
                       c("Dependencies"="out",
                         "Reverse dependencies"="in")),
          radioButtons("graph.type", "Graphic type",
                       c("Sankey"="sankey",
                         "Graph"="graph")),
          width=2),
        mainPanel(uiOutput("depsgraph")))
    ),
    tabPanel(
      "Namespace",
      sidebarLayout(
        sidebarPanel(
          ## radioButtons("namespace.sort", "Sort objects by",
          ##              c("Name"="name")),
          radioButtons("namespace.sort", "Sort conflict packages by",
                       c("Oldest first"="old",
                         "Alphabetical"="alpha")),
          checkboxGroupInput("namespace.filters", "Show only",
                             c("Functions"="functions",
                               "Conflicts"="conflicts",
                               "Last CRAN version"="cran",
                               "Sibling packages"="siblings")),
          width=2),
        mainPanel(uiOutput("namespace")))
    ),
    tabPanel(
      "Clones",
      sidebarLayout(
        sidebarPanel(
          numericInput("clones.filter.size", "Minimum clone AST size", 10, 0),
          numericInput("clones.filter.loc", "Minimum clone LOC", 3, 0),
          ## radioButtons("clones.sort", "Sort clones by",
          ##              c("Size"="size")),
          radioButtons("clones.sort", "Sort packages by",
                       c("Oldest first"="old",
                         "Alphabetical"="alpha")),
          checkboxGroupInput("clones.filters", "Show only",
                             c("Last CRAN version"="cran")),
          width=2),
        mainPanel(uiOutput("clones")))
    )
  )
))
