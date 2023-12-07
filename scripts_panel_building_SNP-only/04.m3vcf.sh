#!/bin/bash

CHR=$1

DIR=/qnap-wlee/wanpingleelab/chengp/36K_panel_build

mkdir -p $DIR/m3vcf

VCF=$DIR/vcfs/ligated/chr$CHR.phased.vcf.gz

# Make m3vcf
/qnap-wlee/wanpingleelab/chengp/tools/Minimac3Executable/bin/Minimac3 \
  --cpus 10 --lowMemory \
  --myChromosome chr$CHR --refHaps $VCF --processReference --prefix $DIR/m3vcf/chr$CHR
