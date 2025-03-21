# bias-correction-data-release

Four institutions have dynamically downscaled CMIP6 global climate model data over Australia: 
- Bureau of Meteorology ([data collection](https://dx.doi.org/10.25914/z1x6-dq28))
- CSIRO ([data collection](https://dx.doi.org/10.25914/rd73-4m38)) 
- Queensland Future Climate Science Program
  ([data collection](https://dx.doi.org/10.25914/8fve-1910), [paper](https://doi.org/10.1029/2023EF003548))
- The NARCliM2.0 project
  ([data collection](https://dx.doi.org/10.25914/resv-vj43), [paper](https://dx.doi.org/10.5194/gmd-2024-87))

The Australian Climate Service (ACS) has been pre-processing (to a common 5km grid)
and then bias correcting some of these data for projects including the
National Climate Risk Assessment (NCRA) and National Hydrological Projections (NHP).
Bias correction also involves calibrating against observations,
so [BARRA-R2](https://dx.doi.org/10.25914/90rq-d839) data have also been pre-processed.

This repository tracks the details and progress of the data produced by the ACS bias correction team.
A first phase of pre-processing and bias correction was conducted to produce a core general purpose dataset
that will soon be published as a stand-alone project on NCI (details will be at https://doi.org/10.25914/yrcz-m051)
and now a second phase is underway to service the NHP.


## Pre-processed input data for bias correction

Model outputs and observational data require pre-processing prior to bias correction.
This pre-processing involves spatial regridding to the AUST-05i grid, unit conversion and re-chunking.

AUST-05i is the AGCD 0.05 x 0.05 degrees spatial grid:
691 latitudes (112.00 to 156.25 East), 886 longitudes (10.0 to 44.5 South). 

### Code

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

### Data availability

The following pre-processed variables are available at a daily timescale
for the historical, ssp126 and ssp370 experiments.

Phase 1:
- Daily maximum surface air temperature (tasmax)
- Daily minimum surface air temperature (tasmin)
- Precipitation (pr)
- Surface downwelling shortwave radiation (rsds)
- Daily maximum surface wind speed (sfcWindmax)
- Daily maximum relative humidity (hursmax)
- Daily minimum relative humidity (hursmin)

Phase 2:
- Surface pressure (ps)
- Sea level pressure (psl)
- Surface specific humidity (huss)
- Surface downwelling longwave radiation (rlds)
- Snowfall (prsn)
- Surface wind speed (sfcWind)
- Surface altitude (orog) (historical experiment only)

### Data location

The AGCD and pre-processed BARRA-R2 observational data 
are available on NCI at the following (example) directories:
```
/g/data/xv83/agcd-csiro/precip/daily/precip-total_AGCD-CSIRO_r005_19300101-19301231_daily.nc

/g/data/ia39/australian-climate-service/release/CORDEX/output-Adjust/CMIP6/bias-adjusted-input/AUST-05i/BOM/ERA5/historical/hres/BARRAR2/v1/day/pr/v20241216/pr_AUST-05i_ERA5_historical_hres_BOM_BARRAR2_v1_day_20020101-20021231.nc
```

The pre-processed model data is available on NCI at the following (example) directory:
```
/g/data/ia39/australian-climate-service/release/CORDEX/output-Adjust/CMIP6/bias-adjusted-input/AUST-05i/BOM/CESM2/ssp370/r11i1p1f1/BARPA-R/v1-r1/day/pr/v20241216/pr_AUST-05i_CESM2_ssp370_r11i1p1f1_BOM_BARPA-R_v1-r1_day_20220101-20221231.nc
```

The phase 1 pre-processed data are also about to be formally published on NCI at the following DOI:  
https://doi.org/10.25914/yrcz-m051


## Bias corrected output data

### Data availability

The following bias corrected data is currently available for two bias correction methods:
Quantile Matching for Extremes (QME) and Multivariate Recursive Nesting Bias Correction (MRNBC).

Phase 1:

| Variable | Timescale | Grid | Units | Observations | Experiments |
| ---      | ---       | ---  | ---   | ---          | ---         |
| Daily maximum surface air temperature (tasmax) | daily | AUST-05i | C | AGCD, BARRA-R2 | historical, ssp126, ssp370 |
| Daily minimum surface air temperature (tasmin) | daily | AUST-05i | C | AGCD, BARRA-R2 | historical, ssp126, ssp370 |
| Precipitation (pr) | daily | AUST-05i | mm/day | AGCD, BARRA-R2 | historical, ssp126, ssp370 |
| Surface downwelling shortwave radiation (rsds) | daily | AUST-05i | W/m2 | BARRA-R2 | historical, ssp126, ssp370 |
| Daily maximum surface wind speed (sfcWindmax) | daily | AUST-05i | m/s | BARRA-R2 | historical, ssp126, ssp370 |
| Daily maximum relative humidity (hursmax) | daily | AUST-05i | % | BARRA-R2 | historical, ssp126, ssp370 |
| Daily minimum relative humidity (hursmin) | daily | AUST-05i | % | BARRA-R2 | historical, ssp126, ssp370 |

Phase 2:

Still to come.

### Data location

Bias corrected output data are available at:
```
/g/data/ia39/australian-climate-service/release/CORDEX/output-Adjust/CMIP6/bias-adjusted-output/
```

For example, pr bias corrected output data for ACCESS-CM2 BARPA-R corrected to AGCD data using the QME method can be found at the following directory:
```
/g/data/ia39/australian-climate-service/release/CORDEX/output-Adjust/CMIP6/bias-adjusted-output/AUST-05i/BOM/ACCESS-CM2/ssp370/r4i1p1f1/BARPA-R/v1-r1-ACS-QME-AGCDv1-1960-2022/day/prAdjust/v20241216
```

The phase 1 bias corrected data are also about to be formally published on NCI at the following DOI:  
https://doi.org/10.25914/z2jm-nr63








