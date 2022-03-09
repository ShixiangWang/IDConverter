# Copy from sigminer
query_remote_data <- function(x) {
  x_url <- paste0("https://zenodo.org/record/6336671/files/", x)
  dir_dest <- system.file("extdata", package = "IDConverter")
  # if (!dir.exists(dir_dest)) dir.create(dir_dest, recursive = TRUE)
  x_dest <- file.path(dir_dest, x)
  message("Downloading ", x_url, " to ", x_dest)
  tryCatch(
    {
      download.file(
        url = x_url,
        destfile = x_dest
      )
      TRUE
    },
    error = function(e) {
      warning("Failed downloading the data.", immediate. = TRUE)
      FALSE
    }
  )
}

#' Load Data from Local or Remote Zenodo Repository
#'
#' @param x a dataset name.
#'
#' @return typically a `data.frame`, depends on `x`.
#' @importFrom utils download.file
#' @export
#' @examples
#' \donttest{
#' load_data("pcawg_full")
#' load_data("pcawg_simple")
#' load_data("tcga")
#' load_data("icgc")
#' }
load_data <- function(x) {
  load_file <- file.path(
    system.file("extdata", package = "IDConverter"),
    paste0(x, ".rda")
  )
  ok <- TRUE
  if (!file.exists(load_file)) ok <- query_remote_data(basename(load_file))
  if (!ok) {
    return(invisible(NULL))
  }
  # data = new.env(parent = emptyenv())
  # load(load_file, envir = data)
  # get(ls(data), envir = data)
  load(load_file)
  get(setdiff(ls(), c("load_file", "ok", "x")))
}

# Copy from sigminer
query_remote_data <- function(x) {
  x_url <- paste0("https://zenodo.org/record/4771552/files/", x)
  x_dest <- file.path(system.file("extdata", package = "sigminer"), x)
  message("Downloading ", x_url, " to ", x_dest)
  tryCatch(
    {
      download.file(
        url = x_url,
        destfile = x_dest
      )
      TRUE
    },
    error = function(e) {
      warning("Failed downloading the data.", immediate. = TRUE)
      FALSE
    }
  )
}

get_ref_data <- function(genome_build = c("hg38", "hg19", "mm10", "mm9")) {
  genome_build <- match.arg(genome_build)
  gene_file <- switch(genome_build,
                      mm9 = file.path(
                        system.file("extdata", package = "sigminer"),
                        "mouse_mm9_gene_info.rds"
                      ),
                      mm10 = file.path(
                        system.file("extdata", package = "sigminer"),
                        "mouse_mm10_gene_info.rds"
                      ),
                      file.path(
                        system.file("extdata", package = "sigminer"),
                        paste0("human_", genome_build, "_gene_info.rds")
                      )
  )
  ok <- TRUE
  if (!file.exists(gene_file)) ok <- query_remote_data(basename(gene_file))
  if (!ok) {
    return(invisible(NULL))
  }
  gene_dt <- readRDS(gene_file)
  gene_dt
}

#' Convert Gene IDs between Ensembl and Hugo Symbol System
#'
#' @param IDs a character vector to convert.
#' @param type type of input `IDs`, could be 'ensembl' or 'symbol'.
#' @param genome_build reference genome build.
#' @param multiple 	if `TRUE`, return a `data.table` instead of a string vector,
#' so multiple identifier mappings can be kept.
#'
#' @return a vector or a `data.table`.
#' @export
#'
#' @examples
#' \donttest{
#' convertID("ENSG00000243485")
#' convertID("ENSG00000243485", multiple = TRUE)
#' convertID(c("TP53", "KRAS", "EGFR", "MYC"), type = "symbol")
#' }
convertID <- function(IDs, type = c("ensembl", "symbol"),
                      genome_build = c("hg38", "hg19", "mm10", "mm9"),
                      multiple = FALSE) {
  type <- match.arg(type)
  genome_build <- match.arg(genome_build)
  ref_data <- get_ref_data(genome_build)
  if (genome_build %in% c("hg38", "hg19")) {
    ref_data$gene_id <- substr(ref_data$gene_id, 1, 15)
  } else {
    ref_data$gene_id <- substr(ref_data$gene_id, 1, 18)
  }

  if (type == "symbol") {
    from <- "gene_name"
    to <- "gene_id"
  } else {
    from <- "gene_id"
    to <- "gene_name"
  }

  IDConverter::convert_custom(IDs, from, to, ref_data, multiple)
}
