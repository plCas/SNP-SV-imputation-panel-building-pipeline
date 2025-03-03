#!/bin/bash

# Ligate the segments of the same chromosome together

set -euxo pipefail

CHR=$1

THREADS=2

DIR=/../panel_build/vcfs

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

