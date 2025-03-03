#!/bin/bash

ETH=$1 # ADGC_NHW, ADGC_AA, ADGC_Asian, ADGC_Hispanic

CHR=$2

VCF=/../$ETH/chr$CHR.vcf.gz

SAMPLES=/../WGS_validation/SNV_Indel/files/${ETH}_sample_list.txt
OUT=/../WGS_validation/SNV_Indel/vcfs/wgs/$ETH
mkdir -p $OUT

bcftools view --threads 2 -S $SAMPLES --force-samples $VCF -Oz -o $OUT/chr$CHR.vcf.gz

bcftools index -t $OUT/chr$CHR.vcf.gz
