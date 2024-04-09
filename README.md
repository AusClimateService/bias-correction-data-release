# bias-correction-data-release

This repository tracks the details and progress of the first ACS bias corrected CORDEX data release.

## Dataset specifications

The following bias corrected data will be produced for the
[CCAMoc-v2112](https://dx.doi.org/10.25914/8fve-1910),
[BARPA-R](https://dx.doi.org/10.25914/z1x6-dq28) and
[CCAM-v2203-SN](https://dx.doi.org/10.25914/rd73-4m38) model outputs.

| Variable | Timescale | Grid | Units | Observations | Experiments |
| ---      | ---       | ---  | ---   | ---          | ---         |
| Daily maximum surface air temperature (tasmax) | daily | AGCD-05i | C | AGCD, BARRA-R2 | historical, ssp370 |
| Daily minimum surface air temperature (tasmin) | daily | AGCD-05i | C | AGCD, BARRA-R2 | historical, ssp370 |
| Precipitation (pr) | daily | AGCD-05i | mm/day | AGCD, BARRA-R2 | historical, ssp370 |
| Surface downwelling solar radiation (rsds) | daily | AGCD-05i | W/m2 | BARRA-R2 | historical, ssp370 |
| Daily maximum surface wind speed (sfcWindmax) | daily | AGCD-05i | m/s | BARRA-R2 | historical, ssp370 |
| Daily maximum relative humidity (hursmax) | daily | AGCD-05i | % | BARRA-R2 | historical, ssp370 |
| Daily minimum relative humidity (hursmin) | daily | AGCD-05i | % | BARRA-R2 | historical, ssp370 |

AGCD-05i is the AGCD 0.05 x 0.05 degrees spatial grid: 691 latitudes (112.00 to 156.25 East), 886 longitudes (10.0 to 44.5 South). 

The rationale for processing two observational datasets is that BARRA-R2 provides a consistent product across all variables,
while having AGCD available for temperature and precipitation caters to users who don't require consistency across many variables
and just want the (arguably) superior observational underpinning.

## Pre-processed input data for bias correction

Model outputs and observational data were pre-processed prior to bias correction.
This pre-processing involved spatial regridding, unit conversion and re-chunking
and was achieved by running the following at the command line:
```
bash preprocess.sh /path/to/file1.nc /path/to/file12.nc  ... /path/to/fileN.nc
```

The preprocessed AGCD and BARRA-R2 observational data 
are available on NCI at the following (example) directories:
```
/g/data/xv83/agcd-csiro/precip/daily/precip-total_AGCD-CSIRO_r005_19300101-19301231_daily.nc

/g/data/ia39/australian-climate-service/test-data/CORDEX-CMIP6/bias-adjustment-input/AGCD-05i/BOM/ERA5/historical/hres/BARRA-R2/v1/day/pr/pr_AGCD-05i_ERA5_historical_hres_BOM_BARRA-R2_v1_day_200208-200208.nc
```

The preprocessed CORDEX regional climate model data
are available on NCI at the following (example) directories:
```
/g/data/ia39/australian-climate-service/test-data/CORDEX-CMIP6/bias-adjustment-input/AGCD-05i/BOM/CESM2/ssp370/r11i1p1f1/BARPA-R/v1-r1/day/pr/pr_AGCD-05i_CESM2_ssp370_r11i1p1f1_BOM_BARPA-R_v1-r1_day_20220101-20221231.nc
```

## Bias corrected output data

Bias corrected output data are available at:
```
/g/data/ia39/australian-climate-service/test-data/CORDEX-CMIP6/bias-adjustment-output/
```

Those data are formatted and archived according to the data reference syntax described by [drs.md](drs.md).

## Data availability

A summary of what pre-processed input data (first dot) and bias corrected output data (second dot) are currently available.

| GCM | RCM | tasmax | tasmin | pr   | rsds   | sfcWindmax | hursmax | hursmin | 
| --- | --- |  :-:   | :-:    | :-:  | :-:    | :-:        | :-:     | :-:     |
|     | AGCD | :green_circle: | :green_circle: | :green_circle: |  |  |  |  |
|     | BARRA-R2 | :white_circle: | :white_circle: | :green_circle: | :white_circle: | :white_circle: | :white_circle: | :white_circle: |
| ACCESS-CM2 | BARPA-R | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: |
| ACCESS-CM2 | CCAM-v2203-SN | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: |
| ACCESS-ESM1-5 | BARPA-R | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: |
| ACCESS-ESM1-5 | CCAM-v2203-SN | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: |
| CESM2 | BARPA-R | :white_circle: :white_circle: | :white_circle: :white_circle: | :green_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: |
| CESM2 | CCAM-v2203-SN | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: |
| CMCC-ESM2 | BARPA-R | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: |
| CMCC-ESM2 | CCAM-v2203-SN | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: |
| CNRM-ESM2-1 | CCAM-v2203-SN | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: |
| EC-Earth3 | BARPA-R | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: |
| EC-Earth3 | CCAM-v2203-SN | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: |
| MPI-ESM1-2-HR | BARPA-R | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: |
| NorESM2-MM | BARPA-R | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: | :white_circle: :white_circle: |
