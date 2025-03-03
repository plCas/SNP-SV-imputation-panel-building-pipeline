#!/bin/bash

DIR=/../

# Produce bedlist.txt
for ((i=2;i<=22;i++));do 
	echo $DIR/chr$i.bi >> $DIR/bedlist.txt
done

bedlist=$DIR/bedlist.txt
bfile=$DIR/chr1.bi

plink=/../plink1.9/plink

$plink --bfile $bfile --merge-list $bedlist --make-bed --out $DIR/all_bed.bi