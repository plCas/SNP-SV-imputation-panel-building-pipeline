#!/bin/bash
# Usage: 
# 	sh 07.1.check_imputation_res.sh <CHR> <MODE>
# 	CHR=21
# 	MODE = 82 # all ADGC cohorts
# 	MODE = 72 # used ADGC cohorts

CHR=$1
MODE=$2

# make impute res file list
#DIR=/qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo/impute_results
#LIST=($(find $DIR -maxdepth 3 -type f -iname chr$CHR.snp_sv.dose.vcf.gz))

DIR=/qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo/impute_results_gt
LIST=($(find $DIR -maxdepth 3 -type f -iname chr$CHR.gt.vcf.gz))

NUM=${#LIST[@]}
echo "Total imputed files : $NUM"

# extract "ETH/COHORT" information
NEW_LIST=()
for VCF in ${LIST[@]};do
    ETH=$(dirname $VCF | xargs dirname | xargs basename)
    COHORT=$(dirname $VCF | xargs basename)

    NEW_LIST+=("$ETH/$COHORT")
done




if [[ $MODE == "All" ]];then
	# 82 cohorts
	readarray COHORT_LIST < /qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo/files/chr$CHR.list
	COHORT_NUM=${#COHORT_LIST[@]}

	for ((i=0;i<$COHORT_NUM;i++)); do
        	VCF=${COHORT_LIST[$i]}
    		ETH=$(dirname $VCF | xargs dirname | xargs basename)
    		COHORT=$(dirname $VCF | xargs basename)

    		my_variable="$ETH/$COHORT"

    		if [[ " ${NEW_LIST[*]} " == *" $my_variable "* ]]; then
    			continue	
    		else
    			echo "$my_variable is not imputed."
    		fi
	done

elif [[ $MODE == "Used" ]];then
# 72 used cohorts
	readarray -t COHORT_LIST < /s3buckets/wanpinglee-lab-psom-s3-bucket-01/wanpingleelab/chengp/impute_sv/HQ_SV_panel/analysis/GWAS/files_IMMerge/Available_cohorts_72.txt
	COHORT_NUM=${#COHORT_LIST[@]}

	## check impute res of 72 cohorts
	for ((i=0;i<$COHORT_NUM;i++)); do    

	    my_variable=${COHORT_LIST[$i]}

	    if [[ " ${NEW_LIST[*]} " == *" $my_variable "* ]]; then
		continue 
	    else
		echo "$my_variable is not imputed."
	    fi
	done

fi

echo "Done Checked!"



