
# Prepare input data
1. prepare Sample_Anno file by [00.0.makeSample_Anno.R](00.0.makeSample_Anno.R)
2. generate gds file from the filtered VCF files. [01.generate_gds.R](01.generate_gds.R)

# Fit nullModel
1. calculate PCair, king and pcrel [02.pcair.maf5.R](02.pcair.maf5.R)
2. fit nullModel [03.nullModel.maf5.noadjAPOE.R](03.nullModel.maf5.noadjAPOE.R)

# Association test
[04.assoc.chr.R](04.assoc.chr.R)
