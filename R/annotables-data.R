#' List Annotation Tables from `annotables` package
#'
#' The tables are obtained from [annotables](https://github.com/stephenturner/annotables)
#' package and stored in Zenodo for better management. They can be downloaded and
#' loaded with [load_data()]. See details for more info.
#'
#' Many bioinformatics tasks require converting gene identifiers from one convention to another, or annotating gene identifiers with gene symbol, description, position, etc. Sure, [biomaRt](https://bioconductor.org/packages/release/bioc/html/biomaRt.html) does this for you, but users may get tired of remembering biomaRt syntax and hammering Ensembl's servers every time. These tables have basic annotation information from **Ensembl Genes** for:
#' -   Human build 38 (`grch38`)
#' -   Human build 37 (`grch37`)
#' -   Mouse (`grcm38`)
#' -   Rat (`rnor6`)
#' -   Chicken (`galgal5`)
#' -   Worm (`wbcel235`)
#' -   Fly (`bdgp6`)
#' -   Macaque (`mmul801`)
#' Where each table contains:
#' -   `ensgene`: Ensembl gene ID
#' -   `entrez`: Entrez gene ID
#' -   `symbol`: Gene symbol
#' -   `chr`: Chromosome
#' -   `start`: Start
#' -   `end`: End
#' -   `strand`: Strand
#' -   `biotype`: Protein coding, pseudogene, mitochondrial tRNA, etc.
#' -   `description`: Full gene name/description
#' Additionally, there are `tx2gene` tables that link Ensembl gene IDs to Ensembl transcript IDs.
#'
#' **NOTE**, the description above is copied from README of `annotables` package.
#' If you are unclear to the data tables, please refer to [annotables](https://github.com/stephenturner/annotables).
#' @return a `data.frame`
#' @export
#' @references <https://github.com/stephenturner/annotables>
#'
#' @examples
#' \donttest{
#' ls_annotables()
#' load_data(ls_annotables()[1])
#' }
ls_annotables <- function() {
  message("Version: ", load_data("ensembl_version"))
  c(
    "bdgp6", "bdgp6_tx2gene",
    "galgal5", "galgal5_tx2gene",
    "grch37", "grch37_tx2gene",
    "grch38", "grch38_tx2gene",
    "grcm38", "grcm38_tx2gene",
    "mmul801", "mmul801_tx2gene",
    "rnor6", "rnor6_tx2gene",
    "wbcel235", "wbcel235_tx2gene"
  )
}
