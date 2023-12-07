'''
# check whether variants exist in overlap region of each chunk for phasing
'''
import pandas as pd
import numpy as np
#import argparse
import multiprocessing

#parser = argparse.ArgumentParser() 
#parser.add_argument("chr") 
#args = parser.parse_args() 
#CHR = args.chr

DIR="/qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo/test_region_overlap"

def process_chr(CHR):

    df = pd.read_table(f"{DIR}/chr{CHR}.pos.txt", sep = "\t", header = None)
    print(df.head())

    chrSizeDic = {1	: 249000000,
                  2 : 243000000,
                  3 : 199000000,
                  4 : 191000000,
                  5 : 182000000,
                  6 : 171000000,
                  7 : 160000000,
                  8 : 146000000,
                  9 : 139000000,
                  10: 134000000,
                  11: 136000000,
                  12: 134000000,
                  13: 115000000,
                  14: 108000000,
                  15: 102000000,
                  16: 91000000,
                  17: 84000000,
                  18: 81000000,
                  19: 59000000,
                  20: 65000000,
                  21: 47000000,
                  22: 51000000}

    length = chrSizeDic[int(CHR)]
    region_length = 1000000

    region_bins = []
    for i in range(1, length, region_length):
        region_bins.append((i, i+999999- 100000, i+999999))
        print(f"{i}  {i+999999- 100000} -{i+999999}")

    ## define functions
    # assign bins
    def assign_bin(pos):
        for i in range(len(region_bins)):
            if (pos >= region_bins[i][0]) & (pos <= region_bins[i][2]):
                return f"{region_bins[i][0]}-{region_bins[i][2]}"

    # check overlap
    def check_overlap(pos):
        for i in range(len(region_bins)):
            if (pos >= region_bins[i][0]) & (pos <= region_bins[i][2]):
                if (pos >= region_bins[i][1]) & (pos <= region_bins[i][2]):
                    return "overlap"
                else:
                    return "no_overlap"

    print("assign bins")
    #df["region"] = df.iloc[:100,0].apply(lambda x: assin_bin(x))
    df["region"] = df.iloc[:,0].apply(lambda x: assign_bin(x))
    print(df["region"].value_counts())


    print("check overlap")
    #df["overlap"] = df.iloc[:100,0].apply(lambda x: check_overlap(x))
    df["overlap"] = df.iloc[:,0].apply(lambda x: check_overlap(x))
    print(df.loc[:,["region", "overlap"]].head())
    print(df.loc[:,["region", "overlap"]].value_counts())
    df_pivot = df.loc[:,["region", "overlap"]].value_counts().reset_index()
    df_pivot = df_pivot.sort_values(by = ["region", "overlap"])
    print(df_pivot.head())

    df_pivot = df_pivot.rename(columns = {0 : "Values"})

    df_pivot = df_pivot.pivot(index="region", columns="overlap", values="Values").reset_index()
    df_pivot.columns.name = None
    print("results")
    print(df_pivot.head())
    
    df_out = pd.DataFrame(region_bins)
    df_out = df_out.rename(columns = {0: 'start', 1:'in', 2:'end'})
    df_out["region"] = df_out['start'].astype(str) + "-" + df_out['end'].astype(str)

    df_out = df_out.merge(df_pivot, how = "left", on = "region")
   
    # relabel output chunk
    start_new = []
    end_new   = []

    start_old = df_out["start"]
    end_old   = df_out["end"]

    for i, no_overlap, overlap in zip(df_out.index, df_out["no_overlap"].isna(), df_out["overlap"].isna()):
        print(f"{i}, {no_overlap}, {overlap}")
        if (no_overlap == True) & (overlap ==False):
            if len(start_new) == len(end_new ):
                start_new.append(start_old[i])
                end_new.append(end_old[i])
            elif len(start_new) != len(end_new ):
                end_new.append(end_old[i])
        elif (no_overlap == False) & (overlap == True):
            start_new.append(start_old[i] - 100000)
            if i == len(df_out.index)-1:
                end_new.append(end_old[i])
            elif len(start_new) > len(end_new ):
                end_new.append(end_old[i])
        elif (no_overlap == False) & (overlap == False):
            if len(start_new) == len(end_new ):
                if len(start_new) == 0 & len(end_new ) == 0:
                    start_new.append(start_old[i])
                else:
                    start_new.append(start_old[i] - 100000)
                end_new.append(end_old[i])
            elif len(start_new) != len(end_new ):
                end_new.append(end_old[i])
        elif (no_overlap == True) & (overlap == True):
            if (i < max(df_out.index)) &  (len(start_new) == len(end_new )):
                start_new.append(start_old[i] - 100000)
        else:
            pass
        print(f"{len(start_new)}, {len(end_new)}")

    df_out_final = pd.DataFrame({ "region" : [f"chr{CHR}:{i}-{i2}" for i,i2 in zip (start_new, end_new)]})  

    return (df_out_final)

if __name__ == '__main__':
    pool = multiprocessing.Pool()
    results = pool.map(process_chr, range(1, 23))
    for result,CHR in zip(results, [i for i in range(1,23)]):
        result.to_csv(f"{DIR}/chr{CHR}.chunk.txt", sep = "\t", index = None, header = None)
        #result.to_csv(f"/qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo/test_region_overlap_tmp/chr{CHR}.chunk.txt", sep = "\t", index = None, header = None)
    pool.close()
    pool.join()

#df_out.to_csv(f"{DIR}/chr{CHR}.chunk.txt", sep = "\t", index = None)


