library(shiny)
datadir <- "/data/cran"
allow.download <- TRUE
shiny::runApp(system.file("webapp", package="maintaineR"), port=3000)
