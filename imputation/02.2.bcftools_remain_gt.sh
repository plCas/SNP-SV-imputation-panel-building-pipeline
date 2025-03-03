#!/bin/bash


CHR=$1

LIST=($(awk '{print $2}' /../imputations/files/imputed_ADSP-Short-Var/chr$CHR.list))

OUTDIR=/../imputations/vcfs/ADSP-Short-Var_imp_gt
mkdir -p $OUTDIR

VCF=${LIST[$SLURM_ARRAY_TASK_ID]}
ETH=$(dirname $VCF | xargs dirname | xargs basename)
COHORT=$(dirname $VCF | xargs basename)
mkdir -p $OUTDIR/$ETH/$COHORT
OUT=$OUTDIR/$ETH/$COHORT/chr$CHR.gt.vcf.gz

if [ ! -f $OUT ];then
    bcftools annotate -x ^FORMAT/GT $VCF | bcftools view -Oz -o $OUT
    bcftools index -t $OUT
    bcftools stats $OUT > ${OUT%%.gz}.stats
fi

