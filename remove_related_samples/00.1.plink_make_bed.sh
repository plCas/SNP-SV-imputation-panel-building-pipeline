#!/bin/bash

CHR=$1
DIR=/../
OUT=$DIR/bed_file
mkdir -p $OUT

plink=/../plink1.9/plink

bi=/../*.vcf.gz

$plink  --double-id \
        --vcf $bi \
        --out $OUT/chr$CHR.bi \
        --make-bed \
        --set-missing-var-ids @:#:\$1:\$2 \
        --maf 0.05