#!/bin/bash
#PBS -P xv83
#PBS -q normal
#PBS -l walltime=10:00:00
#PBS -l mem=60GB
#PBS -l storage=gdata/xv83+gdata/ia39+gdata/ob53
#PBS -l wd
#PBS -l ncpus=5
#PBS -v var

# Example:
#   qsub -v input_var=tas,input_freq=1hr,output_var=tas,output_freq=1hr preprocess-barra-job.sh
#

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

conda activate npcp

command="bash /home/599/dbi599/bias-correction-data-release/preprocess-barra.sh ${input_var} ${input_freq} ${output_var} ${output_freq}"
echo ${command}
${command}


