#!/bin/bash
# intersect SVs between imputation and WGS for each sample

imp_all_bed=$1
wgs_all_bed=$2
output_sample_name=$3

DIR=/../WGS_validation/SV_validation/by_sample/bed_files
OUT=/../WGS_validation/SV_validation/by_var/bed_files/wgs
mkdir -p $OUT

# Intersect the BED file stratefied by SV types.
function intersect_bedfiles(){
    local svtype="$1"
    local imp_all_bed=$2
    local wgs_all_bed=$3

    if [[ "$svtype" == "INS" ]]; then
        # INS region +- 500bp tolerance for mapping $2=$2-500;$3=$3+500
	    # After mapping make the position back $2=$2+500;$3=$3-500
        bedtools intersect \
            -a <(awk '{$2=$2-500;$3=$3+500; print $1"\t"$2"\t"$3"\t"$4"\t"$5}' $imp_all_bed \
                    | awk -v svtype=$svtype '{if($4 == svtype){print $0}}' )  \
            -b <(awk '{$2=$2-500;$3=$3+500; print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$3-$2}' $wgs_all_bed \
                    | awk '{if(!($1 == "chrX" || $1 == "chrY" || $1 == "chrM")){print $0}}' \
                    | awk '{if($6 < 10000000){print $0}}' \
                    | awk -v svtype=$svtype '{if($4 == svtype){print $0}}' )  \
            -f 0.5 -r -wa -wb \
            | awk '{
                    $10 = gensub("/", "|", "g", $10);  # Replace "/" with "|" in column 10
                    key = $1"\t"$2"\t"$3"\t"$4;               # Create a key based on columns 1–4
                    if (!seen[key]) {                         # Initialize array for new key
                        rows[key] = $0;
                        seen[key] = ($5 == $10);
                    } else if ($5 == $10 && !seen[key]) {     # If $5 == $10, overwrite with the matching row
                        rows[key] = $0;
                        seen[key] = 1;
                    }
                }
                END {
                    for (key in rows) {                       # Output all stored rows
                        print rows[key];
                    }
                }' \
            | awk '{$2=$2+500;$3=$3-500; print $1"\t"$2"\t"$3"\t"$4"\t"$10}' | sort |uniq
    else
        bedtools intersect \
            -a <(awk -v svtype=$svtype '{if($4 == svtype){print $0}}' $imp_all_bed )  \
            -b <(awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$3-$2}' $wgs_all_bed \
                        | awk '{if(!($1 == "chrX" || $1 == "chrY" || $1 == "chrM")){print $0}}' \
                        | awk '{if($6 < 10000000){print $0}}' \
                        | awk -v svtype=$svtype '{if($4 == svtype){print $0}}' )  \
            -f 0.5 -r -wa -wb \
            | awk '{
                    $10 = gensub("/", "|", "g", $10);  # Replace "/" with "|" in column 10
                    key = $1"\t"$2"\t"$3"\t"$4;               # Create a key based on columns 1–4
                    if (!seen[key]) {                         # Initialize array for new key
                        rows[key] = $0;
                        seen[key] = ($5 == $10);
                    } else if ($5 == $10 && !seen[key]) {     # If $5 == $10, overwrite with the matching row
                        rows[key] = $0;
                        seen[key] = 1;
                    }
                }
                END {
                    for (key in rows) {                       # Output all stored rows
                        print rows[key];
                    }
                }' \
            |awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$10}' | sort |uniq 
        fi
}

intersect_bedfiles "INS" "$imp_all_bed" "$wgs_all_bed" >  $OUT/$output_sample_name.bed
intersect_bedfiles "DEL" "$imp_all_bed" "$wgs_all_bed" >> $OUT/$output_sample_name.bed
intersect_bedfiles "DUP" "$imp_all_bed" "$wgs_all_bed" >> $OUT/$output_sample_name.bed
