#!/bin/bash

# Split the chromosome into 1Mb segments and retain a 1Kb overlap for later merging.

CHR=$1
REGION=$2

THREADS=12

DIR=/../panel_build_ADSP-All-Var
VCF=$DIR/vcfs/concat/chr$CHR.vcf.gz
MAP=/../genetic_maps.b38/chr$CHR.b38.gmap.gz

OUT_DIR=$DIR/vcfs/phased/chr$CHR
mkdir -p $OUT_DIR


/../shapeit4-4.2.2/bin/shapeit4.2 --input $VCF \
        --map $MAP \
        --region $REGION \
        --output $OUT_DIR/$REGION.phased.vcf.gz \
        --thread $THREADS \
        --ibd2-output $OUT_DIR/$REGION.IBD2blacklist.txt.gz \
        --sequencing \
        --seed 54321 \
        --log $OUT_DIR/$REGION.phased.log

bcftools index -t --threads $THREADS $OUT_DIR/$REGION.phased.vcf.gz

