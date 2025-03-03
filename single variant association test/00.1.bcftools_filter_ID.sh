#!/bin/bash
# Calculate and filter variants by HWE for control-only samples.
# Output a list of IDs that passed the HWE filter.

CHR=$1
ETH=$2 # pooled, ADGC_NHW, ADGC_AA,ADGC_Asian,ADGC_Hispanic
SAMPLES=/../pooled_ctr_sample_list
PC=/../pca/control_sample.pca.txt # pre-calculate PCA for control samples

VCF=/../imputations/IMMerge/ADSP-Short-Var/chr$CHR.ADGC.dose.vcf.gz

OUTDIR=/../association_test_hwe/ADSP-Short-Var/vcfs/$ETH
mkdir -p $OUTDIR

ruth=/../ruth/bin/ruth

bcftools view --threads 2 -S $SAMPLES -i 'R2 > 0.8' $VCF \
    | $ruth --vcf - --evec $PC --field GT --lambda 0 --lrt-em --seed 12345 --out - \
    | bcftools view --threads 2 --drop-genotypes -i 'HWE_SLP_I > -4 && HWE_SLP_I < 4' -Oz -o $OUTDIR/chr$CHR.vcf.gz
bcftools index --threads 2 -t $OUTDIR/chr$CHR.vcf.gz
bcftools stats $OUTDIR/chr$CHR.vcf.gz > $OUTDIR/chr$CHR.vcf.stats

# make ID list
bcftools query -f "%ID" $OUTDIR/chr$CHR.vcf.gz > $OUTDIR/chr$CHR.id_list.txt

