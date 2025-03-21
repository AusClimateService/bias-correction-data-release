################################################################################

CORDEX-CMIP6-based regridded and calibrated data for Australia

################################################################################

VERSION
v1.0: 21/01/25: Created by Dr Damien Irving, damien.irving@csiro.au

--------------------------------------------------------------------------------

INTRODUCTION

The data are the most commonly used surface variables from Regional Climate
Models (RCMs) contributing to the Coordinated Regional Downscaling Experiment
under the Coupled Model Intercomparison Project phase 6 (CORDEX-CMIP6) for
Australasia in a convenient form for applied users.
Data are for historical and two Shared Socioeconomic Pathway (SSP) experiments,
regridded from the native RCM resolution of ~10-20 km to the ~5 km standard and
regular grid of the Australian Gridded Climate Dataset (AGCD) and subset for
Australia only, in raw form and then with four variations of bias correction.

It should be noted that interpolation to ~5km is purely statistical and adds no
new information from the RCMs at this scale, while the native resolution of the
observational information used in the bias correction process was ~5km (AGCD) and 
~11km (BARRA-R2) respectively.


Data Provider: Australian Climate Service (partnership between the Bureau of
               Meteorology and CSIRO)

NCI Data Catalogue: https://dx.doi.org/10.25914/xeca-pw53

NCI THREDDS Data Server: https://dx.doi.org/10.25914/xeca-pw53

License: https://creativecommons.org/licenses/by/4.0/

Extended Documentation: https://opus.nci.org.au/x/LoG_Fg 

--------------------------------------------------------------------------------

CONDITIONS OF USE

The data collection is considered a research product that has not been fully
evaluated. 

Users are advised to refer to the Extended Documentation for the known issues 
and undertake evaluation of the data prior to use in their applications.
 
The Australian Climate Service seeks user feedback on the quality and usage of
the data, to help identify areas for improvements. 

The Australian Climate Service can also advise appropriate use of the data. 

Please refer feedback and questions on data use to help@nci.org.au.


--------------------------------------------------------------------------------

FILE ORGANISATION

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

   An example for the reridded data is, 
      /g/data/kj66/CORDEX/output/CMIP6/DD/AUST-05i/UQ-DES/ACCESS-ESM1-5/
      historical/r40i1p1f1/CCAMoc-v2112/v1-r1/day/sfcWindmax/v20241216/
      sfcWindmax_AUST-05i_ACCESS-ESM1-5_historical_r40i1p1f1_UQ-DES_
      CCAMoc-v2112_v1-r1_day_19600101-19601231.nc

   An example for the bias corrected data is,
      /g/data/kj66/CORDEX/output-Adjust/CMIP6/bias-adjusted-output/AUST-05i/
      CSIRO/CNRM-ESM2-1/ssp370/r1i1p1f2/CCAM-v2203-SN/
      v1-r1-ACS-QME-BARRAR2-1980-2022/day/tasminAdjust/v20241216/tasminAdjust_
      AUST-05i_CNRM-ESM2-1_ssp370_r1i1p1f2_CSIRO_CCAM-v2203-SN_
      v1-r1-ACS-QME-BARRAR2-1980-2022_day_20660101-20661231.nc


--------------------------------------------------------------------------------

DATA FORMAT

netCDF-4 classic

--------------------------------------------------------------------------------

ACKNOWLEDGEMENTS

The production of this data was supported with funding from the Australian Climate
Service and publication support from NCI.

