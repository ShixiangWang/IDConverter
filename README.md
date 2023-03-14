
<!-- README.md is generated from README.Rmd. Please edit that file -->

# IDConverter

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/IDConverter)](https://cran.r-project.org/package=IDConverter)
[![Codecov test
coverage](https://codecov.io/gh/ShixiangWang/IDConverter/branch/master/graph/badge.svg)](https://app.codecov.io/gh/ShixiangWang/IDConverter?branch=master)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html)
[![](https://cranlogs.r-pkg.org/badges/grand-total/IDConverter?color=orange)](https://cran.r-project.org/package=IDConverter)
<!-- badges: end -->

The goal of IDConverter is to convert identifiers between biological
databases. Currently, I mainly use it for promoting cancer study.

## Installation

You can install the released version of IDConverter from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("IDConverter")
```

Or install the latest version of IDConverter in GitHub with:

``` r
remotes::install_github("ShixiangWang/IDConverter")
```

Or Gitee (better in China):

``` r
remotes::install_git("https://gitee.com/ShixiangWang/IDConverter")
```

## Available features

**ID conversions**:

- `convert_custom()` - Convert custom database identifiers.
- `convert_icgc()` - Convert ICGC identifiers.
- `convert_pcawg()` - Convert PCAWG identifiers.
- `convert_tcga()` - Convert TCGA identifiers.
- `convert_hm_genes()` - Convert human/mouse gene IDs between Ensembl
  and Hugo Symbol system.

Annotation tables from
[annotables](https://github.com/stephenturner/annotables) are available
in this package, you can use `ls_annotables()` to print the table list
and then use `load_data()` to download and load the data into R for
conversion operation.

**Others**:

- `parse_gdc_file_uuid()` - Parse Metadata from GDC Portal File UUID.
- `filter_tcga_barcodes()` - Filter TCGA Replicate Sample Barcodes.

## Examples

``` r
library(IDConverter)
```

To follow the CRAN policy, I have to set `tempdir()` as default data
path, however, I recommend you set the data path to a specified path
with `options(IDConverter.datapath)`.

e.g.,

``` r
options(IDConverter.datapath = system.file("extdata", package = "IDConverter"))
```

### TCGA

``` r
x <- convert_tcga("TCGA-02-0001-10")
#> Downloading https://zenodo.org/record/6342397/files/tcga.rda to /Users/wsx/Library/R/IDConverter/extdata/tcga.rda
x
#> [1] "TCGA-02-0001"
```

### PCAWG

``` r
x <- convert_pcawg("SP1677")
#> Downloading https://zenodo.org/record/6342397/files/pcawg_full.rda to /Users/wsx/Library/R/IDConverter/extdata/pcawg_full.rda
x
#> [1] "DO804"
```

### ICGC

``` r
x <- convert_icgc("SP29019")
#> Downloading https://zenodo.org/record/6342397/files/icgc.rda to /Users/wsx/Library/R/IDConverter/extdata/icgc.rda
x
#> [1] "DO13695"
```

### Genes

``` r
convert_hm_genes(c("TP53", "KRAS", "EGFR", "MYC"), type = "symbol")
#> [1] "ENSG00000141510" "ENSG00000133703" "ENSG00000146648" "ENSG00000136997"

# Or use data from annotables
ls_annotables()
#> Downloading https://zenodo.org/record/6342397/files/ensembl_version.rda to /Users/wsx/Library/R/IDConverter/extdata/ensembl_version.rda
#> Version: Ensembl Genes 105
#>  [1] "bdgp6"            "bdgp6_tx2gene"    "galgal5"          "galgal5_tx2gene" 
#>  [5] "grch37"           "grch37_tx2gene"   "grch38"           "grch38_tx2gene"  
#>  [9] "grcm38"           "grcm38_tx2gene"   "mmul801"          "mmul801_tx2gene" 
#> [13] "rnor6"            "rnor6_tx2gene"    "wbcel235"         "wbcel235_tx2gene"
grch37 = load_data("grch37")
#> Downloading https://zenodo.org/record/6342397/files/grch37.rda to /Users/wsx/Library/R/IDConverter/extdata/grch37.rda
head(grch37)
#> # A tibble: 6 × 9
#>   ensgene         entrez symbol   chr       start     end strand biotype descr…¹
#>   <chr>            <int> <chr>    <chr>     <int>   <int>  <int> <chr>   <chr>  
#> 1 ENSG00000000003   7105 TSPAN6   X     100627108  1.01e8     -1 protei… tetras…
#> 2 ENSG00000000005  64102 TNMD     X     100584936  1.01e8      1 protei… tenomo…
#> 3 ENSG00000000419   8813 DPM1     20     50934867  5.10e7     -1 protei… dolich…
#> 4 ENSG00000000457  57147 SCYL3    1     169849631  1.70e8     -1 protei… SCY1 l…
#> 5 ENSG00000000460  55732 C1orf112 1     169662007  1.70e8      1 protei… chromo…
#> 6 ENSG00000000938   2268 FGR      1      27612064  2.76e7     -1 protei… FGR pr…
#> # … with abbreviated variable name ¹​description
convert_custom(c("TP53", "KRAS", "EGFR", "MYC"),
               from = "symbol", to = "entrez", dt = grch37)
#> [1] "7157" "3845" "1956" "4609"
```

## Citation

***Wang S, Li H, Song M, Tao Z, Wu T, He Z, et al. (2021) Copy number
signature analysis tool and its application in prostate cancer reveals
distinct mutational processes and clinical outcomes. PLoS Genet 17(5):
e1009557.*** <https://doi.org/10.1371/journal.pgen.1009557>

## Similar package

- [AnnoProbe](https://github.com/jmzeng1314/AnnoProbe/) ([Gitee
  mirror](https://gitee.com/jmzeng/annoprobe)) is an R package for
  transforming Chips probes to different Gene IDs.

## LICENSE

MIT@2020, Shixiang Wang
