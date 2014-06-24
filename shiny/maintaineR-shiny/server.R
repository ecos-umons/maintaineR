shinyServer(function(input, output, session) {
  data <- reactive(StateData(cran, datadir, ParseParams(session)))
  output$title <- renderText({
    RenderTitle(data()[["package"]], data()$version, data()$date)
  })
  output$summary <- renderUI({
    RenderSummary(data()[["package"]], data()$date,
                  data()$state, data()$descfile)
  })
  output$clones <- renderUI({
    RenderClones(data()[["package"]], data()$code,
                 data()$clones, input$clones.sort2,
                 input$clones.filter, input$clones.filter2)
  })
  output$depsgraph <- renderPrint({
    RenderDepsGraph(data()[["package"]], data()$deps,
                    input$deps.type, input$graph.type)
  })
  output$deps.list <- renderUI({
    RenderDepsList(data()[["package"]], data()$deps, data()$date)
  })
  output$namespace <- renderUI({
    RenderNamespace(data()[["package"]], data()$version,
                    data()$namespace, data()$conflicts,
                    input$namespace.sort2)
  })
  output$history <- renderPlot({
    RenderHistory(data()[["package"]], data()$deps,
                  input$history.type, input$history.range)
  })
})
