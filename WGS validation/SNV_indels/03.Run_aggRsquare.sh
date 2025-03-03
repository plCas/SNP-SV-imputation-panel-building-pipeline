#!/bin/bash

PANEL=$1 # ADSP-Short-Var, ADSP-All-Var, TOPMed, meta
ETH=$2 # ADGC_NHW, ADGC_AA, ADGC_Asian, ADGC_Hispanic
CHR=$3

SCRIPT=/../aggRsqure.sh
OUT=/../WGS_validation/SNV_Indel/aggRsquare/$PANEL/$ETH
mkdir -p $OUT

TEST_VCF=/../WGS_validation/SNV_Indel/vcfs/imputation/$PANEL/$ETH/chr$CHR.vcf.gz

TRUTH_VCF=/../WGS_validation/SNV_Indel/vcfs/wgs/$ETH/chr$CHR.vcf.gz

/bin/bash $SCRIPT $TEST_VCF $TRUTH_VCF $OUT/chr$CHR
