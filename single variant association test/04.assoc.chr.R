args = commandArgs(trailingOnly=TRUE)
print(args)
if (length(args)!=5) {
	        cat("\n")
        cat("Usage: Rscript --vanilla assoc.R <gds> <pheno> <null.model> <out_prefix> <chr>\n")
	        cat("\tThe script will search <Data_Prefix>.gds and <Data_Prefix>.nullModel.rds as inputs.\n")
	        cat("\tThe script will generate <Data_Prefix>.assoc.rds and <Data_Prefix>.assoc.csv.\n")
		        q(save="no")
}

library(SeqArray)
library(GENESIS)
library(Biobase)
library(SeqVarTools)
library(vcfR)
library(GWASTools)
library(dplyr)


## Read in GDS file ##
gdsfile <- args[1]
phenofile <- args[2]
nullmodelfile <- args[3]

# Output
out_prefix <- args[4]
chr <- args[5]
assocfile <- paste0(out_prefix, ".chr", chr, ".assoc.rds")
assoccsv <- paste0(out_prefix, ".chr", chr, ".assoc.csv")

print(gdsfile)
gds <- seqOpen(gdsfile)

#Read in phenotype dataa
pheno<-read.table(phenofile, head=T, sep='\t')


#Create list of IDs from GDS file
sampleIds <- data.frame( sample.id=seqGetData(gds, 'sample.id') )
nrow(sampleIds)

#Left join phenotype data with GDS data
#Matches IDs where possible (some GDS IDs not in phenotype file)
#Does not re-order GDS IDs
pheno5 <- dplyr::left_join(sampleIds, pheno, by=c("sample.id" = "FID") )
nrow(pheno5)


#Create metadata for AnnotatedDataFrame
metadata <- data.frame(labelDescription=c("sample.id","IID","sex","status","ETH","COHORT_x"),row.names=names(pheno5))


#Create annotated data frame
annot <- AnnotatedDataFrame(pheno5, metadata)

#Merge GDS and annotated data frame to create SeqVarData
seqData <- SeqVarData(gds, sampleData=annot)
seqSetFilterChrom(seqData, include=chr)


#Left join PC data with GDS IDs
#Does not re-order GDS IDs

print("load nullmodel")
Nullmod_GRM<-readRDS(nullmodelfile)
print("SeqVarBlockIterator")
iterator <- SeqVarBlockIterator(seqData, variantBlock=2000, verbose=FALSE)
print("assocTestSingle")
#assoc <- assocTestSingle(iterator, Nullmod_GRM, BPPARAM=BiocParallel::SerialParam(), verbose=FALSE)
assoc <- assocTestSingle(iterator, Nullmod_GRM, BPPARAM=BiocParallel::MulticoreParam(8), verbose=TRUE)

saveRDS(object = assoc, file = assocfile)
write.csv(assoc, file = assoccsv)

