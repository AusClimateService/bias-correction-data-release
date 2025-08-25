#
# Bash script for updating to CORDEX metadata
#
# Usage: bash update_cordex_metadata.sh {files to update}
#

module load nco

for inpath in "$@"; do
    if [ ! -f ${inpath} ] ; then
        echo 'File not found: ' ${inpath}
    else    
        echo ${inpath}
        ncatted -O -h -a project_id,global,o,c,"output-CMIP6" ${inpath}
	#ncatted -O -h -a activity_id,global,o,c,"bias-adjusted-output" ${inpath}
	ncatted -O -h -a activity_id,global,o,c,"DD" ${inpath}
    fi
done
