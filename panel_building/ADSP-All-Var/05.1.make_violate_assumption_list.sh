#!/bin/bash
# This script will check which cunk of phasing vcf included variants that might break overlap assumption.
# Generate a list for removing those variants latter.
# break assumption means that the position of first variant in a vcf file smaller than the predefined region.
# e.g. if the position of the first variant in chr1:2000000-3000000.phased.vcf.gz is 1900200 then this variant break assumption and needed to be removed

CHR=$1

DIR=/../panel_build_ADSP-All-Var/vcfs/phased/chr$CHR
OUT=/../panel_build_ADSP-All-Var/file_break_assumption_list
mkdir -p $OUT

readarray -t CHUNKS < /../panel_build_ADSP-All-Var/test_region_overlap/chr$CHR.chunk.txt 

NUM=${#CHUNKS[@]}
for (( i=0; i< $NUM; i++));do
REGION=${CHUNKS[$i]}
CHUNK_POS1=$(echo ${REGION#*:}|cut -d '-' -f 1)
FILE_POS1=$(bcftools query -f "%POS" $DIR/$REGION.phased.vcf.gz|head -n 1)
if [[ $FILE_POS1 -lt $CHUNK_POS1 ]];then
    echo -e "$i\t$REGION"
    echo -e "$i\t$REGION" >> $OUT/chr$CHR.list
fi
done

