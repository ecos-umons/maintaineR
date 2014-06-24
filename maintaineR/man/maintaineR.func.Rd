\name{FlattenDF}
\alias{FlattenDF}
\encoding{UTF-8}
\title{FlattenDF}
\description{
  Converts a list of dataframes having the same columns to a single
  dataframe. This function is more efficient on large list of dataframes
  than calling do.call on rbind.
}

\usage{
FlattenDF(l, keep.rownames)
}
\arguments{
  \item{l}{A list where all elements are dataframes with the same
    columns.}
  \item{keep.rownames}{Keep rownames if TRUE.}
}
\value{
  The dataframe which is the concatenation of all rows of all dataframes
  of the list.
}

\author{
  Maëlick Claes <himself@maelick.net> & Philippe Grosjean
  <Philippe.Grosjean@umons.ac.be>
}

\examples{
l <- sapply(1:3, function(n) data.frame(x=n, y=n:(n*n)))
FlattenDF(l)
}

\keyword{data.frame}
\keyword{df}
\keyword{flatten}
\keyword{list}
