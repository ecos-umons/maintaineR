library(extractoR.utils)
library(igraph)
library(CloneR)
library(rCharts)
library(d3Network)
library(timeline)
library(maintaineR)

datadir <- "../../data"
cran <- ReadCRANData(datadir)

PackageFullName <- function(p) {
  paste(p["package"], p["version"], sep="_")
}

PackageLink <- function(p) {
  sprintf("?p=%s&v=%s", p["package"], p["version"])
}

ParseParams <- function(session) {
  params <- parseQueryString(session$clientData$url_search)
  list(package=params$p, version=params$v, date=params$d)
}

MakeTable <- function(df, class="table") {
  tags$table(tags$tr(lapply(names(df), tags$th)),
             tagList(by(df, 1:nrow(df),
                        function(x) tags$tr(lapply(x, tags$td)))),
             class=class)
}

RenderTitle <- function(package, version, date) {
  if (is.null(package)) {
    "CRAN"
  } else if (is.null(version)) {
    sprintf("No version for %s at %s", package, date)
  } else {
    sprintf("%s %s (%s)", package, version, date)
  }
}

RenderSummary <- function(package, date, packages, descfile) {
  if (is.null(package)) {
    res <- packages[c("package", "version")]
    res <- res[order(res$package), ]
    res$package <- apply(res, 1, function(p) {
      tags$a(href=sprintf("?p=%s&d=%s", p["package"], date), p["package"])
    })
    MakeTable(res)
  } else if (nrow(descfile)) {
    MakeTable(descfile)
  }
}

RenderFunctions <- function(functions) {
  refs <- tagList(lapply(functions, function(f) {
    name <- as.character(f$name)
    name <- if (is.na(name[1])) "Anonymous function" else name
    file <- attr(f$ref, "srcfile")$filename
    text <- sprintf("%s in %s at lines %d to %d",
                    name, file, f$ref[1], f$ref[3])
    tagList(text, tags$br())
  }))
  tagList(p(refs), tags$pre(functions[[1]]$body))
}

RenderClones <- function(package, code, clones, sort, filter1, filter2) {
  if (!is.null(package)) {
    clones <- switch(sort,
                     alpha=clones[order(apply(clones, 1, PackageFullName)), ],
                     old=clones[order(clones$mtime), ])
    if (nrow(clones)) {
      res <- data.frame(Hash=unique(as.character(clones$hash)),
                        stringsAsFactors=FALSE)
      res$Functions <- lapply(res$Hash, function(f) code[[f]])
      res$Size <- sapply(res$Functions, function(f) f[[1]]$size)
      res$LOC <- sapply(res$Functions, function(f) {
        length(strsplit(f[[1]]$body, "\n")[[1]])
      })
      res$Functions <- lapply(lapply(res$Hash, function(f) code[[f]]),
                              RenderFunctions)
      res$Packages <- split(apply(clones, 1, function(p) {
        tagList(a(href=PackageLink(p), PackageFullName(p)), br())
      }), as.character(clones$hash))[res$Hash]
      res <- res[res$Size >= filter1 & res$LOC >= filter2,
                 c("Functions", "Size", "LOC", "Packages", "Hash")]
      if (nrow(res)) {
        res <- res[order(-res$Size, res$Hash), ]
        MakeTable(res)
      }
    }
  }
}

RenderDepsGraph <- function(package, deps, deps.type, graph.type) {
  if (!is.null(package)) {
    if (package %in% V(deps)$name) {
      g <- GraphSubset(deps, package, deps.type)
      if (length(E(g))) {
        render <- if (graph.type == "sankey") RenderSankey else RenderGraph
        render(g)
      }
    } else {
      p(sprintf("%s not found", package))
    }
  }
}

RenderDepsList <- function(package, deps, date) {
  if (!is.null(package)) {
    deps.out <- setdiff(Dependencies(deps, package, type="out"), package)
    deps.in <- setdiff(Dependencies(deps, package, type="in"), package)
    res <- data.frame(Type=c(rep("Dependency", length(deps.out)),
                        rep("Reverse", length(deps.in))))
    res$Package <- lapply(c(deps.out, deps.in), function(p) {
      tags$a(href=sprintf("?p=%s&d=%s", p, date), p)
    })
    MakeTable(res)
  }
}

RenderNamespace <- function(package, version, namespace, conflicts, sort) {
  if (!is.null(package)) {
    c <- switch(sort,
                alpha=conflicts[order(apply(conflicts, 1, PackageFullName)), ],
                old=conflicts[order(conflicts$mtime), ])
    if (!is.null(namespace)) {
      res <- data.frame(Name=sapply(namespace, function(x) x$name),
                        Type=sapply(namespace,
                          function(x) paste(unique(x$type), collapse=", ")))
      confs <- split(apply(c, 1, function(p) {
        tagList(a(href=PackageLink(p), PackageFullName(p)), br())
      }), as.character(c$name))[res$Name]
      res$Conflicts <- lapply(as.character(res$Name), function(n) {
        if (n %in% names(confs)) confs[[n]] else "None"
      })
      MakeTable(res)
    }
  }
}

RenderHistory <- function(package, deps, type, range) {
  if (!is.null(package)) {
    if (package %in% V(deps)$name) {
      packages <- package
      if ("deps" %in% type) {
        packages <- union(packages, Dependencies(deps, package))
      }
      if ("revdeps" %in% type) {
        packages <- union(packages, Dependencies(deps, package, "in"))
      }
      history <- lapply(packages, PackageHistory, cran, range)
      history <- history[sapply(history, nrow) > 0]
      print(timeline(FlattenDF(history)))
    }
  }
}
