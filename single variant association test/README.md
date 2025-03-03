
# Prepare input data
1. prepare Sample_Anno file by [00.0.makeSample_Anno.R](https://github.com/plCas/SNP-SV-imputation-panel-building-pipeline/blob/9496c44894345fe893307565db82e47ffa4e26f1/single%20variant%20association%20test/00.0.makeSample_Anno.R)
2. Calculate and filter variants by HWE for **control-only** samples and generate a variant ID list. [00.1.bcftools_filter_ID.sh](https://github.com/plCas/SNP-SV-imputation-panel-building-pipeline/blob/9496c44894345fe893307565db82e47ffa4e26f1/single%20variant%20association%20test/00.1.bcftools_filter_ID.sh)
3. Filter variants according to HWE <-4 & HWE< 4,  MAF > 0.05 and R2 > 0.8 [00.2.bcftools_filter.sh](https://github.com/plCas/SNP-SV-imputation-panel-building-pipeline/blob/9496c44894345fe893307565db82e47ffa4e26f1/single%20variant%20association%20test/00.2.bcftools_filter.sh)
4. generate gds file from the filtered VCF files. [01.generate_gds.R](https://github.com/plCas/SNP-SV-imputation-panel-building-pipeline/blob/9496c44894345fe893307565db82e47ffa4e26f1/single%20variant%20association%20test/01.generate_gds.R)

# Fit nullModel
1. calculate PCair, king and pcrel [02.pcair.maf5.R](https://github.com/plCas/SNP-SV-imputation-panel-building-pipeline/blob/9496c44894345fe893307565db82e47ffa4e26f1/single%20variant%20association%20test/02.pcair.maf5.R)
2. fit nullModel [03.nullModel.maf5.noadjAPOE.R](https://github.com/plCas/SNP-SV-imputation-panel-building-pipeline/blob/9496c44894345fe893307565db82e47ffa4e26f1/single%20variant%20association%20test/03.nullModel.maf5.noadjAPOE.R)

# Association test
[04.assoc.chr.R](https://github.com/plCas/SNP-SV-imputation-panel-building-pipeline/blob/9496c44894345fe893307565db82e47ffa4e26f1/single%20variant%20association%20test/04.assoc.chr.R)
