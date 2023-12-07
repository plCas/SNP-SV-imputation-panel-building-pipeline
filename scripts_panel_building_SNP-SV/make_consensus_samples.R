args = commandArgs(T)

#DIR="/mnt/adsp/users/polian/impute_sv/vcfs/sv_vcfs"

#getwd()
#setwd(DIR)

df1 = read.table(args[1])
df2 = read.table(args[2])

intersect.sampmles = intersect(df1$V1,df2$V1)

write.table(intersect.sampmles, args[3], sep = "\t",quote = F, row.names = F, col.names = F)

all.equal(df1$V1,df2$V1)

length(intersect.sampmles)

