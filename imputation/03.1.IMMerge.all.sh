#!/bin/bash

CHR=$1
SLURM_ARRAY_TASK_ID=$2

DIR=/../imputations/IMMerge/ADSP-Short-Var
mkdir -p $DIR

MY_LIST=($(awk '{print $2}' /../imputations/files/imputed_ADSP-Short-Var_gt/chr$CHR.list))

NUM=${#MY_LIST[@]}

SAMPLE_LIST=""
for (( i = 0; i < $NUM; i++ ));do SAMPLE_LIST="$SAMPLE_LIST ${MY_LIST[i]}";done
echo $SAMPLE_LIST

python3 /../IMMerge/src/IMMerge/merge_files.py \
    --thread 10 \
    --input $SAMPLE_LIST \
    --output $DIR/chr$CHR.ADGC.dose \
    --check_duplicate_id true \
    --missing 0

python3 /../IMMerge/src/IMMerge/make_info.py \
    --thread 10 \
    --output_dir $DIR \
    --output_fn chr$CHR.ADGC.dose.info.gz \
    --input $DIR/chr$CHR.ADGC.dose.vcf.gz

bcftools index -t $DIR/chr$CHR.ADGC.dose.vcf.gz
bcftools stats $DIR/chr$CHR.ADGC.dose.vcf.gz > $DIR/chr$CHR.ADGC.dose.vcf.stats

