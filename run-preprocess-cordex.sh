
exp=$1

qsub -v gcm=ACCESS-CM2,rcm=BARPA-R,run=r4i1p1f1,exp=${exp},var=tasmax preprocess-cordex-job.sh
qsub -v gcm=ACCESS-CM2,rcm=BARPA-R,run=r4i1p1f1,exp=${exp},var=tasmin preprocess-cordex-job.sh
qsub -v gcm=ACCESS-CM2,rcm=BARPA-R,run=r4i1p1f1,exp=${exp},var=pr preprocess-cordex-job.sh
qsub -v gcm=ACCESS-CM2,rcm=BARPA-R,run=r4i1p1f1,exp=${exp},var=rsds preprocess-cordex-job.sh
qsub -v gcm=ACCESS-CM2,rcm=BARPA-R,run=r4i1p1f1,exp=${exp},var=sfcWindmax preprocess-cordex-job.sh
qsub -v gcm=ACCESS-CM2,rcm=BARPA-R,run=r4i1p1f1,exp=${exp},var=hursmax preprocess-cordex-job.sh
qsub -v gcm=ACCESS-CM2,rcm=BARPA-R,run=r4i1p1f1,exp=${exp},var=hursmin preprocess-cordex-job.sh

qsub -v gcm=ACCESS-CM2,rcm=CCAM-v2203-SN,run=r4i1p1f1,exp=${exp},var=tasmax preprocess-cordex-job.sh
qsub -v gcm=ACCESS-CM2,rcm=CCAM-v2203-SN,run=r4i1p1f1,exp=${exp},var=tasmin preprocess-cordex-job.sh
qsub -v gcm=ACCESS-CM2,rcm=CCAM-v2203-SN,run=r4i1p1f1,exp=${exp},var=pr preprocess-cordex-job.sh
qsub -v gcm=ACCESS-CM2,rcm=CCAM-v2203-SN,run=r4i1p1f1,exp=${exp},var=rsds preprocess-cordex-job.sh
qsub -v gcm=ACCESS-CM2,rcm=CCAM-v2203-SN,run=r4i1p1f1,exp=${exp},var=sfcWindmax preprocess-cordex-job.sh
qsub -v gcm=ACCESS-CM2,rcm=CCAM-v2203-SN,run=r4i1p1f1,exp=${exp},var=hursmax preprocess-cordex-job.sh
qsub -v gcm=ACCESS-CM2,rcm=CCAM-v2203-SN,run=r4i1p1f1,exp=${exp},var=hursmin preprocess-cordex-job.sh

qsub -v gcm=ACCESS-CM2,rcm=CCAMoc-v2112,run=r2i1p1f1,exp=${exp},var=tasmax preprocess-cordex-job.sh
qsub -v gcm=ACCESS-CM2,rcm=CCAMoc-v2112,run=r2i1p1f1,exp=${exp},var=tasmin preprocess-cordex-job.sh
qsub -v gcm=ACCESS-CM2,rcm=CCAMoc-v2112,run=r2i1p1f1,exp=${exp},var=pr preprocess-cordex-job.sh
qsub -v gcm=ACCESS-CM2,rcm=CCAMoc-v2112,run=r2i1p1f1,exp=${exp},var=rsds preprocess-cordex-job.sh
qsub -v gcm=ACCESS-CM2,rcm=CCAMoc-v2112,run=r2i1p1f1,exp=${exp},var=hursmax preprocess-cordex-job.sh
qsub -v gcm=ACCESS-CM2,rcm=CCAMoc-v2112,run=r2i1p1f1,exp=${exp},var=hursmin preprocess-cordex-job.sh

