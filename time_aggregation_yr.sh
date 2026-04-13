#
# Bash script for annual time aggregation
#
# Usage: bash time_aggregation_yr.sh {files}
#
# Example input files:
#  /g/data/kj66/CORDEX/output-CMIP6/bias-adjusted-output/AUST-05i/BOM/ACCESS-CM2/historical/r4i1p1f1/BARPA-R/v1-r1-ACS-MRNBC-AGCDv1-1960-2022/day/tasmaxAdjust/v20241216/tasmaxAdjust_AUST-05i_ACCESS-CM2_historical_r4i1p1f1_BOM_BARPA-R_v1-r1-ACS-MRNBC-AGCDv1-1960-2022_day_*.nc
#
# Example output file:
# /g/data/ia39/australian-climate-service/test-data/CORDEX/output-CMIP6/bias-adjusted-output/AUST-05i/BOM/ACCESS-CM2/historical/r4i1p1f1/BARPA-R/v1-r1-ACS-MRNBC-AGCDv1-1960-2022/yr/tasmaxAdjust/v20241216/tasmaxAdjust_AUST-05i_ACCESS-CM2_historical_r4i1p1f1_BOM_BARPA-R_v1-r1-ACS-MRNBC-AGCDv1-1960-2022_yr_1960-2014.nc

python=/g/data/xv83/dbi599/miniconda3/envs/npcp/bin/python

inpath1=$1
inpathn=${@: -1}

var=`basename ${inpath1} | cut -d _ -f 1`
outpath=`echo ${inpath1} | sed s:kj66/:ia39/australian-climate-service/test-data/:`
outpath=`echo ${outpath} | sed s:day/:yr/:`
outpath=`echo ${outpath} | sed s:_day_:_yr_:`
inpath1end=`basename ${inpath1} | rev | cut -d _ -f 1 | rev`
year1=`echo ${inpath1end:0:4}`
inpathnend=`basename ${inpathn} | rev | cut -d _ -f 1 | rev`
yearn=`echo ${inpathnend:0:4}`

outpath=`echo ${outpath} | sed s:${inpath1end}:${year1}-${yearn}.nc:`
outdir=`dirname ${outpath}`

if [ ! -f ${outpath} ] ; then
    mkdir -p ${outdir}
    command="${python} /home/599/dbi599/bias-correction-data-release/time_aggregation.py $@ ${var} yr ${outpath}"
    echo ${command}
    ${command} 
else
    echo 'File already processed: ' ${outpath}
fi


