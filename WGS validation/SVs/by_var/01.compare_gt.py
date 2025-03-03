'''
Usage: 
    python3 compare_gt.py <FILE_WGS> <FILE_IMP> <OUTPREFIX> <NCORE> <chunk_length> <MODE>
    
FILE_WGS="/../WGS_validation/SV_validation/by_var/bed_files/wgs_all_consensus.bed"
FILE_IMP="/../WGS_validation/SV_validation/by_var/bed_files/imp_all_consensus.bed"
OUTPREFIX="/../accuracy_mode0.txt"
python3 compare_gt.py $FILE_WGS $FILE_IMP $OUTPREFIX 4 100 0

# mode == 0 : genotype = 0, 1, 2; mode == 1 : genotyp = 0, 1

'''

import sys
import os
import gzip
import re
import numpy as np
import pandas as pd
from itertools import islice
import multiprocessing
import argparse 
parser = argparse.ArgumentParser() 
parser.add_argument("wgs") 
parser.add_argument("imp") 
parser.add_argument("OUTPREFIX") 
parser.add_argument("NCORE")
parser.add_argument("chunk_length")
parser.add_argument("MODE")
args = parser.parse_args() 

def compare_gt(i_imp_gt, i_wgs_gt, mode = 0):
    imp_gt = int(i_imp_gt[0]) + int(i_imp_gt[2])
    wgs_gt = int(i_wgs_gt[0]) + int(i_wgs_gt[2])

    # 0 1 mode
    change=lambda x: 1 if x>0 else x
    if mode == 1:
        imp_gt, wgs_gt=change(imp_gt), change(wgs_gt)

    if wgs_gt == imp_gt:
        if wgs_gt >0:
            return("TP")
        elif wgs_gt ==0:
            return("TN")
    elif wgs_gt > imp_gt:
        return("FN")
    elif wgs_gt < imp_gt:
        return("FP")

def cal_values(res_matched):
    #print(res_matched)
    TP, TN, FP, FN  = res_matched.count("TP"), res_matched.count("TN"), res_matched.count("FP"), res_matched.count("FN")
    return(TP, TN, FP, FN)

def get_first_line(FILE):
    num = 0
    with open(FILE,"r") as f:
        for line in f:
            if line[:3] != "CHR":
                return(num)
            num += 1

def get_last_line(FILE):
    num = 0
    with open(FILE,"r") as f:
        for line in f:
            num += 1  
        return(num)  

def calculator(FILE_IMP, FILE_WGS, n_line_start_imp, n_line_end_imp, n_line_start_wgs, n_line_end_wgs, MODE):
    var_ids, AF_imps, AF_wgss, TPs, TNs, FPs, FNs = [], [], [], [], [], [], []
    with open(FILE_IMP,"r") as f_imp, open(FILE_WGS,"r") as f_wgs:
        # slice files
        f_imp_slice = islice(f_imp, n_line_start_imp, n_line_end_imp) 
        f_wgs_slice = islice(f_wgs, n_line_start_wgs, n_line_end_wgs)       
        for line_wgs, line_imp in zip(f_wgs_slice, f_imp_slice):
            # intialize parameters
            TP, TN, FP, FN = np.nan, np.nan, np.nan, np.nan
            # get var id
            var_id = "_".join(line_imp.replace("\n", "").split("\t")[:4])
            # get genotypes
            imp_gt = np.array( line_imp.replace("\n", "").split("\t")[4:] ) 
            wgs_gt = np.array( line_wgs.replace("\n", "").split("\t")[4:] )
            # calculate AF
            Imp_gt_string = "".join(imp_gt)
            wgs_gt_string = "".join(wgs_gt)
            try:
                AF_imp = (Imp_gt_string.count("1")) / (Imp_gt_string.count("1") + Imp_gt_string.count("0"))
                AF_wgs = (wgs_gt_string.count("1")) / (wgs_gt_string.count("1") + wgs_gt_string.count("0"))
            except ZeroDivisionError:
                AF_imp, AF_wgs = np.nan, np.nan
            # compare genotype concordnace
            if (AF_imp > 0 )&(AF_wgs > 0):
                # calculate consistency
                res_matched = [ compare_gt(i_imp_gt, i_wgs_gt, mode = MODE) for i_imp_gt,i_wgs_gt in zip(imp_gt, wgs_gt) ]
                TP, TN, FP, FN = cal_values(res_matched)
            var_ids.append(var_id)
            AF_imps.append(AF_imp)
            AF_wgss.append(AF_wgs)
            TPs.append(TP) 
            TNs.append(TN) 
            FPs.append(FP) 
            FNs.append(FN)
    df = pd.DataFrame({
        "var_id" : var_ids, 
        "AF_imp" : AF_imps, 
        "AF_wgs" : AF_wgss, 
        "TP" : TPs,
        "TN" : TNs, 
        "FP" : FPs,
        "FN" : FNs
    })
    return(df)

# main process
if __name__ == "__main__":
    # input files
    FILE_WGS=args.wgs
    FILE_IMP=args.imp
    OUTPREFIX = args.OUTPREFIX

    # input parameters
    n_core = int(args.NCORE) 
    #chunk_length = 100000
    chunk_length = int(args.chunk_length)
    MODE    = int(args.MODE)
    
    # get the number of first and last row 
    num_first_line_imp, num_last_line_imp = get_first_line(FILE_IMP), get_last_line(FILE_IMP)
    num_first_line_wgs, num_last_line_wgs = get_first_line(FILE_WGS), get_last_line(FILE_WGS)
    # List of numbers to process
    numbers_imp = [i for i in range(num_first_line_imp, num_last_line_imp, chunk_length)]
    numbers_wgs = [i for i in range(num_first_line_wgs, num_last_line_wgs, chunk_length)]
    inputs = [(FILE_IMP, FILE_WGS, param_imp, param_imp + chunk_length, param_wgs, param_wgs + chunk_length, MODE) for param_imp, param_wgs in zip(numbers_imp, numbers_wgs)]

    # Create a pool of worker processes
    with multiprocessing.Pool(processes=n_core) as pool:
        # Map the function 'square' to the list of numbers
        results = pool.starmap(calculator, inputs)

    df_res = pd.DataFrame()
    for res in results:
        df_res = pd.concat([df_res, res])
    print(df_res.head())
    df_res.to_csv(f"{OUTPREFIX}", sep = "\t", index = None)
