#' Parse Metadata from GDC Portal File UUID
#'
#' @param x a GDC manifest file or a vector of file UUIDs.
#'
#' @return a `data.frame`
#' @importFrom httr GET content
#' @export
#'
#' @examples
#' parse_gdc_file_uuid("874e71e0-83dd-4d3e-8014-10141b49f12c")
#' parse_gdc_file_uuid(
#'   c(
#'     "874e71e0-83dd-4d3e-8014-10141b49f12c",
#'     "2c16506f-1110-4d60-81e3-a85233c79909"
#'   )
#' )
parse_gdc_file_uuid <- function(x) {
  if (length(x) == 1 && file.exists(x)) {
    x <- data.table::fread(x)[[1]]
  }
  message("Querying info from GDC portal API: https://api.gdc.cancer.gov")

  x <- sprintf("https://api.gdc.cancer.gov/files/%s?format=tsv", x)
  tryCatch(
    data.table::rbindlist(lapply(x, function(x) {
      suppressMessages(content(GET(x), type = "text/tab-separated-values", encoding = "UTF-8"))
    }), use.names = TRUE, fill = TRUE),
    error = function(e) {
      message("The GDC API seems not working, try later again?")
      NULL
    }
  )
}
