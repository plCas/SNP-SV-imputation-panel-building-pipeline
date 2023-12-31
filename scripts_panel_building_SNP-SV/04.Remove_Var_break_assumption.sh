#!/bin/bash

INFILE=$1
OUT=$2
SCRIPT=/qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo/scripts/04.Remove_Var_break_assumption.py

python3 $SCRIPT $INFILE $OUT

if [ $? -eq 0 ]; then
    echo "file updated."
    bcftools view $OUT -Oz -o $INFILE
    bcftools index -t $INFILE
    rm $OUT
else
    echo "file do not change."
    bcftools index -t $INFILE
fi


