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
    RenderClones(data()[["package"]], data()$packages, data()$code,
                 data()$clones, input$clones.sort,
                 input$clones.filter.size, input$clones.filter.loc,
                 input$clones.filters)
  })
  output$depsgraph <- renderPrint({
    RenderDepsGraph(data()[["package"]], data()$deps,
                    input$deps.type, input$graph.type)
  })
  output$deps.list <- renderUI({
    RenderDepsList(data()[["package"]], data()$deps, data()$date)
  })
  output$namespace <- renderUI({
    ## print(data()$conflicts)
    RenderNamespace(data()[["package"]], data()$packages, data()$deps,
                    data()$namespace, data()$conflicts,
                    input$namespace.sort, input$namespace.filters)
  })
  output$history <- renderPlot({
    RenderHistory(data()[["package"]], data()$deps,
                  input$history.type, input$history.range)
  })
})
