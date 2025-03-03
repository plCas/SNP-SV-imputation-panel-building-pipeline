library(dplyr)
library(tidyr)

#### input files ####
file_bed_wgs = "/qnap-wlee/wanpingleelab/chengp/imputation/imputation_panel_12.02.24/WGS_validation/SV_validation/by_var/bed_files/all_SV_wgs.bed"
file_bed_imp = "/qnap-wlee/wanpingleelab/chengp/imputation/imputation_panel_12.02.24/WGS_validation/SV_validation/by_var/bed_files/all_SV_imp.bed"
OUTDIR="/qnap-wlee/wanpingleelab/chengp/imputation/imputation_panel_12.02.24/WGS_validation/SV_validation/by_var/bed_files"

#### main function ####
print("read wgs bed")
df.wgs= read.table(file_bed_wgs, sep = "\t", header = T)
# remove SVs with all samples are NA
print("remove SVs with all samples are NA")
df.wgs[rowSums(!is.na(df.wgs[,5:ncol(df.wgs)]))>0,]

print("read imp bed")
df.imp= read.table(file_bed_imp, sep = "\t", header = T)
colnames(df.imp)[1:4] = c("CHR", "START", "END", "SVTYPE")

df.wgs.ids = paste0(df.wgs$CHR, df.wgs$START, df.wgs$END, df.wgs$SVTYPE)
df.imp.ids = paste0(df.imp$CHR, df.imp$START, df.imp$END, df.imp$SVTYPE)

# consensus IDs
IDs.consensus = intersect(df.wgs.ids, df.imp.ids)

print("subset wgs bed")
df.wgs.consensus = df.wgs %>% filter(df.wgs.ids %in% IDs.consensus )
print("subset imp bed")
df.imp.consensus = df.imp %>% filter(df.imp.ids %in% IDs.consensus )

print("save new wgs bed")
write.table(df.wgs.consensus,
            file = paste0(OUTDIR, "/wgs_all_consensus.bed"),
            sep = "\t", quote = F, row.names = F)
print("save new imp bed")
write.table(df.imp.consensus,
            file = paste0(OUTDIR, "/imp_all_consensus.bed"),
            sep = "\t", quote = F, row.names = F)
