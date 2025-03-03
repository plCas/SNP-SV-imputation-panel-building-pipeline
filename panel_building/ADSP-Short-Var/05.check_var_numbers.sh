#!/bin/bash

OUT=/../panel_build/vcfs/ligated

DIR=/../panel_build/vcfs/ligated
FILEs=($(ls -v $DIR|grep ".vcf.stats$"|grep -v "chrX"))

echo -e "record\tSNPs\tindels\tothers\tFILE" > $OUT/var_counts.txt

NUM=${#FILEs[@]}
for ((i=0; i<$NUM; i++));do
    echo -e "$i\t${FILEs[$i]}"
    VCF=$DIR/${FILEs[$i]}

    record=$(cat $VCF |grep records:|awk '{print $6}')
    SNP=$(cat $VCF |grep SNPs:|awk '{print $6}')
    indels=$(cat $VCF |grep indels:|awk '{print $6}')
    others=$(cat $VCF |grep others:|awk '{print $6}')
    echo -e "$record\t$SNP\t$indels\t$others\t${FILEs[$i]}"  >> $OUT/var_counts.txt

done

