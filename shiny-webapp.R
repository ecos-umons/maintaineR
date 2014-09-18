library(shiny)
datadir <- "/data/cran"
shiny::runApp(system.file("webapp", package="maintaineR"), port=3000)
