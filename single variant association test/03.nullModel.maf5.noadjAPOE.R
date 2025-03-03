args = commandArgs(trailingOnly=TRUE)
if (length(args)!=5) {
	        cat("\n")
        cat("Usage: Rscript --vanilla nullModel.R <GDS> <pcair.rds> <pcrel.rds> <Pheno_file> <out_prefix>\n")
	        cat("\tThe script will generate <Data_Prefix>.nullModel.rds.\n")
	        q(save="no")
}


library(SeqArray)
library(GENESIS)
library(Biobase)
library(SeqVarTools)
library(vcfR)
library(GWASTools)
library(dplyr)


# Input files:
# 1. Combined GDS file: "/<ethnicity name>.gds"
# 2. Cleaned phenotype file: "ADGC_Pheno.34376_pc_updated_status.txt"
# 3. PCs: "pcair.RDS"
# 4. GRM: "pcair.RDS"

## Read in GDS file ##
gdsfile <- args[1]
pcairfile <- args[2]
pcrelfile <- args[3]

#2.1 Create a SeqVarData object
#Read in phenotype dataa
pheno<-read.table(args[4], head=T, sep='\t')

# Output
nullmodelfile <- paste0(args[5], ".nullModel.rds")


# Import GRM (covariance matrix from pcrelate output)
print("readRDS(pcrelfile)")
gc()
pcrel <- readRDS(pcrelfile)
print(pryr::mem_used())
gc()
print(object.size(pcrel))
print("pcrelateToMatrix(pcrel, scaleKin=2)")
grm <- pcrelateToMatrix(pcrel, scaleKin=2)
print(pryr::mem_used())
print(object.size(grm))
rm(pcrel)
gc()


#Load GDS
print("Load GDS")
gds <- seqOpen(gdsfile)

#Create list of IDs from GDS file
sampleIds <- data.frame( sample.id=seqGetData(gds, 'sample.id') )
nrow(sampleIds)

#Left join phenotype data with GDS data
#Matches IDs where possible (some GDS IDs not in phenotype file)
#Does not re-order GDS IDs
pheno5 <- dplyr::left_join(sampleIds, pheno, by = c("sample.id" = "FID"))
nrow(pheno5)
pheno5 = pheno5[,c("sample.id","IID","sex","status")]
#Create metadata for AnnotatedDataFrame
metadata <- data.frame(labelDescription=c("sample.id","IID","sex","status"),row.names=names(pheno5))

#Create annotated data frame
annot <- AnnotatedDataFrame(pheno5, metadata)

#Merge GDS and annotated data frame to create SeqVarData
seqData <- SeqVarData(gds, sampleData=annot)

#3.2 Replacement: Using existing PCs
#Import PCA output
print("3.2 Replacement: Using existing PCs")
pcs <- readRDS(pcairfile)

#Convert to data frame
pc.df <- as.data.frame(pcs$vectors)
#nrow(pc.df)
names(pc.df) <- paste0("PC", 1:ncol(pcs$vectors))
pc.df$sample.id <- row.names(pcs$vectors)
pc.df <- left_join(pc.df, pData(annot), by="sample.id")

#Left join PC data with GDS IDs
#Does not re-order GDS IDs
pc.df <- dplyr::left_join(sampleIds, pc.df)
nrow(pc.df)

#4.1 Null Model
#Create annotated data frame
print("4.1 Null Model")
annot <- AnnotatedDataFrame(pc.df)

#Add annotated data frame to seqData
sampleData(seqData) <- annot

#Merge phenotype data with PC data
print("Merge phenotype data with PC data")
idsToKeep_df<-as.data.frame(rownames(grm))
names(idsToKeep_df)<-"sample.id"
pc.df_sub <- left_join(idsToKeep_df,pc.df)
nrow(pc.df_sub)

rownames(pc.df_sub)<-pc.df_sub$sample.id

# Fit the null model
#Final Null Model
print("Fit the null model")
Nullmod_CenterLengthPCR <- fitNullModel(seqData, outcome="status", covars=c("sex", paste0("PC", 1:10)), cov.mat=grm, family="binomial")

saveRDS(object = Nullmod_CenterLengthPCR, file = nullmodelfile)


