#!/bin/bash
#
#SBATCH --job-name=merge_bed
#SBATCH -o /qnap-wlee/wanpingleelab/chengp/36K_panel_build/scripts_calculate_IBD_PCA/tmp/merge_bed.%A_%a.txt
#SBATCH -e /qnap-wlee/wanpingleelab/chengp/36K_panel_build/scripts_calculate_IBD_PCA/tmp/merge_bed.error.%A_%a.txt
#SBATCH --ntasks=1
#SBATCH --partition=wleeq
#SBATCH --qos=normal


DIR=/qnap-wlee/wanpingleelab/chengp/36K_panel_build/bed_file
# Produce bedlist.txt
#for ((i=2;i<=22;i++));do 
#	echo $DIR/chr$i.bi >> /qnap-wlee/wanpingleelab/chengp/36K_panel_build/bed_file/bedlist.txt
#done
bedlist=$DIR/bedlist.txt
bfile=$DIR/chr1.bi

plink=/s3buckets/wanpinglee-lab-psom-s3-bucket-01/wanpingleelab/chengp/tools/plink1.9/plink

$plink --bfile $bfile --merge-list $bedlist --make-bed --out $DIR/all_bed.bi
