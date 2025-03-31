#!/bin/bash
#PBS -P xv83
#PBS -q normal
#PBS -l walltime=22:00:00
#PBS -l mem=50GB
#PBS -l storage=gdata/xv83+gdata/kj66
#PBS -l wd
#PBS -v inst,exp,var,type,project

# Options:
#  - inst:    BOM CSIRO NSW-Government UQ-DEC
#  - exp:     historical ssp126 ssp370
#  - var:     hursmax hursmin
#  - type:    input output
#  - project: kj66 ia39
#
# Example:
# qsub -v inst=BOM,exp=historical,var=hursmax,type=input,project=ia39 fix_time_bnds_job.sh


if [[ "${type}" == "output" ]] ; then
filevar=${var}Adjust
else
filevar=${var}
fi

if [[ "${project}" == "kj66" ]] ; then
bash /home/599/dbi599/bias-correction-data-release/fix_time_bnds.sh /g/data/kj66/CORDEX/output/CMIP6/*/AUST-05i/${inst}/*/${exp}/*/*/*/day/${filevar}/v*/*.nc
elif [[ "${project}" == "ia39" ]] ; then
bash /home/599/dbi599/bias-correction-data-release/fix_time_bnds.sh /g/data/ia39/australian-climate-service/release/CORDEX/output-Adjust/CMIP6/*/AUST-05i/${inst}/*/${exp}/*/*/*/day/${filevar}/v*/*.nc
fi






