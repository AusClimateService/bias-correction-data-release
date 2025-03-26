#
# Bash script for fixing hursmin and hursmax time axis
#
# Usage: bash fix_time_bnds.sh {files to fix}
#
# Example input files:
#
# /g/data/kj66/CORDEX/output/CMIP6/DD/AUST-05i/BOM/ACCESS-CM2/historical/r4i1p1f1/BARPA-R/v1-r1/day/hursmin/v20241216/
# hursmin_AUST-05i_ACCESS-CM2_historical_r4i1p1f1_BOM_BARPA-R_v1-r1_day_19930101-19931231.nc
#
# /g/data/kj66/CORDEX/output/CMIP6/bias-adjusted-output/AUST-05i/CSIRO/EC-Earth3/ssp126/r1i1p1f1/CCAM-v2203-SN/v1-r1-ACS-MRNBC-BARRAR2-1980-2022/day/
# hursmaxAdjust/v20241216/hursmaxAdjust_AUST-05i_EC-Earth3_ssp126_r1i1p1f1_CSIRO_CCAM-v2203-SN_v1-r1-ACS-MRNBC-BARRAR2-1980-2022_day_20780101-20781231.nc
#

python=/g/data/xv83/dbi599/miniconda3/envs/npcp/bin/python

for inpath in "$@"; do
    if [ ! -f ${inpath} ] ; then
        echo 'File not found: ' ${inpath}
    else    
        echo ${inpath}
        var=`basename ${inpath} | cut -d _ -f 1`
        outpath=`echo ${inpath} | sed s:kj66:kj66/admin/staging:`
        if [ ! -f ${outpath} ] ; then
            outdir=`dirname ${outpath}`
            mkdir -p ${outdir}
            ${python} /home/599/dbi599/bias-correction-data-release/fix_time_bnds.py ${inpath} ${var} ${outpath}    
            echo ${outpath} 
        else
            echo 'File already processed: ' ${outpath}
        fi
    fi
done
