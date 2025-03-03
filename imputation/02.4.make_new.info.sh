#!/bin/bash

CHR=$1
SLURM_ARRAY_TASK_ID=$2

COHORT_LIST=($(awk '{print $2}' /../imputations/files/imputed_ADSP-Short-Var_gt/chr$CHR.list))

VCF=${COHORT_LIST[$SLURM_ARRAY_TASK_ID]}
DIR=$(dirname $VCF)


python3 /../IMMerge/src/IMMerge/make_info.py \
	--output_dir $DIR \
	--input $VCF


