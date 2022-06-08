#' Parse Sample ID from GDC Portal File UUID
#'
#' @param x a GDC manifest file or a vector of file UUIDs.
#' @param legacy if use GDC legacy data.
#' @param fields a list of fields to query.
#' If it is a string, then fields should be separated by comma.
#' It could also be a vector.
#' See <https://docs.gdc.cancer.gov/API/Users_Guide/Appendix_A_Available_Fields/#file-fields>
#' for list.
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
parse_gdc_file_uuid <- function(x, legacy = FALSE,
                                fields = "cases.samples.submitter_id,cases.samples.sample_type,file_id",
                                token = NULL, max_try = 5L) {
  if (length(x) == 1 && file.exists(x)) {
    x <- data.table::fread(x)[[1]]
  } else {
    if (any(grepl("[\\./]", x))) {
      stop("it seems your input file path does not exist!")
    } else if (!all(nchar(x) == 36)) {
      stop("all GDC file IDs have 35 chars!")
    }
  }
  message("Querying info from GDC portal API: https://api.gdc.cancer.gov")

  if (length(fields) > 1) {
    fields <- fields
    fields <- paste(fields, collapse = ",")
  } else {
    fields <- gsub(" ", "", fields)
    fields2 <- unlist(strsplit(fields, ","))
  }
  message("Fields: ", fields)

  body <- list(
    fields = fields, filters = list(
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
  httr::stop_for_status(response)
  rv <- httr::content(response, show_col_types = FALSE)

  rm_digists_from_name <- function(x) {
    gsub("[0-9]\\.", "", x)
  }

  colnames(rv) <- rm_digists_from_name(colnames(rv))
  rv[, fields2]
}
