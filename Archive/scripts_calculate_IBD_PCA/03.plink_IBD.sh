#!/bin/bash
#
#SBATCH --job-name=IBD
#SBATCH -o /qnap-wlee/wanpingleelab/chengp/36K_panel_build/scripts_calculate_IBD_PCA/tmp/IBD.%A_%a.txt
#SBATCH -e /qnap-wlee/wanpingleelab/chengp/36K_panel_build/scripts_calculate_IBD_PCA/tmp/IBD.error.%A_%a.txt
#SBATCH --ntasks=1
#SBATCH --partition=wleeq
#SBATCH --qos=normal


DIR=/qnap-wlee/wanpingleelab/chengp/36K_panel_build
OUT=$DIR/plink_IBD
mkdir -p $OUT

plink=/s3buckets/wanpinglee-lab-psom-s3-bucket-01/wanpingleelab/chengp/tools/plink1.9/plink

$plink --bfile $DIR/bed_file/all_bed.bi.05 --genome --out $OUT/all_bed.bi.IBD
