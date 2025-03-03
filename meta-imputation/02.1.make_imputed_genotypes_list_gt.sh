#!/bin/bash

CHR=$1

DIR=/../meta-imputation/vcfs

OUT=/../meta-imputation/files/meta-imputation
mkdir -p $OUT

FILES=($(find $DIR -type f -iname "chr$CHR.*"|grep .vcf.gz$))

NUM=${#FILES[@]}

for ((i=0; i< $NUM; i++));do
    f=${FILES[$i]}
    echo -e "$i\t$f" >> $OUT/chr$CHR.list
done

