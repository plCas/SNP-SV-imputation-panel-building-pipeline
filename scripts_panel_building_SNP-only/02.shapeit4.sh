#!/bin/bash
#
#SBATCH --job-name=shapeit4
#SBATCH -o /qnap-wlee/wanpingleelab/chengp/36K_panel_build/scripts_panel_building/tmp/shapeit4.%A_%a.txt
#SBATCH -e /qnap-wlee/wanpingleelab/chengp/36K_panel_build/scripts_panel_building/tmp/shapeit4.error.%A_%a.txt
#SBATCH --ntasks=1
#SBATCH --partition=gcadcbq
#SBATCH --qos=normal-gcadcb 
#SBATCH --cpus-per-task 12

# Split the chromosome into 1Mb segments and retain a 1Kb overlap for later merging.

CHR=$1
REGION=$2

THREADS=12

DIR=/qnap-wlee/wanpingleelab/chengp/36K_panel_build
VCF=$DIR/vcfs/filtered_bi/chr$CHR.bi.vcf.gz
#MAP=/s3buckets/wanpinglee-lab-psom-s3-bucket-01/wanpingleelab/chengp/ref/genetic_maps.b38/chr$CHR.b38.gmap.gz
MAP=/qnap-wlee/wanpingleelab/chengp/ref/genetic_maps.b38/chr$CHR.b38.gmap.gz

OUT_DIR=$DIR/vcfs/phased/chr$CHR
mkdir -p $OUT_DIR


#/s3buckets/wanpinglee-lab-psom-s3-bucket-01/wanpingleelab/chengp/tools/shapeit4-4.2.2/bin/shapeit4.2 --input $VCF \
/qnap-wlee/wanpingleelab/chengp/tools/shapeit4-4.2.2/bin/shapeit4.2 --input $VCF \
	--map $MAP \
	--region $REGION \
	--output $OUT_DIR/$REGION.phased.vcf.gz \
	--thread $THREADS \
	--ibd2-output $OUT_DIR/$REGION.IBD2blacklist.txt.gz \
	--sequencing \
	--seed 54321 \
	--log $OUT_DIR/$REGION.phased.log

bcftools index -t --threads $THREADS $OUT_DIR/$REGION.phased.vcf.gz