qsub -v gcm=ACCESS-ESM1-5,rcm=BARPA-R,run=r6i1p1f1,exp=${exp},var=tasmax preprocess-cordex-job.sh
qsub -v gcm=ACCESS-ESM1-5,rcm=BARPA-R,run=r6i1p1f1,exp=${exp},var=tasmin preprocess-cordex-job.sh
qsub -v gcm=ACCESS-ESM1-5,rcm=BARPA-R,run=r6i1p1f1,exp=${exp},var=pr preprocess-cordex-job.sh
qsub -v gcm=ACCESS-ESM1-5,rcm=BARPA-R,run=r6i1p1f1,exp=${exp},var=rsds preprocess-cordex-job.sh
qsub -v gcm=ACCESS-ESM1-5,rcm=BARPA-R,run=r6i1p1f1,exp=${exp},var=sfcWindmax preprocess-cordex-job.sh
qsub -v gcm=ACCESS-ESM1-5,rcm=BARPA-R,run=r6i1p1f1,exp=${exp},var=hursmax preprocess-cordex-job.sh
qsub -v gcm=ACCESS-ESM1-5,rcm=BARPA-R,run=r6i1p1f1,exp=${exp},var=hursmin preprocess-cordex-job.sh

qsub -v gcm=ACCESS-ESM1-5,rcm=CCAM-v2203-SN,run=r6i1p1f1,exp=${exp},var=tasmax preprocess-cordex-job.sh
qsub -v gcm=ACCESS-ESM1-5,rcm=CCAM-v2203-SN,run=r6i1p1f1,exp=${exp},var=tasmin preprocess-cordex-job.sh
qsub -v gcm=ACCESS-ESM1-5,rcm=CCAM-v2203-SN,run=r6i1p1f1,exp=${exp},var=pr preprocess-cordex-job.sh
qsub -v gcm=ACCESS-ESM1-5,rcm=CCAM-v2203-SN,run=r6i1p1f1,exp=${exp},var=rsds preprocess-cordex-job.sh
qsub -v gcm=ACCESS-ESM1-5,rcm=CCAM-v2203-SN,run=r6i1p1f1,exp=${exp},var=sfcWindmax preprocess-cordex-job.sh
qsub -v gcm=ACCESS-ESM1-5,rcm=CCAM-v2203-SN,run=r6i1p1f1,exp=${exp},var=hursmax preprocess-cordex-job.sh
qsub -v gcm=ACCESS-ESM1-5,rcm=CCAM-v2203-SN,run=r6i1p1f1,exp=${exp},var=hursmin preprocess-cordex-job.sh

qsub -v gcm=ACCESS-ESM1-5,rcm=CCAMoc-v2112,run=r20i1p1f1,exp=${exp},var=tasmax preprocess-cordex-job.sh
qsub -v gcm=ACCESS-ESM1-5,rcm=CCAMoc-v2112,run=r20i1p1f1,exp=${exp},var=tasmin preprocess-cordex-job.sh
qsub -v gcm=ACCESS-ESM1-5,rcm=CCAMoc-v2112,run=r20i1p1f1,exp=${exp},var=pr preprocess-cordex-job.sh
qsub -v gcm=ACCESS-ESM1-5,rcm=CCAMoc-v2112,run=r20i1p1f1,exp=${exp},var=rsds preprocess-cordex-job.sh
qsub -v gcm=ACCESS-ESM1-5,rcm=CCAMoc-v2112,run=r20i1p1f1,exp=${exp},var=hursmax preprocess-cordex-job.sh
qsub -v gcm=ACCESS-ESM1-5,rcm=CCAMoc-v2112,run=r20i1p1f1,exp=${exp},var=hursmin preprocess-cordex-job.sh

qsub -v gcm=ACCESS-ESM1-5,rcm=CCAMoc-v2112,run=r40i1p1f1,exp=${exp},var=tasmax preprocess-cordex-job.sh
qsub -v gcm=ACCESS-ESM1-5,rcm=CCAMoc-v2112,run=r40i1p1f1,exp=${exp},var=tasmin preprocess-cordex-job.sh
qsub -v gcm=ACCESS-ESM1-5,rcm=CCAMoc-v2112,run=r40i1p1f1,exp=${exp},var=pr preprocess-cordex-job.sh
qsub -v gcm=ACCESS-ESM1-5,rcm=CCAMoc-v2112,run=r40i1p1f1,exp=${exp},var=rsds preprocess-cordex-job.sh
qsub -v gcm=ACCESS-ESM1-5,rcm=CCAMoc-v2112,run=r40i1p1f1,exp=${exp},var=sfcWindmax preprocess-cordex-job.sh
qsub -v gcm=ACCESS-ESM1-5,rcm=CCAMoc-v2112,run=r40i1p1f1,exp=${exp},var=hursmax preprocess-cordex-job.sh
qsub -v gcm=ACCESS-ESM1-5,rcm=CCAMoc-v2112,run=r40i1p1f1,exp=${exp},var=hursmin preprocess-cordex-job.sh

