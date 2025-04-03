#!/bin/bash
#PBS -P xv83
#PBS -q normal
#PBS -l walltime=10:00:00
#PBS -l mem=50GB
#PBS -l storage=gdata/ia39
#PBS -l wd
#PBS -v var,type

# Options:
#  - var:  hursmax hursmin pr rsds sfcWindmax tasmax tasmin
#  - type: input output  
#
# Example:
# qsub -v var=hursmax,type=input fix_uq_job.sh

if [[ "${type}" == "output" ]] ; then
  filevar=${var}Adjust
else
  filevar=${var}
fi

bash /home/599/dbi599/bias-correction-data-release/fix_uq.sh /g/data/ia39/australian-climate-service/release/CORDEX/output-Adjust/CMIP6/bias-adjusted-${type}/AUST-05i/UQ-DES/*/*/*/*/*/day/${filevar}/*/*.nc



