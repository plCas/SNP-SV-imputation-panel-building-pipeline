#!/bin/bash

# Ligate the segments of the same chromosome together

set -euxo pipefail

#CHR=$1
CHR=$SLURM_ARRAY_TASK_ID

THREADS=2

DIR=/../panel_build_ADSP-All-Var/vcfs

mkdir -p $DIR/ligated

OUT=$DIR/ligated/chr$CHR.phased.vcf.gz


VCFS=""
for i in $(ls -v $DIR/phased/chr$CHR/*.vcf.gz)

do
  VCFS=$VCFS" "$i
done

bcftools concat -Oz -o $OUT --ligate --threads $THREADS $VCFS
bcftools index -t --threads $THREADS $OUT
bcftools stats $OUT > ${OUT%%.gz}.stats

