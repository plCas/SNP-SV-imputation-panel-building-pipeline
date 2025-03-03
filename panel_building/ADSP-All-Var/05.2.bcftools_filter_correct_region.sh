#!/bin/bash
#

CHR=$1
LIST=($(awk '{print $2}' /../panel_build_ADSP-All-Var/file_break_assumption_list/chr$CHR.list))

SLURM_ARRAY_TASK_ID=$1
REGION=${LIST[$SLURM_ARRAY_TASK_ID]}

DIR=/../panel_build_ADSP-All-Var/vcfs/phased/chr$CHR

VCF=$DIR/$REGION.phased.vcf.gz
VCF_backup=$DIR/$REGION.phased.vcf.gz.backup

mv $VCF $VCF_backup

bcftools view $VCF_backup -r $REGION -Oz -o $VCF
bcftools index -tf $VCF
