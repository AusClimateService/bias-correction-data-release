# bias-correction-data-release

This repository tracks the details and progress of the first
Australian Climate Service (ACS) bias corrected CORDEX-CMIP6 data release.

## Dataset specifications

A number of institutions have dynamically downscaled CMIP6 global climate model data
over Australasia as part of the CORDEX-CMIP6 project. 
For this data release,
bias correction will be applied to CORDEX-CMIP6 model outputs produced by the
[Bureau of Meteorology](https://dx.doi.org/10.25914/z1x6-dq28),
[CSIRO](https://dx.doi.org/10.25914/rd73-4m38) and the
[Queensland Future Climate Science Program](https://dx.doi.org/10.25914/8fve-1910)
(see the [Data Availability](#data-availability) table below for details).

| Variable | Timescale | Grid | Units | Observations | Experiments |
| ---      | ---       | ---  | ---   | ---          | ---         |
| Daily maximum surface air temperature (tasmax) | daily | AGCD-05i | C | AGCD, BARRA-R2 | historical, ssp126, ssp370 |
| Daily minimum surface air temperature (tasmin) | daily | AGCD-05i | C | AGCD, BARRA-R2 | historical, ssp126, ssp370 |
| Precipitation (pr) | daily | AGCD-05i | mm/day | AGCD, BARRA-R2 | historical, ssp126, ssp370 |
| Surface downwelling shortwave radiation (rsds) | daily | AGCD-05i | W/m2 | BARRA-R2 | historical, ssp126, ssp370 |
| Daily maximum surface wind speed (sfcWindmax) | daily | AGCD-05i | m/s | BARRA-R2 | historical, ssp126, ssp370 |
| Daily maximum relative humidity (hursmax) | daily | AGCD-05i | % | BARRA-R2 | historical, ssp126, ssp370 |
| Daily minimum relative humidity (hursmin) | daily | AGCD-05i | % | BARRA-R2 | historical, ssp126, ssp370 |

AGCD-05i is the AGCD 0.05 x 0.05 degrees spatial grid: 691 latitudes (112.00 to 156.25 East), 886 longitudes (10.0 to 44.5 South). 

The rationale for bias correcting against two different observational datasets
is that BARRA-R2 provides a consistent product across all variables,
while having AGCD available for temperature and precipitation caters to users who don't require consistency across many variables
and just want the (arguably) superior observational underpinning.

## Pre-processed input data for bias correction

Model outputs and observational data were pre-processed prior to bias correction.
This pre-processing involved spatial regridding, unit conversion and re-chunking
and was achieved by running the following at the command line
for any given GCM / RCM / model run / variable combination:

```
bash preprocess.sh ACCESS-CM2 BARPA-R r4i1p1f1 ssp370 tasmin -n
```
(The `-n` is optional and allows for a dry run where the commands
that would be executed are just printed to the screen.)

The following is the equivalent command to submit to the job queue on NCI:

```
qsub -v gcm=ACCESS-CM2,rcm=BARPA-R,run=r4i1p1f1,exp=ssp370,var=tasmin preprocess-job.sh
```

The preprocessed AGCD and BARRA-R2 observational data 
are available on NCI at the following (example) directories:
```
/g/data/xv83/agcd-csiro/precip/daily/precip-total_AGCD-CSIRO_r005_19300101-19301231_daily.nc

/g/data/ia39/australian-climate-service/test-data/CORDEX-CMIP6/bias-adjustment-input/AGCD-05i/BOM/ERA5/historical/hres/BARRA-R2/v1/day/pr/pr_AGCD-05i_ERA5_historical_hres_BOM_BARRA-R2_v1_day_20020801-20020831.nc
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

For example, pr bias corrected output data for ACCESS-CM2 BARPA-R corrected to AGCD data using QME (i.e. univariate) can be found at the following directory:
```
/g/data/ia39/australian-climate-service/test-data/CORDEX-CMIP6/bias-adjustment-output/AGCD-05i/BOM/ACCESS-CM2/ssp370/r4i1p1f1/BARPA-R/v1-r1-ACS-QME-AGCD-1960-2022/day/prAdjust/
```

Most completed runs have bias corrected data available from 1960 to 2100 inclusive, with years up to and including 2014 found within the "historical" instead of "ssp370" subdirectory. The exception is for CCAM-v2203-SN runs, which are missing the year 2100.

Note that from previous usage there still exists data following a slightly different directory structure at the RCM level. The new data can be found in RCM directories labelled exactly as they are in the proceeding availability table.

## Data availability

The table below provides a summary of what data has been processed.

The three dots (in order from first/top/left to last/bottom/right) represent:
- Dot 1: Status of the pre-processed input data
- Dot 2: Status of the univariate bias corrected data (i.e. using the QME method)
- Dot 3: Status of the multivariate bias corrected data (i.e. using the MRNBC method)
 
In terms of the colors:
- :green_circle: The data is available in its final official form
- :yellow_circle: The data exists for early / beta users to try
- :white_circle: Not yet processed but we don't anticipate any problems/delays

Last update: Thurs 6 June 2am: Multivariate (MRNBC) output runs complete for tasmax, tasmin and pr using AGCD reference data.
Please note:
- The MRNBC runs have only been corrected using AGCD data thus far.
- For tasmax and tasmin outputs there are small gaps within the WA data void; the exact size and shape of which varies.


| GCM | RCM | run  | exp | tas max | tas min | pr   | rsds   | sfcWind max | hurs max | hurs min | (Notes) |
| --- | --- | ---  | :-: | :-:     | :-:     | :-:  | :-:    | :-:         | :-:      | :-:      | ---     |
|     | AGCD |     |     | :green_circle: | :green_circle: | :green_circle: |  |  |  |  |  |
|     | BARRA-R2 | |     | :green_circle: | :green_circle: | :green_circle: | :green_circle: | :green_circle: | :green_circle: | :green_circle: |  |
| ACCESS-CM2 | BARPA-R | r4i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| ACCESS-CM2 | BARPA-R | r4i1p1f1 | ssp126 | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: |  |
| ACCESS-CM2 | BARPA-R | r4i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| ACCESS-CM2 | CCAM-v2203-SN | r4i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| ACCESS-CM2 | CCAM-v2203-SN | r4i1p1f1 | ssp126 | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: |  |
| ACCESS-CM2 | CCAM-v2203-SN | r4i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| ACCESS-CM2 | CCAMoc-v2112 | r2i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: |   | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| ACCESS-CM2 | CCAMoc-v2112 | r2i1p1f1 | ssp126 | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: |   | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: |  |
| ACCESS-CM2 | CCAMoc-v2112 | r2i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: |   | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| ACCESS-ESM1-5 | BARPA-R | r6i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| ACCESS-ESM1-5 | BARPA-R | r6i1p1f1 | ssp126 | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: |  |
| ACCESS-ESM1-5 | BARPA-R | r6i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | Small amount of missing values |
| ACCESS-ESM1-5 | CCAM-v2203-SN | r6i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| ACCESS-ESM1-5 | CCAM-v2203-SN | r6i1p1f1 | ssp126 | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: |  |
| ACCESS-ESM1-5 | CCAM-v2203-SN | r6i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| ACCESS-ESM1-5 | CCAMoc-v2112 | r20i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| ACCESS-ESM1-5 | CCAMoc-v2112 | r20i1p1f1 | ssp126 | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: |  |
| ACCESS-ESM1-5 | CCAMoc-v2112 | r20i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| ACCESS-ESM1-5 | CCAMoc-v2112 | r40i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| ACCESS-ESM1-5 | CCAMoc-v2112 | r40i1p1f1 | ssp126 | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: |  | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: |  |
| ACCESS-ESM1-5 | CCAMoc-v2112 | r40i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| ACCESS-ESM1-5 | CCAM-v2105 | r6i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: |  | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| ACCESS-ESM1-5 | CCAM-v2105 | r6i1p1f1 | ssp126 | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: |  | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: |  |
| ACCESS-ESM1-5 | CCAM-v2105 | r6i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: |  | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| CESM2 | BARPA-R | r11i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| CESM2 | BARPA-R | r11i1p1f1 | ssp126 | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: |  |
| CESM2 | BARPA-R | r11i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| CESM2 | CCAM-v2203-SN | r11i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | |
| CESM2 | CCAM-v2203-SN | r11i1p1f1 | ssp126 | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | |
| CESM2 | CCAM-v2203-SN | r11i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | |
| CMCC-ESM2 | BARPA-R | r1i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| CMCC-ESM2 | BARPA-R | r1i1p1f1 | ssp126 | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: |  |
| CMCC-ESM2 | BARPA-R | r1i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| CMCC-ESM2 | CCAM-v2203-SN | r1i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | |
| CMCC-ESM2 | CCAM-v2203-SN | r1i1p1f1 | ssp126 | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | |
| CMCC-ESM2 | CCAM-v2203-SN | r1i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | |
| CMCC-ESM2 | CCAM-v2105 | r1i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| CMCC-ESM2 | CCAM-v2105 | r1i1p1f1 | ssp126 | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: |  |
| CMCC-ESM2 | CCAM-v2105 | r1i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| CNRM-CM6-1-HR | CCAMoc-v2112 | r1i1p1f2 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: |  | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| CNRM-CM6-1-HR | CCAMoc-v2112 | r1i1p1f2 | ssp126 | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: |  | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: |  |
| CNRM-CM6-1-HR | CCAMoc-v2112 | r1i1p1f2 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: |  | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| CNRM-CM6-1-HR | CCAMoc-v2112 | r1i1p1f2 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: |  | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| CNRM-CM6-1-HR | CCAMoc-v2112 | r1i1p1f2 | ssp126 | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: |  | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: |  |
| CNRM-CM6-1-HR | CCAMoc-v2112 | r1i1p1f2 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: |  | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| CNRM-CM6-1-HR | CCAMoc-v2112 | r1i1p1f2 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: |  | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| CNRM-CM6-1-HR | CCAMoc-v2112 | r1i1p1f2 | ssp126 | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: |  | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: |  |
| CNRM-CM6-1-HR | CCAMoc-v2112 | r1i1p1f2 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: |  | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| CNRM-CM6-1-HR | CCAM-v2112 | r1i1p1f2 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| CNRM-CM6-1-HR | CCAM-v2112 | r1i1p1f2 | ssp126 | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: |  |
| CNRM-CM6-1-HR | CCAM-v2112 | r1i1p1f2 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| CNRM-ESM2-1 | CCAM-v2203-SN | r1i1p1f2 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| CNRM-ESM2-1 | CCAM-v2203-SN | r1i1p1f2 | ssp126 | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: |  |
| CNRM-ESM2-1 | CCAM-v2203-SN | r1i1p1f2 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| EC-Earth3 | BARPA-R | r1i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| EC-Earth3 | BARPA-R | r1i1p1f1 | ssp126 | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: |  |
| EC-Earth3 | BARPA-R | r1i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| EC-Earth3 | CCAM-v2203-SN | r1i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| EC-Earth3 | CCAM-v2203-SN | r1i1p1f1 | ssp126 | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: |  |
| EC-Earth3 | CCAM-v2203-SN | r1i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| EC-Earth3 | CCAM-v2105 | r1i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| EC-Earth3 | CCAM-v2105 | r1i1p1f1 | ssp126 | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: |  |
| EC-Earth3 | CCAM-v2105 | r1i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| FGOALS-g3 | CCAM-v2105 | r4i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| FGOALS-g3 | CCAM-v2105 | r4i1p1f1 | ssp126 | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: |  |
| FGOALS-g3 | CCAM-v2105 | r4i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| GFDL-ESM4 | CCAM-v2105 | r1i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| GFDL-ESM4 | CCAM-v2105 | r1i1p1f1 | ssp126 | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: |  |
| GFDL-ESM4 | CCAM-v2105 | r1i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| GISS-E2-1-G | CCAM-v2105 | r2i1p1f2 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| GISS-E2-1-G | CCAM-v2105 | r2i1p1f2 | ssp126 | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: |  |
| GISS-E2-1-G | CCAM-v2105 | r2i1p1f2 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| MPI-ESM1-2-HR | BARPA-R | r1i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| MPI-ESM1-2-HR | BARPA-R | r1i1p1f1 | ssp126 | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: |  |
| MPI-ESM1-2-HR | BARPA-R | r1i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| MPI-ESM1-2-LR | CCAM-v2105 | r9i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| MPI-ESM1-2-LR | CCAM-v2105 | r9i1p1f1 | ssp126 | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: |  |
| MPI-ESM1-2-LR | CCAM-v2105 | r9i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| MRI-ESM2-0 | CCAM-v2105 | r1i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| MRI-ESM2-0 | CCAM-v2105 | r1i1p1f1 | ssp126 | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: |  |
| MRI-ESM2-0 | CCAM-v2105 | r1i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| NorESM2-MM | BARPA-R | r1i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| NorESM2-MM | BARPA-R | r1i1p1f1 | ssp126 | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: |  |
| NorESM2-MM | BARPA-R | r1i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| NorESM2-MM | CCAMoc-v2112 | r1i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| NorESM2-MM | CCAMoc-v2112 | r1i1p1f1 | ssp126 | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: |  |
| NorESM2-MM | CCAMoc-v2112 | r1i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| NorESM2-MM | CCAM-v2112 | r1i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |
| NorESM2-MM | CCAM-v2112 | r1i1p1f1 | ssp126 | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: | | :green_circle: :white_circle: :white_circle: | :green_circle: :white_circle: :white_circle: |  |
| NorESM2-MM | CCAM-v2112 | r1i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :white_circle: | | :green_circle: :yellow_circle: :white_circle: | :green_circle: :yellow_circle: :white_circle: |  |

The BARPA-R model was run by the [Bureau of Meteorology](https://dx.doi.org/10.25914/z1x6-dq28),
while the various different versions of the CCAM model were run by
[CSIRO](https://dx.doi.org/10.25914/rd73-4m38) and the
[Queensland Future Climate Science Program](https://dx.doi.org/10.25914/8fve-1910).
