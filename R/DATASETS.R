#' ICGC Sample Identifiers
#' @docType data
#' @name icgc
#' @format A data frame with 155874 rows and 6 variables.
#' @source <https://dcc.icgc.org/repositories>
#' @examples
#' \donttest{
#' load_data("icgc")
#' }
NULL

#' PCAWG Full Sample Identifiers
#' @docType data
#' @name pcawg_full
#' @format A data frame with 7255 rows and 8 variables.
#' @source <https://dcc.icgc.org/releases/PCAWG>
#' @examples
#' \donttest{
#' load_data("pcawg_full")
#' }
NULL

#' PCAWG Mutation Related Simplified Sample Identifiers
#'
#' This dataset contains less records than `data("pcawg_full")` but
#' with more ID columns. Of note, only white-list donors included.
#' @docType data
#' @name pcawg_simple
#' @format A data frame with 2583 rows and 12 variables.
#' @source <https://www.nature.com/articles/s41586-020-1969-6>
#' @examples
#' \donttest{
#' load_data("pcawg_simple")
#' }
NULL

#' TCGA Case Identifiers
#'
#' How to get the dataset can be viewed in code under `data-raw`.
#' Cases in `case_id` column can be directly mapped to a GDC portal
#' page, e.g. <https://portal.gdc.cancer.gov/cases/30a1fe5e-5b12-472c-aa86-c2db8167ab23>.
#' @docType data
#' @name tcga
#' @format A data frame with 150849 rows and 5 variables.
#' @source <https://portal.gdc.cancer.gov/>
#' @examples
#' \donttest{
#' load_data("tcga")
#' }
NULL
