#
# Bash script for overwriting old files once fix_metadata.sh is done
#
# Usage: bash rename.sh {*_fixed.nc files to overwrite old *.nc files with}
#
# Example input file:
# /g/data/kj66/admin/staging/CORDEX/output-Adjust/CMIP6/bias-adjusted-output/AUST-05i/BOM/ACCESS-CM2/historical/r4i1p1f1/BARPA-R/v1-r1-ACS-MRNBC-BARRAR2-1980-2022/day/sfcWindmaxAdjust/v20241216/sfcWindmaxAdjust_AUST-05i_ACCESS-CM2_historical_r4i1p1f1_BOM_BARPA-R_v1-r1-ACS-MRNBC-BARRAR2-1980-2022_day_19610101-19611231_fixed.nc

for inpath in "$@"; do
    if [ ! -f ${inpath} ] ; then
        echo 'File not found: ' ${inpath}
    else    
        #outpath=`echo ${inpath} | sed s:_fixed.nc:.nc:`
	outpath=`echo ${inpath} | sed s:test-data:release:`
        echo ${inpath}
        mv ${inpath} ${outpath}    
        echo ${outpath}
    fi
done
