#
# Bash script for preprocessing CORDEX data for ACS bias correction
#
# Usage: bash preprocess-cordex.sh {gcm} {rcm} {run} {exp} {var} {flags}
#
#   gcm:    name of global climate model (e.g. ACCESS-CM2)
#   rcm:    name of regional climate model (BARPA-R, CCAM-v2203-SN, CCAMoc-v2112, CCAM-v2105, CCAM-v2112, NARCliM2-0-WRF412R3, NARCliM2-0-WRF412R5)
#   run:    run to process (e.g. r1i1p1f1)
#   exp:    experiment (e.g. historical, ssp126, ssp370)
#   var:    variable to process (tasmin, tasmax, pr, rsds, rlds, sfcwind, sfcWindmax, hursmin, hursmax, psl, orog, ps, huss, prsn)
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
    project_dir=/g/data/py18/BARPA/output/CMIP6/DD/AUS-15/BOM
elif [[ "${rcm}" == "CCAM-v2203-SN" ]] ; then
    project_dir=/g/data/hq89/CCAM/output/CMIP6/DD/AUS-10i/CSIRO
elif [[ "${rcm}" == "CCAMoc-v2112" ]] ; then
    project_dir=/g/data/ig45/QldFCP-2/CORDEX/CMIP6/DD/AUS-20i/UQ-DEC
elif [[ "${rcm}" == "CCAM-v2105" ]] ; then
    project_dir=/g/data/ig45/QldFCP-2/CORDEX/CMIP6/DD/AUS-20i/UQ-DEC
elif [[ "${rcm}" == "CCAM-v2112" ]] ; then
    project_dir=/g/data/ig45/QldFCP-2/CORDEX/CMIP6/DD/AUS-20i/UQ-DEC
elif [[ "${rcm}" == "NARCliM2-0-WRF412R3" ]] ; then
    project_dir=/g/data/zz63/NARCliM2-0/output/CMIP6/DD/AUS-18/NSW-Government
    rlon="--rlon /g/data/zz63/NARCliM2-0/rlon-correction-AUS-18.txt"
elif [[ "${rcm}" == "NARCliM2-0-WRF412R5" ]] ; then
    project_dir=/g/data/zz63/NARCliM2-0/output/CMIP6/DD/AUS-18/NSW-Government
    rlon="--rlon /g/data/zz63/NARCliM2-0/rlon-correction-AUS-18.txt"
fi

if [[ "${var}" == "hursmin" || "${var}" == "hursmax" ]] ; then
    input_freq=1hr
    output_freq=day
    input_var=hurs
elif [[ "${var}" == "orog" ]] ; then
    input_freq=fx
    output_freq=fx
    input_var=${var}
else
    input_freq=day
    output_freq=day
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
    
    outdir=/g/data/ia39/australian-climate-service/release/CORDEX/output-Adjust/CMIP6/bias-adjusted-input/AUST-05i/${institution}/${gcm}/${experiment}/${run}/${rcm}/${version}/${output_freq}/${var}/v20250311
    outfile_start=${var}_AUST-05i_${gcm}_${experiment}_${run}_${institution}_${rcm}_${version}_${output_freq}
    if [[ "${var}" == "orog" ]] ; then
        outfile_end=".nc"
    else
        outfile_end="_${start_date:0:6}01-${end_date:0:6}31.nc"
    fi
    outfile=${outfile_start}${outfile_end}

    python_command="${python} preprocess.py ${infile} ${var} bilinear ${outdir}/${outfile} ${rlon}"
    if [[ ! -f ${infile} ]] ; then
        echo "File not found: ${infile}"
    elif [[ "${flags}" == "-n" ]] ; then
        echo ${python_command}
    else
        echo ${infile}
        mkdir -p ${outdir}
        ${python_command}
        echo ${outdir}/${outfile}
    fi
done

