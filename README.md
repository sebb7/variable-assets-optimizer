# variable-assets-optimizer
Modules for creating optimal portfolio from variable number of assets

### Sample data used in computations

All necessary data is provided in [`R_data`](https://github.com/sebb7/variable-assets-optimizer/tree/master/R_data) as R data and in [`other_files`](https://github.com/sebb7/variable-assets-optimizer/blob/master/other_files) as data in csv. 

Computations are based on [composition](https://github.com/sebb7/variable-assets-optimizer/blob/master/other_files/share_in_wig30.csv) of WIG30 index and rates of returns of companies from this index.

### Source of sample data for polish index comapnies

Files which are used in computations were obtained with scripts from this [repository](https://github.com/sebb7/portfolio-analyzer). Data for necessary transformations were obtained from [GPW site](www.gpw.pl/historical-index-portfolios) and transformed to R-data with [`pdf-tables-to-R-data.R`](https://github.com/sebb7/portfolio-analyzer/blob/master/pdf-tables-to-R-data.R) script.

