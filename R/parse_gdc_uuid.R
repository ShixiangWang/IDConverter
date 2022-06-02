#' Parse Sample ID from GDC Portal File UUID
#'
#' @param x a GDC manifest file or a vector of file UUIDs.
#' @param legacy if use GDC legacy data.
#' @param token the token used for querying.
#' @param max_try maximum try time.
#'
#' @return a `data.frame`
#' @importFrom httr GET content
#' @export
#'
#' @examples
#'
#' parse_gdc_file_uuid("fe522fc8-e690-49b9-b3b6-fa3658705057")
#' parse_gdc_file_uuid(
#'   c(
#'     "fe522fc8-e690-49b9-b3b6-fa3658705057",
#'     "2c16506f-1110-4d60-81e3-a85233c79909"
#'   )
#' )
parse_gdc_file_uuid <- function(x, legacy = FALSE, token = NULL, max_try = 5L) {
  if (length(x) == 1 && file.exists(x)) {
    x <- data.table::fread(x)[[1]]
  }
  message("Querying info from GDC portal API: https://api.gdc.cancer.gov")

  body <- list(
    fields = "file_id,cases.samples.submitter_id", filters = list(
      op = structure("in", class = c("scalar", "character")), content = list(
        field = "file_id", value = x
      )
    ), legacy = FALSE,
    facets = "", expand = "", from = 0, size = length(x), format = "tsv",
    pretty = "FALSE"
  )

  uri <- sprintf("%s/%s", "https://api.gdc.cancer.gov", "files")
  if (legacy) {
    uri <- sprintf("%s/legacy/%s", "https://api.gdc.cancer.gov", "files")
    body$legacy <- TRUE
  }

  try_post <- function(uri, token, body, max_try = 5L) {
    Sys.sleep(0.1)
    tryCatch(
      {
        message("Try querying data #", abs(max_try - 6L))
        httr::POST(uri, httr::add_headers(`X-Auth-Token` = token),
          body = body, encode = "json"
        )
      },
      error = function(e) {
        if (max_try == 1) {
          stop("Tried 5 times but failed, please check URL or your internet connection or try it later!")
        } else {
          try_post(uri, token, body, max_try = max_try - 1L)
        }
      }
    )
  }

  response <- try_post(uri, token, body, max_try)
  # response <- httr::POST(uri, httr::add_headers(`X-Auth-Token` = token),
  #                  body = body, encode = "json")
  httr::stop_for_status(response)
  rv <- httr::content(response, show_col_types = FALSE)
  colnames(rv)[1] <- "sample"
  rv
}
