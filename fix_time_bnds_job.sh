#!/bin/bash
#PBS -P xv83
#PBS -q normal
#PBS -l walltime=10:00:00
#PBS -l mem=50GB
#PBS -l storage=gdata/xv83+gdata/kj66
#PBS -l wd
#PBS -v inst,exp,var,bc,obs

# Options:
#  - inst: BOM CSIRO
#  - exp:  historical ssp126 ssp370
#  - var:  hursmax hursmin
#  - type: input output
#
# Example:
# qsub -v inst=BOM,exp=historical,var=hursmax,type=input fix_time_bnds_job.sh


if [[ "${type}" == "output" ]] ; then
filevar=${var}Adjust
else
filevar=${var}
fi

bash /home/599/dbi599/bias-correction-data-release/fix_time_bnds.sh /g/data/kj66/CORDEX/output/CMIP6/*/AUST-05i/${inst}/*/${exp}/*/*/*/day/${filevar}/v*/*.nc



