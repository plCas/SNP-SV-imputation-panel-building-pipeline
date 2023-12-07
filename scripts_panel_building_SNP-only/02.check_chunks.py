import pandas as pd
import numpy as np
import re
import argparse 
parser = argparse.ArgumentParser() 
parser.add_argument("CHR") 
args = parser.parse_args() 

CHR = args.CHR

DIR="/qnap-wlee/wanpingleelab/chengp/36K_panel_build/test_region_overlap"

df = pd.read_table(f"{DIR}/chr{CHR}.pos.txt", sep = "\t", header = None)
print(df.head())

df_chunks = pd.read_table(f"{DIR}/chr{CHR}.chunk.txt", sep = "\t", header = None)
df_chunks = df_chunks.rename(columns = {0 : "region"})
print(df_chunks.head())

print(f"region\thead\ttail")
for i in range(df_chunks.shape[0]):
    # confirm chunks
    region = df_chunks.loc[i, 'region']
    match = re.match("chr[0-9]+:([0-9]+)-([0-9]+)", region)
    start = int(match.group(1))
    end   = int(match.group(2))

    # check head 
    conditions = (df[0] >= start) & (df[0] <= start + 100000)
    head = df.loc[conditions,:].shape[0]
    #print(df.loc[conditions,:].shape)
    # check tail
    conditions = (df[0] >= end - 100000) & (df[0] <= end)
    #print(df.loc[conditions,:].shape)
    tail = df.loc[conditions,:].shape[0]

    print(f"{region}\t{head}\t{tail}")
