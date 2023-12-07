#!/bin/bash 

CHR=$1

DIR=/qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo/IMMerge/TMP

FILES=($(find $DIR -type f -iname "chr$CHR.ADGC.dose*.info.gz"))
echo ${#FILES[@]}
for i in ${FILES[*]};do echo -e "$i\t$(zcat $i|wc -l)";done
