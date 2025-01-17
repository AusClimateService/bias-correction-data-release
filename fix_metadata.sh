#
# Bash script for fixing ACS bias correction file metadata
#
# Usage: bash fix_metadata.sh {files to fix}
#
# Example input files: 
#

python=/g/data/xv83/quantile-mapping/miniconda3/envs/qq-workflows/bin/python

for inpath in "$@"; do
    echo ${inpath}
    var=`basename ${inpath} | cut -d _ -f 1` 
    type=`echo ${inpath} | cut -d '/' -f 10`
    echo $var
    echo $type
    if [[ "${type}" == "bias-adjusted-input" ]] ; then
        outpath=`echo ${inpath} | sed s:output-Adjust:output:`
        outpath=`echo ${outpath} | sed s:bias-adjusted-input:DD:`
        outdir=`dirname ${outpath}`
        #mkdir -p ${outdir}
    else
        outpath=`echo ${inpath} | sed s:.nc:_fixed.nc:`
    fi
    echo ${python} /home/599/dbi599/bias-correction-data-release/fix_metadata.sh ${inpath} ${var} ${outpath}    
    #echo ${outpath}
done
