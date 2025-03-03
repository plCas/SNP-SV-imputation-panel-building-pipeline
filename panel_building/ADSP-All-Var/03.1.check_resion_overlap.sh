#!/bin/bash
# Generate position-only files for dissecting phasing regions.

CHR=$1
DIR=/../panel_build_ADSP-All-Var
OUT=$DIR/test_region_overlap
mkdir -p $OUT
VCF=$DIR/vcfs/concat/chr$CHR.vcf.gz

bcftools query -f "%POS\n" $VCF  > $OUT/chr$CHR.pos.txt
