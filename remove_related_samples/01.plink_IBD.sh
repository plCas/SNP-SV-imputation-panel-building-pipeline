#!/bin/bash

DIR=/../panel_build
OUT=$DIR/plink_IBD
mkdir -p $OUT

plink=/../plink1.9/plink

$plink --bfile $DIR/bed_file/qc_panel.bi --threads 14 --genome --out $OUT/all_bed.bi.IBD

