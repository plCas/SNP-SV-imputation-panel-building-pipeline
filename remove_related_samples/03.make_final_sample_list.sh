#!/bin/bash

DIR=/../panel_build/files

# VCF of all samples
VCF=$1
# get all sample list
bcftools query -l $VCF > $DIR/16905_sample_list

SAMPLE_rm=/../panel_build/plink_IBD/17K_related_sample_list

# remove related samples
cat $DIR/16905_sample_list $SAMPLE_rm | sort | uniq -c | awk '{if($1 == 1 ){print $2}}' > $DIR/final_sample_list
