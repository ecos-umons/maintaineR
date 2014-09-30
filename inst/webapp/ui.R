library(shiny)

shinyUI(tagList(
  tags$head(
    tags$link(rel="stylesheet", href="lib/d3sankey/css/sankey.css"),
    tags$script(src="lib/d3sankey/js/d3.v3.js"),
    tags$script(src="lib/d3sankey/js/sankey.js"),
    tags$style("
      .rChart {
        display: block;
        margin-left: auto;
        margin-right: auto;
        width: 960px;
        height: 700px;
      }")),
  progressInit(),
  uiOutput("main")
))
