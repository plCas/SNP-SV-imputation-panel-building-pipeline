#!/bin/bash

CHR=$1

DIR=/qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo/impute_results_gt
OUT=/qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo/list
mkdir -p $OUT

#readarray COHORT_LIST < /wanpinglee-lab-psom-s3-bucket-01/wanpingleelab/chengp/impute_sv/HQ_SV_panel/analysis/GWAS/files/used_cohorts
readarray COHORT_LIST < /s3buckets/wanpinglee-lab-psom-s3-bucket-01/wanpingleelab/chengp/impute_sv/HQ_SV_panel/analysis/GWAS/files_IMMerge/Available_cohorts_72.txt


#LIST=($(find $DIR -maxdepth 3 -type f -iname chr$CHR.snp_sv.dose.vcf.gz))
LIST=($(find $DIR -maxdepth 3 -type f -iname chr$CHR.gt.vcf.gz))
NUM=${#LIST[@]}

echo $NUM

for ((i=0;i<$NUM;i++)); do
    VCF=${LIST[$i]}
    ETH=$(dirname $VCF | xargs dirname | xargs basename)
    COHORT=$(dirname $VCF | xargs basename)
   
    for C in ${COHORT_LIST[*]};do
        if [[ $C == $ETH/$COHORT ]];then
            echo "${LIST[$i]}"
	    #echo "$C" >> $OUT/chr1.cohorts
            echo "${LIST[$i]}" >> $OUT/chr$CHR.imp.res.list
        fi
    done
done

