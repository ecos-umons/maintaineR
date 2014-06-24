MakeTable <- function(df, class="table") {
  tags$table(tags$tr(lapply(names(df), tags$th)),
             tagList(by(df, 1:nrow(df),
                        function(x) tags$tr(lapply(x, tags$td)))),
             class=class)
}

RenderSankey <- function(graph) {
  E(graph)$value <- 1
  edgelist <- get.data.frame(graph)
  colnames(edgelist) <- c("source","target","value")

  edgelist$source <- as.character(edgelist$source)
  edgelist$target <- as.character(edgelist$target)
  sankeyPlot <- rCharts$new()
  sankeyPlot$setLib('lib/rCharts_d3_sankey/libraries/widgets/d3_sankey')
  sankeyPlot$set(data=edgelist,
                 nodeWidth=15,
                 nodePadding=10,
                 layout=32,
                 width=960,
                 height=20*length(V(graph)))
  sankeyPlot$print(chartId='sankey')
}

RenderGraph <- function(graph) {
  nodes <- data.frame(name=V(graph)$name, group=V(graph)$group)
  edges <- as.data.frame(get.edgelist(graph, names=FALSE) - 1)
  colnames(edges) <- c("source", "target")
  edges <- edges[with(edges, order(source)), ]
  edges$value <- 1
  d3ForceNetwork(Links=edges, Nodes=nodes,
                 Source="source", Target="target",
                 Value="value", NodeID="name",
                 Group="group", width=800, height=600,
                 opacity=0.9, parentElement="#depsgraph", zoom=TRUE)
}
