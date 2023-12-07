#!/bin/bash

RMLIST=/qnap-wlee/wanpingleelab/chengp/36K_panel_build/plink_IBD/sample_to_be_removed.txt
SAMPLE_LIST=/qnap-wlee/wanpingleelab/chengp/36K_panel_build/plink_IBD/sample_list.36361.txt

DIR=/qnap-wlee/wanpingleelab/chengp/36K_panel_build/final_sample_list
mkdir -p $DIR

OUT=$DIR/sample_list.final.txt
TMP_FILE=$DIR/tmp_file.txt

filelist=()
while read F  ; do
        #echo $F
        filelist+=($F)
done < $RMLIST

NUM=${#filelist[@]}
echo "total $NUM"

sed "/${filelist[0]}/d" $SAMPLE_LIST > $OUT
for ((i=1; i<$NUM; i++)); do
    echo "rm $i ${filelist[$i]}"
    sed "/${filelist[$i]}/d" $OUT > $TMP_FILE
    mv $TMP_FILE $OUT
done

