## WBGT progress

This document tracks progress towards bias correcting wet bulb globe temperature (WBGT) data for the Reserve Bank.

- :white_circle: not started
- :yellow_circle: in progress
- :green_circle: complete

| RCM | GCM | ssp126 | ssp370 |
| --- | --- | ---    | ---    |
| BARPA-R | ACCESS-CM2 | :green_circle: | :green_circle: |
| BARPA-R | ACCESS-ESM1-5 | :green_circle: | :green_circle: |
| BARPA-R | CESM2 | :green_circle: | :green_circle: |
| BARPA-R | CMCC-ESM2 | :green_circle: | :green_circle: |
| BARPA-R | EC-Earth3 | :green_circle: | :green_circle: |
| BARPA-R | MPI-ESM1-2-HR | :green_circle: | :green_circle: |
| BARPA-R | NorESM2-MM | :green_circle: | :green_circle: |
| CCAM-v2203-SN | ACCESS-CM2 | :green_circle: | :green_circle: |
| CCAM-v2203-SN | ACCESS-ESM1-5 | :green_circle: | :green_circle: |
| CCAM-v2203-SN | CESM2 | :green_circle: | :green_circle: |
| CCAM-v2203-SN | CMCC-ESM2 | :green_circle: | :green_circle: |
| CCAM-v2203-SN | CNRM-ESM2-1 | :green_circle: | :green_circle: |
| CCAM-v2203-SN | EC-Earth3 | :green_circle: | :green_circle: |
| CCAM-v2203-SN | NorESM2-MM | :green_circle: | :green_circle: |

The completed data can be found at:
```
/g/data/ia39/australian-climate-service/test-data/CORDEX/output-CMIP6/bias-adjusted-output/AUST-11i
```
The generated outputs (yearly files) are not compressed and not chunked (i.e., they are contiguous files) to enable timely and quick evaluation of the results, as compressed files take longer to read. After the evaluation process, the output files will/can be chunked and compressed in a post-processing step for sharing and publishing purposes.


## Codes
Two branches were created under the repository:
```
https://github.com/AusClimateService/QME/ 
•	https://github.com/AusClimateService/QME/tree/qme_dev_daily
•	https://github.com/AusClimateService/QME/tree/qme_dev_hourly
```
The `qme_dev_daily` branch is based on `qme_dev` (available on Mich Black’s NCI-GitLab page), which was used to bias-correct the ACS daily data. `qme_dev` was cloned from NCI-GitLab and some code lines were modified based on Andrew Gammon’s recommendations. So, `qme_dev_daily` is an updated version of `qme_dev`. `qme_dev_daily` was tested on a single CORDEX variable “prsn” by Alicia, which worked fine. No further daily variables were tested by Alicia using this code.

`qme_dev_hourly` was implemented for hourly bias-correction, adopted from `qme_dev_daily`. 

Both branches include a separate README file, which was complemented with information on how to run the code. 

The evaluation script and plots of the results for hourly bias-corrections can be found here:
```
https://github.com/AusClimateService/QME/tree/qme_dev_hourly/evaluation
```


