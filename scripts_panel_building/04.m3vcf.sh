#!/bin/bash
#
#SBATCH --job-name=m3vcf
#SBATCH -o /qnap-wlee/wanpingleelab/chengp/36K_panel_build/scripts_panel_building/tmp/m3vcf.%A_%a.txt
#SBATCH -e /qnap-wlee/wanpingleelab/chengp/36K_panel_build/scripts_panel_building/tmp/m3vcf.error.%A_%a.txt
#SBATCH --ntasks=1
#SBATCH --partition=gcadcbq
#SBATCH --qos=normal-gcadcb
#SBATCH --cpus-per-task 10
#--array=1-22


CHR=$1
#CHR=$SLURM_ARRAY_TASK_ID
#AC=5
#ETH=NHW

DIR=/qnap-wlee/wanpingleelab/chengp/36K_panel_build

mkdir -p $DIR/m3vcf

VCF=$DIR/vcfs/ligated/chr$CHR.phased.vcf.gz

# Make m3vcf
#/s3buckets/wanpinglee-lab-psom-s3-bucket-01/wanpingleelab/chengp/tools/Minimac3Executable/bin/Minimac3 \
/qnap-wlee/wanpingleelab/chengp/tools/Minimac3Executable/bin/Minimac3 \
  --cpus 10 --lowMemory \
  --myChromosome chr$CHR --refHaps $VCF --processReference --prefix $DIR/m3vcf/chr$CHR.snp_sv
