#!/bin/bash

TEST_VCF=$1
TRUTH_VCF=$2
OUT=$3

/../aggRSquare/release-build/aggRSquare \
	-v $TRUTH_VCF \
    -i $TEST_VCF \
	--bins /../bin_used.txt \
	--imputationFormat GT \
    -o $OUT
