#!/bin/bash

CHR=$1

CHUNKS=/qnap-wlee/wanpingleelab/chengp/36K_panel_build/test_region_overlap/chr$CHR.chunk.txt

FILES=($(find /qnap-wlee/wanpingleelab/chengp/36K_panel_build/vcfs/phased/chr$CHR -type f -iname "*.vcf.gz"))
for i in ${FILES[*]};do basename ${i%%.phased.vcf.gz} >> ./tmp.txt;done

paste $CHUNKS ./tmp.txt |awk '{print $1"\n"$2}'|sort|uniq -c|less

rm ./tmp.txt
