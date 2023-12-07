#!/bin/bash
#
#SBATCH --job-name=imputation
#SBATCH -o /qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo/scripts/tmp/imputation.%A_%a.txt
#SBATCH -e /qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo/scripts/tmp/imputation.error.%A_%a.txt
#SBATCH --ntasks=1
#SBATCH --partition=wleeq
#SBATCH --qos=high
#SBATCH --cpus-per-task 8
#SBATCH --mem-per-cpu=4G
#
#set -euxo pipefail


CHR=$1
TEST_VCF=$2
#AC=5

#ETH=NHW
THREADS=10

#readarray SAMPLES < /qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo/files/chr$CHR.list

PANEL=/qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo/m3vcf/chr$CHR.snp_sv.m3vcf.gz
#TEST_VCF=/s3buckets/wanpinglee-lab-psom-s3-bucket-01/wanpingleelab/chengp/datasets/ADGC/ADGC_Asian/ASA-JPN/ASA_JPN_auto_sex-chr$CHR.phased.vcf.gz

ETH=$(dirname $TEST_VCF |xargs dirname| xargs basename)
COHORT=$(dirname $TEST_VCF | xargs basename)
OUT=/qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo/impute_results

mkdir -p $OUT/$ETH/$COHORT

PREFIX=$OUT/$ETH/$COHORT/chr$CHR.snp_sv

# Run imputation
/s3buckets/wanpinglee-lab-psom-s3-bucket-01/wanpingleelab/chengp/tools/Minimac4-1.0.2/minimac4-1.0.2-Linux/bin/minimac4 \
  --refHaps $PANEL \
  --haps $TEST_VCF \
  --cpus $THREADS \
  --prefix $PREFIX \
  --ignoreDuplicates \
  --meta \
  --ChunkLengthMb 100
