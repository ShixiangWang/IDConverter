# IDConverter 0.3.2

* Enhanced `parse_gdc_file_uuid()`.

# IDConverter 0.3.1

* Re-implemented `parse_gdc_file_uuid()`.

# IDConverter 0.3.0

* Used tempdir as user default data directory.
* Supported [annotables](https://github.com/stephenturner/annotables) annotation data tables by combining newly created `ls_annotables()` and `load_data()`.
* Added `convert_hm_genes()` - Convert human/mouse gene IDs between Ensembl and Hugo Symbol system.

# IDConverter 0.2.0

* Added `filter_tcga_barcodes` for TCGA barcode filtering.
* Moved all data to Zenodo `https://zenodo.org/record/6336671` to keep this package smaller.

# IDConverter 0.1.1

* Added `parse_gdc_file_uuid()` to "Parse Metadata from GDC Portal File UUID".
* Added `multiple` option to return a map `data.table`.

# IDConverter 0.1.0

* Added `convert_custom()` to allow user construct custom database for conversion.
* Added `convert_icgc()`.
* Added `convert_pcawg()`.
* Added `convert_tcga()`.

# IDConverter 0.0.0.9000

* Added a `NEWS.md` file to track changes to the package.
