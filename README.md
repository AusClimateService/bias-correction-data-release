# bias-correction-data-release

This repository tracks the details and progress of the first ACS bias corrected CORDEX data release.

## Dataset specifications

The following bias corrected data will be produced for the
[CCAMoc-v2112](https://dx.doi.org/10.25914/8fve-1910),
[BARPA-R](https://dx.doi.org/10.25914/z1x6-dq28) and
[CCAM-v2203-SN](https://dx.doi.org/10.25914/rd73-4m3) model outputs.

| Variable | Timescale | Grid | Units | Observations | Experiments |
| ---      | ---       | ---  | ---   | ---                     | ---          |
| Daily maximum surface air temperature (tasmax) | daily | AUS-05i | C | AGCD, BARRA-R2 | ssp370 |
| Daily minimum surface air temperature (tasmin) | daily | AUS-05i | C | AGCD, BARRA-R2 | ssp370 |
| Precipitation (pr) | daily | AUS-05i | mm/day | AGCD, BARRA-R2 | ssp370 |
| Surface downwelling solar radiation (rsds) | daily | AUS-05i | W/m2 | BARRA-R2 | ssp370 |
| Daily maximum surface wind speed (sfcWindmax) | daily | AUS-05i | m/s | BARRA-R2 | ssp370 |
| Moisture TBC (e.g. relative humidity, vapour pressure) | daily | AUS-05i | TBC | BARRA-R2 | ssp370 |

AUS-05i is the AGCD spatial grid: 0.05 x 0.05 degrees, 691 latitudes (112.00 to 156.25 East), 886 longitudes (10.0 to 44.5 South). 

The rationale for processing two observational datasets is that BARRA-R2 provides a consistent product across all variables,
while having AGCD available for temperature and precipitation caters to users who don't require consistency across many variables
and just want the (arguably) superior observational underpinning.

The AGCD and BARRA-R2 observational data (regridded as necessary) are available on NCI at the following directories:
```
TODO: Provide file paths
```

The regional climate model data (regridded and unit conversion applied as necessary) are available on NCI at the following directories:
```
TODO: Provide file paths
```
