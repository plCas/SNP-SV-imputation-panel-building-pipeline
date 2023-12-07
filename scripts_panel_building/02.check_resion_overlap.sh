#!/bin/bash
#
#SBATCH --job-name=check_region_overlap
#SBATCH -o /qnap-wlee/wanpingleelab/chengp/36K_panel_build/scripts_panel_building/tmp/check_region_overlap.%A_%a.txt
#SBATCH -e /qnap-wlee/wanpingleelab/chengp/36K_panel_build/scripts_panel_building/tmp/check_region_overlap.error.%A_%a.txt
#SBATCH --ntasks=1
#SBATCH --partition=gcadcbq
#SBATCH --qos=high
#SBATCH --cpus-per-task 2
#SBATCH --array=1-22


CHR=$SLURM_ARRAY_TASK_ID
OUT=/qnap-wlee/wanpingleelab/chengp/36K_panel_build/test_region_overlap
mkdir -p $OUT
VCF=/qnap-wlee/wanpingleelab/chengp/36K_panel_build/vcfs/filtered_bi/chr$CHR.bi.vcf.gz

bcftools query -f "%POS\n" $VCF  > $OUT/chr$CHR.pos.txt
