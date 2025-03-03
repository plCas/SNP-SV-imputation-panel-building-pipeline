#!/bin/bash
# generate .bed file for each sample
# awk script check whether the SV is INS or not, if it was INS the svsize will be 0

R2_Threshold=$1 # 0, 0.2, 0.5, 0.8
sample_name_imp=$2

TMP=/../WGS_validation/SV_validation/by_sample/bed_files/imputations/$R2_Threshold
mkdir -p $TMP

# make bed file of each sample for imputation samples
VCF=/../WGS_validation/SV_validation/by_sample/vcfs/ADSP-SV_only/all_sv.vcf.gz

if [[ $R2_Threshold == 0 ]];then
    	bcftools view -s $sample_name_imp $VCF \
    	    | bcftools view -i "AC > 0" \
    	    | bcftools query -f "%CHROM\t%POS\t%END\t%ALT[\t%GT]\n" \
    	    | awk -F'\t' 'BEGIN {OFS="\t"} {
        	if ($4 !~ /INS/) {
            	    svsize = substr($4, index($4, "SVSIZE=") + 7);
            	    svsize = substr(svsize, 1, index(svsize, ":") - 1);
            	    $3 = $3 + svsize;
             	    }
       		print
        	}' \
    	    | awk '{ match($4, /<([^:]+):/, arr); print $1"\t"$2"\t"$3"\t"arr[1]"\t"$5 }' > $TMP/$sample_name_imp.bed
else
	bcftools view -i "R2 > $R2_Threshold" -s $sample_name_imp $VCF \
	    | bcftools view -i "AC > 0" \
	    | bcftools query -f "%CHROM\t%POS\t%END\t%ALT[\t%GT]\n" \
	    | awk -F'\t' 'BEGIN {OFS="\t"} {
		if ($4 !~ /INS/) {
		    svsize = substr($4, index($4, "SVSIZE=") + 7);
		    svsize = substr(svsize, 1, index(svsize, ":") - 1);
		    $3 = $3 + svsize;
		    }
		print
		}' \
	    | awk '{ match($4, /<([^:]+):/, arr); print $1"\t"$2"\t"$3"\t"arr[1]"\t"$5}' > $TMP/$sample_name_imp.bed
fi


