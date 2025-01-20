#!/bin/bash
#PBS -P xv83
#PBS -q normal
#PBS -l walltime=24:00:00
#PBS -l mem=10GB
#PBS -l storage=gdata/xv83+gdata/kj66
#PBS -l wd
#PBS -v type,inst,exp,var

# Options:
#  - type: input output
#  - inst: BOM CSIRO NSW-Government UQ-DES
#  - exp:  historical ssp126 ssp370
#  - var:  hursmax hursmin pr rsds sfcWindmax tasmax tasmin
#
# Example:
# qsub -v type=input,inst=BOM,exp=historical,var=hursmax fix_metadata_job.sh


if [[ "${type}" == "output" ]] ; then
filevar=${var}Adjust
else
filevar=${var}
fi

bash /home/599/dbi599/bias-correction-data-release/fix_metadata.sh /g/data/kj66/admin/staging/CORDEX/output-Adjust/CMIP6/bias-adjusted-${type}/AUST-05i/${inst}/*/${exp}/*/*/v1-r1/day/${filevar}/v20241216/*.nc



