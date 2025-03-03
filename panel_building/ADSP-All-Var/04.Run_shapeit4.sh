#!/bin/bash

# Phasing

CHR=$1 # chromosome 2

readarray REGIONS < /../panel_build_ADSP-All-Var/test_region_overlap/chr$CHR.chunk.txt


SHAPEIT=/../panel_build_ADSP-All-Var/scripts/03.shapeit4.sh

for REGION in ${REGIONS[*]};do
        if [ ! -f $DIR/$REGION.phased.vcf.gz ];then
                echo $REGION
                sbatch $SHAPEIT $CHR $REGION
        fi
done

