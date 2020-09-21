
<!-- README.md is generated from README.Rmd. Please edit that file -->

# IDConverter

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Codecov test
coverage](https://codecov.io/gh/ShixiangWang/IDConverter/branch/master/graph/badge.svg)](https://codecov.io/gh/ShixiangWang/IDConverter?branch=master)
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

## Available features

  - `convert_custom()` - Convert custom database identifiers.
  - `convert_icgc()` - Convert ICGC identifiers.
  - `convert_pcawg()` - Convert PCAWG identifiers.
  - `convert_tcga()` - Convert TCGA identifiers.

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

## LICENSE

MIT@2020, Shixiang Wang
