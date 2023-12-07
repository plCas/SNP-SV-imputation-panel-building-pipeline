#!/bin/bash
#
#SBATCH --job-name=bcftools_benchmark_ligate
#SBATCH -o /qnap-wlee/wanpingleelab/chengp/36K_panel_build/scripts_panel_building/tmp/bcftools_benchmark_ligate.%A_%a.txt
#SBATCH -e /qnap-wlee/wanpingleelab/chengp/36K_panel_build/scripts_panel_building/tmp/bcftools_benchmark_ligate.error.%A_%a.txt
#SBATCH --ntasks=1
#SBATCH --partition=gcadcbq
#SBATCH --qos=high-gcadcb
#SBATCH --cpus-per-task 2

# Ligate the segments of the same chromosome together

set -euxo pipefail

CHR=$1

THREADS=2

DIR=/qnap-wlee/wanpingleelab/chengp/36K_panel_build/vcfs

mkdir -p $DIR/ligated

OUT=$DIR/ligated/chr$CHR.phased.vcf.gz


VCFS=""
for i in $(ls -v $DIR/phased/chr$CHR/*.vcf.gz)

do
  #bcftools index -t $i
  VCFS=$VCFS" "$i
done

bcftools concat -Oz -o $OUT --ligate --threads $THREADS $VCFS
bcftools index -t --threads $THREADS $OUT
bcftools stats $OUT > ${OUT%%.gz}.stats

