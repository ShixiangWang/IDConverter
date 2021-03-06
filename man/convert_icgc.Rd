% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/convert_icgc.R
\name{convert_icgc}
\alias{convert_icgc}
\title{Convert ICGC Identifiers}
\usage{
convert_icgc(
  x,
  from = "icgc_specimen_id",
  to = "icgc_donor_id",
  multiple = FALSE
)
}
\arguments{
\item{x}{A character vector to convert.}

\item{from}{Which identifier type to be converted. One of icgc_sample_id, submitted_sample_id, icgc_specimen_id, submitted_specimen_id, icgc_donor_id, submitted_donor_id.}

\item{to}{Identifier type convert to. Same as parameter \code{from}.}

\item{multiple}{if \code{TRUE}, return a \code{data.table} instead of a
string vector, so multiple identifier mappings can be kept.}
}
\value{
A character vector.
}
\description{
Run \code{data("icgc")} to see detail database for conversion.
}
\examples{
x <- convert_icgc("SP29019")
x
\dontrun{
convert_icgc("SA170678")
}
}
