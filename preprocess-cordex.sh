#
# Bash script for preprocessing CORDEX data for ACS bias correction
#
# Usage: bash preprocess.sh {gcm} {rcm} {run} {exp} {var} {flags}
#
#   gcm:    name of global climate model (e.g. ACCESS-CM2)
#   rcm:    name of regional climate model (BARPA-R, CCAM-v2203-SN, CCAMoc-v2112, CCAM-v2105, CCAM-v2112)
#   run:    run to process (e.g. r1i1p1f1)
#   exp:    experiment (e.g. historical, ssp126, ssp370)
#   var:    variable to process (tasmin, tasmax, pr, rsds, sfcWindmax, hursmin, hursmax)
#   flags:  optional flags (e.g. -n for dry run)
#

gcm=$1
rcm=$2
run=$3
exp=$4
var=$5
flags=$6
python=/g/data/xv83/dbi599/miniconda3/envs/npcp/bin/python

if [[ "${rcm}" == "BARPA-R" ]] ; then
    if [[ "${exp}" == "ssp126" ]] ; then
        project_dir=/g/data/py18/BARPA/output/CMIP6/DD/AUS-15/BOM
    elif [[ "${var}" == "hursmin" || "${var}" == "hursmax" ]] ; then
        project_dir=/scratch/tp28/eh6215/bias_correction_inputs/BARPA/output/CMIP6/DD/AUS-15/BOM
    else
        project_dir=/g/data/py18/BARPA/output/CMIP6/DD/AUS-15/BOM
    fi
elif [[ "${rcm}" == "CCAM-v2203-SN" ]] ; then
    project_dir=/g/data/hq89/CCAM/output/CMIP6/DD/AUS-10i/CSIRO
elif [[ "${rcm}" == "CCAMoc-v2112" ]] ; then
    project_dir=/g/data/ig45/QldFCP-2/CORDEX/CMIP6/DD/AUS-20i/UQ-DES
elif [[ "${rcm}" == "CCAM-v2105" ]] ; then
    project_dir=/g/data/ig45/QldFCP-2/CORDEX/CMIP6/DD/AUS-20i/UQ-DES
elif [[ "${rcm}" == "CCAM-v2112" ]] ; then
    project_dir=/g/data/ig45/QldFCP-2/CORDEX/CMIP6/DD/AUS-20i/UQ-DES
fi

if [[ "${var}" == "hursmin" || "${var}" == "hursmax" ]] ; then
    input_freq=1hr
    input_var=hurs
else
    input_freq=day
    input_var=${var}
fi


infiles=(`ls ${project_dir}/${gcm}/${exp}/${run}/${rcm}/*/${input_freq}/${input_var}/v*/*.nc`)

for infile in "${infiles[@]}"; do
    gcm=`basename ${infile} | cut -d _ -f 3`
    experiment=`basename ${infile} | cut -d _ -f 4`
    run=`basename ${infile} | cut -d _ -f 5`
    institution=`basename ${infile} | cut -d _ -f 6`
    rcm=`basename ${infile} | cut -d _ -f 7`
    version=`basename ${infile} | cut -d _ -f 8`
    tbounds=`basename ${infile} | cut -d _ -f 10 | cut -d . -f 1`
    start_date=`echo ${tbounds} | cut -d - -f 1`
    end_date=`echo ${tbounds} | cut -d - -f 2`
    
    outdir=/g/data/ia39/australian-climate-service/test-data/CORDEX-CMIP6/bias-adjustment-input/AGCD-05i/${institution}/${gcm}/${experiment}/${run}/${rcm}/${version}/day/${var}
    outfile=${var}_AGCD-05i_${gcm}_${experiment}_${run}_${institution}_${rcm}_${version}_day_${start_date:0:6}01-${end_date:0:6}31.nc
    
    python_command="${python} preprocess.py ${infile} ${var} bilinear ${outdir}/${outfile}"
    if [[ "${flags}" == "-n" ]] ; then
        echo ${python_command}
    else
        echo ${infile}
        mkdir -p ${outdir}
        ${python_command}
        echo ${outdir}/${outfile}
    fi
done

