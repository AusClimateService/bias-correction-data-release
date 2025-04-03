#!/bin/bash
#PBS -P xv83
#PBS -q normal
#PBS -l walltime=10:00:00
#PBS -l mem=50GB
#PBS -l storage=gdata/xv83+gdata/kj66
#PBS -l wd
#PBS -v inst,exp,var,bc,obs

# Options:
#  - inst: BOM CSIRO NSW-Government UQ-DES
#  - exp:  historical ssp126 ssp370
#  - var:  hursmax hursmin pr rsds sfcWindmax tasmax tasmin
#  - bc:   MRNBC QME
#  - obs:  AGCDv1 BARRAR2
#
# Example:
# qsub -v inst=BOM,exp=historical,var=hursmax,bc=MRNBC,obs=AGCDv1 fix_metadata_job.sh


#if [[ "${type}" == "output" ]] ; then
filevar=${var}Adjust
#else
#filevar=${var}
#fi

bash /home/599/dbi599/bias-correction-data-release/fix_metadata.sh /g/data/kj66/admin/staging/CORDEX/output-Adjust/CMIP6/bias-adjusted-output/AUST-05i/${inst}/*/${exp}/*/*/v1-r1-ACS-${bc}-${obs}-*/day/${filevar}/v20241216/*1.nc