qsub -v gcm=ACCESS-ESM1-5,rcm=CCAM-v2105,run=r6i1p1f1,exp=${exp},var=tasmax preprocess-cordex-job.sh
qsub -v gcm=ACCESS-ESM1-5,rcm=CCAM-v2105,run=r6i1p1f1,exp=${exp},var=tasmin preprocess-cordex-job.sh
qsub -v gcm=ACCESS-ESM1-5,rcm=CCAM-v2105,run=r6i1p1f1,exp=${exp},var=pr preprocess-cordex-job.sh
qsub -v gcm=ACCESS-ESM1-5,rcm=CCAM-v2105,run=r6i1p1f1,exp=${exp},var=rsds preprocess-cordex-job.sh
qsub -v gcm=ACCESS-ESM1-5,rcm=CCAM-v2105,run=r6i1p1f1,exp=${exp},var=hursmax preprocess-cordex-job.sh
qsub -v gcm=ACCESS-ESM1-5,rcm=CCAM-v2105,run=r6i1p1f1,exp=${exp},var=hursmin preprocess-cordex-job.sh

qsub -v gcm=CESM2,rcm=BARPA-R,run=r11i1p1f1,exp=${exp},var=tasmax preprocess-cordex-job.sh
qsub -v gcm=CESM2,rcm=BARPA-R,run=r11i1p1f1,exp=${exp},var=tasmin preprocess-cordex-job.sh
qsub -v gcm=CESM2,rcm=BARPA-R,run=r11i1p1f1,exp=${exp},var=pr preprocess-cordex-job.sh
qsub -v gcm=CESM2,rcm=BARPA-R,run=r11i1p1f1,exp=${exp},var=rsds preprocess-cordex-job.sh
qsub -v gcm=CESM2,rcm=BARPA-R,run=r11i1p1f1,exp=${exp},var=sfcWindmax preprocess-cordex-job.sh
qsub -v gcm=CESM2,rcm=BARPA-R,run=r11i1p1f1,exp=${exp},var=hursmax preprocess-cordex-job.sh
qsub -v gcm=CESM2,rcm=BARPA-R,run=r11i1p1f1,exp=${exp},var=hursmin preprocess-cordex-job.sh

qsub -v gcm=CESM2,rcm=CCAM-v2203-SN,run=r11i1p1f1,exp=${exp},var=tasmax preprocess-cordex-job.sh
qsub -v gcm=CESM2,rcm=CCAM-v2203-SN,run=r11i1p1f1,exp=${exp},var=tasmin preprocess-cordex-job.sh
qsub -v gcm=CESM2,rcm=CCAM-v2203-SN,run=r11i1p1f1,exp=${exp},var=pr preprocess-cordex-job.sh
qsub -v gcm=CESM2,rcm=CCAM-v2203-SN,run=r11i1p1f1,exp=${exp},var=rsds preprocess-cordex-job.sh
qsub -v gcm=CESM2,rcm=CCAM-v2203-SN,run=r11i1p1f1,exp=${exp},var=sfcWindmax preprocess-cordex-job.sh
qsub -v gcm=CESM2,rcm=CCAM-v2203-SN,run=r11i1p1f1,exp=${exp},var=hursmax preprocess-cordex-job.sh
qsub -v gcm=CESM2,rcm=CCAM-v2203-SN,run=r11i1p1f1,exp=${exp},var=hursmin preprocess-cordex-job.sh

