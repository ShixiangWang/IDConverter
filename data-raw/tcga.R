## code to prepare `tcga` dataset goes here
# https://bioconductor.org/packages/release/bioc/vignettes/TCGAbiolinks/inst/doc/clinical.html#Other_useful_code

setwd("data-raw/")
library(data.table)
library(dplyr)
library(regexPipes)
library(TCGAbiolinks)

# This code will get all clinical XML data from TCGA
getclinical <- function(proj){
  message(proj)
  while(1){
    result = tryCatch({
      query <- GDCquery(project = proj, data.category = "Clinical",file.type = "xml")
      GDCdownload(query)
      clinical <- GDCprepare_clinic(query, clinical.info = "patient")
      for(i in c("admin","radiation","follow_up","drug","new_tumor_event")){
        message(i)
        aux <- GDCprepare_clinic(query, clinical.info = i)
        if(is.null(aux) || nrow(aux) == 0) next
        # add suffix manually if it already exists
        replicated <- which(grep("bcr_patient_barcode",colnames(aux), value = T,invert = T) %in% colnames(clinical))
        colnames(aux)[replicated] <- paste0(colnames(aux)[replicated],".",i)
        if(!is.null(aux)) clinical <- merge(clinical,aux,by = "bcr_patient_barcode", all = TRUE)
      }
      readr::write_csv(clinical,path = paste0(proj,"_clinical_from_XML.csv")) # Save the clinical data into a csv file
      return(clinical)
    }, error = function(e) {
      message(paste0("Error clinical: ", proj))
    })
  }
}
clinical <- TCGAbiolinks:::getGDCprojects()$project_id %>%
  regexPipes::grep("TCGA",value=T) %>% sort %>%
  plyr::alply(1,getclinical, .progress = "text") %>%
  rbindlist(fill = TRUE) %>% setDF

clinical2 <- clinical %>% dplyr::select(c(
  "patient_id",
  "bcr_patient_barcode", "bcr_radiation_barcode", "bcr_radiation_barcode", "bcr_drug_barcode",
  "bcr_patient_uuid",
  "file_uuid", "bcr_radiation_uuid", "bcr_radiation_uuid",
  "bcr_radiation_uuid")) %>%
  unique() %>%
  dplyr::arrange(patient_id)

readr::write_csv(clinical2, path = "tcga_id.csv")



usethis::use_data(tcga, overwrite = TRUE)
