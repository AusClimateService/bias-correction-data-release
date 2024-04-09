# bias-correction-data-release

This repository tracks the details and progress of the first ACS bias corrected CORDEX data release.

## Dataset specifications

The following bias corrected data will be produced for the
[CCAMoc-v2112](https://dx.doi.org/10.25914/8fve-1910),
[BARPA-R](https://dx.doi.org/10.25914/z1x6-dq28) and
[CCAM-v2203-SN](https://dx.doi.org/10.25914/rd73-4m38) model outputs.

| Variable | Timescale | Grid | Units | Observations | Experiments |
| ---      | ---       | ---  | ---   | ---          | ---         |
| Daily maximum surface air temperature (tasmax) | daily | AGCD-05i | C | AGCD, BARRA-R2 | ssp370 |
| Daily minimum surface air temperature (tasmin) | daily | AGCD-05i | C | AGCD, BARRA-R2 | ssp370 |
| Precipitation (pr) | daily | AGCD-05i | mm/day | AGCD, BARRA-R2 | ssp370 |
| Surface downwelling solar radiation (rsds) | daily | AGCD-05i | W/m2 | BARRA-R2 | ssp370 |
| Daily maximum surface wind speed (sfcWindmax) | daily | AGCD-05i | m/s | BARRA-R2 | ssp370 |
| Daily maximum relative humidity (hursmax) | daily | AGCD-05i | % | BARRA-R2 | ssp370 |
| Daily minimum relative humidity (hursmin) | daily | AGCD-05i | % | BARRA-R2 | ssp370 |

AGCD-05i is the AGCD 0.05 x 0.05 degrees spatial grid: 691 latitudes (112.00 to 156.25 East), 886 longitudes (10.0 to 44.5 South). 

The rationale for processing two observational datasets is that BARRA-R2 provides a consistent product across all variables,
while having AGCD available for temperature and precipitation caters to users who don't require consistency across many variables
and just want the (arguably) superior observational underpinning.

The data reference syntax for the bias corrected data is described by [drs.md](drs.md).

## Pre-processed input data for bias correction

Preprocessed AGCD and BARRA-R2 observational data (i.e. with regridding and unit conversion applied as necessary)
are available on NCI at the following (example) directories:
```
/g/data/xv83/agcd-csiro/precip/daily/precip-total_AGCD-CSIRO_r005_19300101-19301231_daily.nc

/g/data/ia39/australian-climate-service/test-data/CORDEX-CMIP6/bias-adjustment-input/AGCD-05i/BOM/ERA5/historical/hres/BARRA-R2/v1/day/pr/pr_AGCD-05i_ERA5_historical_hres_BOM_BARRA-R2_v1_day_200208-200208.nc
```

Preprocessed CORDEX regional climate model data (i.e. with regridding and unit conversion applied as necessary)
are available on NCI at the following (example) directories:
```
/g/data/ia39/australian-climate-service/test-data/CORDEX-CMIP6/bias-adjustment-input/AGCD-05i/BOM/CESM2/ssp370/r11i1p1f1/BARPA-R/v1-r1/day/pr/pr_AGCD-05i_CESM2_ssp370_r11i1p1f1_BOM_BARPA-R_v1-r1_day_20220101-20221231.nc
```
Here's a summary of what pre-processed data are currently available.

| GCM | RCM | experiment | tasmax | tasmin | pr | rsds | sfcWindmax | hursmax | hursmin | 
| ---   | --- | ---        | :-:    | :-:    | :-:| :-:  | :-:        | :-:      | :-:      |
|  | AGCD | historical | :green_circle: | :green_circle: | :green_circle: |  |  |  |  |
| ERA5 | BARRA-R2 | historical | :white_circle: | :white_circle: | :green_circle: | :white_circle: | :white_circle: | :white_circle: | :white_circle: |
| CESM2 | BARPA-R | historical | :white_circle: | :white_circle: | :green_circle: | :white_circle: | :white_circle: | :white_circle: | :white_circle: |
| CESM2 | BARPA-R | ssp370 | :white_circle: | :white_circle: | :green_circle: | :white_circle: | :white_circle: | :white_circle: | :white_circle: |
