# bias-correction-data-release

This repository tracks the details and progress of the first ACS bias corrected CORDEX data release.

## Dataset specifications

#### General
- Timescale: Daily
- Spatial resolution: 5km AGCD grid

#### Variables (observational dataset/s):
- Daily maximum surface air temperature - tasmax (AGCD, BARRA-R2)
- Daily minimum surface air temperature - tasmin (AGCD, BARRA-R2)
- Precipitation - pr (AGCD, BARRA-R2)
- Surface downwelling solar radiation - rsds (BARRA-R2)
- Daily maximum surface wind speed - sfcWindmax (BARRA-R2)
- Moisutre variable (e.g. relative humidity, vapour pressure) still TBC

The rationale for processing two observational datasets is that BARRA-R2 provides a consistent product across all variables,
while having AGCD available for temperature and precipitation caters to users who don't require consistency across many variables
and just want the (arguably) superior observational underpinning.

The AGCD and BARRA-R2 observational data (regridded as necessary) are available on NCI at the following directories:
```
TODO: Provide file paths
```

#### Model data:
- Experiment: ssp370
- Time period: 1960-2100
- Regional climate models: [CCAMoc-v2112](https://dx.doi.org/10.25914/8fve-1910), [BARPA-R](https://dx.doi.org/10.25914/z1x6-dq28), [CCAM-v2203-SN](https://dx.doi.org/10.25914/rd73-4m3)

The regional climate model data (regridded as necessary) are available on NCI at the following directories:
```
TODO: Provide file paths
```
