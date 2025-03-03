#!/bin/bash
# integrate high quality SVs into filtered SNVs/indels VCF

CHR=$1

OUT=/../panel_build_ADSP-All-Var/vcfs/concat
mkdir -p $OUT

VCF_SNV=/../panel_build/vcfs/filtered_bi/chr$CHR.bi.vcf.gz
VCF_SV=/../panel_build_ADSP-All-Var/vcfs/filter_AC_SVSIZE_MR/chr$CHR.sv.vcf.gz

TMP_DIR=$OUT/chr${CHR}_snp_sv_vcfs_tmp

bcftools concat --threads 2 $VCF_SNV $VCF_SV \
  | bcftools sort --temp-dir $TMP_DIR -Oz -o $OUT/chr$CHR.vcf.gz
rm -rf $TMP_DIR

bcftools index --threads 2 -t $OUT/chr$CHR.vcf.gz
bcftools stats --threads 2 $OUT/chr$CHR.vcf.gz > $OUT/chr$CHR.vcf.stats
