library(dplyr)
library(tidyr)

# all independent sample list
FILES="/../WGS_validation/WGS_sample_list/files/independent_sample_list.txt"

df = read.table(FILES, sep = "\t", header = T)

# used sample lists
DIR="/../WGS_validation/SNV_Indel/files"

df.used.samples = data.frame()
for (ETH in c("ADGC_AA", "ADGC_Asian", "ADGC_Hispanic", "ADGC_NHW"))
{
  df.eth = read.table(paste0(DIR,"/",ETH,"_sample_list.txt"), sep = "\t", header = F)
  df.used.samples = rbind(df.used.samples , df.eth) %>% data.frame()
}

df.sel = df %>% filter(USEDID %in% df.used.samples$V1) %>% select(USEDID, SampleID)

OUTDIR = "/../WGS_validation/SV_validation/files"
write.table(df.sel, file = paste0(OUTDIR, "/36K_ADGC_WGSID_GWASID.txt"), sep = "\t", quote = F, row.names = F, col.names = F)
