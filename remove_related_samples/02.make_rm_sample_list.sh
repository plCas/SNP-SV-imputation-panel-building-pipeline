#!/bin/bash


DIR=/../panel_build/plink_IBD

OUT=$DIR/sample_to_be_removed.txt

# Find IBD > 0.4 samples; merge IID1 and IID2 into 1 column
echo "make list"
#awk '{if ($10 > 0.4) {print}}' $DIR/all_bed.bi.IBD.genome > $DIR/IBD_over_0.4_sample_list.txt

cp $DIR/IBD_over_0.4_sample_list.txt $DIR/IBD_over_0.4_sample_list_sed.txt

counts=2

FILE=$DIR/IBD_over_0.4_sample_list_sed.txt
FILE1=$DIR/IBD_over_0.4_sample_list_sed1.txt
FILE2=$DIR/IBD_over_0.4_sample_list_merge.txt

while [ $counts -gt 1 ]; do

    awk '{print $2"\n"$4}' $FILE > $FILE2

    echo "remove sample"


    counts=$(cat $FILE2 |sort | uniq -c |sort -n | tail -n1| awk '{print $1}')
    rm_sample=$(cat $FILE2 |sort | uniq -c |sort -n| tail -n1| awk '{print $2}')
    if [ $counts -gt 1 ]; then
        echo "$counts $rm_sample"
        echo "$rm_sample" >> $OUT

        sed "/$rm_sample/d" $FILE > $FILE1
        mv $FILE1 $FILE
    fi

done

# concat multiple duplicated/related samples and single paired duplicated/related samples

cat <(awk '{print $4}' $DIR/IBD_over_0.4_sample_list_sed.txt | sed 1d) <(cat $OUT) > $DIR/17K_related_sample_list



