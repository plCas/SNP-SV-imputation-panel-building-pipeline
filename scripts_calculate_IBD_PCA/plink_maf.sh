#!/bin/bash
#
#SBATCH --job-name=make_bed
#SBATCH -o /qnap-wlee/wanpingleelab/chengp/36K_panel_build/scripts_calculate_IBD_PCA/tmp/make_bed.%A_%a.txt
#SBATCH -e /qnap-wlee/wanpingleelab/chengp/36K_panel_build/scripts_calculate_IBD_PCA/tmp/make_bed.error.%A_%a.txt
#SBATCH --ntasks=1
#SBATCH --partition=wleeq
#SBATCH --qos=normal

DIR=/qnap-wlee/wanpingleelab/chengp/36K_panel_build
OUT=$DIR/bed_file
mkdir -p $OUT

#plink=/mnt/adsp/users/polian/tools/plink1.9/plink
plink=/s3buckets/wanpinglee-lab-psom-s3-bucket-01/wanpingleelab/chengp/tools/plink1.9/plink

bed=/qnap-wlee/wanpingleelab/chengp/36K_panel_build/bed_file/all_bed.bi

$plink  --double-id \
        --bfile $bed \
        --out $OUT/chr$CHR.bi.05 \
        --make-bed \
        --set-missing-var-ids @:#\$1:\$2 \
        --maf 0.05

