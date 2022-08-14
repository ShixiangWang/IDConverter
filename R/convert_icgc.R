#' Convert ICGC Identifiers
#'
#' Run `data("icgc")` to see detail database for conversion.
#'
#' @inheritParams convert_custom
#' @param x A character vector to convert.
#' @param from Which identifier type to be converted. One of `r paste(colnames(icgc), collapse = ", ")`.
#' @param to Identifier type convert to. Same as parameter `from`.
#'
#' @return A character vector.
#' @export
#'
#' @examples
#' \donttest{
#' x <- convert_icgc("SP29019")
#' x
#' }
#' \dontrun{
#' convert_icgc("SA170678")
#' }
#' @testexamples
#' if (!is.null(x)) expect_equal(x, "DO13695")
#' expect_error(convert_pcawg("SA170678"))
#' expect_error(convert_icgc("SP29019", from = "icgc_specimen_id", to = "icgc_specimen_id"))
convert_icgc <- function(x,
                         from = "icgc_specimen_id",
                         to = "icgc_donor_id",
                         multiple = FALSE) {
  stopifnot(length(from) == 1L, length(to) == 1L)
  if (from == to) {
    stop("from and to cannot be same.")
  }

  dt <- load_data("icgc")
  if (is.null(dt)) {
    warning("Failed converting the data.", immediate. = TRUE)
    return(invisible(NULL))
  }
  convert(dt, x, from, to, multiple)
}
