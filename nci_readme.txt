################################################################################

CORDEX-CMIP6-based regridded and calibrated data for Australia

################################################################################

VERSION
v1.0: 21/01/25: Created by Dr Damien Irving, damien.irving@csiro.au

--------------------------------------------------------------------------------

INTRODUCTION

B

Data Provider: Australian Climate Service (partnership between the Bureau of
               Meteorology and CSIRO)

NCI Data Catalogue: https://dx.doi.org/10.25914/xeca-pw53

NCI THREDDS Data Server: https://dx.doi.org/10.25914/xeca-pw53

License: https://creativecommons.org/licenses/by/4.0/

Extended Documentation: <insert https://opus.nci.org.au/ or GitHub link?> 

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

DISCLAIMER

Refer to http://www.bom.gov.au/other/disclaimer.shtml

--------------------------------------------------------------------------------

CITATION



--------------------------------------------------------------------------------

FILE ORGANISATION

   /g/data/kj66
   |-- <project_id>
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
                                              |-- <netcdf filename>
   where,
     <project_id> is CORDEX
     <product> is "output" or "outputAdjust"
     <mip-era> is the cycle of CMIP that defines experiment and data specifications.
         We use CMIP6.
     <activity_id> is "DD" for dynamical downscaling or "bais-adjusted-output"
     <domain_id> is spatial domain and grid resolution of the data, namely AUST-05i
     <institution_id> is the institution that performed the dynamical downscaling
         institutions are:
         BOM (Bureau of Meteorology)
         CSIRO (Commonwealth Scientific and Industrial Research Organisation)
         NSW-Government (for the New South Wales government)
         UQ-DEC (for the University of Queensland - 
     <driving_source_id> is the global driving model that was downscaled. The 
          models selected are: 
          ACCESS-CM2, ACCESS-ESM1-5, NorESM2-MM, EC-Earth3, CESM2, 
          CMCC-ESM2, MPI-ESM1-2-HR
     <driving_experiment_id> is historical, ssp126 or ssp370
     <driving_variant_label> labels the ensemble member of the CMIP6 simulation 
               that produced forcing data.
     <source_id> is either BARPA-R
     <version_realisation> identifies the modelling version
     <freq> is day (daily)
     <variable_id> is the variable name, mostly based on,
     <version> denotes the date of data generation or date of data release
     <netcdf filename> is 
          <variable_id>_<domain_id>_<driving_source_id>_<driving_experiment_id>_
          <driving_variant_label>_<institution_id>_<source_id>_<version_realisation>_
          <freq>[_<StartTime>-<EndTime>].nc

   Example is, 
      /g/data/kj66/CORDEX/output/CMIP6/DD/AUST-05i/UQ-DES/ACCESS-ESM1-5/historical/
      r40i1p1f1/CCAMoc-v2112/v1-r1/day/sfcWindmax/v20241216/sfcWindmax_AUST-05i_
      ACCESS-ESM1-5_historical_r40i1p1f1_UQ-DES_CCAMoc-v2112_v1-r1_day_19600101-
      19601231.nc

--------------------------------------------------------------------------------

DATA FORMAT

netCDF-4 classic

--------------------------------------------------------------------------------

ACKNOWLEDGEMENTS

The production of this data was supported with funding from the Australian Climate
Service and publication support from NCI.

