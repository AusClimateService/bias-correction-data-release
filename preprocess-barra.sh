#
# Bash script for preprocessing BARRA-R2 data for ACS bias correction
#
# Usage: bash preprocess-barra.sh {var} {flags}
#
#   var:    variable to process (tas, tasmin, tasmax, pr, prsn, rsds, rlds, sfcWind, sfcWindmax, hurs, hursmin, hursmax, psl, ps)
#   flags:  optional flags (e.g. -n for dry run)
#

var=$1
flags=$2
python=/g/data/xv83/dbi599/miniconda3/envs/npcp/bin/python

if [[ "${var}" == "hursmin" || "${var}" == "hursmax" ]] ; then
    input_freq=1hr
    input_var=hurs
else
    input_freq=day
    input_var=${var}
fi
project_dir=/g/data/ob53/BARRA2/output/reanalysis/AUS-11/BOM/ERA5/historical/hres/BARRA-R2/v1

outdir=/g/data/ia39/australian-climate-service/release/CORDEX/output-Adjust/CMIP6/bias-adjusted-input/AUST-05i/BOM/ERA5/historical/hres/BARRAR2/v1/day/${var}/v20250311
for year in $(seq 1979 2023); do
    infiles=(`ls ${project_dir}/${input_freq}/${input_var}/v*/*_${year}??-${year}??.nc`)
    outfile=${var}_AUST-05i_ERA5_historical_hres_BOM_BARRAR2_v1_day_${year}0101-${year}1231.nc
    
    python_command="${python} preprocess.py ${infiles[@]} ${var} bilinear ${outdir}/${outfile}"
    if [[ "${flags}" == "-n" ]] ; then
        echo ${python_command}
    else
        echo ${year}
        mkdir -p ${outdir}
        ${python_command}
        echo ${outdir}/${outfile}
    fi
done

