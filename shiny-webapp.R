library(shiny)
datadir <- "/data/cran"
## datadir <- "/home/maelick/sources/maintaineR/data2"
allow.download <- TRUE
shiny::runApp(system.file("webapp", package="maintaineR"), port=3000)
