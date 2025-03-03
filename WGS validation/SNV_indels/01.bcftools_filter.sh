#!/bin/bash

CHR=$1
VCF=$2 # /../chr$CHR.ADGC.dose.vcf.gz

SAMPLES=/../WGS_validation/SNV_Indel/files/${ETH}_sample_list.txt
OUT=/../WGS_validation/SNV_Indel/vcfs/imputation/$PANEL/$ETH

mkdir -p $OUT

bcftools view --threads 2 -S $SAMPLES --force-samples $VCF -Oz -o $OUT/chr$CHR.vcf.gz
bcftools index -t $OUT/chr$CHR.vcf.gz
