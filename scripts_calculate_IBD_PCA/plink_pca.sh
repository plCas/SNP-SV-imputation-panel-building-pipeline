#!/bin/bash
#
#SBATCH --job-name=pca
#SBATCH -o /qnap-wlee/wanpingleelab/chengp/36K_panel_build/scripts_calculate_IBD_PCA/tmp/pca.%A_%a.txt
#SBATCH -e /qnap-wlee/wanpingleelab/chengp/36K_panel_build/scripts_calculate_IBD_PCA/tmp/pca.error.%A_%a.txt
#SBATCH --ntasks=1
#SBATCH --partition=wleeq
#SBATCH --qos=normal


DIR=/qnap-wlee/wanpingleelab/chengp/36K_panel_build
mkdir -p $DIR/pca

BFILE=$DIR/bed_file/all_bed.bi.05

plink=/s3buckets/wanpinglee-lab-psom-s3-bucket-01/wanpingleelab/chengp/tools/plink1.9/plink

$plink --pca --threads 10 -bfile $BFILE -out $DIR/pca/all_bed.bi.pca

# make file for RUTH by remove first column
#cut -d' ' -f2- /qnap-wlee/wanpingleelab/chengp/36K_panel_build/pca/all_bed.bi.pca.eigenvec > /qnap-wlee/wanpingleelab/chengp/36K_panel_build/pca/all_bed.bi.pca.txt

