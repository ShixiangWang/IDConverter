#' Convert PCAWG Identifiers
#'
#' Run `data("pcawg_full")` or `data("pcawg_simple")` to see detail database for conversion.
#' The `pcawg_simple` database only contains PCAWG white-list donors.
#'
#' @param x A character vector to convert.
#' @param from Which identifier type to be converted.
#' For db "full", one of `r paste(colnames(pcawg_full), collapse = ", ")`.
#' For db "simple", one of `r paste(colnames(pcawg_simple), collapse = ", ")`.
#' @param to Identifier type convert to. Same as parameter `from`.
#' @param db Database, one of "full" (for `data("pcawg_full")`) or
#' "simple" (for `data("pcawg_simple")`).
#'
#' @return A character vector.
#' @export
#'
#' @examples
#' convert_pcawg("SP1677")
#' \dontrun{
#' convert_pcawg("SA5213")
#' }
convert_pcawg <- function(x,
                          from = "icgc_specimen_id",
                          to = "icgc_donor_id",
                          db = c("full", "simple")) {
  db <- match.arg(db)
  db <- switch(db,
    full = "pcawg_full",
    simple = "pcawg_simple"
  )

  stopifnot(length(from) == 1L, length(to) == 1L)
  if (from == to) {
    stop("from and to cannot be same.")
  }

  dt <- get(db, envir = as.environment("package:IDConverter"))
  convert(dt, x, from, to)
}
