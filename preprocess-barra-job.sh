#!/bin/bash
#PBS -P xv83
#PBS -q normal
#PBS -l walltime=12:00:00
#PBS -l mem=150GB
#PBS -l storage=gdata/xv83+gdata/ia39+gdata/ob53
#PBS -l wd
#PBS -v input_var,input_freq,output_var,output_freq,output_grid,regrid_method

# Example:
#   qsub -v input_var=tas,input_freq=1hr,output_var=tas,output_freq=1hr,output_grid=AUST-20i,regrid_method=conservative preprocess-barra-job.sh
#
# Compute usage:
#   One year of hourly data takes about 40 minutes to process and 260 GB of memory for the AUST-05i grid (with --compute)

__conda_setup="$('/g/data/xv83/dbi599/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/g/data/xv83/dbi599/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/g/data/xv83/dbi599/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/g/data/xv83/dbi599/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup

conda activate npcp2

command="bash /home/599/dbi599/bias-correction-data-release/preprocess-barra.sh ${input_var} ${input_freq} ${output_var} ${output_freq} ${output_grid} ${regrid_method}"
echo ${command}
${command}


