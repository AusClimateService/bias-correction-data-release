# Data Reference Syntax (DRS)

This document defines the file naming conventions and metadata (i.e. netCDF attributes)
for the bias corrected CORDEX-Australasia data being produced by the Australian Climate Service.
It follows the DRS for bias-adjusted CORDEX simulations
([Nikulin & Legutke, 2016](http://is-enes-data.github.io/CORDEX_adjust_drs.pdf)).
It should be noted that achieving absolute consistency across the
[CCAMoc-v2112](https://dx.doi.org/10.25914/8fve-1910),
[BARPA-R](https://dx.doi.org/10.25914/z1x6-dq28) and
[CCAM-v2203-SN](https://dx.doi.org/10.25914/rd73-4m3)
contributions to CORDEX-Australasia isn't possible
because each modelling group has used slightly different global file attributes.

### File name

Bias corrected data files should inherit the same file name as the original CORDEX data file
with a simple modification to the variable name by adding the suffix "Adjust".
For example, the file
```
pr_AUS-10i_CNRM-ESM2-1_historical_r1i1p1f2_CSIRO_CCAM-v2203-SN_v1-r1_day_19540101-19541231.nc
```
would become
```
prAdjust_AUS-10i_CNRM-ESM2-1_historical_r1i1p1f2_CSIRO_CCAM-v2203-SN_v1-r1_day_19540101-19541231.nc
```
Within the netCDF file the variable name remains unchanged (e.g. it would remain as `pr`).

### Variable attributes 

Bias corrected data files should inherit the variable attributes of the original CORDEX data file
with one small modification.
The words "Bias-Adjusted" should be added to the beginning of the `long_name` variable attribute.
For example,
```
pr:long_name = "Precipitation"
```
would become
```
pr:long_name = "Bias-Adjusted Precipitation"
```

### Global attributes

As a starting point, bias corrected data files should inherit the global attributes of the original CORDEX data file.
A number of global attributes then need to be deleted, overwritten or created anew.

