#!/bin/bash
#
#SBATCH --job-name=check_region_overlap
#SBATCH -o /qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo/scripts/tmp/check_region_overlap.%A_%a.txt
#SBATCH -e /qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo/scripts/tmp/check_region_overlap.error.%A_%a.txt
#SBATCH --ntasks=1
#SBATCH --partition=wleeq
#SBATCH --qos=normal
#SBATCH --cpus-per-task 2
#SBATCH --array=1-22


CHR=$SLURM_ARRAY_TASK_ID
OUT=/qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo/test_region_overlap
mkdir -p $OUT
VCF=/qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo/vcfs/SNP_SV/chr$CHR.snp_sv.vcf.gz

bcftools query -f "%POS\n" $VCF  > $OUT/chr$CHR.pos.txt
