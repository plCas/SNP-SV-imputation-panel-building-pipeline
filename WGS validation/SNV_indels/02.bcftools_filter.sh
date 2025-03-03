#!/bin/bash

PANEL=$1 # ADSP-Short-Var, ADSP-All-Var, TOPMed, meta
ETH=$2 # ADGC_NHW, ADGC_AA, ADGC_Asian, ADGC_Hispanic
CHR=$3

if [[ $PANEL == "ADSP-Short-Var" ]];then
    VCF=/../imputations/IMMerge/ADSP-Short-Var/chr$CHR.ADGC.dose.vcf.gz
elif [[ $PANEL == "ADSP-All-Var" ]];then
    VCF=/../imputations/IMMerge/ADSP-All-Var/chr$CHR.ADGC.dose.vcf.gz
elif [[ $PANEL == "TOPMed" ]];then
    VCF=/../vcfs/TOPMed/$ETH/chr$CHR.vcf.gz
elif [[ $PANEL == "meta" ]];then
    VCF=/../meta-imputation/IMMerge/chr$CHR.vcf.gz
fi

SAMPLES=/../WGS_validation/SNV_Indel/files/${ETH}_sample_list.txt
OUT=/../WGS_validation/SNV_Indel/vcfs/imputation/$PANEL/$ETH

mkdir -p $OUT

bcftools view --threads 2 -S $SAMPLES --force-samples $VCF -Oz -o $OUT/chr$CHR.vcf.gz
bcftools index -t $OUT/chr$CHR.vcf.gz
