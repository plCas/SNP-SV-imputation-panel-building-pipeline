#!/bin/bash
#
#SBATCH --job-name=make.gds
#SBATCH -o /qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo/scripts/tmp_gds/make.gds.%A_%a.txt
#SBATCH -e /qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo/scripts/tmp_gds/make.gds.error.%A_%a.txt
#SBATCH --ntasks=1
#SBATCH --partition=wleeq
#SBATCH --qos=normal
#SBATCH --cpus-per-task=10
#SBATCH --array=1-22

source /home/chengp/miniconda3/etc/profile.d/conda.sh
conda activate GENESIS

CHR=$SLURM_ARRAY_TASK_ID


# 36K samples
VCF=/qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo/IMMerge/chr$CHR.ADGC.dose.info.gz
OUT_PREFIX=/qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo/gds/36K_SNPSV/chr$CHR
mkdir -p /qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo/gds/36K_SNPSV

SCRIPT=/qnap-wlee/wanpingleelab/chengp/Rare_variants/scripts/generate_gds.R

echo "step 1 : 01.generate_gds.R"
Rscript --vanilla $SCRIPT $VCFs $OUT_PREFIX