qsub -v gcm=CMCC-ESM2,rcm=BARPA-R,run=r1i1p1f1,exp=${exp},var=tasmax preprocess-cordex-job.sh
qsub -v gcm=CMCC-ESM2,rcm=BARPA-R,run=r1i1p1f1,exp=${exp},var=tasmin preprocess-cordex-job.sh
qsub -v gcm=CMCC-ESM2,rcm=BARPA-R,run=r1i1p1f1,exp=${exp},var=pr preprocess-cordex-job.sh
qsub -v gcm=CMCC-ESM2,rcm=BARPA-R,run=r1i1p1f1,exp=${exp},var=rsds preprocess-cordex-job.sh
qsub -v gcm=CMCC-ESM2,rcm=BARPA-R,run=r1i1p1f1,exp=${exp},var=sfcWindmax preprocess-cordex-job.sh
qsub -v gcm=CMCC-ESM2,rcm=BARPA-R,run=r1i1p1f1,exp=${exp},var=hursmax preprocess-cordex-job.sh
qsub -v gcm=CMCC-ESM2,rcm=BARPA-R,run=r1i1p1f1,exp=${exp},var=hursmin preprocess-cordex-job.sh

qsub -v gcm=CMCC-ESM2,rcm=CCAM-v2203-SN,run=r1i1p1f1,exp=${exp},var=tasmax preprocess-cordex-job.sh
qsub -v gcm=CMCC-ESM2,rcm=CCAM-v2203-SN,run=r1i1p1f1,exp=${exp},var=tasmin preprocess-cordex-job.sh
qsub -v gcm=CMCC-ESM2,rcm=CCAM-v2203-SN,run=r1i1p1f1,exp=${exp},var=pr preprocess-cordex-job.sh
qsub -v gcm=CMCC-ESM2,rcm=CCAM-v2203-SN,run=r1i1p1f1,exp=${exp},var=rsds preprocess-cordex-job.sh
qsub -v gcm=CMCC-ESM2,rcm=CCAM-v2203-SN,run=r1i1p1f1,exp=${exp},var=sfcWindmax preprocess-cordex-job.sh
qsub -v gcm=CMCC-ESM2,rcm=CCAM-v2203-SN,run=r1i1p1f1,exp=${exp},var=hursmax preprocess-cordex-job.sh
qsub -v gcm=CMCC-ESM2,rcm=CCAM-v2203-SN,run=r1i1p1f1,exp=${exp},var=hursmin preprocess-cordex-job.sh

qsub -v gcm=CMCC-ESM2,rcm=CCAM-v2105,run=r1i1p1f1,exp=${exp},var=tasmax preprocess-cordex-job.sh
qsub -v gcm=CMCC-ESM2,rcm=CCAM-v2105,run=r1i1p1f1,exp=${exp},var=tasmin preprocess-cordex-job.sh
qsub -v gcm=CMCC-ESM2,rcm=CCAM-v2105,run=r1i1p1f1,exp=${exp},var=pr preprocess-cordex-job.sh
qsub -v gcm=CMCC-ESM2,rcm=CCAM-v2105,run=r1i1p1f1,exp=${exp},var=rsds preprocess-cordex-job.sh
qsub -v gcm=CMCC-ESM2,rcm=CCAM-v2105,run=r1i1p1f1,exp=${exp},var=hursmax preprocess-cordex-job.sh
qsub -v gcm=CMCC-ESM2,rcm=CCAM-v2105,run=r1i1p1f1,exp=${exp},var=hursmin preprocess-cordex-job.sh

qsub -v gcm=CNRM-CM6-1-HR,rcm=CCAMoc-v2112,run=r1i1p1f2,exp=${exp},var=tasmax preprocess-cordex-job.sh
qsub -v gcm=CNRM-CM6-1-HR,rcm=CCAMoc-v2112,run=r1i1p1f2,exp=${exp},var=tasmin preprocess-cordex-job.sh
qsub -v gcm=CNRM-CM6-1-HR,rcm=CCAMoc-v2112,run=r1i1p1f2,exp=${exp},var=pr preprocess-cordex-job.sh
qsub -v gcm=CNRM-CM6-1-HR,rcm=CCAMoc-v2112,run=r1i1p1f2,exp=${exp},var=rsds preprocess-cordex-job.sh
qsub -v gcm=CNRM-CM6-1-HR,rcm=CCAMoc-v2112,run=r1i1p1f2,exp=${exp},var=hursmax preprocess-cordex-job.sh
qsub -v gcm=CNRM-CM6-1-HR,rcm=CCAMoc-v2112,run=r1i1p1f2,exp=${exp},var=hursmin preprocess-cordex-job.sh

