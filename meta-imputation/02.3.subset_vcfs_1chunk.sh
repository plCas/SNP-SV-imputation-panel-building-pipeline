#!/bin/bash
# subst whole chromosomes into smaller chunks for each cohort 

CHR=$1
SLURM_ARRAY_TASK_ID=$2
i=$3 # chunk number

THREADS=2

# get VCF file
DIR=/../meta-imputation/vcfs
FILES=($(awk '{print $2}' /../meta-imputation/files/meta-imputation/chr$CHR.list))
VCF=${FILES[$SLURM_ARRAY_TASK_ID]}

ETH=$(dirname $VCF |xargs dirname| xargs basename)
COHORT=$(dirname $VCF | xargs basename)

# set output directory
#OUT=/qnap-wlee/wanpingleelab/chengp/imputation/imputation_panel_12.02.24/meta-imputation/IMMerge
OUT=/../IMMerge
OUT_TMP=$OUT/TMP_chr$CHR/$ETH/$COHORT
mkdir -p $OUT_TMP


# get chunked region
readarray -t REGIONS < /../meta-imputation/files/IMMerge/chr$CHR.chunks.info

NUM=${#REGIONS[@]}

if [[ ! -f $OUT_TMP/chr$CHR.chunk$i.vcf.gz.tbi ]];then
    REGION=${REGIONS[$i]}
    echo "Subset $i   $REGION"
    bcftools view --threads $THREADS $VCF -r $REGION \
	    |bcftools sort --temp-dir $OUT_TMP/chunk$i -Oz -o $OUT_TMP/chr$CHR.chunk$i.vcf.gz
    bcftools index --threads $THREADS -t $OUT_TMP/chr$CHR.chunk$i.vcf.gz
    bcftools stats --threads $THREADS $OUT_TMP/chr$CHR.chunk$i.vcf.gz > $OUT_TMP/chr$CHR.chunk$i.vcf.stats

    echo "make info"
    python3 /../IMMerge/src/IMMerge/make_info.py \
            --output_dir $OUT_TMP \
            --input $OUT_TMP/chr$CHR.chunk$i.vcf.gz \
	    --thread $THREADS \
    	    --output_fn $OUT_TMP/chr$CHR.chunk$i.info.gz
fi

