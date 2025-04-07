# bias-correction-data-release

Four institutions have run regional climate models (RCMs) to dynamically downscale CMIP6 global climate model (GCM) data over Australia: 
- Bureau of Meteorology (BoM; [data collection](https://dx.doi.org/10.25914/z1x6-dq28))
- CSIRO ([data collection](https://dx.doi.org/10.25914/rd73-4m38)) 
- University of Queensland and Department of Energy and Climate
  (UQ-DEC; [data collection](https://dx.doi.org/10.25914/8fve-1910), [paper](https://doi.org/10.1029/2023EF003548))
- NSW Government (NARCliM2.0 project)
  ([data collection](https://dx.doi.org/10.25914/resv-vj43), [paper](https://dx.doi.org/10.5194/gmd-2024-87))

The Australian Climate Service (ACS) has been pre-processing (to a common 5km grid)
and then bias correcting some of these data for projects including the
National Climate Risk Assessment (NCRA) and National Hydrological Projections (NHP).
Bias correction also involves calibrating against observations,
so [BARRA-R2](https://dx.doi.org/10.25914/90rq-d839) data have also been pre-processed.

This repository tracks the details and progress of the data produced by the ACS bias correction team.
A first phase of pre-processing and bias correction was conducted to produce a core general purpose dataset,
and now a second phase is underway to service the NHP.
Data is generally first made available on project ia39 on NCI for early/advanced users
(ia39 is the general ACS data sharing project)
and then when appropriate some data is eventually published to a stand-alone
project on NCI with all the bells and whistles
(more detailed documentation, THREDDS access, an intake catalogue, etc).


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
for all historical, ssp126 and ssp370 experiment data
produced by the BoM, CSIRO, UQ-DEC and NSW Government
(see [Appendix](#appendix) for details).

Phase 1:
- Daily maximum surface air temperature (tasmax)
- Daily minimum surface air temperature (tasmin)
- Precipitation (pr)
- Surface downwelling shortwave radiation (rsds)
- Daily maximum surface wind speed (sfcWindmax; not available for UQ-DEC)
- Daily maximum relative humidity (hursmax)
- Daily minimum relative humidity (hursmin)

Phase 2:
- Daily mean surface air temperature (tas)
- Daily mean relative humidity (hurs)
- Surface pressure (ps)
- Sea level pressure (psl)
- Surface specific humidity (huss)
- Surface downwelling longwave radiation (rlds)
- Snowfall (prsn; not available for UQ-DEC)
- Surface wind speed (sfcWind)
- Surface altitude (orog) (historical experiment only)

### Data location

The AGCD and pre-processed BARRA-R2 observational data 
are available in project ia39 on NCI at the following (example) directories:
```
/g/data/xv83/agcd-csiro/precip/daily/precip-total_AGCD-CSIRO_r005_19300101-19301231_daily.nc

/g/data/ia39/australian-climate-service/release/CORDEX/output-Adjust/CMIP6/bias-adjusted-input/AUST-05i/BOM/ERA5/historical/hres/BARRAR2/v1/day/pr/v20241216/pr_AUST-05i_ERA5_historical_hres_BOM_BARRAR2_v1_day_20020101-20021231.nc
```

The pre-processed model data from BoM and CSIRO for Phase 1 have been formally published to project kj66 on NCI (https://doi.org/10.25914/yrcz-m051)
and are available at the following (example) directory:

```
/g/data/kj66/CORDEX/output/CMIP6/DD/AUST-05i/BOM/EC-Earth3/historical/r1i1p1f1/BARPA-R/v1-r1/day/sfcWindmax/v20241216/sfcWindmax_AUST-05i_EC-Earth3_historical_r1i1p1f1_BOM_BARPA-R_v1-r1_day_19600101-19601231.nc
```

The kj66 file naming convention is explained in detail at: https://opus.nci.org.au/x/LoG_Fg

Everything else (i.e. all Phase 2 data and Phase 1 data for UQ-DEC and NSW-Government)
is available in project ia39 on NCI at the following (example) directory:
```
/g/data/ia39/australian-climate-service/release/CORDEX/output-Adjust/CMIP6/bias-adjusted-input/AUST-05i/BOM/CESM2/ssp370/r11i1p1f1/BARPA-R/v1-r1/day/pr/v20241216/pr_AUST-05i_CESM2_ssp370_r11i1p1f1_BOM_BARPA-R_v1-r1_day_20220101-20221231.nc
```

(A replica of the Phase 1 BoM and CSIRO data on kj66 data is also on ia39 at the moment.)


## Bias corrected output data

### Data availability

The following bias corrected data is currently available for two bias correction methods:
Quantile Matching for Extremes (QME) and Multivariate Recursive Nesting Bias Correction (MRNBC).
All relevant BoM, CSIRO, UQ-DEC and NSW Government data were processed
(see [Appendix](#appendix) for details).

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

Note: sfcWindmax data is not available UQ-DEC.

Phase 2:

Still to come.

### Data location

The Phase 1 bias corrected output data for BoM and CSIRO have been formally published to project kj66 on NCI (https://doi.org/10.25914/yrcz-m051)
and are available at the following (example) directory:

```
/g/data/kj66/CORDEX/output/CMIP6/bias-adjusted-output/AUST-05i/CSIRO/CNRM-ESM2-1/ssp370/r1i1p1f2/CCAM-v2203-SN/v1-r1-ACS-QME-BARRAR2-1980-2022/day/tasminAdjust/v20241216/tasminAdjust_AUST-05i_CNRM-ESM2-1_ssp370_r1i1p1f2_CSIRO_CCAM-v2203-SN_v1-r1-ACS-QME-BARRAR2-1980-2022_day_20660101-20661231.nc
```

The kj66 file naming convention is explained in detail at: https://opus.nci.org.au/x/LoG_Fg

Everything else (i.e. the Phase 1 data for UQ-DEC and NSW-Government) and a replica of what's on kj66 
is available in project ia39 on NCI at the following (example) directory:
```
/g/data/ia39/australian-climate-service/release/CORDEX/output-Adjust/CMIP6/bias-adjusted-output/AUST-05i/BOM/ACCESS-CM2/ssp370/r4i1p1f1/BARPA-R/v1-r1-ACS-QME-AGCDv1-1960-2022/day/prAdjust/v20241216
```


## Appendix

Here's a list of GCM / RCM combination processed by each modelling group.

BoM:
- ACCESS-CM2 (run r4i1p1f1) / BARPA-R
- ACCESS-ESM1-5 (r6i1p1f1) / BARPA-R
- CESM2 (r11i1p1f1) / BARPA-R
- CMCC-ESM2 (r1i1p1f1) / BARPA-R
- EC-Earth3 (r1i1p1f1) / BARPA-R
- MPI-ESM1-2-HR (r1i1p1f1) / BARPA-R
- NorESM2-MM 	(r1i1p1f1) / BARPA-R

CSIRO:
- ACCESS-CM2 	(r4i1p1f1) / CCAM-v2203-SN
- ACCESS-ESM1-5 (r6i1p1f1) / CCAM-v2203-SN
- CESM2 (r11i1p1f1) / CCAM-v2203-SN
- CMCC-ESM2 (r1i1p1f1) / CCAM-v2203-SN
- CNRM-ESM2-1 (r1i1p1f2) / CCAM-v2203-SN
- EC-Earth3 (r1i1p1f1) / CCAM-v2203-SN
- NorESM2-MM (r1i1p1f1) / CCAM-v2203-SN 	

UQ-DEC:
- ACCESS-CM2 (r2i1p1f1) / CCAMoc-v2112 	
- ACCESS-ESM1-5 (r20i1p1f1) / CCAMoc-v2112 	
- ACCESS-ESM1-5 (r40i1p1f1) /	CCAMoc-v2112 	
- ACCESS-ESM1-5 (r6i1p1f1) / CCAM-v2105 	
- CMCC-ESM2 (r1i1p1f1) / CCAM-v2105 	
- CNRM-CM6-1-HR (r1i1p1f2) / CCAMoc-v2112 	
- CNRM-CM6-1-HR (r1i1p1f2) / CCAM-v2112 	
- EC-Earth3 (r1i1p1f1) / CCAM-v2105 	
- FGOALS-g3 (r4i1p1f1) / CCAM-v2105 
- GFDL-ESM4 (r1i1p1f1) / CCAM-v2105
- GISS-E2-1-G (r2i1p1f2) / CCAM-v2105 	
- MPI-ESM1-2-LR (r9i1p1f1) / CCAM-v2105 	
- MRI-ESM2-0 (r1i1p1f1) /	CCAM-v2105 	
- NorESM2-MM (r1i1p1f1) / CCAMoc-v2112
- NorESM2-MM (r1i1p1f1) / CCAM-v2112

NSW-Government:
- ACCESS-ESM1-5 (r6i1p1f1) / NARCliM2-0-WRF412R3 	
- ACCESS-ESM1-5 (r6i1p1f1) / NARCliM2-0-WRF412R5
- EC-Earth3-Veg (r1i1p1f1) / NARCliM2-0-WRF412R3 	
- EC-Earth3-Veg (r1i1p1f1) / NARCliM2-0-WRF412R5
- MPI-ESM1-2-HR (r1i1p1f1) / NARCliM2-0-WRF412R3
- MPI-ESM1-2-HR (r1i1p1f1) / NARCliM2-0-WRF412R5
- NorESM2-MM (r1i1p1f1) /	NARCliM2-0-WRF412R3
- NorESM2-MM (r1i1p1f1) /	NARCliM2-0-WRF412R5
- UKESM1-0-LL (r1i1p1f2) / NARCliM2-0-WRF412R3
- UKESM1-0-LL (r1i1p1f2) / NARCliM2-0-WRF412R5
