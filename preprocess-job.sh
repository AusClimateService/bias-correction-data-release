#!/bin/bash
#PBS -P xv83
#PBS -q normal
#PBS -l walltime=5:00:00
#PBS -l mem=100GB
#PBS -l storage=gdata/xv83+gdata/ia39+gdata/hq89+gdata/ig45+gdata/py18+gdata/ob53
#PBS -l wd
#PBS -l ncpus=5
#PBS -v infile,var,outfile

module load nco

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

command="python /home/599/dbi599/bias-correction-data-release/preprocess.py ${infile} ${var} bilinear ${outfile}"
echo ${command}
${command}
ncatted -O -a least_significant_digit,${var},d,, ${outfile}

