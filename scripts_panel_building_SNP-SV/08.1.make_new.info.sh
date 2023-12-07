#!/bin/bash
#
#SBATCH --job-name=make.info
#SBATCH -o /qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo/scripts/tmp_IMMerge/make.info.%A_%a.txt
#SBATCH -e /qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo/scripts/tmp_IMMerge/make.info.error.%A_%a.txt
#SBATCH --ntasks=1
#SBATCH --partition=wleeq
#SBATCH --qos=high
#SBATCH --cpus-per-task 2
#SBATCH --mem-per-cpu=4G
#SBATCH --array=0-81
#
#set -euxo pipefail

CHR=$1
#CHR=$SLURM_ARRAY_TASK_ID
#SLURM_ARRAY_TASK_ID=0
export PATH=/s3buckets/wanpinglee-lab-psom-s3-bucket-01/wanpingleelab/chengp/tools/htslib-1.16/bin:$PATH
#export PATH=/s3buckets/wanpinglee-lab-psom-s3-bucket-01/wanpingleelab/chengp/tools/miniconda3/bin:$PATH
#export PATH=/home/chengp/miniconda3/bin:$PATH
#export PATH=/home/chengp/miniconda3/condabin:$PATH
#source activate IMMerge
#conda init bash
#conda activate IMMerge

#DIR=/wanpinglee-lab-psom-s3-bucket-01/wanpingleelab/chengp/impute_sv/HQ_SV_panel/analysis/GWAS/ADGC_All/GT_only_vcfs
DIR=/qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo/impute_results_gt

readarray COHORT_LIST < /s3buckets/wanpinglee-lab-psom-s3-bucket-01/wanpingleelab/chengp/impute_sv/HQ_SV_panel/analysis/GWAS/files_IMMerge/Available_cohorts_72.txt


LIST=($(find $DIR -maxdepth 3 -type f -iname chr$CHR.gt.vcf.gz))
NUM=${#LIST[@]}

echo $NUM

VCF=${LIST[$SLURM_ARRAY_TASK_ID]}
DIR=$(dirname $VCF)
ETH=$(dirname $VCF | xargs dirname | xargs basename)
COHORT=$(dirname $VCF | xargs basename)

echo $VCF
for C in ${COHORT_LIST[*]};do
	if [[ $C == $ETH/$COHORT ]];then
	    echo "$DIR $VCF"
	    python3 /s3buckets/wanpinglee-lab-psom-s3-bucket-01/wanpingleelab/chengp/tools/IMMerge/src/IMMerge/make_info.py \
		--output_dir $DIR \
		--input $VCF
	fi
done
