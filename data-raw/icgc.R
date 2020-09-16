## code to prepare `icgc` dataset goes here

# Select all donors: https://dcc.icgc.org/search?filters=%7B%22donor%22:%7B%22id%22:%7B%22is%22:%5B%22ES:a447f5b5-74e0-4a48-a9b4-bc0a695056e0%22%5D%7D%7D%7D
# Download donor clinical data
# Extract and get sample.tsv.gz

icgc <- data.table::fread("data-raw/icgc-sample.tsv.gz")
icgc <- icgc[, c(1, 3:7)]
usethis::use_data(icgc, overwrite = TRUE)
