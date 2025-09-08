#
# Bash script for monthly time aggregation
#
# Usage: bash time_aggregation.sh {files}
#
# Example input file:
#  /g/data/kj66/CORDEX/output-CMIP6/bias-adjusted-output/AUST-05i/BOM/ACCESS-CM2/historical/r4i1p1f1/BARPA-R/v1-r1-ACS-MRNBC-AGCDv1-1960-2022/day/tasmaxAdjust/v20241216/tasmaxAdjust_AUST-05i_ACCESS-CM2_historical_r4i1p1f1_BOM_BARPA-R_v1-r1-ACS-MRNBC-AGCDv1-1960-2022_day_19600101-19601231.nc
#
# Example output file:
# /g/data/ia39/australian-climate-service/test-data/CORDEX/output-CMIP6/bias-adjusted-output/AUST-05i/BOM/ACCESS-CM2/historical/r4i1p1f1/BARPA-R/v1-r1-ACS-MRNBC-AGCDv1-1960-2022/mon/tasmaxAdjust/v20241216/tasmaxAdjust_AUST-05i_ACCESS-CM2_historical_r4i1p1f1_BOM_BARPA-R_v1-r1-ACS-MRNBC-AGCDv1-1960-2022_mon_196001-196012.nc

python=/g/data/xv83/dbi599/miniconda3/envs/npcp/bin/python

for inpath in "$@"; do
    if [ ! -f ${inpath} ] ; then
        echo 'File not found: ' ${inpath}
    else    
        echo ${inpath}
        var=`basename ${inpath} | cut -d _ -f 1`
        outpath=`echo ${inpath} | sed s:kj66/:ia39/australian-climate-service/test-data/:`
        outpath=`echo ${outpath} | sed s:day/:mon/:`
        outpath=`echo ${outpath} | sed s:_day_:_mon_:`
        outpath=`echo ${outpath} | sed s:0101-:01-:`
        outpath=`echo ${outpath} | sed s:1231.nc:12.nc:`
        outdir=`dirname ${outpath}`
        if [ ! -f ${outpath} ] ; then
            mkdir -p ${outdir}
            ${python} /home/599/dbi599/bias-correction-data-release/time_aggregation.py ${inpath} ${var} ${outpath}    
            echo ${outpath} 
        else
            echo 'File already processed: ' ${outpath}
        fi
    fi
done


