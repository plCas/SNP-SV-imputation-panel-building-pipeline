#!/bin/bash
#
#SBATCH --job-name=IMMerge
#SBATCH -o /qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo/scripts/tmp_IMMerge/IMMerge.%A_%a.txt
#SBATCH -e /qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo/scripts/tmp_IMMerge/IMMerge.error.%A_%a.txt
#SBATCH --ntasks=1
#SBATCH --partition=wleeq
#SBATCH --qos=high
#SBATCH --cpus-per-task 8
#SBATCH --mem-per-cpu=8G
#SBATCH --array=0,4,8,12,16,20,24,28,32,36,40,44,48,52,56,60,64,68%2
#--array=8
##set -euxo pipefail
CHR=$1
#CHR=$SLURM_ARRAY_TASK_ID

export PATH=/s3buckets/wanpinglee-lab-psom-s3-bucket-01/wanpingleelab/chengp/tools/htslib-1.16/bin:$PATH
#export PATH=/fsx01/s3-wanpingleelab/chengp/tools/miniconda3/bin:$PATH
#source activate association_test

DIR=/qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo/IMMerge
TMP_DIR=$DIR/TMP
mkdir -p $TMP_DIR

readarray MY_LIST < /qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo/list/chr$CHR.imp.res.list

NUM=${#MY_LIST[@]}
echo $NUM

#for num in $(seq 0 4 $NUM);do
    echo $num
    num=$SLURM_ARRAY_TASK_ID
    SAMPLE_LIST=""
    for ((i=$num;i<=$(($num+3));i++));do SAMPLE_LIST="$SAMPLE_LIST ${MY_LIST[i]}";done
    echo $SAMPLE_LIST

    python3 /s3buckets/wanpinglee-lab-psom-s3-bucket-01/wanpingleelab/chengp/tools/IMMerge/src/IMMerge/merge_files.py \
            --thread 10 \
            --input $SAMPLE_LIST \
            --output $TMP_DIR/chr$CHR.ADGC.dose.$num \
            --check_duplicate_id true \
            --missing 0

    python3 /s3buckets/wanpinglee-lab-psom-s3-bucket-01/wanpingleelab/chengp/tools/IMMerge/src/IMMerge/make_info.py \
            --thread 10 \
	    --output_dir $TMP_DIR \
            --output_fn chr$CHR.ADGC.dose.$num.info.gz \
            --input $TMP_DIR/chr$CHR.ADGC.dose.$num.vcf.gz

#done


#echo "Start 2nd merge"

#SAMPLE_FILE=($(find $TMP_DIR -type f -iname "chr$CHR.*.vcf.gz"))
#SAMPLE_LIST=""
#for i in ${SAMPLE_FILE[*]}; do SAMPLE_LIST="$SAMPLE_LIST $i";done

#INFO_FILE=($(find $TMP_DIR -type f -iname "chr$CHR.*info.gz"))
#INFO_LIST=""
#for i in ${INFO_FILE[*]}; do INFO_LIST="$INFO_LIST $i";done

#python3 /wanpinglee-lab-psom-s3-bucket-01/wanpingleelab/chengp/tools/IMMerge/src/IMMerge/merge_files.py \
#    --thread 10 \
#    --input $SAMPLE_LIST \
#    --info $INFO_LIST \
#    --output $DIR/chr$CHR.ADGC.dose \
#    --check_duplicate_id true \
#    --missing 0

#python3 /wanpinglee-lab-psom-s3-bucket-01/wanpingleelab/chengp/tools/IMMerge/src/IMMerge/make_info.py \
#    --output_dir $DIR \
#    --output_fn chr$CHR.ADGC.dose.info.gz \
#    --input $DIR/chr$CHR.ADGC.dose.vcf.gz

#bcftools index -t $DIR/chr$CHR.ADGC.dose.vcf.gz

#echo "All merge done"

