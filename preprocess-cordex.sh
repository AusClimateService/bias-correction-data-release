#
# Bash script for preprocessing CORDEX data for ACS bias correction
#
# Usage: bash preprocess-cordex.sh {gcm} {rcm} {run} {exp} {invar} {infreq} {outvar} {outfreq} {outgrid} {regrid} {chunking} {flags}
#
#   gcm:      name of global climate model (e.g. ACCESS-CM2)
#   rcm:      name of regional climate model (BARPA-R, CCAM-v2203-SN, CCAMoc-v2112, CCAM-v2105, CCAM-v2112, NARCliM2-0-WRF412R3, NARCliM2-0-WRF412R5)
#   run:      run to process (e.g. r1i1p1f1)
#   exp:      experiment (e.g. historical, ssp126, ssp370)
#   invar:    variable to process (tas, tasmin, tasmax, pr, prsn, rsds, rlds, sfcWind, sfcWindmax, hurs, psl, ps, wbgt)
#   infreq:   input data frequency (fx, day, 1hr)
#   outvar:   variable to output  (tas, tasmin, tasmax, pr, prsn, rsds, rlds, sfcWind, sfcWindmax, hurs, hursmin, hursmax, psl, ps, wbgt)
#   outfreq:  input data frequency (fx, day, 1hr)
#   outgrid:  output grid (AUST-05i, AUST-11i, AUST-20i)
#   regrid:   regrid method (bilinear, conservative)
#   chunking: chunking strategy (temporal, spatial)
#   flags:    optional flags (e.g. -n for dry run)
#

gcm=$1
rcm=$2
run=$3
exp=$4
invar=$5
infreq=$6
outvar=$7
outfreq=$8
outgrid=$9
regrid=${10}
chunking=${11}
flags=${12}
python=/g/data/xv83/dbi599/miniconda3/envs/npcp2/bin/python

if [[ "${invar}" == "wbgt" ]] ; then
    if [[ "${exp}" == "historical" ]] ; then
        infiles=(`ls /scratch/e53/bxn599/aus10i/access-cm2_historical/wbgt*.nc`)
    else
        infiles=(`ls /scratch/e53/bxn599/aus10i/wbgt*_${exp}_*.nc`)
    fi
else
    if [[ "${rcm}" == "BARPA-R" ]] ; then
        project_dir=/g/data/py18/BARPA/output/CMIP6/DD/AUS-15/BOM
        tstamp="latest"
    elif [[ "${rcm}" == "CCAM-v2203-SN" ]] ; then
        project_dir=/g/data/hq89/CCAM/output/CMIP6/DD/AUS-10i/CSIRO
        tstamp="v*"
    elif [[ "${rcm}" == "CCAMoc-v2112" ]] ; then
        project_dir=/g/data/ig45/QldFCP-2/CORDEX-CMIP6/DD/AUS-20i/UQ-DEC
        tstamp="latest"
    elif [[ "${rcm}" == "CCAM-v2105" ]] ; then
        project_dir=/g/data/ig45/QldFCP-2/CORDEX-CMIP6/DD/AUS-20i/UQ-DEC
        tstamp="latest"
    elif [[ "${rcm}" == "CCAM-v2112" ]] ; then
        project_dir=/g/data/ig45/QldFCP-2/CORDEX-CMIP6/DD/AUS-20i/UQ-DEC
        tstamp="latest"
    elif [[ "${rcm}" == "NARCliM2-0-WRF412R3" ]] ; then
        project_dir=/g/data/zz63/NARCliM2-0/output/CMIP6/DD/AUS-18/NSW-Government
        rlon="--rlon /g/data/zz63/NARCliM2-0/rlon-correction-AUS-18.txt"
        tstamp="latest"
    elif [[ "${rcm}" == "NARCliM2-0-WRF412R5" ]] ; then
        project_dir=/g/data/zz63/NARCliM2-0/output/CMIP6/DD/AUS-18/NSW-Government
        rlon="--rlon /g/data/zz63/NARCliM2-0/rlon-correction-AUS-18.txt"
        tstamp="latest"
    fi
    infiles=(`ls ${project_dir}/${gcm}/${exp}/${run}/${rcm}/*/${infreq}/${invar}/${tstamp}/*.nc`)
fi

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
    
    outdir=/g/data/ia39/australian-climate-service/test-data/CORDEX/output-CMIP6/DD/${outgrid}/${institution}/${gcm}/${experiment}/${run}/${rcm}/${version}/${outfreq}/${outvar}/latest
    outfile_start=${outvar}_${outgrid}_${gcm}_${experiment}_${run}_${institution}_${rcm}_${version}_${outfreq}
    if [[ "${outvar}" == "orog" ]] ; then
        outfile_end=".nc"
    else
        outfile_end="_${start_date:0:6}01-${end_date:0:6}31.nc"
    fi
    outfile=${outfile_start}${outfile_end}
    outpath=${outdir}/${outfile}
    python_command="${python} preprocess.py ${infile} ${invar} ${infreq} ${outvar} ${outfreq} ${outgrid} ${regrid} ${outpath} ${rlon} --chunking_strategy ${chunking} --compute"
    if [[ ! -f ${infile} ]] ; then
        echo "File not found: ${infile}"
    elif [[ "${flags}" == "-n" ]] ; then
        echo ${python_command}
    elif [[ ! -f ${outpath} ]] ; then
        echo ${infile}
        mkdir -p ${outdir}
        ${python_command}
        echo ${outpath}
    else
        echo "File already exists: ${outpath}"
    fi
done

