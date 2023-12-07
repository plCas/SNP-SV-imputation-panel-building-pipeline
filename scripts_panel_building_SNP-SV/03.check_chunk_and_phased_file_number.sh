#!/bin/bash

# check chunk number and phased file number

CHR=$1

DIR=/qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo
CHUNK=$(cat $DIR/test_region_overlap/chr$CHR.chunk.txt|wc -l)
FILES=($(ls -v $DIR/vcfs/phased/chr$CHR | grep ".vcf.gz$"))
echo "chr$CHR   phased file:${#FILES[@]};  chunk file : $CHUNK"

