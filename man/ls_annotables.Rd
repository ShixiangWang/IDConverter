% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/annotables-data.R
\name{ls_annotables}
\alias{ls_annotables}
\title{List Annotation Tables from \code{annotables} package}
\usage{
ls_annotables()
}
\value{
a \code{data.frame}
}
\description{
The tables are obtained from \href{https://github.com/stephenturner/annotables}{annotables}
package and stored in Zenodo for better management. They can be downloaded and
loaded with \code{\link[=load_data]{load_data()}}. See details for more info.
}
\details{
Many bioinformatics tasks require converting gene identifiers from one convention to another, or annotating gene identifiers with gene symbol, description, position, etc. Sure, \href{https://bioconductor.org/packages/release/bioc/html/biomaRt.html}{biomaRt} does this for you, but users may get tired of remembering biomaRt syntax and hammering Ensembl's servers every time. These tables have basic annotation information from \strong{Ensembl Genes} for:
\itemize{
\item Human build 38 (\code{grch38})
\item Human build 37 (\code{grch37})
\item Mouse (\code{grcm38})
\item Rat (\code{rnor6})
\item Chicken (\code{galgal5})
\item Worm (\code{wbcel235})
\item Fly (\code{bdgp6})
\item Macaque (\code{mmul801})
Where each table contains:
\item \code{ensgene}: Ensembl gene ID
\item \code{entrez}: Entrez gene ID
\item \code{symbol}: Gene symbol
\item \code{chr}: Chromosome
\item \code{start}: Start
\item \code{end}: End
\item \code{strand}: Strand
\item \code{biotype}: Protein coding, pseudogene, mitochondrial tRNA, etc.
\item \code{description}: Full gene name/description
Additionally, there are \code{tx2gene} tables that link Ensembl gene IDs to Ensembl transcript IDs.
}

\strong{NOTE}, the description above is copied from README of \code{annotables} package.
If you are unclear to the data tables, please refer to \href{https://github.com/stephenturner/annotables}{annotables}.
}
\examples{
\donttest{
ls_annotables()
load_data(ls_annotables()[1])
}
}
\references{
\url{https://github.com/stephenturner/annotables}
}
