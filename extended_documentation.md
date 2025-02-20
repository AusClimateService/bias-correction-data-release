## Introduction

This collection contains data from Regional Climate Models (RCMs) contributing to the Coordinated Regional Downscaling Experiment under the Coupled Model Intercomparison Project phase 6 (CORDEX-CMIP6) for Australasia, processed in a convenient form for applied users. 

Data for several commonly used surface variables and three model experiments have been regridded to a regular 0.05 degree (~5km) latitude-longitude grid across Australia and then calibrated against two different observational datasets using two different bias correction methods. Users can access the regridded data (i.e. with no bias correction applied) or the bias corrected data.

The regridded data is useful for analysis that compares / combines CORDEX-CMIP6 data across different RCMs, as each individual RCM is run on a different spatial grid. The bias corrected data is useful for analysis of future climate change scenarios for Australia where the application requires data to statistically match observed/reanalysis datasets – including analysis of changes in the variables included, indices derived from these variables (including indices with absolute thresholds) and downstream modelling of areas such as hydrology, agriculture, environmental suitability, fire risk and more.

## Data specifications

Timescale: Daily

Spatial grid: AUST-05i (regular 0.05 degree lat/lon grid across Australia; 112.00 to 156.25 East, 10.00 to 44.50 South)

Variables:
- Daily maximum surface air temperature (tasmax)
- Daily minimum surface air temperature (tasmin)
- Precipitation (pr)
- Surface downwelling shortwave radiation (rsds)
- Daily maximum surface wind speed (sfcWindmax)
- Daily maximum relative humidity (hursmax)
- Daily minimum relative humidity (hursmin)

Experiments (year range):
- historical (1960-2014)
- SSP1-2.6 (2015-2099)
- SSP3-7.0 (2015-2099)

Bias correction methods:
- Quantile Matching for Extremes (QME)
- Multivariate Recursive Nesting Bias Correction (MRNBC)
- (Regridded data with no bias correction applied is also available.)

Observations (for bias correction calibration):
- AGCD (tasmax, tasmin, pr)
- BARRA-R2 (all variables)

