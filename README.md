
<!-- README.md is generated from README.Rmd. Please edit that file -->

# IDConverter

<!-- badges: start -->

[![Codecov test
coverage](https://codecov.io/gh/ShixiangWang/IDConverter/branch/master/graph/badge.svg)](https://app.codecov.io/gh/ShixiangWang/IDConverter?branch=master)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html)
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

ID convertions:

-   `convert_custom()` - Convert custom database identifiers.
-   `convert_icgc()` - Convert ICGC identifiers.
-   `convert_pcawg()` - Convert PCAWG identifiers.
-   `convert_tcga()` - Convert TCGA identifiers.

Others:

-   `parse_gdc_file_uuid()` - Parse Metadata from GDC Portal File UUID.
-   `filter_tcga_barcodes()` - Filter TCGA Replicate Sample Barcodes.

## Examples

``` r
library(IDConverter)
```

### TCGA

``` r
x <- convert_tcga("TCGA-02-0001-10")
x
#> [1] "TCGA-02-0001"
```

### PCAWG

``` r
x <- convert_pcawg("SP1677")
x
#> [1] "DO804"
```

### ICGC

``` r
x <- convert_icgc("SP29019")
x
#> [1] "DO13695"
```

## Citation

***Wang S, Li H, Song M, Tao Z, Wu T, He Z, et al. (2021) Copy number
signature analysis tool and its application in prostate cancer reveals
distinct mutational processes and clinical outcomes. PLoS Genet 17(5):
e1009557.*** <https://doi.org/10.1371/journal.pgen.1009557>

## Similar package

-   [AnnoProbe](https://github.com/jmzeng1314/AnnoProbe/) ([Gitee
    mirror](https://gitee.com/jmzeng/annoprobe)) is an R package for
    transforming Chips probes to different Gene IDs.

## LICENSE

MIT@2020, Shixiang Wang
