#!/bin/bash

R2_threshold=0.8

OUT=/../WGS_validation/SV_validation/by_var/bed_files
mkdir -p $OUT

VCF=/../all_sv.vcf.gz


# first awk generate END position; second generate SVTYPE
bcftools view -i "R2 > $R2_threshold && AC > 0" $VCF \
    | bcftools query -f "%CHROM\t%POS\t%END\t%ALT[\t%GT]\n" \
    | awk -F'\t' 'BEGIN {OFS="\t"} {
	if ($4 !~ /INS/) {
	    svsize = substr($4, index($4, "SVSIZE=") + 7);
	    svsize = substr(svsize, 1, index(svsize, ":") - 1);
	    $3 = $3 + svsize;
	    }
	print
	}' \
    | awk '{
        match($4, /<([^:]+):/, arr);
        printf "%s\t%s\t%s\t%s", $1, $2, $3, arr[1];
        for (i = 5; i <= NF; i++) {
            printf "\t%s", $i;
        }
        printf "\n";
        }'  > $OUT/all_SV_imp.bed


