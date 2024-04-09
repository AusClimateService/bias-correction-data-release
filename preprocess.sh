#
# Bash script for preprocessing data for ACS bias correction
#
# Usage: bash preprocess.sh {full/path/to/file1.nc ... full/path/to/fileN.nc }
#
# EXAMPLES
#
# Input: /g/data/hq89/CCAM/output/CMIP6/DD/AUS-10i/CSIRO/ACCESS-CM2/ssp370/r4i1p1f1/CCAM-v2203-SN/v1-r1/day/tasmax/v20231206/tasmax_AUS-10i_ACCESS-CM2_ssp370_r4i1p1f1_CSIRO_CCAM-v2203-SN_v1-r1_day_20400101-20401231.nc
# Output: /g/data/ia39/australian-climate-service/test-data/CORDEX-CMIP6/bias-adjustment-input/AGCD-05i/CSIRO/ACCESS-CM2/ssp370/r4i1p1f1/CCAM-v2203-SN/v1-r1/day/tasmax/tasmax_AGCD-05i_ACCESS-CM2_ssp370_r4i1p1f1_CSIRO_CCAM-v2203-SN_v1-r1_day_20400101-20401231.nc
#
# Input: /g/data/ig45/QldFCP-2/CORDEX/CMIP6/DD/AUS-20i/UQ-DES/ACCESS-CM2/historical/r2i1p1f1/CCAMoc-v2112/v1-r1/day/tasmax/v20231215/tasmax_AUS-20i_ACCESS-CM2_historical_r2i1p1f1_UQ-DES_CCAMoc-v2112_v1-r1_day_19850101-19851231.nc
# Output: /g/data/ia39/australian-climate-service/test-data/CORDEX-CMIP6/bias-adjustment-input/AGCD-05i/CSIRO/ACCESS-CM2/historical/r2i1p1f1/CCAMoc-v2112/v1-r1/day/tasmax/tasmax_AGCD-05i_ACCESS-CM2_historical_r2i1p1f1_UQ-DES_CCAMoc-v2112_v1-r1_day_19850101-19851231.nc
#
# Input: /g/data/py18/BARPA/output/CMIP6/DD/AUS-15/BOM/CESM2/ssp370/r11i1p1f1/BARPA-R/v1-r1/day/pr/v20231001/pr_AUS-15_CESM2_ssp370_r11i1p1f1_BOM_BARPA-R_v1-r1_day_202201-202212.nc
# Output: /g/data/ia39/australian-climate-service/test-data/CORDEX-CMIP6/bias-adjustment-input/AGCD-05i/BOM/CESM2/ssp370/r11i1p1f1/BARPA-R/v1-r1/day/pr/pr_AGCD-05i_CESM2_ssp370_r11i1p1f1_BOM_BARPA-R_v1-r1_day_20220101-20221231.nc
#
# Input: /g/data/ob53/BARRA2/output/reanalysis/AUS-11/BOM/ERA5/historical/hres/BARRA-R2/v1/day/pr/v20231001/pr_AUS-11_ERA5_historical_hres_BOM_BARRA-R2_v1_day_200208-200208.nc
# Output: /g/data/ia39/australian-climate-service/test-data/CORDEX-CMIP6/bias-adjustment-input/AGCD-05i/BOM/ERA5/historical/hres/BARPA-R/v1/day/pr/pr_AGCD-05i_ERA5_historical_hres_BOM_BARRA-R2_v1_day_200208-200208.nc

python=/g/data/xv83/dbi599/miniconda3/envs/npcp/bin/python

for infile in "$@"; do
    echo ${infile}
    var=`basename ${infile} | cut -d _ -f 1`
    gcm=`basename ${infile} | cut -d _ -f 3`
    experiment=`basename ${infile} | cut -d _ -f 4`
    run=`basename ${infile} | cut -d _ -f 5`
    institution=`basename ${infile} | cut -d _ -f 6`
    rcm=`basename ${infile} | cut -d _ -f 7`
    version=`basename ${infile} | cut -d _ -f 8`
    tbounds=`basename ${infile} | cut -d _ -f 10 | cut -d . -f 1`
    
    outdir=/g/data/ia39/australian-climate-service/test-data/CORDEX-CMIP6/bias-adjustment-input/AGCD-05i/${institution}/${gcm}/${experiment}/${run}/${rcm}/${version}/day/${var}
    outfile=${var}_AGCD-05i_${gcm}_${experiment}_${run}_${institution}_${rcm}_${version}_day_${tbounds}.nc

    mkdir -p ${outdir}
    qsub -v infile=${infile},var=${var},outfile=${outdir}/${outfile} preprocess-job.sh
#    ${python} preprocess.py ${infile} ${var} bilinear ${outdir}/${outfile} 
#    echo ${outdir}/${outfile}
done

