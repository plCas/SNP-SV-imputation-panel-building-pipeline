#!/bin/bash

# Phasing

CHR=$1 # chromosome 2 

readarray REGIONS < /qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo/test_region_overlap/chr$CHR.chunk.txt

SHAPEIT=/qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo/scripts/03.shapeit4.sh

for REGION in ${REGIONS[*]};do 
	echo $REGION
	sbatch $SHAPEIT $CHR $REGION
done