Models: All RCM/GCM combinations from the following CORDEX submissions...
- Bureau of Meteorology (https://dx.doi.org/10.25914/z1x6-dq28)
- CSIRO (https://dx.doi.org/10.25914/rd73-4m38)
- Queensland Future Climate Science Program (https://dx.doi.org/10.25914/8fve-1910)
- NARCLIM2.0 (https://dx.doi.org/10.25914/resv-vj43)

## Data access

You can browse the full CORDEX-CMIP6-based regridded and calibrated data holdings in the NCI Data Catalogue.

NCI users: To access the CORDEX-CMIP6-based regridded and calibrated data from either NCI's Gadi, or via the ARE interface, you must first register with project kj66 (https://my.nci.org.au/mancini/project/kj66).  

Non-NCI users: You may access the CORDEX-CMIP6-based regridded and calibrated data data via the NCI THREDDS Data Server, linked from the NCI Data Catalogue.
Data organisation

```
   /g/data/kj66/CORDEX/
      |-- <product>
         |-- <mip_era>
            |-- <activity_id>
               |-- <domain_id>
                  |-- <institution_id>
                     |-- <driving_source_id>
                        |-- <driving_experiment_id>
                           |-- <driving_variant_label>
                              |-- <source_id>
                                  |-- <version_realisation>
                                     |-- <freq>
                                        |-- <variable_id>
                                           |-- <version>
                                              |-- <netcdf_filename>

    where,
     <product> is:
         "output" (for all regridded data)
         "outputAdjust" (for all bias corrected/adjusted data)
     <mip-era> is "CMIP6"
     <activity_id> is:
         "DD" for dynamical downscaling (i.e. the regridded data)
         "bias-adjusted-output" (for the bias corrected/adjusted data) 
     <domain_id> is the spatial domain and grid resolution: "AUST-05i"
     <institution_id> is the institution that performed the downscaling:
         "BOM" (Bureau of Meteorology)
         "CSIRO" (Commonwealth Scientific and Industrial Research Organisation)
         "NSW-Government" (New South Wales Government)
         "UQ-DEC" (University of Queensland - Department of Energy and Climate) 
     <driving_source_id> is the global driving model that was downscaled:
          "ACCESS-CM2", "ACCESS-ESM1-5", "CESM2", "CMCC-ESM2", "EC-Earth3",
          "MPI-ESM1-2-HR", "NorESM2-MM"
     <driving_experiment_id> is "historical", "ssp126" or "ssp370"
     <driving_variant_label> labels the ensemble member of the CMIP6 simulation 
           that produced forcing data.
     <source_id> is the regional climate model that performed the downscaling:
           "BARPA-R", "CCAM-v2203-SN", "NARCliM2-0-WRF412R3",
           "NARCliM2-0-WRF412R5", "CCAM-v2112" "CCAMoc-v2112", "CCAM-v2105"
     <version_realisation> identifies the modelling version
     <freq> is "day" (daily)
     <variable_id> is the variable name:
         "hursmax" (daily maximum surface relative humidity)
         "hursmin" (daily minimum surface relative humidity)
         "pr" (precipitation)
         "rsds" (surface downwelling solar radiation)
         "sfcWindmax" (daily maximum surface wind speed)
         "tasmax" (daily maximum surface air temperature)
         "tasmin" (daily minimum surface air temperature)
     <version> denotes the date of data generation or date of data release
         in the form "vYYYYMMDD"
     <netcdf_filename> is: 
          <variable_id>_<domain_id>_<driving_source_id>_<driving_experiment_id>_
          <driving_variant_label>_<institution_id>_<source_id>_
          <version_realisation>_<freq>[_<StartTime>-<EndTime>].nc
```

An example for the reridded data is,

```
/g/data/kj66/CORDEX/output/CMIP6/DD/AUST-05i/UQ-DES/ACCESS-ESM1-5/
historical/r40i1p1f1/CCAMoc-v2112/v1-r1/day/sfcWindmax/v20241216/
sfcWindmax_AUST-05i_ACCESS-ESM1-5_historical_r40i1p1f1_UQ-DES_
CCAMoc-v2112_v1-r1_day_19600101-19601231.nc
```

An example for the bias corrected data is,

```
/g/data/kj66/CORDEX/output-Adjust/CMIP6/bias-adjusted-output/AUST-05i/
CSIRO/CNRM-ESM2-1/ssp370/r1i1p1f2/CCAM-v2203-SN/
v1-r1-ACS-QME-BARRAR2-1980-2022/day/tasminAdjust/v20241216/tasminAdjust_
AUST-05i_CNRM-ESM2-1_ssp370_r1i1p1f2_CSIRO_CCAM-v2203-SN_
v1-r1-ACS-QME-BARRAR2-1980-2022_day_20660101-20661231.nc
```

## Known issues

The BARPA-R dataset has a small number of daily timesteps where the value at all latitude/longitude points is NaN (see the BARPA known issues page for details). Those NaN timesteps are also present in the bias corrected data for all variables except hursmin and hursmax (which were calculated using unaffected hourly BARPA data). The impacted days in the CORDEX-CMIP6-based regridded and calibrated data are as follows:
- ACCESS-CM2 (r4i1p1f1), ssp126: 1-2 Jul 2049
- ACCESS-ESM1-5 (r6i1p1f1), ssp126: 9-10 Sep & 16-17 Oct 2073
- ACCESS-ESM1-5 (r6i1p1f1), ssp370: 21-22 Apr 2029

## Citing the data

To cite the regridded CORDEX-CMIP6 data:
- Irving D (2025). CORDEX-CMIP6-based regridded data for Australia. National Computational Infrastructure. https://doi.org/10.25914/yrcz-m051

To cite the bias corrected CORDEX-CMIP6 data:
- Gammon A & Peter J (2025). CORDEX-CMIP6-based calibrated data for Australia. National Computational Infrastructure. https://doi.org/10.25914/z2jm-nr63

To cite the entire dataset (i.e. the regridded and bias corrected data):
- Gammon A, Irving D & Peter J (2025). CORDEX-CMIP6-based regridded and calibrated data for Australia. National Computational Infrastructure. https://doi.org/10.25914/xeca-pw53

## Licensing, terms and conditions

The CORDEX-CMIP6-based regridded and calibrated data for Australia is licensed under Creative Commons Attribution 4.0 International (https://creativecommons.org/licenses/by/4.0/).

Conditions of Use: The data collection is considered a research product containing regridded and bias corrected modelling outputs that have not been fully evaluated. Users are advised to refer to the documented known issues and undertake evaluation of the data prior to use in their applications. 

The Australian Climate Service seeks user feedback on the quality and usage of the data, to help identify areas for improvements. 

The Australian Climate Service can also advise appropriate use of the data. 

Please refer feedback and questions on data use to help@nci.org.au.

## Published Evaluation and Assessment

See the National Partnership for Climate Projections (NPCP) bias correction intercomparison (https://github.com/AusClimateService/npcp) for an assessment of the bias correction methods used to produce the CORDEX-CMIP6-based regridded and calibrated data for Australia.

## Acknowledgements

The production of this dataset was supported with funding from the Australian Climate Service.

The availability of this dataset at NCI has been made possible through the Australian Climate Service, and support of NCI.
