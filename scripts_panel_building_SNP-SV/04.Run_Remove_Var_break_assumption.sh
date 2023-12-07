#!/bin/bash

CHR=$1
DIR=/qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo/vcfs/phased/chr$CHR
FILES=($(ls -v $DIR | grep ".vcf.gz$"))


SCRIPT=/qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo/scripts/04.Remove_Var_break_assumption.sh

for i in ${FILES[*]};do
	INFILE=$DIR/$i
	OUT=$DIR/${i%%.vcf.gz}.tmp.vcf.gz
	sbatch $SCRIPT $INFILE $OUT 
done

