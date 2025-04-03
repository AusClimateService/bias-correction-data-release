#
# Bash script for updating the bias corrected data reference syntax
#
# Usage: bash move_data.sh {files to move}
#
# Example 1: 
#  - Input: /g/data/ia39/australian-climate-service/test-data/CORDEX-CMIP6/bias-adjustment-output/AGCD-05i/CSIRO/CESM2/historical/r11i1p1f1/CCAM-v2203-SN/v1-r1-ACS-QME-AGCD-1960-2022/day/prAdjust/prAdjust_AGCD-05i_CESM2_historical_r11i1p1f1_CSIRO_CCAM-v2203-SN_v1-r1-ACS-QME-AGCD-1960-2022_day_19860101-19861231.nc
#  - Output: /g/data/ia39/australian-climate-service/release/CORDEX/output-Adjust/CMIP6/bias-adjusted-output/AUST-05i/CSIRO/CESM2/historical/r11i1p1f1/CCAM-v2203-SN/v1-r1-ACS-QME-AGCDv1-1960-2022/day/prAdjust/v20241216/prAdjust_AUST-05i_CESM2_historical_r11i1p1f1_CSIRO_CCAM-v2203-SN_v1-r1-ACS-QME-AGCDv1-1960-2022_day_19860101-19861231.nc
#
# Example 2:
#  - Input: /g/data/ia39/australian-climate-service/test-data/CORDEX-CMIP6/bias-adjustment-input/AGCD-05i/BOM/CESM2/historical/r11i1p1f1/BARPA-R/v1-r1/day/rsds/rsds_AGCD-05i_CESM2_historical_r11i1p1f1_BOM_BARPA-R_v1-r1_day_19890101-19891231.nc
#  - Output: /g/data/ia39/australian-climate-service/release/CORDEX/output-Adjust/CMIP6/bias-adjusted-input/AUST-05i/BOM/CESM2/historical/r11i1p1f1/BARPA-R/v1-r1/day/rsds/v20241216/rsds_AUST-05i_CESM2_historical_r11i1p1f1_BOM_BARPA-R_v1-r1_day_19890101-19891231.nc
#
# Example 3:
#  - Input: /g/data/ia39/australian-climate-service/test-data/CORDEX-CMIP6/bias-adjustment-output/AGCD-05i/NSW-Government/EC-Earth3-Veg/ssp126/r1i1p1f1/NARCliM2-0-WRF412R3/v1-r1-ACS-MRNBC-BARRA-R2-1980-2022/day/sfcWindmaxAdjust/sfcWindmaxAdjust_AGCD-05i_EC-Earth3-Veg_ssp126_r1i1p1f1_NSW-Government_NARCliM2-0-WRF412R3_v1-r1-ACS-MRNBC-BARRA-R2-1980-2022_day_20250101-20251231.nc
#  - Output: /g/data/ia39/australian-climate-service/release/CORDEX/output-Adjust/CMIP6/bias-adjusted-output/AUST-05i/NSW-Government/EC-Earth3-Veg/ssp126/r1i1p1f1/NARCliM2-0-WRF412R3/v1-r1-ACS-MRNBC-BARRAR2-1980-2022/day/sfcWindmaxAdjust/v20241216/sfcWindmaxAdjust_AUST-05i_EC-Earth3-Veg_ssp126_r1i1p1f1_NSW-Government_NARCliM2-0-WRF412R3_v1-r1-ACS-MRNBC-BARRAR2-1980-2022_day_20250101-20251231.nc


for inpath in "$@"; do
    echo ${inpath}
    base=`basename ${inpath}`
    var=`echo ${base} | cut -d '_' -f 1`
    outpath=`echo ${inpath} | sed s:test-data:release:`
    outpath=`echo ${outpath} | sed s:CORDEX-CMIP6/:CORDEX/output-Adjust/CMIP6/:`
    outpath=`echo ${outpath} | sed s:adjustment:adjusted:`
    outpath=`echo ${outpath} | sed s:AGCD-05i:AUST-05i:g`
    outpath=`echo ${outpath} | sed s:BARRA-R2:BARRAR2:g`
    outpath=`echo ${outpath} | sed s:AGCD:AGCDv1:g`
    outpath=`echo ${outpath} | sed s:${var}/:${var}/v20241216/:g`
    # Move file
    outdir=`dirname ${outpath}`
#    mkdir -p ${outdir}
#    mv ${inpath} ${outpath}
    echo ${outpath}
done
