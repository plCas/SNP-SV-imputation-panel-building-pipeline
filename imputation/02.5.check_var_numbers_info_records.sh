#!/bin/bash
CHR=$1

LIST=($(awk '{print $2}' /../imputations/files/imputed_ADSP-Short-Var/chr$CHR.list))

OUTDIR=/../imputations/vcfs/ADSP-Short-Var_imp_gt

echo -e "Task_num\tCOHORT\tRecords\tInfo\tReco-Info"> $OUTDIR/chr$CHR.info_var_counts.txt

for i in $(seq 0 1 65);do
    VCF=${LIST[$i]}
    ETH=$(dirname $VCF | xargs dirname | xargs basename)
    COHORT=$(dirname $VCF | xargs basename)

    STATS=$OUTDIR/$ETH/$COHORT/chr$CHR.gt.vcf.stats
    NUM_RECORDS=$(cat $STATS|grep records:|awk '{print $6}')

    INFO=$OUTDIR/$ETH/$COHORT/chr$CHR.info.gz
    NUM_INFO=$(zcat $INFO|sed 1d |wc -l)

    echo -e "$i\t$ETH/$COHORT\t$NUM_RECORDS\t$NUM_INFO\t$(($NUM_RECORDS-$NUM_INFO))" >> $OUTDIR/chr$CHR.info_var_counts.txt
done
