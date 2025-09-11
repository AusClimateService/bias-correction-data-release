#
# Bash script for preprocessing BARRA-R2 data for ACS bias correction
#
# Usage: bash preprocess-barra.sh {input_var} {input_freq} {output_var} {output_freq} {output_grid} {regrid_method} {flags}
#
#   input_var:       variable to process (tas, tasmin, tasmax, pr, prsn, rsds, rlds, sfcWind, sfcWindmax, hurs, psl, ps)
#   input_freq:      input data frequency (fx, day, 1hr)
#   output_var:      variable to output  (tas, tasmin, tasmax, pr, prsn, rsds, rlds, sfcWind, sfcWindmax, hurs, hursmin, hursmax, psl, ps)
#   output_freq:     input data frequency (fx, day, 1hr)
#   output_grid:     output grid (AUST-05i, AUST-11i, AUST-20i)
#   regrid_method:   regrid method (bilinear, conservative)
#   flags:           optional flags (e.g. -n for dry run)
#

input_var=$1
input_freq=$2
output_var=$3
output_freq=$4
output_grid=$5
regrid_method=$6
flags=$7

python=/g/data/xv83/dbi599/miniconda3/envs/npcp2/bin/python

project_dir=/g/data/ob53/BARRA2/output/reanalysis/AUS-11/BOM/ERA5/historical/hres/BARRA-R2/v1
outdir=/g/data/ia39/australian-climate-service/test-data/BARRA2/output/reanalysis/${output_grid}/BOM/ERA5/historical/hres/BARRAR2/v1/${output_freq}/${output_var}/latest
for year in $(seq 1979 2024); do
    infiles=(`ls ${project_dir}/${input_freq}/${input_var}/v*/*_${year}??-${year}??.nc`)
    outfile=${output_var}_${output_grid}_ERA5_historical_hres_BOM_BARRAR2_v1_${output_freq}_${year}0101-${year}1231.nc
    
    python_command="${python} preprocess.py ${infiles[@]} ${input_var} ${input_freq} ${output_var} ${output_freq} ${output_grid} ${regrid_method} ${outdir}/${outfile} --compute"
    if [[ "${flags}" == "-n" ]] ; then
        echo ${python_command}
    else
        echo ${year}
        mkdir -p ${outdir}
        ${python_command}
        echo ${outdir}/${outfile}
    fi
done

