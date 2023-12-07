#!/bin/bash
CHR=$1

# exam impute_results
#DIR=/wanpinglee-lab-psom-s3-bucket-01/wanpingleelab/chengp/impute_sv/HQ_SV_panel/impute_results
#FILE=chr$CHR.snp_sv.dose.vcf.gz.tbi

# check remain_GT results
DIR=/wanpinglee-lab-psom-s3-bucket-01/wanpingleelab/chengp/impute_sv/HQ_SV_panel/analysis/GWAS/ADGC_All/GT_only_vcfs
#FILE=chr$CHR.dose.gt.vcf.gz
FILE=chr$CHR.info.gz

# exam files changed format
#DIR=/wanpinglee-lab-psom-s3-bucket-01/wanpingleelab/chengp/impute_sv/HQ_SV_panel/analysis/GWAS/ADGC_All/REF.changed_res
#FILE=chr$CHR.dose.c.vcf.gz.tbi

# exam filtered files
#DIR=/wanpinglee-lab-psom-s3-bucket-01/wanpingleelab/chengp/impute_sv/HQ_SV_panel/analysis/GWAS/ADGC_All/Asso_test_filtered_vcfs
#FILE=chr$CHR.GT.AF005.vcf.gz.tbi

#readarray COHORT_LIST <  /wanpinglee-lab-psom-s3-bucket-01/wanpingleelab/chengp/impute_sv/HQ_SV_panel/analysis/case-control_table/files/used_cohorts
readarray COHORT_LIST < /wanpinglee-lab-psom-s3-bucket-01/wanpingleelab/chengp/impute_sv/HQ_SV_panel/analysis/GWAS/files_IMMerge/Available_cohorts_72.txt

for i in ${COHORT_LIST[*]};do
    if [[ ! -f $DIR/$i/$FILE ]];then
        echo -e "$DIR/$i"
    fi
done

#LIST=($(find $DIR -maxdepth 3 -type d))
#LIST=($(find $DIR -maxdepth 4 -type f -iname chr$CHR.dose.vcf.gz))
#NUM=${#LIST[@]}

#for ((i=0;i<$NUM;i++)); do
#    if [[ ! -f ${LIST[$i]}/$FILE ]];then
#        echo -e "chr$CHR\t${LIST[$i]}"
#        #echo ${LIST[$i]} >> $OUT/chr$CHR.impute.res.list
#    fi
#done


