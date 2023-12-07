#!/bin/bash
CHR=$1
OUT=/qnap-wlee/wanpingleelab/chengp/36K_panel_build/test_region_overlap
mkdir -p $OUT
VCF=/qnap-wlee/wanpingleelab/chengp/36K_panel_build/vcfs/filtered_bi/chr$CHR.bi.vcf.gz

bcftools query -f "%POS\n" $VCF  > $OUT/chr$CHR.pos.txt
