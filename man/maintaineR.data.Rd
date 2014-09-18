\name{Data}
\alias{Data}
\alias{ReadCRANData}
\alias{DownloadDataFile}
\alias{DataState}
\alias{PackagesToDownload}
\encoding{UTF-8}
\title{Data}
\description{
  Manipulates CRAN data files.
}

\usage{
ReadCRANData(datadir)
DownloadDataFile(file, dest.root, url.root, download.once=FALSE)
DataState(packages, datadir)
PackagesToDownload(todl, packages, cran, g, options, clones.size, clones.loc)
}
\arguments{
  \item{datadir}{Root data directory.}
  \item{file}{Data file to download.}
  \item{dest.root}{Root directory where to store data.}
  \item{url.root}{Root url where to fetch data.}
  \item{download.once}{If TRUE, downloads data only if the destination
    file doesn't exist.}
  \item{cran}{CRAN data.}
  \item{todl}{Dataframe of packages to download.}
  \item{packages}{Dataframe with all packages.}
  \item{g}{Dependency graph.}
  \item{options}{Vector containing types of related package to consider
    (deps, rev.deps, clones and/or conflicts).}
  \item{clones.size}{Maximum clone AST size to consider.}
  \item{clones.loc}{Maximum clone line of code to consider.}
}
\value{
  \code{ReadCRANData} returns a list with four elements containing
  loaded rds/packages.rds, rds/deps.rds, clones.rds and conflicts.rds
  from https://github.com/maelick/CRANData.

  \code{DownloadDataFile} downloads a data file from url.root.

  \code{DataState} returns a dataframe with package name, version and
  mtime with additional boolean columns indicating if there is a local
  copy of the namespace, function and description file data.

  \code{PackagesToDownload} returns a data.frame listing packages that
  needs to be downloaded along \code{todl}. This will list all of
  dependencies, reverse dependencies and the packages with clones and
  conflicts if they are provided in \code{options}.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{read}
\keyword{cran}
\keyword{data}
\keyword{packages}
\keyword{dependencies}
\keyword{clones}
\keyword{conflicts}
\keyword{file}
\keyword{download}