#!/bin/bash

CHR=$1

OUT=/qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo/var_counts
mkdir -p $OUT

readarray mylist < /qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo/list/chr$CHR.imp.res.list

echo -e "File\tVarCounts" > $OUT/chr$CHR.var_counts.txt

for i in ${mylist[*]};do 
    DIR=$(dirname $i)
    NUM=$(zcat $DIR/chr$CHR.info.gz|wc -l )
    echo -e "$i\t$NUM" >> $OUT/chr$CHR.var_counts.txt
done

