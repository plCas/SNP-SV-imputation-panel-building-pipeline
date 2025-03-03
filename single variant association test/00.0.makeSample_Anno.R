DIR="/../ADGC_sample_list/files/"

Pheno = read.table(paste0(DIR,"/ADGC_Pheno.34376_pc_updated_status.txt"), sep = "\t", header = T)

Sample_Anno = Pheno[,c("FID", "COHORT_x", "ETH")]
colnames(Sample_Anno) = c("sample.id", "Population", "SuperPopulation")
Sample_Anno$Project = "ADGC"

write.table(Sample_Anno, file = "/../association_test/ADSP-Short-Var/files/Sample_Annot_pooled", sep = "\t", quote = F, row.names = F)


for (i in c("ADGC_NHW", "ADGC_AA", "ADGC_Asian", "ADGC_Hispanic"))
{
  write.table(Sample_Anno %>% filter(SuperPopulation  == i), 
              file = paste0("/../association_test/ADSP-Short-Var/files/Sample_Annot_",i), 
              sep = "\t", quote = F, row.names = F)
  
}