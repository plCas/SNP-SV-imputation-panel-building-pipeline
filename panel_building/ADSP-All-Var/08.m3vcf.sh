#!/bin/bash

CHR=$1

DIR=/../panel_build_ADSP-All-Var

mkdir -p $DIR/m3vcf

VCF=$DIR/vcfs/ligated/chr$CHR.phased.vcf.gz

# Make m3vcf
/../Minimac3Executable/bin/Minimac3 \
  --cpus 8 --lowMemory \
  --myChromosome chr$CHR --refHaps $VCF --processReference --prefix $DIR/m3vcf/chr$CHR

