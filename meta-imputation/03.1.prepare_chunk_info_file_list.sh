#!/bin/bash

CHR=$1

DIR=/../IMMerge/TMP_chr$CHR

OUT=/../meta-imputation/files/chunk_file_lists/chr$CHR
mkdir -p $OUT

CHUNK_num=$(cat /../meta-imputation/files/IMMerge/chr$CHR.chunks.info| wc -l)


for ((i=0; i< $CHUNK_num; i++));do

    FILES=($(find $DIR -type f -iname "chr$CHR.chunk$i*"|grep .info.gz$))
    NUM=${#FILES[@]}

    for ((j=0; j< $NUM; j++));do
        f=${FILES[$j]}
        echo -e "$j\t$f" >> $OUT/chr$CHR.chunk$i.info.list
    done

done
