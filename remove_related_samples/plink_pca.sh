#!/bin/bash

DIR=/../
mkdir -p $DIR/pca

BFILE=$DIR/bed_file/all_bed.bi.05

plink=/../plink1.9/plink

$plink --pca --threads 10 -bfile $BFILE -out $DIR/pca/all_bed.bi.pca

# make file for RUTH by remove first column
cut -d' ' -f2- /../pca/all_bed.bi.pca.eigenvec > /../pca/all_bed.bi.pca.txt