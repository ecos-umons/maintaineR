library(shiny)

shinyUI(tagList(
  tags$head(
    tags$link(rel="stylesheet", href="lib/rCharts_d3_sankey/libraries/widgets/d3_sankey/css/sankey.css"),
    tags$script(src="lib/rCharts_d3_sankey/libraries/widgets/d3_sankey/js/d3.v3.js"),
    tags$script(src="lib/rCharts_d3_sankey/libraries/widgets/d3_sankey/js/sankey.js"),
    tags$style("
      .rChart {
        display: block;
        margin-left: auto;
        margin-right: auto;
        width: 960px;
        height: 700px;
      }")),
  uiOutput("main")
))
