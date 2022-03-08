#' Convert TCGA Identifiers
#'
#' Run `data("tcga")` to see detail database for conversion.
#'
#' @inheritParams convert_custom
#' @param x A character vector to convert.
#' @param from Which identifier type to be converted. One of `r paste(colnames(tcga), collapse = ", ")`.
#' @param to Identifier type convert to. Same as parameter `from`.
#'
#' @return A character vector.
#' @export
#'
#' @examples
#' x <- convert_tcga("TCGA-02-0001-10")
#' x
#' \dontrun{
#' convert_tcga("TCGA-02-0001-10A-01W-0188-10")
#' }
#' @testexamples
#' expect_equal(x, "TCGA-02-0001")
#' expect_error(convert_pcawg("TCGA-02-0001-10A-01W-0188-10"))
convert_tcga <- function(x,
                         from = "sample_id",
                         to = "submitter_id",
                         multiple = FALSE) {
  stopifnot(length(from) == 1L, length(to) == 1L)
  if (from == to) {
    stop("from and to cannot be same.")
  }

  dt <- load_data("tcga")
  convert(dt, x, from, to, multiple)
}
