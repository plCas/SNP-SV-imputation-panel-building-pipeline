#!/bin/bash

sample_name_wgs=$1

TMP=/../WGS_validation/SV_validation/by_sample/bed_files/wgs
mkdir -p $TMP

# make bed file of each sample for WGS samples manta
VCF=/../$sample_name_wgs.manta.diploidSV.vcf.gz
bcftools view -f 'PASS' -i 'SVTYPE != "BND"' $VCF \
	| bcftools query -f "%CHROM\t%POS\t%END\t%SVTYPE[\t%GT]\n" > $TMP/$sample_name_wgs.bed

