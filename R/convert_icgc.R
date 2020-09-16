#' Convert ICGC Identifiers
#'
#' @param x A character vector to convert.
#' @param from Which identifier type to be converted.
#' @param to Identifier type convert to.
#'
#' @return A character vector.
#' @export
#'
#' @examples
#' convert_icgc("SP29019")
#' \dontrun{
#' convert_icgc("SA170678")
#' }
convert_icgc <- function(x,
                         from = c("icgc_specimen_id", "submitted_specimen_id",
                                  "icgc_sample_id", "submitted_sample_id",
                                  "icgc_donor_id", "submitted_donor_id"),
                         to = c("icgc_donor_id", "submitted_donor_id",
                                "icgc_specimen_id", "submitted_specimen_id",
                                "icgc_sample_id", "submitted_sample_id")) {
  from = match.arg(from)
  to = match.arg(to)
  stopifnot(length(from) == 1L, length(to) == 1L)
  if (from == to) {
    stop("from and to cannot be same.")
  }

  dt <- get("icgc", envir = as.environment("package:IDConverter"))
  dt <- unique(dt[, c(from, to), with = FALSE])
  mp <- dt[[2]]
  names(mp) <- dt[[1]]
  if (!x %in% dt[[1]]) {
    stop("Cannot find your input in 'from', please check the identifier type!")
  }
  x <- as.character(mp[x])
  return(x)
}
