# Data Reference Syntax (DRS)

This document defines the file naming conventions and metadata (i.e. netCDF attributes)
for the bias corrected CORDEX-Australasia data produced by the Australian Climate Service.
It follows the DRS for bias-adjusted CORDEX simulations
([Nikulin & Legutke, 2016](http://is-enes-data.github.io/CORDEX_adjust_drs.pdf)).
It should be noted that achieving absolute consistency across the
[CCAMoc-v2112](https://dx.doi.org/10.25914/8fve-1910),
[BARPA-R](https://dx.doi.org/10.25914/z1x6-dq28) and
[CCAM-v2203-SN](https://dx.doi.org/10.25914/rd73-4m38)
contributions to CORDEX-Australasia isn't possible
because each modelling group has used slightly different global file attributes.

### File path

Bias corrected data files inherit many of the characteristics of the original CORDEX data file
with a number of small modifications for consistency with the
[ACS data standards](https://github.com/AusClimateService/data-code-group/blob/main/data_standards.md#cordex-cmip6)
and the DRS for bias-adjusted CORDEX simulations.

For example, taking the original file
```
/g/data/hq89/CCAM/output/CMIP6/DD/AUS-10i/CSIRO/CNRM-ESM2-1/ssp370/r1i1p1f2/CCAM-v2203-SN/v1-r1/day/pr/v20231206/pr_AUS-10i_CNRM-ESM2-1_ssp370_r1i1p1f2_CSIRO_CCAM-v2203-SN_v1-r1_day_20540101-20541231.nc
```
and applying QME bias correction would produce the following file:
```
/g/data/ia39/australian-climate-service/test-data/CORDEX-CMIP6/bias-adjustment-output/AGCD-05i/CSIRO/CNRM-ESM2-1/ssp370/r1i1p1f2/CCAM-v2203-SN/v1-r1-ACS-QME-AGCD-1985-2014/day/prAdjust/prAdjust_AGCD-05i_CNRM-ESM2-1_ssp370_r1i1p1f2_CSIRO_CCAM-v2203-SN_v1-r1-ACS-QME-AGCD-1985-2014_day_19540101-19541231.nc
```

(See the global attribute `bc_info` below for an explanation of the `ACS-QME-AGCD-1985-2014` field.) 

### Variable attributes 

Bias corrected data files should inherit the variable attributes of the original CORDEX data file
with two small modifications.
The suffix "Adjust" needs to be added to the variable name (e.g. `pr` becomes `prAdjust`)
and the words "Bias-Adjusted" should be added to the beginning of the `long_name` variable attribute.
For example,
```
prAdjust:long_name = "Precipitation"
```
would become
```
prAdjust:long_name = "Bias-Adjusted Precipitation"
```

### Global attributes

As a starting point, bias corrected data files should inherit the global attributes of the original CORDEX data file.
A number of global attributes then need to be deleted, overwritten or created anew.

#### Rename

If they exist in the original CORDEX data file,
these global attributes need to be renamed:

- `tracking_id` becomes `input_tracking_id`
- `institution` becomes `input_institution`
- `institution_id` becomes `input_institution_id`
- `doi` becomes `input_doi`

#### Delete

If they exist in the original CORDEX data file,
these global attributes need to be deleted:

- `axiom_version`
- `axiom_schemas_version`
- `axiom_schema`
- `productive_version`
- `processing_level`
- `geospatial_lat_min`
- `geospatial_lat_max`
- `geospatial_lat_units`
- `geospatial_lon_min`
- `geospatial_lon_max`
- `geospatial_lon_units`
- `date_modified`
- `date_metadata_modified`

#### Create or modify

The following attributes need to be modified or created if they don't exist
in the original CORDEX data file:

- `institution = "Australian Climate Service"`
- `institution_id = "ACS"`
- `domain = "Australia/AGCD"`
- `domain_id = "AGCD-05i"`
- `driving_experiment = "gap-filling scenario reaching 7.0 based on SSP3"`
- `driving_experiment_id = "ssp370"`
- `product = "bias-adjusted-output"`
- `project_id = "CORDEX-Adjust"`
- `contact = "email@address"`
- `bc_method =`
  - `"Quantile Matching for Extremes (QME); http://www.bom.gov.au/research/publications/researchreports/BRR-087.pdf"`
  - `"Multivariate Recursive Nesting Bias Correction (MRNBC); https://doi.org/10.1016/j.jhydrol.2014.11.037"`
- `bc_method_id =`
  - `"ACS-QME"`
  - `"ACS-MRNBC"`
- `bc_observation =`
  - `"Australian Gridded Climate Data, version 1-0-1; https://dx.doi.org/10.25914/hjqj-0x55; Jones D, Wang W, & Fawcett R (2009). High-quality spatial climate datasets for Australia. Australian Meteorological and Oceanographic Journal, 58, 233-248. http://www.bom.gov.au/jshess/docs/2009/jones_hres.pdf"`
  - `"Bureau of Meteorology Atmospheric high-resolution Regional Reanalysis for Australia, version 2;  https://doi.org/10.25914/1X6G-2V48; Su, C.-H., Rennie, S., Dharssi, I., Torrance, J., Smith, A., Le, T., Steinle, P., Stassen, C., Warren, R. A., Wang, C., and Le Marshall, J. (2022), BARRA2 - Development of the next-generation Australian regional atmospheric reanalysis, Bureau Research Report 067, accessed online http://www.bom.gov.au/research/publications/researchreports/BRR-067.pdf"`
- `bc_observation_id =`
  - `"AGCD"`
  - `"BARRA-R2"`
- `bc_period = 1985-2014` (or whatever the training period is)
- `bc_info =`
  - `"ACS-QME-AGCD-1985-2014"`
  - `"ACS-MRNBC-AGCD-1985-2014"`
- `creation_date = "YYYY-MM-DDTHH:MM:SSZ"`

