#!/bin/bash

CHR=$1
chunk_i=$2

DIR=/../IMMerge/TMP_chr$CHR
mkdir -p $DIR

SAMPLE_FILE=($(awk '{print $2}' /../meta-imputation/files/chunk_file_lists/chr$CHR/chr$CHR.chunk$chunk_i.list))
SAMPLE_LIST=""
for i in ${SAMPLE_FILE[*]}; do SAMPLE_LIST="$SAMPLE_LIST $i";done

INFO_FILE=($(awk '{print $2}' /../meta-imputation/files/chunk_file_lists/chr$CHR/chr$CHR.chunk$chunk_i.info.list))
INFO_LIST=""
for i in ${INFO_FILE[*]}; do INFO_LIST="$INFO_LIST $i";done

python3 /../IMMerge/src/IMMerge/merge_files.py \
    --thread 10 \
    --input $SAMPLE_LIST \
    --info $INFO_LIST \
    --output $DIR/chr$CHR.ADGC.dose.chunk$chunk_i \
    --check_duplicate_id true \
    --missing 0

bcftools index -t $DIR/chr$CHR.ADGC.dose.chunk$chunk_i.vcf.gz
bcftools stats $DIR/chr$CHR.ADGC.dose.chunk$chunk_i.vcf.gz > $DIR/chr$CHR.ADGC.dose.chunk$chunk_i.vcf.stats

