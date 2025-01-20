#
# Bash script for fixing ACS bias correction file metadata
#
# Usage: bash fix_metadata.sh {files to fix}
#
# Example input files:
#
# /g/data/kj66/admin/staging/CORDEX/output-Adjust/CMIP6/bias-adjusted-input/AUST-05i/UQ-DES/NorESM2-MM/ssp126/r1i1p1f1/CCAMoc-v2112/v1-r1/day/rsds/v20241216/
# rsds_AUST-05i_NorESM2-MM_ssp126_r1i1p1f1_UQ-DES_CCAMoc-v2112_v1-r1_day_21000101-21001231.nc
#
# /g/data/kj66/admin/staging/CORDEX/output-Adjust/CMIP6/bias-adjusted-output/AUST-05i/NSW-Government/NorESM2-MM/ssp370/r1i1p1f1/NARCliM2-0-WRF412R5/v1-r1-ACS-MRNBC-BARRAR2-1980-2022/day/hursminAdjust/v20241216/
# hursminAdjust_AUST-05i_NorESM2-MM_ssp370_r1i1p1f1_NSW-Government_NARCliM2-0-WRF412R5_v1-r1-ACS-MRNBC-BARRAR2-1980-2022_day_20720101-20721231.nc
#

python=/g/data/xv83/quantile-mapping/miniconda3/envs/qq-workflows/bin/python

for inpath in "$@"; do
    if [ ! -f ${inpath} ] ; then
        echo 'File not found: ' ${inpath}
    else    
        echo ${inpath}
        var=`basename ${inpath} | cut -d _ -f 1` 
        type=`echo ${inpath} | cut -d '/' -f 10`
        if [[ "${type}" == "bias-adjusted-input" ]] ; then
            outpath=`echo ${inpath} | sed s:output-Adjust:output:`
            outpath=`echo ${outpath} | sed s:bias-adjusted-input:DD:`
            outdir=`dirname ${outpath}`
            mkdir -p ${outdir}
        else
            outpath=`echo ${inpath} | sed s:.nc:_fixed.nc:`
        fi
        ${python} /home/599/dbi599/bias-correction-data-release/fix_metadata.py ${inpath} ${var} ${outpath}    
        echo ${outpath}
    fi
done
