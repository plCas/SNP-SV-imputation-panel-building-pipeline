#!/bin/bash
#
#SBATCH --job-name=bcftools_gt
#SBATCH -o /qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo/scripts/tmp/bcftools_gt.%A_%a.txt
#SBATCH -e /qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo/scripts/tmp/bcftools_gt.error.%A_%a.txt
#SBATCH --ntasks=1
#SBATCH --partition=wleeq
#SBATCH --qos=high
#SBATCH --cpus-per-task 1
#SBATCH --mem-per-cpu=4G
#SBATCH --array=0-81

CHR=$1

DIR=/qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo/impute_results
LIST=($(find $DIR -maxdepth 3 -type f -iname chr$CHR.snp_sv.dose.vcf.gz))
#NUM=${#LIST[@]}
#echo "Total imputed files : $NUM"

OUTDIR=/qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo/impute_results_gt
mkdir -p $OUTDIR


#for i in ${LIST[*]}; do
VCF=${LIST[$SLURM_ARRAY_TASK_ID]}
ETH=$(dirname $VCF | xargs dirname | xargs basename)
COHORT=$(dirname $VCF | xargs basename)   
mkdir -p $OUTDIR/$ETH/$COHORT
OUT=$OUTDIR/$ETH/$COHORT/chr$CHR.gt.vcf.gz

if [ ! -f $OUT ];then
    bcftools annotate -x ^FORMAT/GT $VCF | bcftools view -Oz -o $OUT
    bcftools index -t $OUT
fi
#done

