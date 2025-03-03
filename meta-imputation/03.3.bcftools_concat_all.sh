#!/bin/bash

CHR=$1
DIR=/../IMMerge/TMP_chr$CHR
OUT=/../IMMerge
mkdir -p $OUT

VCFS=$(ls -v $DIR/chr$CHR.ADGC.dose.*|grep vcf.gz$)
bcftools concat --threads 2 --allow-overlaps --remove-duplicates $VCFS -Oz -o $OUT/chr$CHR.vcf.gz
bcftools index --threads 2 -t $OUT/chr$CHR.vcf.gz
bcftools stats --threads 2 $OUT/chr$CHR.vcf.gz > $OUT/chr$CHR.vcf.stats

