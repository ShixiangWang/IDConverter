## code to prepare `pcawg` dataset goes here

# Download from ICGC PCAWG repository
pcawg_full <- data.table::fread("data-raw/pcawg_sample_sheet.tsv")
pcawg_full <- pcawg_full[, c(
  "donor_unique_id",
  "submitter_donor_id",
  "icgc_donor_id",
  "aliquot_id",
  "submitter_specimen_id",
  "icgc_specimen_id",
  "submitter_sample_id",
  "icgc_sample_id"
)]
pcawg_full <- unique(pcawg_full)
usethis::use_data(pcawg_full, overwrite = TRUE)


# Data from Nature 2020 PCAWG flagship paper
# https://www.nature.com/articles/s41586-020-1969-6
# Only white list donors are included
pcawg_simple <- readxl::read_excel("data-raw/Supplementary Table 1.xlsx", skip = 2)

data.table::setDT(pcawg_simple)
pcawg_simple[, c(
  "tumour_specimen_aliquot_id", "normal_specimen_aliquot_id",
  "donor_unique_id", "submitted_donor_id",
  "icgc_donor_id", "icgc_sample_id", "icgc_specimen_id",
  "submitted_specimen_id", "submitted_sample_id",
  "tcga_specimen_uuid", "tcga_sample_uuid", "tcga_donor_uuid"
)] -> pcawg_simple
pcawg_simple <- unique(pcawg_simple)

usethis::use_data(pcawg_simple, overwrite = TRUE)
