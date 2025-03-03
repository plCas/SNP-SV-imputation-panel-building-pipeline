#!/usr/bin/env Rscript

##### Parse parameters #####
args = commandArgs(trailingOnly=TRUE)
if (length(args)!=3) {
  cat("\n")
  cat("Usage: Rscript --vanilla pcair.r <GDS> <Sample_Annot File> <Out_Prefix>\n")
  cat("\tSample Annot file is tab-delimited with the header: sample.id Population SuperPopulation Project\n\n")
  q(save="no")
}

library(SeqArray)
library(GENESIS)
library(Biobase)
library(SeqVarTools)
library(SNPRelate)
library(dplyr)
library(GGally)
library(RColorBrewer)

##### Inputs #####
gdsfile <- args[1]

# Annot file format is
# sample.id  Population  SuperPopulation Project
# Note: The order of samples should match to VCF.
annotfile <- args[2]

##### Output #####
outprefix <- args[3]
kingfile <- paste0(outprefix, ".king.rds")
pcairfile <- paste0(outprefix,".pcair.rds")
pcrelfile <- paste0(outprefix, ".pcrel.rds")
pccsv <- paste0(outprefix, ".pc.csv")

# Load VCF
gds <- seqOpen(gdsfile)
annot <- read.table(annotfile, head=T, sep='\t')
annot$outcome <- rnorm(nrow(annot))
metadata <- data.frame(labelDescription=c("sample id", "population", "super population", "project"))
annot <- AnnotatedDataFrame(annot, metadata)

seqData <- SeqVarData(gds, sampleData=annot)

snpset <- snpgdsLDpruning(gds, method="corr", slide.max.bp=10e6, num.thread = 12, maf = 0.05,
                          ld.threshold=sqrt(0.1), verbose=FALSE)
pruned <- unlist(snpset, use.names=FALSE)

saveRDS (object = snpset, file = paste0(outprefix, ".snpset.rds"))
saveRDS (object = pruned, file = paste0(outprefix, ".pruned.rds"))

print("king")
king <- snpgdsIBDKING(gds, num.thread = 20, verbose=FALSE)
kingMat <- king$kinship
dimnames(kingMat) <- list(king$sample.id, king$sample.id)

saveRDS (object = king, file = kingfile)

print("pcair")
pcs <- pcair(seqData,
             kinobj=kingMat,
             divobj=kingMat,
             snp.include=pruned,
             algorithm='randomized',
             num.cores = 20)

saveRDS (object = pcs, file = pcairfile)
rm(king)
gc()

print("PC-Relate")
#PC-Relate
seqSetFilter(seqData, variant.id=pruned)
iterator <- SeqVarBlockIterator(seqData, variantBlock=5000, verbose=FALSE)
pcrel <- pcrelate(iterator,
                  pcs=pcs$vectors[,1:2],
                  training.set=pcs$unrels,
                  maf.thresh = 0.05,
                  small.samp.correct = FALSE,
                  BPPARAM=BiocParallel::SerialParam())
seqResetFilter(seqData, verbose=FALSE)

saveRDS(object = pcrel, file = pcrelfile)

# Output PCS
pc.df <- as.data.frame(pcs$vectors)
names(pc.df) <- paste0("PC", 1:ncol(pcs$vectors))
pc.df$sample.id <- row.names(pcs$vectors)

write.csv(pc.df, pccsv)


