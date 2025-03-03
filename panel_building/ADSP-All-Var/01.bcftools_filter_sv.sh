#!/bin/bash
# filter SV files with allele count (AC), SV size, and missing rate

CHR=$1
SAMPLE_SIZE=15958

VCF=/../panel_build_ADSP-All-Var/vcfs/HQ_SV/$CHR.reheader.vcf.gz

OUT=/../panel_build_ADSP-All-Var/vcfs/filter_AC_SVSIZE_MR

mkdir -p $OUT

SAMPLES=/../panel_build/files/final_sample_list

bcftools view -S $SAMPLES $VCF \
	| bcftools view -i 'AC >= 5 && (SVSIZE >= 50 || SVSIZE == ".") & AN >= $SAMPLE_SIZE*2*0.9' -Oz -o $OUT/chr$CHR.sv.vcf.gz

bcftools index -t $OUT/chr$CHR.sv.vcf.gz
bcftools stats $OUT/chr$CHR.sv.vcf.gz > $OUT/chr$CHR.sv.vcf.stats

