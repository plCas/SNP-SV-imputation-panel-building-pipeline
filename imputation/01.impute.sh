#!/bin/bash

CHR=$1

THREADS=10

readarray SAMPLES < /../imputations/files/array_files_66/chr$CHR.list # pre generate array vcf file list

TASK_ID=$2

PANEL=/../panel_build/m3vcf/chr$CHR.m3vcf.gz
TEST_VCF=${SAMPLES[$TASK_ID]}

ETH=$(dirname $TEST_VCF |xargs dirname| xargs basename)
COHORT=$(dirname $TEST_VCF | xargs basename)
OUT=/../imputations/vcfs/ADSP-Short-Var_imp

PREFIX=$OUT/$ETH/$COHORT/chr$CHR

# Run imputation
/../Minimac4-1.0.2/minimac4-1.0.2-Linux/bin/minimac4 \
--refHaps $PANEL \
--haps $TEST_VCF \
--cpus $THREADS \
--prefix $PREFIX \
--meta \          # generate weighted file for meta-imputation
--ignoreDuplicates

