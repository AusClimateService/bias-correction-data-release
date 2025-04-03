#
# Bash script for changing UQ-DES to UQ_DEC
#
# Usage: bash fix_uq.sh {files to fix}
#
# Example input files:
#
# /g/data/ia39/australian-climate-service/release/CORDEX/output-Adjust/CMIP6/bias-adjusted-input/AUST-05i/UQ-DES/NorESM2-MM/historical/r1i1p1f1/CCAM-v2112/v1-r1/day/rsds/v20241216/rsds_AUST-05i_NorESM2-MM_historical_r1i1p1f1_UQ-DES_CCAM-v2112_v1-r1_day_19860101-19861231.nc
#
# /g/data/ia39/australian-climate-service/release/CORDEX/output-Adjust/CMIP6/bias-adjusted-output/AUST-05i/UQ-DES/EC-Earth3/ssp126/r1i1p1f1/CCAM-v2105/v1-r1-ACS-MRNBC-BARRAR2-1980-2022/day/prAdjust/v20241216/prAdjust_AUST-05i_EC-Earth3_ssp126_r1i1p1f1_UQ-DES_CCAM-v2105_v1-r1-ACS-MRNBC-BARRAR2-1980-2022_day_20780101-20781231.nc
#

module load nco

for inpath in "$@"; do
    if [ ! -f ${inpath} ] ; then
        echo 'File not found: ' ${inpath}
    else    
        echo ${inpath}
        type=`echo ${inpath} | cut -d '/' -f 10`
        outpath=`echo ${inpath} | sed s:UQ-DES:UQ-DEC:g`
        outdir=`dirname ${outpath}`
        mkdir -p ${outdir}
        cp ${inpath} ${outpath}
        if [[ "${type}" == "bias-adjusted-input" ]] ; then
          ncatted -O -h -a contact,global,d,, ${outpath}
          ncatted -O -h -a institution_id,global,o,c,"UQ-DEC" ${outpath}
          ncatted -O -h -a institution,global,o,c,"University of Queensland and Department of Energy and Climate" ${outpath}
        elif [[ "${type}" == "bias-adjusted-output" ]] ; then
          ncatted -O -h -a input_institution_id,global,o,c,"UQ-DEC" ${outpath}
          ncatted -O -h -a input_institution,global,o,c,"University of Queensland and Department of Energy and Climate" ${outpath}
        fi
        ncatted -O -h -a acknowledgement,global,o,c,"The Queensland Future Climate Projections 2 dataset (QldFCP-2) was produced by the Queensland Future Climate Science Program, which aims to support climate adaptation and natural disasters preparedness and was funded by the Queensland Government, Australia (dataset DOI: https://doi.org/10.25914/8fve-1910). Citation: Chapman S, Syktus J, Trancoso R, Thatcher M, Toombs N, Wong K K-H, Takbash A, 2023. Earths Future. Evaluation of dynamically downscaled CMIP6-CCAM models over Australia." ${outpath}
        echo ${outpath}
    fi
done
