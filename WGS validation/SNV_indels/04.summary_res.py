'''
Usage:
    python3 04.summary_res.py ADSP-Short-Var ADGC_AA 
'''
import pandas as pd
import numpy as np
import re
import argparse 
parser = argparse.ArgumentParser()
parser.add_argument("panel") # ADSP-Short-Var, ADSP-All-Var, TOPMed, meta
parser.add_argument("eth") # ADGC_NHW, ADGC_AA, ADGC_Asian, ADGC_Hispanic
args = parser.parse_args()


DIR=f"/../WGS_validation/SNV_Indel/aggRsquare/{args.panel}/{args.eth}"

Prefix=DIR

data = pd.read_table(f"{DIR}/chr1.rowdata", sep= "\t")
data["#Variants"] = [0]*data.shape[0]
df_agg = pd.read_table(f"{DIR}/chr1.aggRSquare", sep= "\t", skiprows=8)

print(data.shape)
print(df_agg.head())

condition = data["#Bin.Aggregated.by.MAF"].isin(data["#Bin.Aggregated.by.MAF"].to_list())
data.loc[condition,"#Variants"] = data.loc[condition,"#Variants"].values + df_agg["#Variants"].values


for CHR in range(2, 23, 1):
    df = pd.read_table(f"{DIR}/chr{CHR}.rowdata", sep= "\t")
    df_agg = pd.read_table(f"{DIR}/chr{CHR}.aggRSquare", sep= "\t", skiprows=8) 
    
    # check whether the order of the two Bin columns are identical or not
    condition = data["#Bin.Aggregated.by.MAF"].isin(df["#Bin.Aggregated.by.MAF"].to_list())

    for col in df.columns[1:7]:
        data.loc[condition,col] = data.loc[condition,col].values + df[col].values

    data.loc[condition,"#Variants"] = data.loc[condition,"#Variants"].values + df_agg["#Variants"].values

print(data)


df_out = pd.DataFrame()

df_out["#Bin.Aggregated.by.MAF"] = data["#Bin.Aggregated.by.MAF"]
df_out["EX"] = data["sumX"]/data["n"]
df_out["EY"] = data["sumY"]/data["n"]
df_out["varX"] = data["sumX2"]/data["n"] - df_out["EX"]*df_out["EX"] 
df_out["varY"] = data["sumY2"]/data["n"] - df_out["EY"]*df_out["EY"]
df_out["cov"]  = data["sumXY"]/data["n"] - df_out["EX"]*df_out["EY"]

df_out["R2"] = 1.0*(df_out["cov"]/df_out["varX"])*(df_out["cov"]/df_out["varY"])
df_out["#Variants"] = data["#Variants"]

print(df_out[["#Bin.Aggregated.by.MAF", "R2", "#Variants"]])

df_out[["#Bin.Aggregated.by.MAF", "R2", "#Variants"]].to_csv(f"{Prefix}.merged", sep = "\t", index = None)

print(f"File save at:  {Prefix}.merged")

