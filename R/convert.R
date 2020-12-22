# Core convert part
# @param dt A `data.table` with 2 columns.
# @param x A character vector to to converted.
# @param from type to be converted.
# @param to type convert to.
# @param multiple support mapping to multiple samples
convert <- function(dt, x, from, to, multiple = FALSE) {
  if (!all(c(from, to) %in% colnames(dt))) {
    stop(paste0(
      "Bad identifier types, valid input are:\n",
      paste(colnames(dt), collapse = ", ")
    ))
  }
  dt <- dt[, c(from, to), with = FALSE]
  # Drop NAs and make sure unique
  dt <- unique(dt[!is.na(dt[[1]])])
  # Filter out useless rows
  dt <- dt[dt[[1]] %in% x]
  # Construct Map
  mp <- dt[[2]]
  names(mp) <- dt[[1]]
  if (all(!x %in% dt[[1]])) {
    stop("Cannot find your input in 'from', please check the identifier type!")
  }
  if (!multiple) {
    if (any(duplicated(dt[[1]]))) {
      warning("Please note multiple identifiers can be converted to, but only the first is used!", immediate. = TRUE)
    }
    x <- as.character(mp[x])
  } else {
    x <- dt
    colnames(x) <- c("from", "to")
  }
  return(x)
}