qsub -v gcm=CNRM-CM6-1-HR,rcm=CCAM-v2112,run=r1i1p1f2,exp=${exp},var=tasmax preprocess-cordex-job.sh
qsub -v gcm=CNRM-CM6-1-HR,rcm=CCAM-v2112,run=r1i1p1f2,exp=${exp},var=tasmin preprocess-cordex-job.sh
qsub -v gcm=CNRM-CM6-1-HR,rcm=CCAM-v2112,run=r1i1p1f2,exp=${exp},var=pr preprocess-cordex-job.sh
qsub -v gcm=CNRM-CM6-1-HR,rcm=CCAM-v2112,run=r1i1p1f2,exp=${exp},var=rsds preprocess-cordex-job.sh
qsub -v gcm=CNRM-CM6-1-HR,rcm=CCAM-v2112,run=r1i1p1f2,exp=${exp},var=hursmax preprocess-cordex-job.sh
qsub -v gcm=CNRM-CM6-1-HR,rcm=CCAM-v2112,run=r1i1p1f2,exp=${exp},var=hursmin preprocess-cordex-job.sh

qsub -v gcm=CNRM-ESM2-1,rcm=CCAM-v2203-SN,run=r1i1p1f2,exp=${exp},var=tasmax preprocess-cordex-job.sh
qsub -v gcm=CNRM-ESM2-1,rcm=CCAM-v2203-SN,run=r1i1p1f2,exp=${exp},var=tasmin preprocess-cordex-job.sh
qsub -v gcm=CNRM-ESM2-1,rcm=CCAM-v2203-SN,run=r1i1p1f2,exp=${exp},var=pr preprocess-cordex-job.sh
qsub -v gcm=CNRM-ESM2-1,rcm=CCAM-v2203-SN,run=r1i1p1f2,exp=${exp},var=rsds preprocess-cordex-job.sh
qsub -v gcm=CNRM-ESM2-1,rcm=CCAM-v2203-SN,run=r1i1p1f2,exp=${exp},var=sfcWindmax preprocess-cordex-job.sh
qsub -v gcm=CNRM-ESM2-1,rcm=CCAM-v2203-SN,run=r1i1p1f2,exp=${exp},var=hursmax preprocess-cordex-job.sh
qsub -v gcm=CNRM-ESM2-1,rcm=CCAM-v2203-SN,run=r1i1p1f2,exp=${exp},var=hursmin preprocess-cordex-job.sh

qsub -v gcm=EC-Earth3,rcm=BARPA-R,run=r1i1p1f1,exp=${exp},var=tasmax preprocess-cordex-job.sh
qsub -v gcm=EC-Earth3,rcm=BARPA-R,run=r1i1p1f1,exp=${exp},var=tasmin preprocess-cordex-job.sh
qsub -v gcm=EC-Earth3,rcm=BARPA-R,run=r1i1p1f1,exp=${exp},var=pr preprocess-cordex-job.sh
qsub -v gcm=EC-Earth3,rcm=BARPA-R,run=r1i1p1f1,exp=${exp},var=rsds preprocess-cordex-job.sh
qsub -v gcm=EC-Earth3,rcm=BARPA-R,run=r1i1p1f1,exp=${exp},var=sfcWindmax preprocess-cordex-job.sh
qsub -v gcm=EC-Earth3,rcm=BARPA-R,run=r1i1p1f1,exp=${exp},var=hursmax preprocess-cordex-job.sh
qsub -v gcm=EC-Earth3,rcm=BARPA-R,run=r1i1p1f1,exp=${exp},var=hursmin preprocess-cordex-job.sh

