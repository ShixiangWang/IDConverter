#' ICGC Sample Identifiers
#' @format A data frame with 155874 rows and 6 variables.
#' @source <https://dcc.icgc.org/repositories>
#' @examples
#' data("icgc")
"icgc"

#' PCAWG Full Sample Identifiers
#' @format A data frame with 7255 rows and 8 variables.
#' @source <https://dcc.icgc.org/releases/PCAWG>
#' @examples
#' data("pcawg_full")
"pcawg_full"

#' PCAWG Mutation Related Simplified Sample Identifiers
#'
#' This dataset contains less records than `data("pcawg_full")` but
#' with more ID columns. Of note, only white-list donors included.
#' @format A data frame with 2583 rows and 12 variables.
#' @source <https://www.nature.com/articles/s41586-020-1969-6>
#' @examples
#' data("pcawg_simple")
"pcawg_simple"
