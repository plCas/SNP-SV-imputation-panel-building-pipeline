#!/bin/bash

CHR=$1

DIR=/qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo
SNP=/s3buckets/wanpinglee-lab-psom-s3-bucket-01/wanpingleelab/chengp/imputation/qc_panel/vcfs/concat/chr$CHR.merge.vcf.gz
SV=/s3buckets/wanpinglee-lab-psom-s3-bucket-01/wanpingleelab/chengp/datasets/ADSP17K_HQ_SVs/$CHR.reheader.vcf.gz
TMP_DIR=$DIR/vcfs/HQ_SV/chr${CHR}_snp_v_vcfs_tmp
mkdir -p $TMP_DIR

mkdir -p $DIR/vcfs/SNP_SV

OUT=$DIR/vcfs/SNP_SV/chr$CHR.snp_sv.vcf.gz

START_TIME=$(date)

# Extract sample list of each file
bcftools query -l $SNP > $TMP_DIR/chr$CHR.merge.snp.sample.list
bcftools query -l $SV > $TMP_DIR/chr$CHR.sv.sample.list

# make consensus sample list : Rscript make_consensus_samples.R [file1] [file2] [out_file]
/opt/R/4.2.1/bin/Rscript /qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo/scripts/make_consensus_samples.R $TMP_DIR/chr$CHR.merge.snp.sample.list $TMP_DIR/chr$CHR.sv.sample.list $TMP_DIR/chr${CHR}_consensus_samples.txt

# Output consensus sample vcfs
bcftools view -S $TMP_DIR/chr${CHR}_consensus_samples.txt $SNP -Oz -o $TMP_DIR/chr$CHR.snp.consensus.vcf.gz
bcftools view -S $TMP_DIR/chr${CHR}_consensus_samples.txt $SV -Oz -o $TMP_DIR/chr$CHR.sv.consensus.vcf.gz

# Concat 2 samples
echo combining snp and sv vcfs
bcftools concat --threads 2 $TMP_DIR/chr$CHR.snp.consensus.vcf.gz $TMP_DIR/chr$CHR.sv.consensus.vcf.gz \
  | bcftools sort --temp-dir $TMP_DIR -Oz -o $OUT

rm -rf $TMP_DIR

bcftools index --threads 2 -t $OUT
bcftools stats --threads 2 $OUT > ${OUT%%.gz}.stats

END_TIME=$(date)

echo "Start from ${START_TIME}"
echo "End at ${END_TIME}"

