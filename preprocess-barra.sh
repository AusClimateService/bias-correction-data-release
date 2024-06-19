#
# Bash script for preprocessing BARRA-R2 data for ACS bias correction
#
# Usage: bash preprocess-barra.sh {var} {flags}
#
#   var:    variable to process (tasmin, tasmax, pr, rsds, sfcWindmax, hursmin, hursmax)
#   flags:  optional flags (e.g. -n for dry run)
#

var=$1
flags=$2
python=/g/data/xv83/dbi599/miniconda3/envs/npcp/bin/python

if [[ "${var}" == "hursmin" || "${var}" == "hursmax" ]] ; then
    project_dir=/scratch/hd50/jt4085/bias_correction/BARRA2/output/reanalysis/AUS-11/BOM/ERA5/historical/hres/BARRA-R2/v1
    input_freq=1hr
    input_var=hurs
else
    project_dir=/g/data/ob53/BARRA2/output/reanalysis/AUS-11/BOM/ERA5/historical/hres/BARRA-R2/v1
    input_freq=day
    input_var=${var}
fi

outdir=/g/data/ia39/australian-climate-service/test-data/CORDEX-CMIP6/bias-adjustment-input/AGCD-05i/BOM/ERA5/historical/hres/BARRA-R2/v1/day/${var}
for year in $(seq 1979 2023); do
    infiles=(`ls ${project_dir}/${input_freq}/${input_var}/v*/*_${year}??-${year}??.nc`)
    outfile=${var}_AGCD-05i_ERA5_historical_hres_BOM_BARRA-R2_v1_day_${year}0101-${year}1231.nc
    
    python_command="${python} preprocess.py ${infiles[@]} ${var} bilinear ${outdir}/${outfile}"
    if [[ "${flags}" == "-n" ]] ; then
        echo ${python_command}
    else
        echo ${infile}
        mkdir -p ${outdir}
        ${python_command}
        echo ${outdir}/${outfile}
    fi
done

