#!/bin/bash

# Phasing

CHR=$1 # chromosome 2 
DIR=/qnap-wlee/wanpingleelab/chengp/36K_panel_build/vcfs/phased/chr$CHR

readarray REGIONS < /qnap-wlee/wanpingleelab/chengp/36K_panel_build/test_region_overlap/chr$CHR.chunk.txt


SHAPEIT=/qnap-wlee/wanpingleelab/chengp/36K_panel_build/scripts_panel_building/02.shapeit4.sh

for REGION in ${REGIONS[*]};do 
	if [ ! -f $DIR/$REGION.phased.vcf.gz ];then
		echo $REGION
		sbatch $SHAPEIT $CHR $REGION
	fi
done
