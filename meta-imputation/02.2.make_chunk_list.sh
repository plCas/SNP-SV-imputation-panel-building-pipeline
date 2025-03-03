#!/bin/bash
# make list for subsetting whole chromosomes into smaller chunks for each cohort 
CHR=$1

OUT=/../meta-imputation/files/IMMerge
mkdir -p $OUT

VCF=/../meta-imputation/vcfs/ADGC_AA/ACT/chr$CHR.meta.metaDose.vcf.gz
STATS=/../meta-imputation/vcfs/ADGC_AA/ACT/chr$CHR.meta.metaDose.vcf.stats
num_total=$(cat $STATS|grep records:|awk '{print $6}')

SEQ=($(seq 1 3000000 $num_total))
NUM=${#SEQ[@]}

for ((i=0;i<$NUM;i++));do
    i_SEQ=${SEQ[$i]}
    if [[ $i == 0 ]];then
        START=1
    else
        START=$(bcftools query -f '%POS' $VCF|head -n $i_SEQ |tail -1)
    fi
    
    if [[ $i == $(($NUM-1)) ]];then
        END=""
    else
        END=$(bcftools query -f '%POS' $VCF|head -n $((3000000 + $i_SEQ)) |tail -1)
    fi
    REGION="chr$CHR:$START-$END"
    echo $REGION
    echo $REGION >> $OUT/chr$CHR.chunks.info
done
