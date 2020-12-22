#' Convert Identifiers with Custom Database
#'
#' @param x A character vector to convert.
#' @param from Which identifier type to be converted.
#' @param to Identifier type convert to.
#' @param dt A `data.frame` as database for conversion.
#' @param multiple if `TRUE`, return a `data.table` instead of a
#' string vector, so multiple identifier mappings can be kept.
#'
#' @return A character vector.
#' @export
#'
#' @examples
#' dt <- data.table::data.table(UpperCase = LETTERS[1:5], LowerCase = letters[1:5])
#' dt
#' x <- convert_custom(c("B", "C", "E", "E", "FF"), from = "UpperCase", to = "LowerCase", dt = dt)
#' x
#' @testexamples
#' expect_is(dt, "data.frame")
#' expect_equal(x, c("b", "c", "e", "e", NA))
convert_custom <- function(x,
                           from = NULL,
                           to = NULL,
                           dt = NULL,
                           multiple = FALSE) {
  stopifnot(length(from) == 1L, length(to) == 1L, is.data.frame(dt))
  if (from == to) {
    stop("from and to cannot be same.")
  }

  dt <- data.table::as.data.table(dt)
  convert(dt, x, from, to, multiple)
}
