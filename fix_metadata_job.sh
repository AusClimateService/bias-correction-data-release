#!/bin/bash
#PBS -P xv83
#PBS -q normal
#PBS -l walltime=24:00:00
#PBS -l mem=10GB
#PBS -l storage=gdata/xv83+gdata/kj66
#PBS -l wd

bash /home/599/dbi599/bias-correction-data-release/fix_metadata.sh /g/data/kj66/admin/staging/CORDEX/output-Adjust/CMIP6/bias-adjusted-input/AUST-05i/*/*/${exp}/*/*/v1-r1/day/${var}/v20241216/*.nc