qsub -v gcm=EC-Earth3,rcm=CCAM-v2203-SN,run=r1i1p1f1,exp=${exp},var=tasmax preprocess-cordex-job.sh
qsub -v gcm=EC-Earth3,rcm=CCAM-v2203-SN,run=r1i1p1f1,exp=${exp},var=tasmin preprocess-cordex-job.sh
qsub -v gcm=EC-Earth3,rcm=CCAM-v2203-SN,run=r1i1p1f1,exp=${exp},var=pr preprocess-cordex-job.sh
qsub -v gcm=EC-Earth3,rcm=CCAM-v2203-SN,run=r1i1p1f1,exp=${exp},var=rsds preprocess-cordex-job.sh
qsub -v gcm=EC-Earth3,rcm=CCAM-v2203-SN,run=r1i1p1f1,exp=${exp},var=sfcWindmax preprocess-cordex-job.sh
qsub -v gcm=EC-Earth3,rcm=CCAM-v2203-SN,run=r1i1p1f1,exp=${exp},var=hursmax preprocess-cordex-job.sh
qsub -v gcm=EC-Earth3,rcm=CCAM-v2203-SN,run=r1i1p1f1,exp=${exp},var=hursmin preprocess-cordex-job.sh

qsub -v gcm=EC-Earth3,rcm=CCAM-v2105,run=r1i1p1f1,exp=${exp},var=tasmax preprocess-cordex-job.sh
qsub -v gcm=EC-Earth3,rcm=CCAM-v2105,run=r1i1p1f1,exp=${exp},var=tasmin preprocess-cordex-job.sh
qsub -v gcm=EC-Earth3,rcm=CCAM-v2105,run=r1i1p1f1,exp=${exp},var=pr preprocess-cordex-job.sh
qsub -v gcm=EC-Earth3,rcm=CCAM-v2105,run=r1i1p1f1,exp=${exp},var=rsds preprocess-cordex-job.sh
qsub -v gcm=EC-Earth3,rcm=CCAM-v2105,run=r1i1p1f1,exp=${exp},var=hursmax preprocess-cordex-job.sh
qsub -v gcm=EC-Earth3,rcm=CCAM-v2105,run=r1i1p1f1,exp=${exp},var=hursmin preprocess-cordex-job.sh

qsub -v gcm=FGOALS-g3,rcm=CCAM-v2105,run=r4i1p1f1,exp=${exp},var=tasmax preprocess-cordex-job.sh
qsub -v gcm=FGOALS-g3,rcm=CCAM-v2105,run=r4i1p1f1,exp=${exp},var=tasmin preprocess-cordex-job.sh
qsub -v gcm=FGOALS-g3,rcm=CCAM-v2105,run=r4i1p1f1,exp=${exp},var=pr preprocess-cordex-job.sh
qsub -v gcm=FGOALS-g3,rcm=CCAM-v2105,run=r4i1p1f1,exp=${exp},var=rsds preprocess-cordex-job.sh
qsub -v gcm=FGOALS-g3,rcm=CCAM-v2105,run=r4i1p1f1,exp=${exp},var=hursmax preprocess-cordex-job.sh
qsub -v gcm=FGOALS-g3,rcm=CCAM-v2105,run=r4i1p1f1,exp=${exp},var=hursmin preprocess-cordex-job.sh

qsub -v gcm=GFDL-ESM4,rcm=CCAM-v2105,run=r1i1p1f1,exp=${exp},var=tasmax preprocess-cordex-job.sh
qsub -v gcm=GFDL-ESM4,rcm=CCAM-v2105,run=r1i1p1f1,exp=${exp},var=tasmin preprocess-cordex-job.sh
qsub -v gcm=GFDL-ESM4,rcm=CCAM-v2105,run=r1i1p1f1,exp=${exp},var=pr preprocess-cordex-job.sh
qsub -v gcm=GFDL-ESM4,rcm=CCAM-v2105,run=r1i1p1f1,exp=${exp},var=rsds preprocess-cordex-job.sh
qsub -v gcm=GFDL-ESM4,rcm=CCAM-v2105,run=r1i1p1f1,exp=${exp},var=hursmax preprocess-cordex-job.sh
qsub -v gcm=GFDL-ESM4,rcm=CCAM-v2105,run=r1i1p1f1,exp=${exp},var=hursmin preprocess-cordex-job.sh

