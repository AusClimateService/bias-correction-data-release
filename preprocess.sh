#
# Bash script for preprocessing data for ACS bias correction
#
# Usage: bash preprocess.sh {gcm} {rcm} {run} {var} {flags}
#
#   gcm:    name of global climate model (e.g. ACCESS-CM2)*
#   rcm:    name of regional climate model (BARPA-R, CCAM-v2203-SN, CCAMoc-v2112, CCAM-v2105, CCAM-v2112, BARRA-R2)
#   run:    run to process (e.g. r1i1p1f1)
#   var:    variable to process (tasmin, tasmax, pr, rsds, sfcWindmax)
#   flags:  optional flags (e.g. -n for dry run)
#
# *For BARRA-R2 the gcm is ERA5

gcm=$1
rcm=$2
run=$3
var=$4
flags=$5
python=/g/data/xv83/dbi599/miniconda3/envs/npcp/bin/python

if [[ "${rcm}" == "BARPA-R" ]] ; then
    project_dir=/g/data/py18/BARPA/output/CMIP6/DD/AUS-15/BOM
elif [[ "${rcm}" == "CCAM-v2203-SN" ]] ; then
    project_dir=/g/data/hq89/CCAM/output/CMIP6/DD/AUS-10i/CSIRO
elif [[ "${rcm}" == "CCAMoc-v2112" ]] ; then
    project_dir=/g/data/ig45/QldFCP-2/CORDEX/CMIP6/DD/AUS-20i/UQ-DES
elif [[ "${rcm}" == "CCAM-v2105" ]] ; then
    project_dir=/g/data/ig45/QldFCP-2/CORDEX/CMIP6/DD/AUS-20i/UQ-DES
elif [[ "${rcm}" == "CCAM-v2112" ]] ; then
    project_dir=/g/data/ig45/QldFCP-2/CORDEX/CMIP6/DD/AUS-20i/UQ-DES
elif [[ "${rcm}" == "BARRA-R2" ]] ; then
    project_dir=/g/data/ob53/BARRA2/output/reanalysis/AUS-11/BOM
fi
infiles=(`ls ${project_dir}/${gcm}/{historical,ssp370}/${run}/${rcm}/*/day/${var}/*/*.nc`)

for infile in "${infiles[@]}"; do
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
    
    python_command="${python} preprocess.py ${infile} ${var} bilinear ${outdir}/${outfile}"
    if [[ "${flags}" == "-n" ]] ; then
        echo ${python_command}
    else
        echo ${infile}
        mkdir -p ${outdir}
        ${python_command}
        ncatted -O -a least_significant_digit,${var},d,, ${outdir}/${outfile}
        echo ${outdir}/${outfile}
    fi
done

