#!/bin/bash

# Phasing

CHR=$1 # chromosome 2
DIR=/../panel_build/vcfs/phased/chr$CHR

#LENGTH=$2 # full length of chromosome 2 : 243000000 bp
readarray REGIONS < /../panel_build/test_region_overlap/chr$CHR.chunk.txt # generate from 02.2.make_region_metadata_1CHR.v2.py


SHAPEIT=/../03.shapeit4.sh

for REGION in ${REGIONS[*]};do
        if [ ! -f $DIR/$REGION.phased.vcf.gz ];then
                echo $REGION
                sbatch $SHAPEIT $CHR $REGION
        fi
done

