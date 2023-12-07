import pandas as pd
import numpy as np
import re
import argparse 
parser = argparse.ArgumentParser() 
parser.add_argument("CHR") 
args = parser.parse_args() 

CHR=args.CHR

DIR="/qnap-wlee/wanpingleelab/chengp/impute_sv/SNP-SV_panel_redo/test_region_overlap"

df = pd.read_table(f"{DIR}/chr{CHR}.pos.txt", sep = "\t", header = None)
print(df.head())


chrSizeDic = {1 : 249000000,
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
    if i == 1:
        region_bins.append((i, i+999999))
        #print(f"{i}-{i+999999}")
    else:
        region_bins.append((i- 100000, i+999999))
        #print(f"{i-100000}-{i+999999}")

print(region_bins)

start_pos = []
end_pos   = []
for i, region in enumerate(region_bins):
    start = region[0]
    end   = region[1]
    #print(f"{start}-{end}")
    
    # check head 
    conditions = (df[0] >= start) & (df[0] <= start + 100000)
    if (df.loc[conditions,:].shape[0] != 0):
        start_pos.append(start)
    
    # check tail
    conditions = (df[0] >= end - 100000) & (df[0] <= end)
    
    if (df.loc[conditions,:].shape[0] !=0):
        end_pos.append(end)
    elif i == (len(region_bins)-1) :
        end_pos.append(end)

    if (len(end_pos) != 0) & (len(start_pos) == 0):
        start_pos.append(start)

print(f"{len(start_pos)} {len(end_pos)}")

for i, i2 in zip(start_pos, end_pos):
    print(f"chr{CHR}:{i}-{i2}\n")

with open(f"{DIR}/chr{CHR}.chunk.txt", "w") as file:
    for i, i2 in zip(start_pos, end_pos):
        file.write(f"chr{CHR}:{i}-{i2}\n")

