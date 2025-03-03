#!/bin/bash

DIR=/../WGS_validation/SV_validation/by_sample/vcfs/ADSP-SV_only
FILES=$(ls -v $DIR/*.vcf.gz)

bcftools concat $FILES -oz -o $DIR/all_sv.vcf.gz
bcftools index -t $DIR/all_sv.vcf.gz
