#!/bin/bash

CHR=$1

DIR=/qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo

mkdir -p $DIR/m3vcf

VCF=$DIR/vcfs/ligated/chr$CHR.phased.vcf.gz

# Make m3vcf
/s3buckets/wanpinglee-lab-psom-s3-bucket-01/wanpingleelab/chengp/tools/Minimac3Executable/bin/Minimac3 \
  --cpus 10 --lowMemory \
  --myChromosome chr$CHR --refHaps $VCF --processReference --prefix $DIR/m3vcf/chr$CHR.snp_sv
