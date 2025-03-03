#!/bin/bash

CHR=$1
SLURM_ARRAY_TASK_ID=$2

SAMPLES=/../imputations/files/array_files_66/chr$CHR.list
COHORTS=($(cat $SAMPLES | sed 's/^.*\/\([^/]*\)\/\([^/]*\)\/\(.*\)$/\1\/\2/'))

COHORT=${COHORTS[$SLURM_ARRAY_TASK_ID]}

#ADSP
RESULT_PANEL1=/../imputations/vcfs/ADSP-Short-Var_imp/$COHORT/chr$CHR
#TOPMed
RESULT_PANEL2=/../ADGC_TOPMed_impute_res/$COHORT/vcfs/chr$CHR

OUT=/../meta-imputation/vcfs/$COHORT
mkdir -p $OUT

MetaMinimac2=/../MetaMinimac2/release-build/MetaMinimac2

$MetaMinimac2 -i $RESULT_PANEL1:$RESULT_PANEL2 \
              -o $OUT/chr$CHR.meta \
	          -f GT \
              -w ON \
              -l ON

bcftools index -t $OUT/chr$CHR.meta.metaDose.vcf.gz
bcftools stats $OUT/chr$CHR.meta.metaDose.vcf.gz > $OUT/chr$CHR.meta.metaDose.vcf.stats
