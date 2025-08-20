#!/bin/bash
#PBS -P xv83
#PBS -q normal
#PBS -l walltime=30:00:00
#PBS -l mem=50GB
#PBS -l storage=gdata/xv83+gdata/ia39+gdata/hq89+gdata/ig45+gdata/py18+gdata/ob53+gdata/zz63
#PBS -l wd
#PBS -v gcm,rcm,run,exp,invar,infreq,outvar,outfreq

# Example:
#   qsub -v gcm=ACCESS-CM2,rcm=BARPA-R,run=r4i1p1f1,exp=historical,invar=tas,infreq=1hr,outvar=tas,outfreq=1hr preprocess-cordex-job.sh


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

command="bash /home/599/dbi599/bias-correction-data-release/preprocess-cordex.sh ${gcm} ${rcm} ${run} ${exp} ${invar} ${infreq} ${outvar} ${outfreq}"
echo ${command}
${command}


