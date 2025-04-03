#
# Bash script for fixing hursmin and hursmax time axis
#
# Usage: bash fix_time_bnds.sh {files to fix}
#
# Example input files:
#
# /g/data/kj66/admin/staging/CORDEX/output/CMIP6/DD/AUST-05i/NSW-Government/UKESM1-0-LL/ssp126/r1i1p1f2/NARCliM2-0-WRF412R3/v1-r1/day/hursmin/v20241216/
# hursmin_AUST-05i_UKESM1-0-LL_ssp126_r1i1p1f2_NSW-Government_NARCliM2-0-WRF412R3_v1-r1_day_20270101-20271231.nc
#
# /g/data/ia39/australian-climate-service/release/CORDEX/output-Adjust/CMIP6/bias-adjusted-output/AUST-05i/UQ-DEC/FGOALS-g3/ssp126/r4i1p1f1/CCAM-v2105/v1-r1-ACS-MRNBC-BARRAR2-1980-2022/day/hursminAdjust/v20241216/hursminAdjust_AUST-05i_FGOALS-g3_ssp126_r4i1p1f1_UQ-DEC_CCAM-v2105_v1-r1-ACS-MRNBC-BARRAR2-1980-2022_day_20970101-20971231.nc
#

python=/g/data/xv83/dbi599/miniconda3/envs/npcp/bin/python

for inpath in "$@"; do
    if [ ! -f ${inpath} ] ; then
        echo 'File not found: ' ${inpath}
    else    
        echo ${inpath}
        var=`basename ${inpath} | cut -d _ -f 1`
        project=`echo ${inpath} | cut -d / -f 4`
        if [[ "${project}" == "kj66" ]] ; then
            outpath=`echo ${inpath} | sed s:.nc:_fixed.nc:`
        elif [[ "${project}" == "ia39" ]] ; then
            outpath=`echo ${inpath} | sed s:release:test-data:`
            outdir=`dirname ${outpath}`
            mkdir -p ${outdir}
        fi
        if [ ! -f ${outpath} ] ; then
            ${python} /home/599/dbi599/bias-correction-data-release/fix_time_bnds.py ${inpath} ${var} ${outpath}    
            echo ${outpath} 
        else
            echo 'File already processed: ' ${outpath}
        fi
    fi
done
