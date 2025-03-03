#!/bin/bash

CHR=$1

DIR=/../imputations/vcfs/ADSP-Short-Var_imp_gt

OUT=/../imputations/files/imputed_ADSP-Short-Var_gt
mkdir -p $OUT

FILES=($(find $DIR -type f -iname "chr$CHR.*"|grep .vcf.gz$))

NUM=${#FILES[@]}

for ((i=0; i< $NUM; i++));do
    f=${FILES[$i]}
    echo -e "$i\t$f" >> $OUT/chr$CHR.list
done

