# bias-correction-data-release

This repository tracks the details and progress of the first
Australian Climate Service (ACS) bias corrected CORDEX-CMIP6 data release.

## Dataset specifications

A number of institutions have dynamically downscaled CMIP6 global climate model data
over Australasia as part of the CORDEX-CMIP6 project. 
For this data release,
bias correction will be applied to CORDEX-CMIP6 model outputs produced by the
[Bureau of Meteorology](https://dx.doi.org/10.25914/z1x6-dq28),
[CSIRO](https://dx.doi.org/10.25914/rd73-4m38),
[NARCliM2.0](https://dx.doi.org/10.25914/resv-vj43) and the
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
This pre-processing involved spatial regridding, unit conversion and re-chunking.

For the model outputs,
the pre-processing was achieved by running the following at the command line
for any given GCM / RCM / model run / variable combination:

```
bash preprocess-cordex.sh ACCESS-CM2 BARPA-R r4i1p1f1 ssp370 tasmin -n
```
(The `-n` is optional and allows for a dry run where the commands
that would be executed are just printed to the screen.)

The following is the equivalent command to submit to the job queue on NCI:

```
qsub -v gcm=ACCESS-CM2,rcm=BARPA-R,run=r4i1p1f1,exp=ssp370,var=tasmin preprocess-cordex-job.sh
```

For the observational data,
no pre-processing was required for the AGCD data.
For BARRA-R2,
the pre-processing was achieved by running the following at the command line
for any given variable:
```
bash preprocess-barra.sh tasmin -n
```
(The `-n` is optional and allows for a dry run where the commands
that would be executed are just printed to the screen.)

The following is the equivalent command to submit to the job queue on NCI:

```
qsub -v var=tasmin preprocess-barra-job.sh
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

The table below provides a summary of what data has been processed for each GCM.

The order of the dots in each table (from first/top/left to last/bottom/right) represents:
- Dot 1: Status of the pre-processed input data
- Dot 2: Status of the univariate bias corrected data (i.e. using the QME method)
- Dot 3: Status of the multivariate bias corrected data (i.e. using the MRNBC method)

The color of the dots in the table represents:
- :green_circle: The data is available in its final official form
- :yellow_circle: The data exists for early / beta users to try
- :white_circle: Not processed yet but we don't anticipate any problems/delays
- :red_circle: Not processed yet due to issues/delays with the original data

The BARPA-R dataset has a small number of daily timesteps
where the value at all latitude/longitude points is NaN for all variables
(see the BARPA [known issues](https://opus.nci.org.au/pages/viewpage.action?pageId=264241299) page for details).
Those NaN timesteps are also present in the bias corrected data for all variables
except hursmin and hursmax (which were calculated using unaffected hourly BARPA data).
The table below lists the affected timesteps.

Last update: Tues 29 October 9:30pm: Completed final MRNBC runs (UKESM NARCliM).

### Observations

| GCM | RCM | run  | exp | tas max | tas min | pr   | rsds   | sfcWind max | hurs max | hurs min | missing data |
| --- | --- | ---  | :-: | :-:     | :-:     | :-:  | :-:    | :-:         | :-:      | :-:      | ---          |
|     | AGCD |     |     | :green_circle: | :green_circle: | :green_circle: |  |  |  |  |  |
|     | BARRA-R2 | |     | :green_circle: | :green_circle: | :green_circle: | :green_circle: | :green_circle: | :green_circle: | :green_circle: |  |

### ACCESS-CM2

| GCM | RCM | run  | exp | tas max | tas min | pr   | rsds   | sfcWind max | hurs max | hurs min | missing data |
| --- | --- | ---  | :-: | :-:     | :-:     | :-:  | :-:    | :-:         | :-:      | :-:      | ---          |
| ACCESS-CM2 | BARPA-R | r4i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| ACCESS-CM2 | BARPA-R | r4i1p1f1 | ssp126 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | 1-2 July 2049 |
| ACCESS-CM2 | BARPA-R | r4i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| ACCESS-CM2 | CCAM-v2203-SN | r4i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| ACCESS-CM2 | CCAM-v2203-SN | r4i1p1f1 | ssp126 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| ACCESS-CM2 | CCAM-v2203-SN | r4i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| ACCESS-CM2 | CCAMoc-v2112 | r2i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |   | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| ACCESS-CM2 | CCAMoc-v2112 | r2i1p1f1 | ssp126 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |   | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| ACCESS-CM2 | CCAMoc-v2112 | r2i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |   | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |

### ACCESS-ESM1-5

| GCM | RCM | run  | exp | tas max | tas min | pr   | rsds   | sfcWind max | hurs max | hurs min | missing data |
| --- | --- | ---  | :-: | :-:     | :-:     | :-:  | :-:    | :-:         | :-:      | :-:      | ---          |
| ACCESS-ESM1-5 | BARPA-R | r6i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| ACCESS-ESM1-5 | BARPA-R | r6i1p1f1 | ssp126 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | 9-10 Sep, 16-17 Oct 2073 |
| ACCESS-ESM1-5 | BARPA-R | r6i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | 21-22 Apr 2029 |
| ACCESS-ESM1-5 | CCAM-v2203-SN | r6i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| ACCESS-ESM1-5 | CCAM-v2203-SN | r6i1p1f1 | ssp126 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| ACCESS-ESM1-5 | CCAM-v2203-SN | r6i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| ACCESS-ESM1-5 | CCAMoc-v2112 | r20i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| ACCESS-ESM1-5 | CCAMoc-v2112 | r20i1p1f1 | ssp126 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| ACCESS-ESM1-5 | CCAMoc-v2112 | r20i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| ACCESS-ESM1-5 | CCAMoc-v2112 | r40i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| ACCESS-ESM1-5 | CCAMoc-v2112 | r40i1p1f1 | ssp126 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| ACCESS-ESM1-5 | CCAMoc-v2112 | r40i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| ACCESS-ESM1-5 | CCAM-v2105 | r6i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| ACCESS-ESM1-5 | CCAM-v2105 | r6i1p1f1 | ssp126 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| ACCESS-ESM1-5 | CCAM-v2105 | r6i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| ACCESS-ESM1-5 | NARCliM2-0-WRF412R3 | r6i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| ACCESS-ESM1-5 | NARCliM2-0-WRF412R3 | r6i1p1f1 | ssp126 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| ACCESS-ESM1-5 | NARCliM2-0-WRF412R3 | r6i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| ACCESS-ESM1-5 | NARCliM2-0-WRF412R5 | r6i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| ACCESS-ESM1-5 | NARCliM2-0-WRF412R5 | r6i1p1f1 | ssp126 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| ACCESS-ESM1-5 | NARCliM2-0-WRF412R5 | r6i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |

### CESM2

| GCM | RCM | run  | exp | tas max | tas min | pr   | rsds   | sfcWind max | hurs max | hurs min | missing data |
| --- | --- | ---  | :-: | :-:     | :-:     | :-:  | :-:    | :-:         | :-:      | :-:      | ---          |
| CESM2 | BARPA-R | r11i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| CESM2 | BARPA-R | r11i1p1f1 | ssp126 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| CESM2 | BARPA-R | r11i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| CESM2 | CCAM-v2203-SN | r11i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | |
| CESM2 | CCAM-v2203-SN | r11i1p1f1 | ssp126 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | |
| CESM2 | CCAM-v2203-SN | r11i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | |

### CMCC-ESM2

| GCM | RCM | run  | exp | tas max | tas min | pr   | rsds   | sfcWind max | hurs max | hurs min | missing data |
| --- | --- | ---  | :-: | :-:     | :-:     | :-:  | :-:    | :-:         | :-:      | :-:      | ---          |
| CMCC-ESM2 | BARPA-R | r1i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| CMCC-ESM2 | BARPA-R | r1i1p1f1 | ssp126 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| CMCC-ESM2 | BARPA-R | r1i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| CMCC-ESM2 | CCAM-v2203-SN | r1i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | |
| CMCC-ESM2 | CCAM-v2203-SN | r1i1p1f1 | ssp126 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | |
| CMCC-ESM2 | CCAM-v2203-SN | r1i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | |
| CMCC-ESM2 | CCAM-v2105 | r1i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| CMCC-ESM2 | CCAM-v2105 | r1i1p1f1 | ssp126 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| CMCC-ESM2 | CCAM-v2105 | r1i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |

### CNRM-CM6-1-HR

| GCM | RCM | run  | exp | tas max | tas min | pr   | rsds   | sfcWind max | hurs max | hurs min | missing data |
| --- | --- | ---  | :-: | :-:     | :-:     | :-:  | :-:    | :-:         | :-:      | :-:      | ---          |
| CNRM-CM6-1-HR | CCAMoc-v2112 | r1i1p1f2 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| CNRM-CM6-1-HR | CCAMoc-v2112 | r1i1p1f2 | ssp126 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| CNRM-CM6-1-HR | CCAMoc-v2112 | r1i1p1f2 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| CNRM-CM6-1-HR | CCAM-v2112 | r1i1p1f2 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| CNRM-CM6-1-HR | CCAM-v2112 | r1i1p1f2 | ssp126 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| CNRM-CM6-1-HR | CCAM-v2112 | r1i1p1f2 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |

### CNRM-ESM2-1

| GCM | RCM | run  | exp | tas max | tas min | pr   | rsds   | sfcWind max | hurs max | hurs min | missing data |
| --- | --- | ---  | :-: | :-:     | :-:     | :-:  | :-:    | :-:         | :-:      | :-:      | ---          |
| CNRM-ESM2-1 | CCAM-v2203-SN | r1i1p1f2 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| CNRM-ESM2-1 | CCAM-v2203-SN | r1i1p1f2 | ssp126 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| CNRM-ESM2-1 | CCAM-v2203-SN | r1i1p1f2 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |

### EC-Earth3

| GCM | RCM | run  | exp | tas max | tas min | pr   | rsds   | sfcWind max | hurs max | hurs min | missing data |
| --- | --- | ---  | :-: | :-:     | :-:     | :-:  | :-:    | :-:         | :-:      | :-:      | ---          |
| EC-Earth3 | BARPA-R | r1i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| EC-Earth3 | BARPA-R | r1i1p1f1 | ssp126 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| EC-Earth3 | BARPA-R | r1i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| EC-Earth3 | CCAM-v2203-SN | r1i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| EC-Earth3 | CCAM-v2203-SN | r1i1p1f1 | ssp126 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| EC-Earth3 | CCAM-v2203-SN | r1i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| EC-Earth3 | CCAM-v2105 | r1i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| EC-Earth3 | CCAM-v2105 | r1i1p1f1 | ssp126 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| EC-Earth3 | CCAM-v2105 | r1i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |

### EC-Earth3-Veg

| GCM | RCM | run  | exp | tas max | tas min | pr   | rsds   | sfcWind max | hurs max | hurs min | missing data |
| --- | --- | ---  | :-: | :-:     | :-:     | :-:  | :-:    | :-:         | :-:      | :-:      | ---          |
| EC-Earth3-Veg | NARCliM2-0-WRF412R3 | r1i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| EC-Earth3-Veg | NARCliM2-0-WRF412R3 | r1i1p1f1 | ssp126 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| EC-Earth3-Veg | NARCliM2-0-WRF412R3 | r1i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| EC-Earth3-Veg | NARCliM2-0-WRF412R5 | r1i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| EC-Earth3-Veg | NARCliM2-0-WRF412R5 | r1i1p1f1 | ssp126 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| EC-Earth3-Veg | NARCliM2-0-WRF412R5 | r1i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |

### FGOALS-g3

| GCM | RCM | run  | exp | tas max | tas min | pr   | rsds   | sfcWind max | hurs max | hurs min | missing data |
| --- | --- | ---  | :-: | :-:     | :-:     | :-:  | :-:    | :-:         | :-:      | :-:      | ---          |
| FGOALS-g3 | CCAM-v2105 | r4i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| FGOALS-g3 | CCAM-v2105 | r4i1p1f1 | ssp126 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| FGOALS-g3 | CCAM-v2105 | r4i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |

### GFDL-ESM4

| GCM | RCM | run  | exp | tas max | tas min | pr   | rsds   | sfcWind max | hurs max | hurs min | missing data |
| --- | --- | ---  | :-: | :-:     | :-:     | :-:  | :-:    | :-:         | :-:      | :-:      | ---          |
| GFDL-ESM4 | CCAM-v2105 | r1i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| GFDL-ESM4 | CCAM-v2105 | r1i1p1f1 | ssp126 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| GFDL-ESM4 | CCAM-v2105 | r1i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |

### GISS-E2-1-G

| GCM | RCM | run  | exp | tas max | tas min | pr   | rsds   | sfcWind max | hurs max | hurs min | missing data |
| --- | --- | ---  | :-: | :-:     | :-:     | :-:  | :-:    | :-:         | :-:      | :-:      | ---          |
| GISS-E2-1-G | CCAM-v2105 | r2i1p1f2 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| GISS-E2-1-G | CCAM-v2105 | r2i1p1f2 | ssp126 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| GISS-E2-1-G | CCAM-v2105 | r2i1p1f2 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |

### MPI-ESM1-2-HR

| GCM | RCM | run  | exp | tas max | tas min | pr   | rsds   | sfcWind max | hurs max | hurs min | missing data |
| --- | --- | ---  | :-: | :-:     | :-:     | :-:  | :-:    | :-:         | :-:      | :-:      | ---          |
| MPI-ESM1-2-HR | BARPA-R | r1i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| MPI-ESM1-2-HR | BARPA-R | r1i1p1f1 | ssp126 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| MPI-ESM1-2-HR | BARPA-R | r1i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| MPI-ESM1-2-HR | NARCliM2-0-WRF412R3 | r1i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| MPI-ESM1-2-HR | NARCliM2-0-WRF412R3 | r1i1p1f1 | ssp126 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| MPI-ESM1-2-HR | NARCliM2-0-WRF412R3 | r1i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| MPI-ESM1-2-HR | NARCliM2-0-WRF412R5 | r1i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| MPI-ESM1-2-HR | NARCliM2-0-WRF412R5 | r1i1p1f1 | ssp126 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| MPI-ESM1-2-HR | NARCliM2-0-WRF412R5 | r1i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |

### MPI-ESM1-2-LR

| GCM | RCM | run  | exp | tas max | tas min | pr   | rsds   | sfcWind max | hurs max | hurs min | missing data |
| --- | --- | ---  | :-: | :-:     | :-:     | :-:  | :-:    | :-:         | :-:      | :-:      | ---          |
| MPI-ESM1-2-LR | CCAM-v2105 | r9i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| MPI-ESM1-2-LR | CCAM-v2105 | r9i1p1f1 | ssp126 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| MPI-ESM1-2-LR | CCAM-v2105 | r9i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |

### MRI-ESM2-0

| GCM | RCM | run  | exp | tas max | tas min | pr   | rsds   | sfcWind max | hurs max | hurs min | missing data |
| --- | --- | ---  | :-: | :-:     | :-:     | :-:  | :-:    | :-:         | :-:      | :-:      | ---          |
| MRI-ESM2-0 | CCAM-v2105 | r1i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| MRI-ESM2-0 | CCAM-v2105 | r1i1p1f1 | ssp126 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| MRI-ESM2-0 | CCAM-v2105 | r1i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |

### NorESM2-MM

| GCM | RCM | run  | exp | tas max | tas min | pr   | rsds   | sfcWind max | hurs max | hurs min | missing data |
| --- | --- | ---  | :-: | :-:     | :-:     | :-:  | :-:    | :-:         | :-:      | :-:      | ---          |
| NorESM2-MM | BARPA-R | r1i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| NorESM2-MM | BARPA-R | r1i1p1f1 | ssp126 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| NorESM2-MM | BARPA-R | r1i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| NorESM2-MM | CCAM-v2203-SN | r1i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| NorESM2-MM | CCAM-v2203-SN | r1i1p1f1 | ssp126 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| NorESM2-MM | CCAM-v2203-SN | r1i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| NorESM2-MM | CCAMoc-v2112 | r1i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| NorESM2-MM | CCAMoc-v2112 | r1i1p1f1 | ssp126 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| NorESM2-MM | CCAMoc-v2112 | r1i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| NorESM2-MM | CCAM-v2112 | r1i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| NorESM2-MM | CCAM-v2112 | r1i1p1f1 | ssp126 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| NorESM2-MM | CCAM-v2112 | r1i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| NorESM2-MM | NARCliM2-0-WRF412R3 | r1i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| NorESM2-MM | NARCliM2-0-WRF412R3 | r1i1p1f1 | ssp126 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| NorESM2-MM | NARCliM2-0-WRF412R3 | r1i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| NorESM2-MM | NARCliM2-0-WRF412R5 | r1i1p1f1 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| NorESM2-MM | NARCliM2-0-WRF412R5 | r1i1p1f1 | ssp126 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| NorESM2-MM | NARCliM2-0-WRF412R5 | r1i1p1f1 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |

### UKESM1-0-LL

| GCM | RCM | run  | exp | tas max | tas min | pr   | rsds   | sfcWind max | hurs max | hurs min | missing data |
| --- | --- | ---  | :-: | :-:     | :-:     | :-:  | :-:    | :-:         | :-:      | :-:      | ---          |
| UKESM1-0-LL | NARCliM2-0-WRF412R3 | r1i1p1f2 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| UKESM1-0-LL | NARCliM2-0-WRF412R3 | r1i1p1f2 | ssp126 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| UKESM1-0-LL | NARCliM2-0-WRF412R3 | r1i1p1f2 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| UKESM1-0-LL | NARCliM2-0-WRF412R5 | r1i1p1f2 | historical | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| UKESM1-0-LL | NARCliM2-0-WRF412R5 | r1i1p1f2 | ssp126 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |
| UKESM1-0-LL | NARCliM2-0-WRF412R5 | r1i1p1f2 | ssp370 | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: | :green_circle: :yellow_circle: :yellow_circle: |  |

The BARPA-R model was run by the Bureau of Meteorology
([data collection](https://dx.doi.org/10.25914/z1x6-dq28)).

The CCAM-v2203-SN version of the CCAM model was run by CSIRO
([data collection](https://dx.doi.org/10.25914/rd73-4m38)). 

The CCAMoc-v2112, CCAM-v2112 and CCAM-v2105 versions of the CCAM model were run by the 
Queensland Future Climate Science Program
([data collection](https://dx.doi.org/10.25914/8fve-1910), [paper](https://doi.org/10.1029/2023EF003548)).

The NARCliM2-0-WRF412R3 and NARCliM2-0-WRF412R5 versions of the WRF model were run by the
NARCliM project, which was led by the NSW Government
([data collection](https://dx.doi.org/10.25914/resv-vj43), [paper](https://dx.doi.org/10.5194/gmd-2024-87)).
