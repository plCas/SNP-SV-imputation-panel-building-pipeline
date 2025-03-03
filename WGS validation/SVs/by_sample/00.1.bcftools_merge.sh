#!/bin/bash

CHR=$1

DIR=/../WGS_validation/SNV_Indel/vcfs/imputation/ADSP-All-Var
OUT=/../WGS_validation/SV_validation/by_sample/vcfs/ADSP-SV_only
mkdir -p $OUT

VCFs=$(find $DIR -type f -name "chr$CHR.vcf.gz")

bcftools merge --missing-to-ref $VCFs \
        | bcftools view  --exclude-types snps,indels -Oz -o $OUT/chr$CHR.vcf.gz

bcftools index -t $OUT/chr$CHR.vcf.gz
