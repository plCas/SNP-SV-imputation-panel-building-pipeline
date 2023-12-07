#!/bin/bash
CHR=$1
VCF=/s3buckets/GCADCOREBdatasets/PVCF-storage/pVCF-2023/QC-36k/compact-filtered/fixedAF/biallelic/gcad.qc.compact_filtered.r4.wgs.36361.GATK.2022.08.15.biallelic.genotypes.chr$CHR.ALL.vcf.bgz

DIR=/qnap-wlee/wanpingleelab/chengp/36K_panel_build/vcfs

ruth=/qnap-wlee/wanpingleelab/chengp/tools/ruth/bin/ruth
PC=/qnap-wlee/wanpingleelab/chengp/36K_panel_build/pca/all_bed.bi.pca.txt
REF=/s3buckets/wanpinglee-lab-psom-s3-bucket-01/wanpingleelab/chengp/ref/GRCh38_full_analysis_set_plus_decoy_hla.fa
SAMPLE_LIST=/qnap-wlee/wanpingleelab/chengp/36K_panel_build/final_sample_list/sample_list.final.txt # produce from IBD remove sample step
OUT=$DIR/filtered_bi

mkdir -p $OUT

bcftools view  --threads 2 -f PASS -i 'AC >= 5 && AN >= 35644*2*0.9' -S $SAMPLE_LIST $VCF\
    | $ruth --vcf - --evec $PC --field GT --lambda 0 --lrt-em --seed 12345 --out - \
    | bcftools annotate --threads 2 -x 'FORMAT' \
    | bcftools view  --threads 2 -i 'HWE_SLP_I > -4' -Oz -o $OUT/chr$CHR.bi.vcf.gz 

bcftools index --threads 2 -t $OUT/chr$CHR.bi.vcf.gz
bcftools stats --threads 2 $OUT/chr$CHR.bi.vcf.gz > $OUT/chr$CHR.bi.vcf.stats

echo "Start time : ${STARTIME}; End time : ${ENDTIME}"