qsub -v gcm=GISS-E2-1-G,rcm=CCAM-v2105,run=r2i1p1f2,exp=${exp},var=tasmax preprocess-cordex-job.sh
qsub -v gcm=GISS-E2-1-G,rcm=CCAM-v2105,run=r2i1p1f2,exp=${exp},var=tasmin preprocess-cordex-job.sh
qsub -v gcm=GISS-E2-1-G,rcm=CCAM-v2105,run=r2i1p1f2,exp=${exp},var=pr preprocess-cordex-job.sh
qsub -v gcm=GISS-E2-1-G,rcm=CCAM-v2105,run=r2i1p1f2,exp=${exp},var=rsds preprocess-cordex-job.sh
qsub -v gcm=GISS-E2-1-G,rcm=CCAM-v2105,run=r2i1p1f2,exp=${exp},var=hursmax preprocess-cordex-job.sh
qsub -v gcm=GISS-E2-1-G,rcm=CCAM-v2105,run=r2i1p1f2,exp=${exp},var=hursmin preprocess-cordex-job.sh

qsub -v gcm=MPI-ESM1-2-HR,rcm=BARPA-R,run=r1i1p1f1,exp=${exp},var=tasmax preprocess-cordex-job.sh
qsub -v gcm=MPI-ESM1-2-HR,rcm=BARPA-R,run=r1i1p1f1,exp=${exp},var=tasmin preprocess-cordex-job.sh
qsub -v gcm=MPI-ESM1-2-HR,rcm=BARPA-R,run=r1i1p1f1,exp=${exp},var=pr preprocess-cordex-job.sh
qsub -v gcm=MPI-ESM1-2-HR,rcm=BARPA-R,run=r1i1p1f1,exp=${exp},var=rsds preprocess-cordex-job.sh
qsub -v gcm=MPI-ESM1-2-HR,rcm=BARPA-R,run=r1i1p1f1,exp=${exp},var=sfcWindmax preprocess-cordex-job.sh
qsub -v gcm=MPI-ESM1-2-HR,rcm=BARPA-R,run=r1i1p1f1,exp=${exp},var=hursmax preprocess-cordex-job.sh
qsub -v gcm=MPI-ESM1-2-HR,rcm=BARPA-R,run=r1i1p1f1,exp=${exp},var=hursmin preprocess-cordex-job.sh

qsub -v gcm=MPI-ESM1-2-LR,rcm=CCAM-v2105,run=r9i1p1f1,exp=${exp},var=tasmax preprocess-cordex-job.sh
qsub -v gcm=MPI-ESM1-2-LR,rcm=CCAM-v2105,run=r9i1p1f1,exp=${exp},var=tasmin preprocess-cordex-job.sh
qsub -v gcm=MPI-ESM1-2-LR,rcm=CCAM-v2105,run=r9i1p1f1,exp=${exp},var=pr preprocess-cordex-job.sh
qsub -v gcm=MPI-ESM1-2-LR,rcm=CCAM-v2105,run=r9i1p1f1,exp=${exp},var=rsds preprocess-cordex-job.sh
qsub -v gcm=MPI-ESM1-2-LR,rcm=CCAM-v2105,run=r9i1p1f1,exp=${exp},var=hursmax preprocess-cordex-job.sh
qsub -v gcm=MPI-ESM1-2-LR,rcm=CCAM-v2105,run=r9i1p1f1,exp=${exp},var=hursmin preprocess-cordex-job.sh

