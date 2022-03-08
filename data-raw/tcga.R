## code to prepare `tcga` dataset goes here
# https://bioconductor.org/packages/release/bioc/vignettes/TCGAbiolinks/inst/doc/clinical.html#Other_useful_code

setwd("data-raw/")

# clin <- GDCquery_clinic("TCGA-ACC", type = "biospecimen", save.csv = FALSE)

library(data.table)
library(dplyr)
library(regexPipes)
library(TCGAbiolinks)

# This code will get all clinical XML data from TCGA
getclinical <- function(proj) {
  message(proj)
  while (1) {
    result <- tryCatch(
      {
        query <- GDCquery(project = proj, data.category = "Clinical", file.type = "xml")
        GDCdownload(query)
        clinical <- GDCprepare_clinic(query, clinical.info = "patient")
        for (i in c("admin", "radiation", "follow_up", "drug", "new_tumor_event")) {
          message(i)
          aux <- GDCprepare_clinic(query, clinical.info = i)
          if (is.null(aux) || nrow(aux) == 0) next
          # add suffix manually if it already exists
          replicated <- which(grep("bcr_patient_barcode", colnames(aux), value = T, invert = T) %in% colnames(clinical))
          colnames(aux)[replicated] <- paste0(colnames(aux)[replicated], ".", i)
          if (!is.null(aux)) clinical <- merge(clinical, aux, by = "bcr_patient_barcode", all = TRUE)
        }
        readr::write_csv(clinical, path = paste0(proj, "_clinical_from_XML.csv")) # Save the clinical data into a csv file
        return(clinical)
      },
      error = function(e) {
        message(paste0("Error clinical: ", proj))
      }
    )
  }
}
clinical <- TCGAbiolinks:::getGDCprojects()$project_id %>%
  regexPipes::grep("TCGA", value = T) %>%
  sort() %>%
  plyr::alply(1, getclinical, .progress = "text") %>%
  rbindlist(fill = TRUE) %>%
  setDF()

clinical2 <- clinical %>%
  dplyr::select(c(
    "bcr_patient_barcode"
  )) %>%
  unique() %>%
  dplyr::arrange(bcr_patient_barcode)

readr::write_csv(clinical2, path = "tcga_id.csv")
# gzip it
system("gzip tcga_id.csv")

##
setwd("../")
getwd()
tcga_barcode <- data.table::fread("data-raw//tcga_id.csv.gz")


## Query case metadata
# example https://api.gdc.cancer.gov/cases?filters=%7B%22op%22%3A%22and%22%2C%22content%22%3A%5B%7B%22op%22%3A%22in%22%2C%22content%22%3A%7B%22field%22%3A%22submitter_id%22%2C%22value%22%3A%5B%22TCGA-02-0001%22%5D%7D%7D%5D%7D%0A%0A

query_case_metadata <- function(submitter_id) {
  jsonlite::read_json(
    paste0(
      "https://api.gdc.cancer.gov/cases?filters=%7B%22op%22%3A%22and%22%2C%22content%22%3A%5B%7B%22op%22%3A%22in%22%2C%22content%22%3A%7B%22field%22%3A%22submitter_id%22%2C%22value%22%3A%5B%22",
      submitter_id,
      "%22%5D%7D%7D%5D%7D%0A%0A"
    ),
    simplifyVector = TRUE
  )
}

library(parallel)
tcga_list <- mclapply(tcga_barcode$bcr_patient_barcode,
  query_case_metadata,
  mc.cores = 8L
)

tcga <- purrr::map_df(tcga_list, ~ .$data$hits) %>% dplyr::as_tibble()

saveRDS(tcga, "data-raw/tcga_metadata_for_all_cases.RDS")

# To keep simple, only use submitter_id & submitter_aliquot_ids
# case id can be viewed at the page, e.g. https://portal.gdc.cancer.gov/cases/942c0088-c9a0-428c-a879-e16f8c5bfdb8
tcga_keep <- tcga %>%
  dplyr::select(c("case_id", "aliquot_ids", "submitter_aliquot_ids", "submitter_id")) %>%
  tidyr::unnest(c("submitter_aliquot_ids", "aliquot_ids")) %>%
  unique() %>%
  dplyr::mutate(sample_id = substr(submitter_aliquot_ids, 1, 15))

tcga <- data.table::as.data.table(tcga_keep)

usethis::use_data(tcga, overwrite = TRUE)
