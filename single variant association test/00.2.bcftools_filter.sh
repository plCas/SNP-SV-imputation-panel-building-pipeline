#!/bin/bash
CHR=$1

ETH=$2 # pooled, ADGC_NHW, ADGC_AA,ADGC_Asian,ADGC_Hispanic
SAMPLES=/../ADGC_34376_sample_list
PC=/../ADGC_34376_sample.pca.txt  # calculate PCA for each ethnicity

VCF=/../imputations/IMMerge/ADSP-Short-Var/chr$CHR.ADGC.dose.vcf.gz
ID=/../association_test_hwe/ADSP-Short-Var/vcfs/$ETH/chr$CHR.id_list.txt  # generate from "00.1.bcftools_filter_ID.sh" variants that pass hwe filter

OUTDIR=/../association_test/ADSP-Short-Var/vcfs/$ETH
mkdir -p $OUTDIR

bcftools view --threads 2 -S $SAMPLES --include ID==@$ID $VCF \
    | bcftools +fill-tags --threads 2 -- -t AN,AC,AF \
    | bcftools view --threads 2 -i 'AC > 0 && MAF > 0.005 && R2 > 0.8' -Oz -o $OUTDIR/chr$CHR.vcf.gz
bcftools index --threads 2 -t $OUTDIR/chr$CHR.vcf.gz
bcftools stats $OUTDIR/chr$CHR.vcf.gz > $OUTDIR/chr$CHR.vcf.stats
