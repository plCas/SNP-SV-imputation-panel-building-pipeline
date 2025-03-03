library(dplyr)
library(tidyr)

#### input files ####
DIR_TP_wgs = "/../" # directory of bed files generate from "00.2.intersect_imp_wgs.sh" 
FILE_imp_sample_list="/../imp_sample_list"
FILE_imp_bed_position_only = "/../all_SV_imp_position-only.bed" # pre generate position only bed file from "all_SV_imp.bed"
OUTDIR="/../WGS_validation/SV_validation/by_var/bed_files"

#### main function ####
filesTP_wgs = list.files(DIR_TP_wgs)

imp_sample_list = read.table(FILE_imp_sample_list, sep = "\t", header = F)
file_list = paste0(imp_sample_list$V1, ".bed")
# check sample list
print("check sample list are match")
print(all(file_list %in% filesTP_wgs))
print(all(filesTP_wgs %in% file_list))

# imputed SVs bed
bed_imp = read.table(FILE_imp_bed_position_only, header = F)
colnames(bed_imp) = c("CHR", "START", "END", "SVTYPE")
DIM_Before = dim(bed_imp)

n=0
for (file in file_list)
{
    n = n+1
    print(n)
    df =  read.table(paste0(DIR_TP_wgs,"/",file), sep = "\t", header = F, fill = TRUE)
    colnames(df) = c("CHR", "START", "END", "SVTYPE", gsub(".bed", "", file) )
    bed_imp = bed_imp %>% left_join(df, by = c("CHR", "START", "END", "SVTYPE"))
}

DIM_After=dim(bed_imp)
print(paste0("dim before : ", DIM_Before))
print(paste0("dim after  : ", DIM_After))

# remain SVs present in both imputation and WGS dataset
print("remove all NA rows")
bed_imp[rowSums(!is.na(bed_imp[,5:ncol(bed_imp)]))>0,] # genotypes are started from column 5

# replace NA with 0|0
print("replace NA with 0|0")
bed_imp[is.na(bed_imp)] = "0|0"

print("save file")
write.table(bed_imp,
            file = paste0(OUTDIR, "/all_SV_wgs.bed"),
            sep = "\t", quote = F, row.names = F)
