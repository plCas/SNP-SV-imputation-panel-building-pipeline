#!/bin/bash

R2_threshold=$1 # 0, 0.2, 0.5, 0.8
# Input the corresponding sample ID in case WGS and array use different IDs for the same sample.
$output_sample_name=$2
imp_all_bed=$3
wgs_all_bed=$4


DIR=/../WGS_validation/SV_validation/by_sample/bed_files
OUT=/../WGS_validation/SV_validation/by_sample/res
mkdir -p $OUT

function compare_gt(){
    local svtype="$1"
    local output_sample_name=$2
    local imp_all_bed=$3
    local wgs_all_bed=$4

    if [[ "$svtype" == "INS" ]]; then
        # INS region +- 500bp tolerance for mapping
        TP=$(bedtools intersect \
            -a <(awk '{$2=$2-500;$3=$3+500; print $1"\t"$2"\t"$3"\t"$4}' $imp_all_bed \
                    | awk -v svtype=$svtype '{if($4 == svtype){print $0}}' )  \
            -b <(awk '{$2=$2-500;$3=$3+500; print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$3-$2}' $wgs_all_bed \
                    | awk '{if(!($1 == "chrX" || $1 == "chrY" || $1 == "chrM")){print $0}}' \
                    | awk '{if($6 < 10000000){print $0}}' \
                    | awk -v svtype=$svtype '{if($4 == svtype){print $0}}' )  \
            -f 0.5 -r -wa \
            |sort|uniq |wc -l)
        FP=$(bedtools intersect \
            -a <(awk '{$2=$2-500;$3=$3+500; print $1"\t"$2"\t"$3"\t"$4}' $imp_all_bed \
                    | awk -v svtype=$svtype '{if($4 == svtype){print $0}}' )  \
            -b <(awk '{$2=$2-500;$3=$3+500; print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$3-$2}' $wgs_all_bed \
                    | awk '{if(!($1 == "chrX" || $1 == "chrY" || $1 == "chrM")){print $0}}' \
                    | awk '{if($6 < 10000000){print $0}}' \
                    | awk -v svtype=$svtype '{if($4 == svtype){print $0}}' )  \
            -f 0.5 -r -v \
            |sort|uniq |wc -l)
        FN=$(bedtools intersect \
            -a <(awk '{$2=$2-500;$3=$3+500; print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$3-$2}' $wgs_all_bed \
                | awk '{if(!($1 == "chrX" || $1 == "chrY" || $1 == "chrM")){print $0}}' \
                | awk '{if($6 < 10000000){print $0}}' \
                | awk -v svtype=$svtype '{if($4 == svtype){print $0}}' )  \
            -b <(awk '{$2=$2-500;$3=$3+500; print $1"\t"$2"\t"$3"\t"$4}' $imp_all_bed \
                    | awk -v svtype=$svtype '{if($4 == svtype){print $0}}' )  \
            -f 0.5 -r -v \
            |sort|uniq |wc -l)
    else
        TP=$(bedtools intersect \
            -a <(awk -v svtype=$svtype '{if($4 == svtype){print $0}}' $imp_all_bed )  \
            -b <(awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$3-$2}' $wgs_all_bed \
                        | awk '{if(!($1 == "chrX" || $1 == "chrY" || $1 == "chrM")){print $0}}' \
                        | awk '{if($6 < 10000000){print $0}}' \
                        | awk -v svtype=$svtype '{if($4 == svtype){print $0}}' )  \
            -f 0.5 -r -wa \
            |sort|uniq |wc -l)
        FP=$(bedtools intersect \
            -a <(awk -v svtype=$svtype '{if($4 == svtype){print $0}}' $imp_all_bed )  \
            -b <(awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$3-$2}' $wgs_all_bed \
                        | awk '{if(!($1 == "chrX" || $1 == "chrY" || $1 == "chrM")){print $0}}' \
                        | awk '{if($6 < 10000000){print $0}}' \
                        | awk -v svtype=$svtype '{if($4 == svtype){print $0}}' )  \
            -f 0.5 -r -v \
            |sort|uniq |wc -l)
        FN=$(bedtools intersect \
            -a <(awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$3-$2}' $wgs_all_bed \
                | awk '{if(!($1 == "chrX" || $1 == "chrY" || $1 == "chrM")){print $0}}' \
                | awk '{if($6 < 10000000){print $0}}' \
                | awk -v svtype=$svtype '{if($4 == svtype){print $0}}' )  \
            -b <(awk -v svtype=$svtype '{if($4 == svtype){print $0}}' $imp_all_bed )  \
            -f 0.5 -r -v \
            |sort|uniq |wc -l)
    fi

    echo -e "$svtype\t$sample_name_wgs\t$TP\t$FP\t$FN" 
}


if [[ $SLURM_ARRAY_TASK_ID == 0 ]];then
    echo -e "SVTYPE\tsample_id\tTP\tFP\tFN" > $OUT/R2_${R2_threshold}.txt
fi

compare_gt "INS" $output_sample_name $imp_all_bed $wgs_all_bed >> $OUT/R2_${R2_threshold}.txt
compare_gt "DEL" $output_sample_name $imp_all_bed $wgs_all_bed >> $OUT/R2_${R2_threshold}.txt
compare_gt "DUP" $output_sample_name $imp_all_bed $wgs_all_bed >> $OUT/R2_${R2_threshold}.txt