qsub -v gcm=MRI-ESM2-0,rcm=CCAM-v2105,run=r1i1p1f1,exp=${exp},var=tasmax preprocess-cordex-job.sh
qsub -v gcm=MRI-ESM2-0,rcm=CCAM-v2105,run=r1i1p1f1,exp=${exp},var=tasmin preprocess-cordex-job.sh
qsub -v gcm=MRI-ESM2-0,rcm=CCAM-v2105,run=r1i1p1f1,exp=${exp},var=pr preprocess-cordex-job.sh
qsub -v gcm=MRI-ESM2-0,rcm=CCAM-v2105,run=r1i1p1f1,exp=${exp},var=rsds preprocess-cordex-job.sh
qsub -v gcm=MRI-ESM2-0,rcm=CCAM-v2105,run=r1i1p1f1,exp=${exp},var=hursmax preprocess-cordex-job.sh
qsub -v gcm=MRI-ESM2-0,rcm=CCAM-v2105,run=r1i1p1f1,exp=${exp},var=hursmin preprocess-cordex-job.sh

qsub -v gcm=NorESM2-MM,rcm=BARPA-R,run=r1i1p1f1,exp=${exp},var=tasmax preprocess-cordex-job.sh
qsub -v gcm=NorESM2-MM,rcm=BARPA-R,run=r1i1p1f1,exp=${exp},var=tasmin preprocess-cordex-job.sh
qsub -v gcm=NorESM2-MM,rcm=BARPA-R,run=r1i1p1f1,exp=${exp},var=pr preprocess-cordex-job.sh
qsub -v gcm=NorESM2-MM,rcm=BARPA-R,run=r1i1p1f1,exp=${exp},var=rsds preprocess-cordex-job.sh
qsub -v gcm=NorESM2-MM,rcm=BARPA-R,run=r1i1p1f1,exp=${exp},var=sfcWindmax preprocess-cordex-job.sh
qsub -v gcm=NorESM2-MM,rcm=BARPA-R,run=r1i1p1f1,exp=${exp},var=hursmax preprocess-cordex-job.sh
qsub -v gcm=NorESM2-MM,rcm=BARPA-R,run=r1i1p1f1,exp=${exp},var=hursmin preprocess-cordex-job.sh

qsub -v gcm=NorESM2-MM,rcm=CCAMoc-v2112,run=r1i1p1f1,exp=${exp},var=tasmax preprocess-cordex-job.sh
qsub -v gcm=NorESM2-MM,rcm=CCAMoc-v2112,run=r1i1p1f1,exp=${exp},var=tasmin preprocess-cordex-job.sh
qsub -v gcm=NorESM2-MM,rcm=CCAMoc-v2112,run=r1i1p1f1,exp=${exp},var=pr preprocess-cordex-job.sh
qsub -v gcm=NorESM2-MM,rcm=CCAMoc-v2112,run=r1i1p1f1,exp=${exp},var=rsds preprocess-cordex-job.sh
qsub -v gcm=NorESM2-MM,rcm=CCAMoc-v2112,run=r1i1p1f1,exp=${exp},var=hursmax preprocess-cordex-job.sh
qsub -v gcm=NorESM2-MM,rcm=CCAMoc-v2112,run=r1i1p1f1,exp=${exp},var=hursmin preprocess-cordex-job.sh

qsub -v gcm=NorESM2-MM,rcm=CCAM-v2112,run=r1i1p1f1,exp=${exp},var=tasmax preprocess-cordex-job.sh
qsub -v gcm=NorESM2-MM,rcm=CCAM-v2112,run=r1i1p1f1,exp=${exp},var=tasmin preprocess-cordex-job.sh
qsub -v gcm=NorESM2-MM,rcm=CCAM-v2112,run=r1i1p1f1,exp=${exp},var=pr preprocess-cordex-job.sh
qsub -v gcm=NorESM2-MM,rcm=CCAM-v2112,run=r1i1p1f1,exp=${exp},var=rsds preprocess-cordex-job.sh
qsub -v gcm=NorESM2-MM,rcm=CCAM-v2112,run=r1i1p1f1,exp=${exp},var=hursmax preprocess-cordex-job.sh
qsub -v gcm=NorESM2-MM,rcm=CCAM-v2112,run=r1i1p1f1,exp=${exp},var=hursmin preprocess-cordex-job.sh

