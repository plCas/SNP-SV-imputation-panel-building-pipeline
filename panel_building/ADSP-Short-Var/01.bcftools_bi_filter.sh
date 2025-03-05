#!/bin/bash

CHR=$1
SAMPLE_NUM=15958

VCF=/../chr$CHR.vcf.gz

ruth=/../ruth/bin/ruth
PC=/../pca.txt
REF=/../GRCh38_full_analysis_set_plus_decoy_hla.fa # download from ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/GRCh38_reference_genome/GRCh38_full_analysis_set_plus_decoy_hla.fa
SAMPLE_LIST=/../final_sample_list # produce from IBD remove sample step
OUT=/../filtered_bi
mkdir -p $OUT

bcftools view  --threads 2 -S $SAMPLE_LIST -f PASS -i 'VFLAGS_one_subgroup=0 && (ABHet_one_subgroup > 0.25 && ABHet_one_subgroup < 0.75)' $VCF \
    | bcftools view -i "AC >= 5 && AN >= $SAMPLE_NUM*2*0.9" \
    | $ruth --vcf - --evec $PC --field GT --lambda 0 --lrt-em --seed 12345 --out - \
    | bcftools annotate --threads 2 -x 'FORMAT' \
    | bcftools view  --threads 2 -i 'HWE_SLP_I > -4 && HWE_SLP_I < 4' -Oz -o $OUT/chr$CHR.bi.vcf.gz

bcftools index --threads 2 -t $OUT/chr$CHR.bi.vcf.gz
bcftools stats --threads 2 $OUT/chr$CHR.bi.vcf.gz > $OUT/chr$CHR.bi.vcf.stats

